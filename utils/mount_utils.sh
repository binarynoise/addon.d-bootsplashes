#!/sbin/sh
# Credit: osm0sis @ xda-developers

# https://github.com/osm0sis/AnyKernel3/blob/3e99a63e924c5720c78d8d428e564661b38de810/META-INF/com/google/android/update-binary

setup_mountpoint() {
  [ -L $1 ] && mv -f $1 ${1}_link
  if [ ! -d $1 ]; then
    rm -f $1
    mkdir -p $1
  fi
}

is_mounted() { mount | grep -q " $1 "; }

umount_all() {
  local mount
  (
    umount /system
    umount -l /system
    if [ -e /system_root ]; then
      umount /system_root
      umount -l /system_root
    fi
    for mount in /mnt/system /vendor /mnt/vendor /product /mnt/product /persist /system_ext /mnt/system_ext; do
      umount $mount
      umount -l $mount
    done
    if [ "$UMOUNT_DATA" ]; then
      umount /data
      umount -l /data
    fi
    if [ "$UMOUNT_CACHE" ]; then
      umount /cache
      umount -l /cache
    fi
  ) 2>/dev/null
}

mount_partitions() {
  BOOTMODE=false
  ps | grep zygote | grep -v grep >/dev/null && BOOTMODE=true
  $BOOTMODE || ps -A 2>/dev/null | grep zygote | grep -v grep >/dev/null && BOOTMODE=true

  [ "$ANDROID_ROOT" ] || ANDROID_ROOT=/system

  # emulators can only flash booted and may need /system (on legacy images), or / (on system-as-root images), remounted rw
  if ! $BOOTMODE; then
    #mount -o bind /dev/urandom /dev/random
    if [ -L /etc ]; then
      setup_mountpoint /etc
      cp -af /etc_link/* /etc
      sed -i 's; / ; /system_root ;' /etc/fstab
    fi
    umount_all
    mount_all
  fi
  if [ -d /dev/block/mapper ]; then
    for block in system vendor product system_ext; do
      for slot in "" _a _b; do
        blockdev --setrw /dev/block/mapper/$block$slot 2>/dev/null
      done
    done
  fi
  mount -o rw,remount -t auto /system_root
  mount -o rw,remount -t auto /system || mount -o rw,remount -t auto /
  (
    mount -o rw,remount -t auto /vendor
    mount -o rw,remount -t auto /product
    mount -o rw,remount -t auto /system_ext
  ) 2>/dev/null

  for m in /system_root /system /vendor /product /system_ext; do
    if [ -d $m ] && [ ! -w $m ]; then
      abort "$m partitions could not be mounted as rw"
    fi
  done
}
