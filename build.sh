#!/bin/bash

# Thanks https://github.com/dataviruset/sm-hosties/blob/master/build.sh

HASH="$(git log --pretty=format:%h -n 1)"

# Download und extract sourcemod
wget -q "http://www.sourcemod.net/latest.php?version=1.10&os=linux" -O sourcemod.tar.gz
# wget "http://www.sourcemod.net/latest.php?version=$1&os=linux" -O sourcemod.tar.gz

tar -xzf sourcemod.tar.gz

rm -r addons/sourcemod/translations
rm -r addons/sourcemod/scripting/admin-flatfile
rm -r addons/sourcemod/scripting/adminmenu
rm -r addons/sourcemod/scripting/basebans
rm -r addons/sourcemod/scripting/basecomm
rm -r addons/sourcemod/scripting/basecommands
rm -r addons/sourcemod/scripting/basevotes
rm -r addons/sourcemod/scripting/funcommands
rm -r addons/sourcemod/scripting/funvotes
rm -r addons/sourcemod/scripting/playercommands
rm -r addons/sourcemod/scripting/testsuite
rm -r addons/metamod
rm -r addons/sourcemod/bin
rm -r addons/sourcemod/configs/geoip
rm -r addons/sourcemod/configs/sql-init-scripts
rm -r addons/sourcemod/data
rm -r addons/sourcemod/extensions
rm -r addons/sourcemod/gamedata
rm -r addons/sourcemod/logs
rm -r addons/sourcemod/plugins
rm -r cfg
rm addons/sourcemod/*.txt
rm addons/sourcemod/scripting/adminhelp.sp
rm addons/sourcemod/scripting/adminmenu.sp
rm addons/sourcemod/scripting/admin-sql-prefetch.sp
rm addons/sourcemod/scripting/admin-sql-threaded.sp
rm addons/sourcemod/scripting/antiflood.sp
rm addons/sourcemod/scripting/basebans.sp
rm addons/sourcemod/scripting/basechat.sp
rm addons/sourcemod/scripting/basecommands.sp
rm addons/sourcemod/scripting/basecomm.sp
rm addons/sourcemod/scripting/basetriggers.sp
rm addons/sourcemod/scripting/basevotes.sp
rm addons/sourcemod/scripting/clientprefs.sp
rm addons/sourcemod/scripting/funcommands.sp
rm addons/sourcemod/scripting/funvotes.sp
rm addons/sourcemod/scripting/mapchooser.sp
rm addons/sourcemod/scripting/nextmap.sp
rm addons/sourcemod/scripting/nominations.sp
rm addons/sourcemod/scripting/playercommands.sp
rm addons/sourcemod/scripting/randomcycle.sp
rm addons/sourcemod/scripting/reservedslots.sp
rm addons/sourcemod/scripting/rockthevote.sp
rm addons/sourcemod/scripting/sounds.sp
rm addons/sourcemod/scripting/sql-admin-manager.sp
rm addons/sourcemod/configs/admins_simple.ini
rm addons/sourcemod/configs/*.txt
rm addons/sourcemod/configs/*.cfg

# Give compiler rights for compile
chmod +x addons/sourcemod/scripting/spcomp

# Download missing includes
wget https://raw.githubusercontent.com/ashort96/SetCollisionGroup/master/addons/sourcemod/scripting/includes/SetCollisionGroup.inc -O addons/sourcemod/scripting/include/SetCollisionGroup.inc

# Compile plugin
addons/sourcemod/scripting/spcomp -E -v0 addons/sourcemod/scripting/jailbreak.sp
