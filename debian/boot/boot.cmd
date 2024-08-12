# Print boot source

echo "Boot script loaded from devtype:${devtype} devnum:${devnum} devplist:${devplist}"

imagefile="Image"

setenv dtb_chose 'if test "${hb_board_id}" = "0x0201"; then echo "Board is X5 EVB V1"; setenv fdtfile "x5-evb.dtb"; elif test "${hb_board_id}" = "0x0202"; then echo "Board is X5 EVB V2"; setenv fdtfile "x5-evb-v2.dtb"; ' \
    'elif test "${hb_board_id}" = "0x0301"; then echo "Board is X5 RDK"; setenv fdtfile "x5-rdk.dtb";  ' \
    'else echo "Unknown board ID, use x5-evb-v2.dtb default"; setenv fdtfile "x5-evb-v2.dtb"; fi; '

run dtb_chose

echo fdtfile = ${fdtfile}

# setting bootargs
rootfs_args="rootfstype=ext4 rw rootwait root=/dev/mmcblk${devnum}p${devplist}"
setenv bootargs "console=tty1 console=ttyS0,115200 ${rootfs_args}"
echo bootargs = ${bootargs}

echo Loading fdt file: ${prefix}hobot/${fdtfile}
ext4load ${devtype} ${devnum}:${devplist} ${fdt_addr_r} ${prefix}hobot/${fdtfile}

echo Apply device tree overlay
dtoverlay ${fdt_addr_r} 0x85000000 ${prefix}config.txt 0x85800000

echo Loading kernel: ${prefix}${imagefile}
ext4load ${devtype} ${devnum}:${devplist} ${kernel_addr_r} ${prefix}${imagefile}

echo Boot kernel from ${kernel_addr_r}, devices tree from ${fdt_addr_r}
booti ${kernel_addr_r} - ${fdt_addr_r}

# Recompile with:
# mkimage -C none -A arm -T script -d boot.cmd boot.scr

