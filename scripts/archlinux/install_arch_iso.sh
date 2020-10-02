#!/usr/bin/env sh
set -eux
ISO="$1"
BOOT=/boot
ROOT_DEV="$(findmnt -o SOURCE -n "$BOOT")"
ROOT_UUID="$(lsblk -dno UUID "$ROOT_DEV")"

rm -rf \
    "$BOOT/arch" \
    "$BOOT/shellx64.efi"

7z x -ba -o"$BOOT" "$1" \
    arch \
    shellx64.efi

cat > "$BOOT/loader/entries/arch_install.conf" << EOF
title   Arch Linux install medium (x86_64, UEFI)
linux   /arch/boot/x86_64/vmlinuz-linux
initrd  /arch/boot/intel-ucode.img
initrd  /arch/boot/amd-ucode.img
initrd  /arch/boot/x86_64/initramfs-linux.img
options archisobasedir=arch archisodevice=/dev/disk/by-uuid/$ROOT_UUID
EOF
