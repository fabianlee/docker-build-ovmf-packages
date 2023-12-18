qemu-system-aarch64 \
  -boot menu=on,splash-time=3000 \
  -M virt,highmem=on \
  -serial stdio \
  -accel hvf \
  -cpu host \
  -display default,show-cursor=on \
  -device qemu-xhci \
  -device virtio-gpu-pci \
  -device usb-kbd \
  -net none \
  -bios Build/ArmVirtQemu-AARCH64/RELEASE_GCC5/FV/QEMU_EFI.fd

# not necessary, but could add these
#  -smp 4 \
#  -m 4096 \
#  -device intel-hda \
#  -device hda-duplex \
#  -device usb-tablet \
