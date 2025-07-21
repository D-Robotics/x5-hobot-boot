# Print boot source

echo "Boot script loaded from devtype:${devtype} devnum:${devnum} devplist:${devplist}"

imagefile="Image"

setenv fdtfile "x5-rdk-v1p0.dtb";
setenv uart_baudrate "115200";

if test "${hb_board_id}" = "0x0201"; then setenv fdtfile "x5-evb-lp4-1_a.dtb"; fi
if test "${hb_board_id}" = "0x0202"; then setenv fdtfile "x5-evb-lp4-1_b.dtb"; fi
if test "${hb_board_id}" = "0x0203"; then setenv fdtfile "x5-evb-lp4-v1p2.dtb"; fi
if test "${hb_board_id}" = "0x0204"; then setenv fdtfile "x5-evb-lp4-v1p3.dtb"; fi
if test "${hb_board_id}" = "0x0301"; then setenv fdtfile "x5-rdk.dtb"; fi
if test "${hb_board_id}" = "0x0302"; then setenv fdtfile "x5-rdk-v1p0.dtb"; fi
if test "${hb_board_id}" = "0x0501"; then setenv fdtfile "x5-md-v0p1.dtb"; fi
if test "${hb_board_id}" = "0x0502"; then setenv fdtfile "x5-md-v0p2.dtb"; setenv uart_baudrate "921600"; fi
if test "${hb_board_id}" = "0x0503"; then setenv fdtfile "x5-md-v0p2.dtb"; setenv uart_baudrate "921600"; fi
if test "${hb_board_id}" = "0x0504"; then setenv fdtfile "x5-md-v0p2.dtb"; setenv uart_baudrate "921600"; fi
if test "${hb_board_id}" = "0x0505"; then setenv fdtfile "x5-md-v0p2.dtb"; setenv uart_baudrate "921600"; fi

echo fdtfile = ${fdtfile}

# setting bootargs
flash_partitions="mtdparts=spi7.0:0x700000@0x0(miniboot),0x180000@0x700000(ubootenv)"
rootfs_args="rootfstype=ext4 rw rootwait root=/dev/mmcblk${devnum}p${devplist} ${flash_partitions}"
setenv bootargs "console=tty1 console=ttyS0,${uart_baudrate} ${rootfs_args} hobotboot.reason=${reset_reason}"
echo bootargs = ${bootargs}

echo Loading fdt file: ${prefix}hobot/${fdtfile}
ext4load ${devtype} ${devnum}:${devplist} ${fdt_addr_r} ${prefix}hobot/${fdtfile}

echo Apply device tree overlay
dtoverlay ${fdt_addr_r} 0x85000000 ${prefix}config.txt 0x85800000
setpin ${prefix}config.txt 0x85800000

echo Loading kernel: ${prefix}${imagefile}
ext4load ${devtype} ${devnum}:${devplist} ${kernel_addr_r} ${prefix}${imagefile}

echo Boot kernel from ${kernel_addr_r}, devices tree from ${fdt_addr_r}
booti ${kernel_addr_r} - ${fdt_addr_r}

# Recompile with:
# mkimage -C none -A arm -T script -d boot.cmd boot.scr

