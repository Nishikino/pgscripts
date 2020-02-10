#!/bin/bash
#
# Title:      PGBlitz (Reference Title File)
# Authors:    Admin9705, Deiteq, and many PGBlitz Contributors
# URL:        https://pgblitz.com - http://github.pgblitz.com
# GNU:        General Public License v3.0
################################################################################

source /home15/maki/plexguide/pgclone/cloneclean.sh

# Starting Actions
touch /home15/maki/logs/pgblitz.log
truncate -s 0 /home15/maki/logs/pgblitz.log

echo "" >>/home15/maki/plexguide/logs/pgblitz.log
echo "" >>/home15/maki/plexguide/logs/pgblitz.log
echo "---Starting Blitz: $(date "+%Y-%m-%d %H:%M:%S")---" >>/home15/maki/plexguide/logs/pgblitz.log
hdpath="$(cat /home15/maki/plexguide/server.hd.path)"

startscript() {
    while read p; do

        # Update the vars
        useragent="$(cat /home15/maki/plexguide/uagent)"
        bwlimit="$(cat /home15/maki/plexguide/blitz.bw)"
        vfs_dcs="$(cat /home15/maki/plexguide/vfs_dcs)"
        vfs_mt="$(cat /home15/maki/plexguide/vfs_mt)"
        vfs_t="$(cat /home15/maki/plexguide/vfs_t)"
        vfs_c="$(cat /home15/maki/plexguide/vfs_c)"

        let "cyclecount++"

        if [[ $cyclecount -gt 4294967295 ]]; then
            cyclecount=0
        fi

        echo "" >>/home15/maki/plexguide/logs/pgblitz.log
        echo "---Begin cycle $cyclecount - $p: $(date "+%Y-%m-%d %H:%M:%S")---" >>/home15/maki/plexguide/logs/pgblitz.log
        echo "Checking for files to upload..." >>/home15/maki/plexguide/logs/pgblitz.log

        rsync "$hdpath/downloads/" "$hdpath/move/" \
            -aq --remove-source-files --link-dest="$hdpath/downloads/" \
            --exclude-from="/home15/maki/plexguide/transport.exclude" \
            --exclude="**_HIDDEN~" --exclude=".unionfs/**" \
            --exclude="**partial~" --exclude=".unionfs-fuse/**" \
            --exclude=".fuse_hidden**" --exclude="**.grab/**" \
            --exclude="**sabnzbd**" --exclude="**nzbget**" \
            --exclude="**qbittorrent**" --exclude="**rutorrent**" \
            --exclude="**deluge**" --exclude="**transmission**" \
            --exclude="**jdownloader**" --exclude="**makemkv**" \
            --exclude="**handbrake**" --exclude="**bazarr**" \
            --exclude="**ignore**" --exclude="**inProgress**"

        if [[ $(find "$hdpath/move" -type f | wc -l) -gt 0 ]]; then
            rclone moveto "$hdpath/move" "${p}C:/" \
                --config=/home15/maki/plexguide/rclone.conf \
                --log-file=/home15/maki/plexguide/logs/pgblitz.log \
                --log-level=INFO --stats=5s --stats-file-name-length=0 \