#!/bin/bash
#
# Title:      PGBlitz (Reference Title File)
# Authors:    Admin9705, Deiteq, and many PGBlitz Contributors
# URL:        https://pgblitz.com - http://github.pgblitz.com
# GNU:        General Public License v3.0
################################################################################
sleep 2

hdpath="$(cat /home15/maki/plexguide/server.hd.path)"
mergerfs -o sync_read,auto_cache,dropcacheonclose=true,use_ino,allow_other,func.getattr=newest,category.create=ff,minfreespace=0,fsname=pgunion \
$hdpath/move=RW:$hdpath/downloads=RW:/home15/maki/mnt/tdrive=NC:/home15/maki/mnt/gdrive=NC:/home15/maki/mnt/tcrypt=NC:/home15/maki/mnt/gcrypt=NC /home15/maki/mnt/unionfs
