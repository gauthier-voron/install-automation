SRC := package/
OBJ := obj/
PKG := pkg/
ISO := iso/

# IMG := fake-disk.img
IMG := fake2.img

packages := config-audio config-devel config-desktop config-graphic config-multimedia emacs-go-mode homectl setup-laurier setup-qemu xmde


V ?= 1
ifneq ($(V),2)
  Q := @
endif
ifeq ($(V),1)
  define cmd-print
    @echo '$(1)'
  endef
endif


# check: fake-disk.img $(OBJ)vdisk.tgz
# 	qemu-system-x86_64 -m 4G -smp 4 -enable-kvm -drive file=$(IMG),if=virtio,media=disk,format=raw -drive file=$(OBJ)vdisk.tgz,if=virtio,media=disk,format=raw,snapshot=on
# qemu-system-x86_64 -m 4G -smp 4 -enable-kvm -drive file=$(IMG),if=virtio,media=disk,format=raw,snapshot=on -drive file=$(OBJ)vdisk.tgz,if=virtio,media=disk,format=raw,snapshot=on

all: $(ISO)archlinux-custom.iso

check: $(OBJ)system.img

# check: $(OBJ)devel.iso $(OBJ)disk.img $(OBJ)payload.img
# 	$(call cmd-qemu, $(filter %.iso, $^), $(filter %.img, $^))


$(OBJ)devel.iso: $(shell find archiso/devel -type f) | $(OBJ)
	$(call cmd-archiso, $@, archiso/devel)

$(ISO)archlinux-custom.iso: $(shell find archiso/custom -type f) \
                            $(shell find script -type f)         \
                            $(PKG)custom.db.tar.gz               \
                          | $(ISO)
	$(call cmd-cp, archiso/custom/airootfs/root/script, script)
	$(call cmd-cp, archiso/custom/airootfs/root/$(PKG), $(PKG))
	$(call cmd-archiso, $@, archiso/custom)

$(OBJ)disk.img: $(OBJ)devel.iso $(OBJ)payload.img | $(OBJ)
	$(call cmd-mkdisk, $@)
	$(call cmd-qemu, $(filter %.iso, $^), $@ $(filter %.img, $^))

$(OBJ)payload.img: $(PKG)custom.db.tar.gz $(shell find script -type f) | $(OBJ)
	$(call cmd-tgz, $@, $(PKG) script)

$(OBJ)system.img: $(OBJ)disk.img $(OBJ)payload.img | $(OBJ)
	$(call cmd-mkdelta, $@, disk.img)
	$(call cmd-qemu, , $(OBJ)payload.img, $@)


$(OBJ)vdisk.tgz: $(PKG)custom.db.tar.gz $(wildcard laurier/*) | $(OBJ)
	tar -czf $@ $(PKG) common laurier

$(PKG)custom.db.tar.gz: $(patsubst %, $(PKG)%.tar.xz, $(packages)) | $(PKG)
	rm $@ || true
	repo-add $@ $^

$(PKG)%.tar.xz: $(SRC)%/PKGBUILD | $(PKG)
	cd $(patsubst %/PKGBUILD, %, $<) ; makepkg --force --nodeps
	cp $(patsubst %/PKGBUILD, %, $<)/*.tar.xz $@


$(OBJ) $(PKG) $(ISO):
	$(call cmd-mkdir, $@)

clean:
	$(call cmd-clean, $(OBJ) $(PKG) $(ISO) \
            $(patsubst %, $(SRC)%/src, $(packages)) \
            $(patsubst %, $(SRC)%/pkg, $(packages)) \
            $(patsubst %, $(SRC)%/*.pkg.tar.xz, $(packages)))


define cmd-archiso
  $(call cmd-print,  ISO     $(strip $(1)))
  $(Q)sudo ./archiso/mkiso $(2) $(1)
endef

define cmd-clean
  $(call cmd-print,  CLEAN)
  $(Q)rm -rf $(1) 2> /dev/null || true
endef

define cmd-cp
  $(call cmd-print,  CP      $(strip $(1)))
  $(Q)test -e $(1) && rm -rf $(1) || true
  $(Q)cp -R $(2) $(1)
endef

define cmd-mkdelta
  $(call cmd-print,  DELTA   $(strip $(1)))
  $(Q)qemu-img create -f qcow2 $(1) -b $(2)
endef

define cmd-mkdir
  $(call cmd-print,  MKDIR   $(strip $(1)))
  $(Q)mkdir $(1)
endef

define cmd-mkdisk
  $(call cmd-print,  DISK    $(strip $(1)))
  $(Q)rm $(1) 2> /dev/null || true
  $(Q)truncate -s 8G $(1)
endef

define cmd-qemu
  $(call cmd-print,  QEMU    $(strip $(1)))
  $(Q)qemu-system-x86_64 -m 4G -smp 4 -enable-kvm \
      $(foreach disk, $(3), \
        -drive file=$(strip $(disk)),if=virtio,media=disk) \
      $(foreach disk, $(2), \
        -drive file=$(strip $(disk)),if=virtio,media=disk,format=raw) \
      $(foreach disk, $(1), \
        -drive file=$(strip $(disk)),media=cdrom)
endef

define cmd-tgz
  $(call cmd-print,  TAR     $(strip $(1)))
  $(Q)tar -czf $(1) $(2)
endef
