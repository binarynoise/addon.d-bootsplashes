#!/sbin/sh
#
# ADDOND_VERSION=2
#
# /system/addon.d/90-bootsplashes.sh
#

case "$1" in
backup)
    dd if=/dev/block/by-name/up_param of=/tmp/up_param
    ;;
restore)
    dd if=/tmp/up_param of=/dev/block/by-name/up_param
    ;;
pre-backup)
    # Stub
    ;;
post-backup)
    # Stub
    ;;
pre-restore)
    # Stub
    ;;
post-restore)
    # Stub
    ;;
esac
