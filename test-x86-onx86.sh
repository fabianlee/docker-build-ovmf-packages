qemu-system-x86_64 \
  -boot menu=on,splash-time=3000 \
  -cpu host \
  --accel kvm \
  -display default,show-cursor=on \
  -net none \
  -bios Build/OvmfX64/RELEASE_GCC5/FV/OVMF.fd
