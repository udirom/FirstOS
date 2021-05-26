#!/bin/bash

read -p "Do you want to setup btrfs for timeshift snapshots? Your computer may not boot after this! (y/N) " -n 1 -r
if [[ $REPLY =~ ^[Yy]$ ]]
then
    BTRFS_PARTITION=$(sudo blkid | grep TYPE=\"btrfs\" | awk '{ print $1 }' | sed 's/:$//')
    sudo mkdir -p /btrfs_pool
    mount -o subvolid=5 $BTRFS_PARTITION /btrfs_pool
    sudo mv /btrfs_pool/root /btrfs_pool/@
    sudo mv /btrfs_pool/home /btrfs_pool/@home
    sudo sed -i 's/subvol=root/subvol=@/' /etc/fstab
    sudo sed -i 's/subvol=home/subvol=@home/' /etc/fstab
    grub2-mkconfig -o /boot/efi/EFI/fedora/grub.cfg
fi
