/*
 * icap_ctrl.c
 *
 *  Created on: Jan 22, 2014
 *  Author: Vipin K
 */
#include "zycap.h"
#include <stdlib.h>

XDcfg *XDcfg_0;
XAxiDma xcdma;
XAxiDma_Config * CdmaCfgPtr;
FATFS * fatfs;
bs_info *bs_list;


static void TxIntrHandler(void *Callback);
static int SetupIntrSystem(XScuGic * IntcInstancePtr, XAxiDma * AxiDmaPtr, u16 TxIntrId);
static int SD_TransferPartial(char *FileName, u32 DestinationAddress);
static int SD_Init(FATFS *fatfs);
static int check_bs_present(bs_info *bs_list,char *bs_name);
static int find_first_bs(bs_info *bs_list);
static int find_last_bs(bs_info *bs_list);
static void print_schedule(bs_info *bs_list);


static int check_bs_present(bs_info *bs_list,char *bs_name)
{
    int i;
    for(i=0;i<MAX_BS_NUM;i++)
    {
        if(strcmp(bs_list[i].name,bs_name) == 0)
            return i;
    }
    return -1;
}

bs_info * init_bs_list(int num_bs)
{
    int i;
    bs_info *bs_list;
    bs_list = (bs_info *)malloc(num_bs*sizeof(bs_info));
    for(i=0;i<num_bs;i++)
    {
        strcpy(bs_list[i].name,"Dummy");
        bs_list[i].size = -1;
        if(i==0)
            bs_list[i].prev = NULL;
        else
            bs_list[i].prev = &bs_list[i-1];
        if(i==num_bs-1)
            bs_list[i].next = NULL;
        else
            bs_list[i].next = &bs_list[i+1];
        bs_list[i].addr = BS_BASEADDR + i*0x100000;
    }
    return bs_list;
}


int find_first_bs(bs_info *bs_list)
{
    int i;
    for(i=0;i<MAX_BS_NUM;i++)
    {
        if(bs_list[i].prev == NULL)
            return i;
    }
    return -1;
}

int find_last_bs(bs_info *bs_list)
{
    int i;
    for(i=0;i<MAX_BS_NUM;i++)
    {
        if(bs_list[i].next== NULL)
            return i;
    }
    return -1;
}


void print_schedule(bs_info *bs_list)
{
    bs_info *current_bs;
    int i;
    for(i=0;i<MAX_BS_NUM;i++)
    {
        current_bs = &bs_list[i];
        printf("BS Num : %d BS Name : %s  BS Prev %s BS Next %s\n",i,current_bs->name,current_bs->prev,current_bs->next);
    }
}


/*****************************************************************************/
/*
*
* This is the DMA TX Interrupt handler function.
*
* It gets the interrupt status from the hardware, acknowledges it, and if any
* error happens, it resets the hardware. Otherwise, if a completion interrupt
* is present, then sets the TxDone.flag
*
* @param	Callback is a pointer to TX channel of the DMA engine.
*
* @return	None.
*
* @note		None.
*
******************************************************************************/
static void TxIntrHandler(void *Callback)
{

	u32 IrqStatus;
	int TimeOut;
	XAxiDma *AxiDmaInst = (XAxiDma *)Callback;
	/* Read pending interrupts */
	IrqStatus = XAxiDma_IntrGetIrq(AxiDmaInst, XAXIDMA_DMA_TO_DEVICE);
	/* Acknowledge pending interrupts */
	XAxiDma_IntrAckIrq(AxiDmaInst, IrqStatus, XAXIDMA_DMA_TO_DEVICE);
	/*
	 * If no interrupt is asserted, we do not do anything
	 */
	if (!(IrqStatus & XAXIDMA_IRQ_ALL_MASK)) {
		return;
	}
	/*
	 * If error interrupt is asserted, raise error flag, reset the
	 * hardware to recover from the error, and return with no further
	 * processing.
	 */
	if ((IrqStatus & XAXIDMA_IRQ_ERROR_MASK)) {
		Error = 1;
		/*
		 * Reset should never fail for transmit channel
		 */
		XAxiDma_Reset(AxiDmaInst);
		TimeOut = RESET_TIMEOUT_COUNTER;
		while (TimeOut) {
			if (XAxiDma_ResetIsDone(AxiDmaInst)) {
				break;
			}
			TimeOut -= 1;
		}
		return;
	}
	/*
	 * If Completion interrupt is asserted, then set the TxDone flag
	 */
	if ((IrqStatus & XAXIDMA_IRQ_IOC_MASK)) {
		//print("Tx interrupt received\n\r");
		TxDone = 1;
	}
}



