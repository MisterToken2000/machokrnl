rm efi.iso boot.efi
rm iso/efi/boot/bootx64.efi
rm *.o *.so
gcc -I /gnu-efi/inc -fpic -ffreestanding -fno-stack-protector -fno-stack-check -fshort-wchar -mno-red-zone -maccumulate-outgoing-args -c main/main.c -o boot.o
gcc -I /gnu-efi/inc -fpic -ffreestanding -fno-stack-protector -fno-stack-check -fshort-wchar -mno-red-zone -maccumulate-outgoing-args -c libkern/draw/draw.c -o draw.o
gcc -I /gnu-efi/inc -fpic -ffreestanding -fno-stack-protector -fno-stack-check -fshort-wchar -mno-red-zone -maccumulate-outgoing-args -c libkern/kprint/kprint.c -o kprint.o
gcc -I /gnu-efi/inc -fpic -ffreestanding -fno-stack-protector -fno-stack-check -fshort-wchar -mno-red-zone -maccumulate-outgoing-args -c libkern/libkernst/drivers.c -o drivers.o
gcc -I /gnu-efi/inc -fpic -ffreestanding -fno-stack-protector -fno-stack-check -fshort-wchar -mno-red-zone -maccumulate-outgoing-args -c libkern/shell/shell.c -o shell.o
ld -shared -Bsymbolic -L gnu-efi/x86_64/lib -L gnu-efi/x86_64/gnuefi -T gnu-efi/gnuefi/elf_x86_64_efi.lds gnu-efi/x86_64/gnuefi/crt0-efi-x86_64.o boot.o kprint.o draw.o drivers.o shell.o -o boot.so -lgnuefi -lefi
objcopy -j .text -j .sdata -j .data -j .rodata -j .dynamic -j .dynsym  -j .rel -j .rela -j .rel.* -j .rela.* -j .reloc --target efi-app-x86_64 --subsystem=10 boot.so boot.efi
cp -r boot.efi iso/efi/boot/bootx64.efi
xorriso -as mkisofs \
  -R -J -l -D \
  -partition_offset 16 \
  -eltorito-alt-boot iso/efi/boot/bootx64.efi \
  -no-emul-boot -isohybrid-gpt-basdat \
  -o efi.iso iso/
