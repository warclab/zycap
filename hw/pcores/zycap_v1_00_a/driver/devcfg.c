/******************************************************************************
*
* (c) Copyright 2011-2012 Xilinx, Inc. All rights reserved.
*
* This file contains confidential and proprietary information of Xilinx, Inc.
* and is protected under U.S. and international copyright and other
* intellectual property laws.
*
* DISCLAIMER
* This disclaimer is not a license and does not grant any rights to the
* materials distributed herewith. Except as otherwise provided in a valid
* license issued to you by Xilinx, and to the maximum extent permitted by
* applicable law: (1) THESE MATERIALS ARE MADE AVAILABLE "AS IS" AND WITH ALL
* FAULTS, AND XILINX HEREBY DISCLAIMS ALL WARRANTIES AND CONDITIONS, EXPRESS,
* IMPLIED, OR STATUTORY, INCLUDING BUT NOT LIMITED TO WARRANTIES OF
* MERCHANTABILITY, NON-INFRINGEMENT, OR FITNESS FOR ANY PARTICULAR PURPOSE;
* and (2) Xilinx shall not be liable (whether in contract or tort, including
* negligence, or under any other theory of liability) for any loss or damage
* of any kind or nature related to, arising under or in connection with these
* materials, including for any direct, or any indirect, special, incidental,
* or consequential loss or damage (including loss of data, profits, goodwill,
* or any type of loss or damage suffered as a result of any action brought by
* a third party) even if such damage or loss was reasonably foreseeable or
* Xilinx had been advised of the possibility of the same.
*
* CRITICAL APPLICATIONS
* Xilinx products are not designed or intended to be fail-safe, or for use in
* any application requiring fail-safe performance, such as life-support or
* safety devices or systems, Class III medical devices, nuclear facilities,
* applications related to the deployment of airbags, or any other applications
* that could lead to death, personal injury, or severe property or
* environmental damage (individually and collectively, "Critical
* Applications"). Customer assumes the sole risk and liability of any use of
* Xilinx products in Critical Applications, subject only to applicable laws
* and regulations governing limitations on product liability.
*
* THIS COPYRIGHT NOTICE AND DISCLAIMER MUST BE RETAINED AS PART OF THIS FILE
* AT ALL TIMES.
******************************************************************************/

#include <stdlib.h>
#include "devcfg.h"
#include "xil_printf.h"


/*
 * SLCR registers
 */
#define SLCR_LOCK	   0xF8000004 /**< SLCR Write Protection Lock */
#define SLCR_UNLOCK	   0xF8000008 /**< SLCR Write Protection Unlock */
#define FPGA_RST_CTRL  0xF8000240 /**< FPGA Software Reset Control */
#define LVL_SHFTR_EN   0xF8000900 /**< FPGA Level Shifters Enable */

#define SLCR_LOCK_VAL	0x767B
#define SLCR_UNLOCK_VAL	0xDF0D


XDcfg *XDcfg_Initialize(u16 DeviceId)
{
	XDcfg *Instance = malloc(sizeof *Instance);
	XDcfg_Config *Config = XDcfg_LookupConfig(DeviceId);
	XDcfg_CfgInitialize(Instance, Config, Config->BaseAddr);

	// Enable and select PCAP interface for partial reconfiguration
	XDcfg_EnablePCAP(Instance);
	XDcfg_SetControlRegister(Instance, XDCFG_CTRL_PCAP_PR_MASK);

	return Instance;
}


int XDcfg_TransferBitfile(XDcfg *Instance, u32 StartAddress, u32 WordLength)
{
	int Status;
	volatile u32 IntrStsReg = 0;

	// Clear DMA and PCAP Done Interrupts
	XDcfg_IntrClear(Instance, XDCFG_IXR_D_P_DONE_MASK);

	// Transfer bitstream from DDR into fabric in non secure mode
	Status = XDcfg_Transfer(Instance, (u32 *) StartAddress, WordLength, (u32 *) XDCFG_DMA_INVALID_ADDRESS, 0, XDCFG_NON_SECURE_PCAP_WRITE);
	if (Status != XST_SUCCESS)
		return Status;

	// Poll PCAP Done Interrupt
	while ((IntrStsReg & XDCFG_IXR_D_P_DONE_MASK) != XDCFG_IXR_D_P_DONE_MASK)
		IntrStsReg = XDcfg_IntrGetStatus(Instance);

	return XST_SUCCESS;
}