static int SetupIntrSystem(XScuGic * IntcInstancePtr, XAxiDma * AxiDmaPtr, u16 TxIntrId)
{
	int Status;
	XScuGic_Config *IntcConfig;
	/*
	 * Initialize the interrupt controller driver so that it is ready to
	 * use.
	 */
	IntcConfig = XScuGic_LookupConfig(XPAR_SCUGIC_SINGLE_DEVICE_ID);
	if (NULL == IntcConfig) {
		return XST_FAILURE;
	}
	Status = XScuGic_CfgInitialize(IntcInstancePtr, IntcConfig,IntcConfig->CpuBaseAddress);
	if (Status != XST_SUCCESS) {
		return XST_FAILURE;
	}
	XScuGic_SetPriorityTriggerType(IntcInstancePtr, TxIntrId, 0xA0, 0x3);
	/*
	 * Connect the device driver handler that will be called when an
	 * interrupt for the device occurs, the handler defined above performs
	 * the specific interrupt processing for the device.
	 */
	Status = XScuGic_Connect(IntcInstancePtr, TxIntrId,(Xil_InterruptHandler)TxIntrHandler,AxiDmaPtr);
	if (Status != XST_SUCCESS) {
		return Status;
	}
	XScuGic_Enable(IntcInstancePtr, TxIntrId);
	/* Enable interrupts from the hardware */
	Xil_ExceptionInit();
	Xil_ExceptionRegisterHandler(XIL_EXCEPTION_ID_INT,(Xil_ExceptionHandler)XScuGic_InterruptHandler,(void *)IntcInstancePtr);
	Xil_ExceptionEnable();
	return XST_SUCCESS;
}



static XDcfg *XDcfg_Initialize(u16 DeviceId)
{
	u32 CtrlReg;
	u32 Status;
	XDcfg *Instance = malloc(sizeof *Instance);
	XDcfg_Config *Config = XDcfg_LookupConfig(DeviceId);
	Status = XDcfg_CfgInitialize(Instance, Config, Config->BaseAddr);
	if(Status != XST_SUCCESS){
		print("Device configuration initialisation failed\n\r");
		exit(0);
	}
	// Disable PCAP interface for partial reconfiguration
	XDcfg_DisablePCAP(Instance);
	CtrlReg = XDcfg_ReadReg(Instance->Config.BaseAddr,XDCFG_CTRL_OFFSET);
	XDcfg_WriteReg(Instance->Config.BaseAddr, XDCFG_CTRL_OFFSET,(CtrlReg & XDCFG_CTRL_ICAP_PR_MASK));
	return Instance;
}



static int SD_TransferPartial(char *FileName, u32 DestinationAddress)
{
	FIL fil;
	FRESULT rc;
	UINT br;
	u32 file_size;

	rc = f_open(&fil, FileName, FA_READ);
	if (rc) {
		xil_printf(" ERROR : f_open returned %d\r\n", rc);
		return XST_FAILURE;
	}

	file_size = f_size(&fil);

	//xil_printf("file size is %0x\n\r",file_size);

	rc = f_lseek(&fil, 0);
	if (rc) {
		xil_printf(" ERROR : f_lseek returned %d\r\n", rc);
		return XST_FAILURE;
	}

	rc = f_read(&fil, (void*) DestinationAddress, file_size, &br);
	if (rc) {
		xil_printf(" ERROR : f_read returned %d\r\n", rc);
		return XST_FAILURE;
	}

	rc = f_close(&fil);
	if (rc) {
		xil_printf(" ERROR : f_close returned %d\r\n", rc);
		return XST_FAILURE;
	}

	Xil_DCacheFlush();

	return file_size;
}

static int SD_Init(FATFS *fatfs)
{
	FRESULT rc;
	rc = f_mount(0, fatfs);
	if (rc) {
		xil_printf(" ERROR : f_mount returned %d\r\n", rc);
		return XST_FAILURE;
	}
	return XST_SUCCESS;
}


int Init_Zycap(XScuGic * InterruptController)
{
  int Status;
  fatfs=malloc(sizeof(FATFS));
  Status = SD_Init(fatfs);
  if (Status != XST_SUCCESS) {
	 print("file system init failed\n\r");
  	 exit(XST_FAILURE);
  }
  XDcfg_0 = XDcfg_Initialize(XPAR_XDCFG_0_DEVICE_ID);
  CdmaCfgPtr = XAxiDma_LookupConfig(XPAR_AXI_DMA_0_DEVICE_ID);
  if (!CdmaCfgPtr) {
  	xil_printf("DMA pointer failed\r\n");
  	return XST_FAILURE;
  }
  Status = XAxiDma_CfgInitialize(&xcdma , CdmaCfgPtr);
  if (Status != XST_SUCCESS) {
  	xil_printf("DMA initialization failed\r\n",Status);
  	return XST_FAILURE;
  }
  //print("DMA init done\n\r");
  Status = SetupIntrSystem(InterruptController, &xcdma, TX_INTR_ID);
  	if (Status != XST_SUCCESS) {
  		xil_printf("Failed intr setup\r\n");
  		return XST_FAILURE;
  	}
  //Enable all interrupts
  XAxiDma_IntrEnable(&xcdma, XAXIDMA_IRQ_ALL_MASK,XAXIDMA_DMA_TO_DEVICE);
  bs_list = init_bs_list(MAX_BS_NUM);
  return XST_SUCCESS;
}



