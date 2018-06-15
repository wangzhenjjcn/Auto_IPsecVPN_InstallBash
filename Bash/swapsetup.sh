touch /mnt/swap
dd if=/dev/vda  of=/mnt/swap bs=1M count=4096
chmod 600 /mnt/swap
mkswap  /mnt/swap
swapon /mnt/swap
swapon -s
echo "/mnt/swap none swap sw 0 0" >>  /etc/fstab