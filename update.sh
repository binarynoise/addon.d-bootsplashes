#!/sbin/sh

# At the time this file is executed, the following partitions are mounted:
# /system_root /system /system_ext /vendor /product /data

# redirect stout and stderr to /cache/install.log

ui_print "placing addon.d survival script..."
unzip -o "$ZIPFILE" 99-bootsplashes.sh -d /system/addon.d/
ui_print "done"