int Config_PR_Bitstream(char *bs_name,int sync_intr)
{
	int Status;
    int bs_pres;
    int pres_first;
    int pres_last;
    int file_size;
    bs_pres = check_bs_present(bs_list,bs_name);
    if (bs_pres != -1 && bs_list[bs_pres].prev != NULL)            //The bitstream is already in the list and is not the most recently used
    {
    	//print("bitstream in the list\n\r");
        bs_list[bs_pres].prev->next = bs_list[bs_pres].next;
        if(bs_list[bs_pres].next != NULL)
        {
            bs_list[bs_pres].next->prev = bs_list[bs_pres].prev;
        }
        pres_first = find_first_bs(bs_list);
        bs_list[bs_pres].prev = NULL;
        bs_list[bs_pres].next = &bs_list[pres_first];
        bs_list[pres_first].prev = &bs_list[bs_pres];
    }
    else if(bs_pres == -1)
    {
    	//print("bitstream not in the list\n\r");
    	pres_last = find_last_bs(bs_list);
    	file_size = SD_TransferPartial(bs_name, bs_list[pres_last].addr);
        if(file_size == XST_FAILURE)
        {
        	print("bitstream transfer failed\n\r");
        	return XST_FAILURE;
        }
        //print("Successfully transferred PR files from flash to DDR\n\r");
        pres_first = find_first_bs(bs_list);
        bs_list[pres_last].prev->next = NULL;   //make the second last element as the last element
        strcpy(bs_list[pres_last].name,bs_name);
        bs_list[pres_last].size = file_size;
        bs_list[pres_last].prev = NULL;
        bs_list[pres_last].next = &bs_list[pres_first];
        bs_list[pres_first].prev = &bs_list[pres_last];
    }
    //print_schedule(bs_list);
	//print("Central DMA Initialized\r\n");
    pres_first = find_first_bs(bs_list);
	Status = XAxiDma_SimpleTransfer(&xcdma,bs_list[pres_first].addr,bs_list[pres_first].size,XAXIDMA_DMA_TO_DEVICE);
	if (Status != XST_SUCCESS) {
		xil_printf("DMA transfer failed\r\n",Status);
		return XST_FAILURE;
	}
	TxDone = 0;
	Error = 0;
	if(sync_intr)
	{
		Status = Sync_Zycap();
		if (Status != XST_SUCCESS) {
			xil_printf("interrupt failed\r\n",Status);
			return XST_FAILURE;
		}
	}
	return XST_SUCCESS;
}


int Sync_Zycap()
{
	while (!TxDone && !Error) {
	}
	if (Error) {
		xil_printf("Failed transmit");
		return XST_FAILURE;
	}
	return XST_SUCCESS;
}

int Prefetch_PR_Bitstream(char *bs_name)
{
    int bs_pres;
    int pres_first;
    int pres_last;
    int file_size;
    bs_pres = check_bs_present(bs_list,bs_name);
    if (bs_pres != -1 && bs_list[bs_pres].prev != NULL)            //The bitstream is already in the list and is not the most recently used
    {
        bs_list[bs_pres].prev->next = bs_list[bs_pres].next;
        if(bs_list[bs_pres].next != NULL)
        {
            bs_list[bs_pres].next->prev = bs_list[bs_pres].prev;
        }
        pres_first = find_first_bs(bs_list);
        bs_list[bs_pres].prev = NULL;
        bs_list[bs_pres].next = &bs_list[pres_first];
        bs_list[pres_first].prev = &bs_list[bs_pres];
    }
    else if(bs_pres == -1)
    {
    	pres_last = find_last_bs(bs_list);
    	file_size = SD_TransferPartial(bs_name, bs_list[pres_last].addr);
        if(file_size == XST_FAILURE)
        {
        	print("bitstream transfer failed\n\r");
        	return XST_FAILURE;
        }
        //print("Successfully transferred PR files from flash to DDR\n\r");
        pres_first = find_first_bs(bs_list);
        bs_list[pres_last].prev->next = NULL;   //make the second last element as the last element
        strcpy(bs_list[pres_last].name,bs_name);
        bs_list[pres_last].size = file_size;
        bs_list[pres_last].prev = NULL;
        bs_list[pres_last].next = &bs_list[pres_first];
        bs_list[pres_first].prev = &bs_list[pres_last];
    }
	return XST_SUCCESS;
}
