#!/bin/bash

# Starting Actions
touch /home15/maki/logs/pgblitz.log
truncate -s 0 /home15/maki/logs/pgblitz.log

echo "" >>/home15/maki/logs/pgblitz.log
echo "" >>/home15/maki/logs/pgblitz.log
echo "---Starting Blitz: $(date "+%Y-%m-%d %H:%M:%S")---" >>/home15/maki/logs/pgblitz.log
hdpath="$(cat /home15/maki/scripts/server.hd.path)"

startscript() {
    while read p; do

        # Update the vars
        useragent="$(cat /home15/maki/scripts/uagent)"
        bwlimit="$(cat /home15/maki/scripts/blitz.bw)"
        vfs_dcs="$(cat /home15/maki/scripts/vfs_dcs)"
        vfs_mt="$(cat /home15/maki/scripts/vfs_mt)"
        vfs_t="$(cat /home15/maki/scripts/vfs_t)"
        vfs_c="$(cat /home15/maki/scripts/vfs_c)"

        let "cyclecount++"

        if [[ $cyclecount -gt 4294967295 ]]; then
            cyclecount=0
        fi

        echo "" >>/home15/maki/logs/pgblitz.log
        echo "---Begin cycle $cyclecount - $p: $(date "+%Y-%m-%d %H:%M:%S")---" >>/home15/maki/logs/pgblitz.log
        echo "Checking for files to upload..." >>/home15/maki/logs/pgblitz.log

        rsync "$hdpath/downloads/" "$hdpath/move/" \
            -aq --remove-source-files --link-dest="$hdpath/downloads/" \
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
                --config=/home15/maki/.config/rclone/rclone.conf \
                --log-file=/home15/maki/logs/pgblitz.log \
                --log-level=INFO --stats=5s --stats-file-name-length=0 \
                --max-size=300G \
                --tpslimit=10 \
                --checkers="$vfs_c" \
                --transfers="$vfs_t" \
                --no-traverse \
                --fast-list \
                --max-transfer "$vfs_mt" \
                --bwlimit="$bwlimit" \
                --drive-chunk-size="$vfs_dcs" \
                --user-agent="$useragent" \
                --exclude="**_HIDDEN~" --exclude=".unionfs/**" \
                --exclude="**partial~" --exclude=".unionfs-fuse/**" \
                --exclude=".fuse_hidden**" --exclude="**.grab/**" \
                --exclude="**sabnzbd**" --exclude="**nzbget**" \
                --exclude="**qbittorrent**" --exclude="**rutorrent**" \
                --exclude="**deluge**" --exclude="**transmission**" \
                --exclude="**jdownloader**" --exclude="**makemkv**" \
                --exclude="**handbrake**" --exclude="**bazarr**" \
                --exclude="**ignore**" --exclude="**inProgress**"

            echo "Upload has finished." >>/home15/maki/logs/pgblitz.log
        else
            echo "No files in $hdpath/downloads to upload." >>/home15/maki/logs/pgblitz.log
        fi

        echo "---Completed cycle $cyclecount: $(date "+%Y-%m-%d %H:%M:%S")---" >>/home15/maki/logs/pgblitz.log
        echo "$(tail -n 200 /home15/maki/logs/pgblitz.log)" >/home15/maki/logs/pgblitz.log
        #sed -i -e "/Duplicate directory found in destination/d" /home15/maki/logs/pgblitz.log

    done </home15/maki/plexguide/.blitzfinal
}
    exit