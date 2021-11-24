OBJ := obj/
ISO := iso/


V ?= 1
ifneq ($(V),2)
  Q := @
endif
ifeq ($(V),1)
  define cmd-print
    @echo '$(1)'
  endef
endif


all: $(ISO)autoinstaller.iso


check: $(OBJ)stage-2.img

$(OBJ)stage-1.img: $(OBJ)devinstaller.iso $(OBJ)devscripts.iso | $(OBJ)
	$(call cmd-print,  MKDISK  $@)
	$(Q)truncate -s 8G $@
	$(call cmd-print,  QEMU    $(OBJ)devinstaller.iso + $@ + $(OBJ)devscripts.iso)
	$(Q)qemu-system-x86_64 -m 4G -smp 4 -enable-kvm               \
          -drive file=$(OBJ)devinstaller.iso,media=cdrom,format=raw   \
          -drive file=$@,if=virtio,media=disk,format=raw              \
          -drive file=$(OBJ)devscripts.iso,if=virtio,media=disk

$(OBJ)stage-2.img: $(OBJ)stage-1.img | $(OBJ)
	$(call cmd-print,  MKDELTA $@)
	$(Q)qemu-img create -f qcow2 $@ -b $(notdir $<) -F raw
	$(call cmd-print,  QEMU    $@)
	$(Q)qemu-system-x86_64 -m 4G -smp 4 -enable-kvm  \
          -drive file=$@,if=virtio,media=disk


# Two possible stems: auto and dev
#
# Auto: Complete ISO, ready to burn.
# Can take a long time to produce. Create it only when ze are sure about the
# quality of the install scripts.
#
# Dev: Stub ISO, needs an additional disk.
# Only a normal archiso to unpack and execute the content of another external
# disk. No need to rebuild it after a modification to install scripts.
#
define INSTALLER-ISO-TEMPLATE

  $(strip $(2))$(strip $(1))installer.iso: prepare \
                $$(shell find $(strip $(1))root -type f) | $(strip $(2))
	$$(call cmd-print,  PREPARE $$@)
	$$(Q)./prepare -b $$@ -d $(strip $(1))root \
          $(strip $(2))$(strip $(1))installer

endef

$(eval $(call INSTALLER-ISO-TEMPLATE, auto, $(ISO)))
$(eval $(call INSTALLER-ISO-TEMPLATE, dev,  $(OBJ)))


$(OBJ)devscripts.iso: $(shell find autoroot -type f) | $(OBJ)
	$(call cmd-print,  MKISO   $@)
	$(Q)xorriso -outdev $@ -blank as_needed -joliet on \
          $$(ls -1A autoroot | while read f ; do \
                 echo "-map autoroot/$$f /$$f" ; done)


$(OBJ) $(ISO):
	$(call cmd-mkdir, $@)

clean:
	$(call cmd-clean, $(OBJ) $(ISO))


define cmd-clean
  $(call cmd-print,  CLEAN)
  $(Q)rm -rf $(1) 2> /dev/null || true
endef

define cmd-mkdir
  $(call cmd-print,  MKDIR   $(strip $(1)))
  $(Q)mkdir $(1)
endef
