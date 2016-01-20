/*  Author   :   Shreejith S
 *  Project  :   pr_app
 *  Dcpr.    :   Example application for ZyCAP
 */


#include "xparameters.h"
#include "xil_io.h"
#include "xstatus.h"
#include "zycap.h"
#include "xscutimer.h"


XScuGic InterruptController;         /* Instance of the Interrupt Controller. User has to provide a pointer to the ICAP driver */
XScuTimer Timer;		/* Cortex A9 SCU Private Timer Instance */
int TimerClock = XPAR_CPU_CORTEXA9_0_CPU_CLK_FREQ_HZ/2000000;
int main()
{
	int Status;
	int rtn;
	u32 delay,delay1;
	XScuTimer_Config *ConfigPtr;
	XScuTimer *TimerInstancePtr = &Timer;        /* The instance of the Timer Counter. Used to measure the performance of the ICAP controller */
	// Initialize timer counter
	ConfigPtr = XScuTimer_LookupConfig(XPAR_PS7_SCUTIMER_0_DEVICE_ID);

	/*
	 * This is where the virtual address would be used, this example
	 * uses physical address.
	 */
	Status = XScuTimer_CfgInitialize(TimerInstancePtr, ConfigPtr,
				 ConfigPtr->BaseAddr);
	if (Status != XST_SUCCESS) {
		return XST_FAILURE;
	}

	/*Read data from the peripheral. The peripheral implements a single register. In config1, the peripheral increments the data by one
	 * before writing to the internal register. In config2, the peripheral decrements the data by one before writing to the internal
	 * register.
	 */
	Xil_Out32(XPAR_PARTIAL_LED_TEST_0_S00_AXI_BASEADDR,0x0);
	print("Reading data from register before PR\n\r");
	rtn = Xil_In32(XPAR_PARTIAL_LED_TEST_0_S00_AXI_BASEADDR);
	xil_printf("Register content is %0x\n\r",rtn);
	print("Starting Reconfiguration\n\r");
	//Initialise the ICAP controller
	Status = Init_Zycap(&InterruptController);
	if (Status != XST_SUCCESS){
		xil_printf("ICAP controller initialisation failed\r\n",Status);
		return XST_FAILURE;
	}
	//Reset the Timer and start it
	XScuTimer_LoadTimer(TimerInstancePtr, 0xFFFFFFFF);
	delay1 = XScuTimer_GetCounterValue(TimerInstancePtr);
	XScuTimer_Start(TimerInstancePtr);
	//Send config2 partial bitstream to the ICAP with reset sync bit set
	Status = Config_PR_Bitstream("mode2.bin",1);
	delay =  delay1 - XScuTimer_GetCounterValue(TimerInstancePtr);
	if (Status == XST_FAILURE){
		xil_printf("Reconfiguration failed\r\n",Status);
		return XST_FAILURE;
	}
	//Read the content of the timer and check the performance
	XScuTimer_Stop(TimerInstancePtr);
	xil_printf("Reconfiguration speed: %d MBytes/sec\r\n", (Status*TimerClock)/delay);
	Xil_Out32(XPAR_PARTIAL_LED_TEST_0_S00_AXI_BASEADDR,0x0);
	print("Reading data from register after PR\n\r");
	rtn = Xil_In32(XPAR_PARTIAL_LED_TEST_0_S00_AXI_BASEADDR);
	xil_printf("Register content is %0x\n\r",rtn);


	XScuTimer_LoadTimer(TimerInstancePtr, 0xFFFFFFFF);
	delay1 = XScuTimer_GetCounterValue(TimerInstancePtr);
	XScuTimer_Start(TimerInstancePtr);

	//Do the reconfiguration once again to see the effect of bufferring in the DRAM
	Status = Config_PR_Bitstream("mode2.bin",1);
	delay =  delay1 - XScuTimer_GetCounterValue(TimerInstancePtr);
	if (Status == XST_FAILURE){
		xil_printf("Reconfiguration failed\r\n",Status);
		return XST_FAILURE;
	}
	XScuTimer_Stop(TimerInstancePtr);
	xil_printf("Reconfiguration speed for the second try: %d MBytes/sec\r\n", (Status*TimerClock)/delay);
	//Prefetch the config1 bitstream for better ICAP performance
	print("Prefetching a partial bitstream\n\r");
	Status = Prefetch_PR_Bitstream("mode1.bin");
	if (Status == XST_FAILURE){
		xil_printf("Bitstream prefetch failed\r\n",Status);
		return XST_FAILURE;
	}
	print("Prefetching success..\n\r");
	XScuTimer_LoadTimer(TimerInstancePtr, 0xFFFFFFFF);
	delay1 = XScuTimer_GetCounterValue(TimerInstancePtr);
	XScuTimer_Start(TimerInstancePtr);
	//Send the PR bitstream to the ICAP with sync bit unset
	Status = Config_PR_Bitstream("mode1.bin",0);
	if (Status == XST_FAILURE){
		xil_printf("Reconfiguration failed\r\n",Status);
		return XST_FAILURE;
	}
	//synchronize the interrupt
	Sync_Zycap();
	delay =  delay1 - XScuTimer_GetCounterValue(TimerInstancePtr);
	XScuTimer_Stop(TimerInstancePtr);
	xil_printf("Performance with prefetching and deferred interrupt sync: %d MBytes/sec\r\n", (Status*TimerClock)/delay);
	xil_printf("Time taken: %d sec\r\n", delay);
	Xil_Out32(XPAR_PARTIAL_LED_TEST_0_S00_AXI_BASEADDR,0x0);
	rtn = Xil_In32(XPAR_PARTIAL_LED_TEST_0_S00_AXI_BASEADDR);
	xil_printf("Now the register content is %0x\n\r",rtn);
	return 0;
}
