/*  Author   :   Vipin.K
 *  Project  :   Zycap
 *  Dcpr.    :   Example application for the custom ICAP controller
 */


#include "xparameters.h"
#include "xil_io.h"
#include "xstatus.h"
#include "xtmrctr.h"
#include "zycap.h"

#define PARTIAL_BITFILE1_LEN 0x6A1C   /*Partial bitstream size. Not needed by the ICAP, used only to calculate the performance*/
#define PARTIAL_BITFILE2_LEN 0x6A58   /*Partial bitstream size. Not needed by the ICAP, used only to calculate the performance*/

XScuGic InterruptController;         /* Instance of the Interrupt Controller. User has to provide a pointer to the ICAP driver */


int main()
{
	int Status;
	int rtn;
	u32 delay;
	XTmrCtr TimerCounterInst;        /* The instance of the Timer Counter. Used to measure the performance of the ICAP controller */
	// Initialize timer counter
	Status = XTmrCtr_Initialize(&TimerCounterInst, XPAR_AXI_TIMER_0_DEVICE_ID);
	if (Status != XST_SUCCESS){
		xil_printf("Timer initialisation failed\r\n",Status);
		return XST_FAILURE;
	}
	XTmrCtr_SetOptions(&TimerCounterInst, 0, XTC_AUTO_RELOAD_OPTION);
	/*Read data from the peripheral. The peripheral implements a single register. In config1, the peripheral increments the data by one
	 * before writing to the internal register. In config2, the peripheral decrements the data by one before writing to the internal
	 * register.
	 */
	Xil_Out32(XPAR_REG_PERIPHERAL_0_BASEADDR,0x0);
	print("Reading data from register before PR\n\r");
	rtn = Xil_In32(XPAR_REG_PERIPHERAL_0_BASEADDR);
	xil_printf("Register content is %0x\n\r",rtn);
	print("Starting Reconfiguration\n\r");
	//Initialise the ICAP controller
	Status = Init_Zycap(&InterruptController);
	if (Status != XST_SUCCESS){
		xil_printf("ICAP controller initialisation failed\r\n",Status);
		return XST_FAILURE;
	}
	//Reset the Timer and start it
	XTmrCtr_Reset(&TimerCounterInst, 0);
	XTmrCtr_Start(&TimerCounterInst, 0);
	//Send config2 partial bitstream to the ICAP with reset sync bit set
	Status = Config_PR_Bitstream("config2.bin",1);
	if (Status != XST_SUCCESS){
		xil_printf("Reconfiguration failed\r\n",Status);
		return XST_FAILURE;
	}
	//Read the content of the timer and check the performance
	delay = XTmrCtr_GetValue(&TimerCounterInst, 0);
	xil_printf("Reconfiguration speed: %d MBytes/sec\r\n", PARTIAL_BITFILE2_LEN*100/delay);
	Xil_Out32(XPAR_REG_PERIPHERAL_0_BASEADDR,0x0);
	print("Reading data from register after PR\n\r");
	rtn = Xil_In32(XPAR_REG_PERIPHERAL_0_BASEADDR);
	xil_printf("Register content is %0x\n\r",rtn);
	XTmrCtr_Reset(&TimerCounterInst, 0);
	XTmrCtr_Start(&TimerCounterInst, 0);
	//Do the reconfiguration once again to see the effect of bufferring in the DRAM
	Status = Config_PR_Bitstream("config2.bin",1);
	if (Status != XST_SUCCESS){
		xil_printf("Reconfiguration failed\r\n",Status);
		return XST_FAILURE;
	}
	delay = XTmrCtr_GetValue(&TimerCounterInst, 0);
	xil_printf("Reconfiguration speed for the second try: %d MBytes/sec\r\n", PARTIAL_BITFILE2_LEN*100/delay);
	//Prefetch the config1 bitstream for better ICAP performance
	print("Prefetching a partial bitstream\n\r");
	Status = Prefetch_PR_Bitstream("config1.bin");
	if (Status != XST_SUCCESS){
		xil_printf("Bitstream prefetch failed\r\n",Status);
		return XST_FAILURE;
	}
	print("Prefetching success..\n\r");
	XTmrCtr_Reset(&TimerCounterInst, 0);
	XTmrCtr_Start(&TimerCounterInst, 0);
	//Send the PR bitstream to the ICAP with sync bit unset
	Status = Config_PR_Bitstream("config1.bin",0);
	if (Status != XST_SUCCESS){
		xil_printf("Reconfiguration failed\r\n",Status);
		return XST_FAILURE;
	}
	//synchronize the interrupt
	Sync_Zycap();
	delay = XTmrCtr_GetValue(&TimerCounterInst, 0);
	xil_printf("Performance with prefetching and deferred interrupt sync: %d MBytes/sec\r\n", PARTIAL_BITFILE1_LEN*100/delay);
	Xil_Out32(XPAR_REG_PERIPHERAL_0_BASEADDR,0x0);
	rtn = Xil_In32(XPAR_REG_PERIPHERAL_0_BASEADDR);
	xil_printf("Now the register content is %0x\n\r",rtn);
	return 0;
}
