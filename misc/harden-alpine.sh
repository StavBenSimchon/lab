#!/bin/sh

# Credits: 
# https://github.com/ellerbrock/docker-collection/blob/master/dockerfiles/alpine-harden/harden.sh
# https://github.com/HazCod/hardened-alpine/blob/master/Dockerfile

set -euxo pipefail

# Remove existing crontabs, if any.
rm -rf /var/spool/cron
rm -rf /etc/crontabs
rm -rf /etc/periodic

# Remove all but a handful of admin commands.
find /sbin /usr/sbin ! -type d \
  -a ! -name nologin \
  -a ! -name sshd \
  -a ! -name apk \
  -a ! -name adduser \
  -delete

# Remove world-writable permissions.
# This breaks apps that need to write to /tmp,
# such as ssh-agent.
find / -xdev -type d -perm +0002 -exec chmod o-w {} +
find / -xdev -type f -perm +0002 -exec chmod o-w {} +

# Remove unnecessary user accounts.
# check if $APP_USER is set
if [ -z "$APP_USER" ]
then
  sed -i -r "/^(root|sshd)/!d" /etc/group
  sed -i -r "/^(root|sshd)/!d" /etc/passwd
  sed -i -r "/^(root|nobody)/!d" /etc/shadow
else
  sed -i -r "/^(${APP_USER}|root|sshd)/!d" /etc/group
  sed -i -r "/^(${APP_USER}|root|sshd)/!d" /etc/passwd
  sed -i -r "/^(${APP_USER}|root|nobody)/!d" /etc/shadow
  # Remove interactive login shell for everybody but user.
  sed -i -r '/^'${APP_USER}':/! s#^(.*):[^:]*$#\1:/sbin/nologin#' /etc/passwd
  # Remove root home dir
  rm -rf /root
fi

# Disable password login for everybody
while IFS=: read -r username _; do passwd -l "$username"; done < /etc/passwd || true

# Remove temp shadow,passwd,group
find /bin /etc /lib /sbin /usr -xdev -type f -regex '.*-$' -exec rm -f {} +

# Ensure system dirs are owned by root and not writable by anybody else.
find /bin /etc /lib /sbin /usr -xdev -type d \
  -exec chown root:root {} \; \
  -exec chmod 0755 {} \;

sysdirs="
  /bin
  /etc
  /lib
  /sbin
  /usr
"

# Remove other programs that could be dangerous.
find $sysdirs -xdev \( \
  -name hexdump -o \
  -name chgrp -o \
  -name chmod -o \
  -name chown -o \
  -name od -o \
  -name strings -o \
  -name su \
  \) -delete

# Remove init scripts since we do not use them.
rm -rf /etc/init.d
rm -rf /lib/rc
rm -rf /etc/conf.d
rm -rf /etc/inittab
rm -rf /etc/runlevels
rm -rf /etc/rc.conf

# Remove kernel tunables since we do not need them.
rm -rf /etc/sysctl*
rm -rf /etc/modprobe.d
rm -rf /etc/modules
rm -rf /etc/mdev.conf
rm -rf /etc/acpi

# Remove fstab
rm -f /etc/fstab

# Remove any symlinks that we broke during previous steps
find /bin /etc /lib /sbin /usr -xdev -type l -exec test ! -e {} \; -delete

# remove this file
rm -f "$0"