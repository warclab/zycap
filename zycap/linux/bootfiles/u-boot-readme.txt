NOTE: The patches are with reference to xilinx u-boot version tagged at xilinx-v14.7. These may or may not be applicable to newer versions. 

[PATCH 1/3] fpga: zynqpl: Fixed bug in alignment routine

The aligned buffer is always with a higher address, so copying should run
from the end of the buffer to the beginning, and not the other way around.

Signed-off-by: Eli Billauer <eli.billauer@gmail.com>
---
 drivers/fpga/zynqpl.c |    5 +++--
 1 files changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/fpga/zynqpl.c b/drivers/fpga/zynqpl.c
index 160abc7..2888131 100644
--- a/drivers/fpga/zynqpl.c
+++ b/drivers/fpga/zynqpl.c
@@ -173,7 +173,8 @@ int zynq_load(Xilinx_desc *desc, const void *buf, size_t bsize)
 {
 	unsigned long ts; /* Timestamp */
 	u32 partialbit = 0;
-	u32 i, control, isr_status, status, swap, diff;
+	u32 control, isr_status, status, swap, diff;
+	int i;
 	u32 *buf_start;
 
 	/* Detect if we are going working with partial or full bitstream */
@@ -206,7 +207,7 @@ int zynq_load(Xilinx_desc *desc, const void *buf, size_t bsize)
 		printf("%s: Align buffer at %x to %x(swap %d)\n", __func__,
 		       (u32)buf_start, (u32)new_buf, swap);
 
-		for (i = 0; i < (bsize/4); i++)
+		for (i = (bsize/4)-1; i >= 0 ; i--)
 			new_buf[i] = load_word(&buf_start[i], swap);
 
 		swap = SWAP_DONE;
-- 
1.7.2.3


[PATCH 2/3] zynq_common.h: Configuration for Xillinux

---
 include/configs/zynq_common.h |   19 +++++++++----------
 1 files changed, 9 insertions(+), 10 deletions(-)

diff --git a/include/configs/zynq_common.h b/include/configs/zynq_common.h
index f8ff0ac..f70ef5b 100644
--- a/include/configs/zynq_common.h
+++ b/include/configs/zynq_common.h
@@ -97,7 +97,7 @@
 #define CONFIG_SYS_HZ			1000
 
 /* Miscellaneous configurable options */
-#define CONFIG_SYS_PROMPT		"zynq-uboot> "
+#define CONFIG_SYS_PROMPT		"zycap-uboot> "
 #define CONFIG_SYS_HUSH_PARSER	/* use "hush" command parser */
 #define CONFIG_SYS_PROMPT_HUSH_PS2	"> "
 
@@ -234,7 +234,7 @@
-   "ethaddr=00:0a:35:00:01:22\0"	\
+   "ethaddr=00:0a:36:00:01:24\0"	\
 	"kernel_image=uImage\0"	\
 	"ramdisk_image=uramdisk.image.gz\0"	\
 	"devicetree_image=devicetree.dtb\0"	\
-	"bitstream_image=system.bit.bin\0"	\
+	"bitstream_image=xillydemo.bit\0"	\
 	"loadbit_addr=0x100000\0"	\
 	"loadbootenv_addr=0x2000000\0" \
 	"kernel_size=0x500000\0"	\
@@ -273,14 +273,13 @@
 			"echo Running uenvcmd ...; " \
 			"run uenvcmd; " \
 		"fi\0" \
-	"sdboot=if mmcinfo; then " \
-			"run uenvboot; " \
-			"echo Copying Linux from SD to RAM... && " \
-			"fatload mmc 0 0x3000000 ${kernel_image} && " \
-			"fatload mmc 0 0x2A00000 ${devicetree_image} && " \
-			"fatload mmc 0 0x2000000 ${ramdisk_image} && " \
-			"bootm 0x3000000 0x2000000 0x2A00000; " \
-		"fi\0" \
+	"sdboot=echo Booting into ZyLinux.. && " \
+		"mmcinfo && " \
+		"fatload mmc 0 ${loadbit_addr} ${bitstream_image} && " \
+		"fpga loadb 0 ${loadbit_addr} ${filesize} && " \
+		"fatload mmc 0 0x3000000 ${kernel_image} && " \
+		"fatload mmc 0 0x2A00000 ${devicetree_image} && " \
+		"bootm 0x3000000 - 0x2A00000;\0" \
 	"nandboot=echo Copying Linux from NAND flash to RAM... && " \
 		"nand read 0x3000000 0x100000 ${kernel_size} && " \
 		"nand read 0x2A00000 0x600000 ${devicetree_size} && " \
-- 
1.7.2.3

[PATCH 3/3] zynq_common.h: One second delay instead of 3

---
 include/configs/zynq_common.h |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/include/configs/zynq_common.h b/include/configs/zynq_common.h
index f70ef5b..fc45f35 100644
--- a/include/configs/zynq_common.h
+++ b/include/configs/zynq_common.h
@@ -294,7 +294,7 @@
 
 /* default boot is according to the bootmode switch settings */
 #define CONFIG_BOOTCOMMAND		"run $modeboot"
-#define CONFIG_BOOTDELAY		3 /* -1 to Disable autoboot */
+#define CONFIG_BOOTDELAY		1 /* -1 to Disable autoboot */
 #define CONFIG_SYS_LOAD_ADDR		0 /* default? */
 
 #define CONFIG_CMD_CACHE
-- 
1.7.2.3