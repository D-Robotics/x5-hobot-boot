# Print boot source

echo "Boot script loaded from devtype:${devtype} devnum:${devnum} devplist:${devplist}"

imagefile="Image"

dtb_0x201="x5-evb.dtb"
dtb_0x202="x5-evb-v2.dtb"
dtb_0x312="x5rdk.dtb"

setenv fdtfile "${dtb_${hb_board_id}}"
echo fdtfile = ${fdtfile}

# setting bootargs
flash_partitions="ubi.mtd=2,2048 mtdparts=hr_nand.0:6291456@0x0(miniboot),2097152@0x600000(env) "
rootfs_args="rootfstype=ext4 rw rootwait root=/dev/mmcblk${devnum}p${devplist}"
setenv bootargs "console=tty1 console=ttyS0,115200 ${rootfs_args} ${flash_partitions}"
echo bootargs = ${bootargs}

echo Loading fdt file: ${prefix}hobot/${fdtfile}
ext4load ${devtype} ${devnum}:${devplist} ${fdt_addr_r} ${prefix}hobot/${fdtfile}

echo Apply device tree overlay
dtoverlay ${fdt_addr_r} 0x3D00000 ${prefix}config.txt 0x3E00000

echo Loading kernel: ${prefix}${imagefile}
ext4load ${devtype} ${devnum}:${devplist} ${kernel_addr_r} ${prefix}${imagefile}

echo Boot kernel from ${kernel_addr_r}, devices tree from ${fdt_addr_r}
booti ${kernel_addr_r} - ${fdt_addr_r}

# Recompile with:
# mkimage -C none -A arm -T script -d boot.cmd boot.scr

