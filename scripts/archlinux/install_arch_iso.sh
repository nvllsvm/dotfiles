#!/usr/bin/env sh
set -eux
ISO="$1"
BOOT=/boot
ROOT_DEV="$(findmnt -o SOURCE -n "$BOOT")"
ROOT_UUID="$(lsblk -dno UUID "$ROOT_DEV")"

rm -rf \
    "$BOOT/arch" \
    "$BOOT/EFI/shellx64_v1.efi" \
    "$BOOT/EFI/shellx64_v2.efi"

7z x -ba -o"$BOOT" "$1" \
    arch \
    EFI/shellx64_v1.efi \
    EFI/shellx64_v2.efi

cat > "$BOOT/loader/entries/archiso.conf" << EOF
title   archiso
linux   /arch/boot/x86_64/vmlinuz
initrd  /arch/boot/intel_ucode.img
initrd  /arch/boot/amd_ucode.img
initrd  /arch/boot/x86_64/archiso.img
options archisobasedir=arch archisodevice=/dev/disk/by-uuid/$ROOT_UUID
EOF

cat > "$BOOT/loader/entries/uefi-shell-v1-x86_64.conf" << EOF
title  UEFI Shell x86_64 v1
efi    /EFI/shellx64_v1.efi
EOF

cat > "$BOOT/loader/entries/uefi-shell-v2-x86_64.conf" << EOF
title  UEFI Shell x86_64 v2
efi    /EFI/shellx64_v2.efi
EOF
