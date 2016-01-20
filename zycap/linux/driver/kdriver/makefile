# run make setup, make and make install
NAME := zycap
MAJNUM := 100

# Build variables
KVER := $(shell uname -r)
KDIR := /lib/modules/`uname -r`/build
RHR := /etc/redhat-release

obj-m += $(NAME).o
$(NAME)-y := ds_axidma.o

# Helper functions
define assert
  $(if $1,,$(error Assertion failed: $2))
endef
define assert-not-null
  $(call assert,$($1),The variable "$1" is null, please specify it.)
endef
define assert-variables
	$(call assert-not-null,NAME)
	$(call assert-not-null,MAJNUM)
	@printf "Compiling driver for kernel: %s with the following values\n" $(KVER)
endef

default: $(NAME).ko

$(NAME).ko:
	$(call assert-variables)
	make -C $(KDIR) SUBDIRS=`pwd` modules

load: build
	insmod $(NAME).ko
	
unload:
	rmmod $(NAME)

clean:
	rm -Rf *.ko *.cmd *.o .*.cmd Module.symvers Module.markers modules.order *.mod.c .tmp_versions

setup:
	if [ -f "$(RHR)" ]; then yum install kernel-devel-`uname -r`;\
	else apt-get install linux-headers-`uname -r`; fi

install: $(NAME).ko
	mkdir -p /lib/modules/$(KVER)/kernel/drivers/zycap
	cp $(NAME).ko /lib/modules/$(KVER)/kernel/drivers/zycap/
	if [ -f "$(RHR)" ]; then\
		printf "%b\n" "#!/bin/sh\nexec /sbin/modprobe $(NAME) >/dev/null 2>&1" > /etc/sysconfig/modules/zycap.modules;\
		chmod 755 /etc/sysconfig/modules/zycap.modules;\
	else\
		if ! grep -Fxq "$(NAME)" /etc/modules; then echo "$(NAME)" >> /etc/modules; fi;\
	fi
	printf "%b\n" "KERNEL==\"$(NAME)\", MODE=\"777\", GROUP=\"root\"" > /etc/udev/rules.d/99-$(NAME).rules
	depmod

uninstall: 
	rm -rf /lib/modules/$(KVER)/kernel/drivers/zycap
	rm -f /etc/udev/rules.d/99-$(NAME).rules
	if [ -f "$(RHR)" ]; then rm -f /etc/sysconfig/modules/fpga.modules;\
	else cp /etc/modules ./etc.modules.bak; sed -i '/$(NAME)/d' /etc/modules; fi
	depmod


