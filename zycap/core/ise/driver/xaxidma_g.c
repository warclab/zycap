/******************************************************************************
*
* (c) Copyright 2010-2011 Xilinx, Inc. All rights reserved.
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
*
******************************************************************************/
/*****************************************************************************/
/**
*
* @file xaxidma_g.c
*
* Provide a template for user to define their own hardware settings.
*
* If using XPS, then XPS will automatically generate this file.
*
* <pre>
* MODIFICATION HISTORY:
*
* Ver   Who  Date     Changes
* ----- ---- -------- -------------------------------------------------------
* 1.00a jz   08/16/10 First release
* 2.00a jz   08/10/10 Second release, added in xaxidma_g.c, xaxidma_sinit.c,
*                     updated tcl file, added xaxidma_porting_guide.h
* 3.00a jz   11/22/10 Support IP core parameters change
* 4.00a rkv  02/22/11 Added support for simple DMA mode
* 6.00a srt  01/24/12 Added support for Multi-Channel DMA mode
* 7.02a srt  01/23/13 Replaced *_TDATA_WIDTH parameters to *_DATA_WIDTH
*		      (CR 691867)
*
* </pre>
*
******************************************************************************/

/***************************** Include Files *********************************/

#include "xparameters.h"
#include "xaxidma.h"
#include "zycap.h"

/************************** Constant Definitions *****************************/
#define XPAR_AXIDMA_0_INCLUDE_SG	0

XAxiDma_Config XAxiDma_ConfigTable[] =
{
	{
		XPAR_AXIDMA_0_DEVICE_ID,
		XPAR_AXIDMA_0_BASEADDR,
		XPAR_AXIDMA_0_SG_INCLUDE_STSCNTRL_STRM,
		XPAR_AXIDMA_0_INCLUDE_MM2S,
		XPAR_AXIDMA_0_INCLUDE_MM2S_DRE,
		XPAR_AXIDMA_0_M_AXI_MM2S_DATA_WIDTH,
		XPAR_AXIDMA_0_INCLUDE_S2MM,
		XPAR_AXIDMA_0_INCLUDE_S2MM_DRE,
		XPAR_AXIDMA_0_M_AXI_S2MM_DATA_WIDTH,
		XPAR_AXIDMA_0_INCLUDE_SG,
		XPAR_AXIDMA_0_NUM_MM2S_CHANNELS,
		XPAR_AXIDMA_0_NUM_S2MM_CHANNELS
	}
};
