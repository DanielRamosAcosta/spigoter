#!/bin/bash

# Check for dependencies
type wget >/dev/null 2>&1 || { echo >&2 "[ERROR] I require wget but it's not installed. Aborting."; exit 1; }
type java >/dev/null 2>&1 || { echo >&2 "[ERROR] I require java but it's not installed. Aborting."; exit 1; }

PREFIX_INFO="[\e[34mINFO\e[0m]"
PREFIX_INPUT="[\e[32mQUESTION\e[0m]"
PREFIX_ERROR="[\e[31mERROR\e[0m]"
TIMESTAMP=$(date)

function yes_or_no(){
	local resp=""
	while [[ $resp != "y" && $resp != "yes" && $resp != "n" && $resp != "no" ]]; do
		echo -e "$PREFIX_SCRIPT $1 yes/no"
		read resp
	done
	if [[ $resp == "y" || $resp == "yes" ]]; then
		return 0
	else
		return 1
	fi
}

function ask(){
	echo -e -n "$PREFIX_INPUT $1 "
	read resp
	eval ${2}=${resp}
}

function say(){
	echo -e "$PREFIX_INFO $1"
}

function exit_error(){
	echo -e "$PREFIX_ERROR $1. Aborting."
	exit 1
}

# ============================================================================ Main script
if false; then
# [DEPEN] wget
mkdir build
cd build
say "Downloading Spigot..."
wget https://hub.spigotmc.org/jenkins/job/BuildTools/lastSuccessfulBuild/artifact/target/BuildTools.jar > /dev/null 2>&1
if [[ $? == "1" ]]; then
	exit_error "An error ocurred while downloading spigot"
fi

# [DEPEN] java
say "Compiling Spigot... (wait... a lot)"
java -jar BuildTools.jar > /dev/null 2>&1
if [[ $? == "1" ]]; then
	exit_error "An error ocurred while compiling spigot"
fi

cd .. # Return to main directory

say "Moving compiled file to main directory"
cp build/spigot-*.jar spigot.jar

say "Creating start script"
cat << EOF > start.sh
#!/bin/bash
java -Xms512M -Xmx1024M -jar spigot.jar
EOF
chmod u+x start.sh

say "First server run"
# We start the server
./start.sh > /dev/null 2>&1 # Clean output

# Accept EULA
yes_or_no "Do you accept EULA (https://account.mojang.com/documents/minecraft_eula)?"
EULA=$?
if [[ $EULA == "1" ]]; then
	exit_error "You must accept EULA in order to proceed"
fi
say "EULA accepted, continuing..."

sed -i -e 's/eula=false/eula=true/g' eula.txt

# ============================================================================ server.properties questions
fi
ask "What's the server name? [SuperServer]" SERVERNAME
ask "Is an online or offline server? [true]" ONLINEMODE

if [ -z "$SERVERNAME" ]; then
	SERVERNAME="SuperServer"
fi
if [ -z "$ONLINEMODE" ]; then
	ONLINEMODE="true"
fi

cat << EOF > server.properties
#Minecraft server properties
#$TIMESTAMP
generator-settings=
use-native-transport=true
op-permission-level=4
resource-pack-hash=
allow-nether=true
level-name=spawn
enable-query=false
allow-flight=false
announce-player-achievements=true
server-port=25565
max-world-size=29999984
level-type=DEFAULT
enable-rcon=false
force-gamemode=false
level-seed=
server-ip=
network-compression-threshold=256
max-build-height=256
spawn-npcs=true
white-list=false
spawn-animals=true
snooper-enabled=true
hardcore=false
online-mode=$ONLINEMODE
resource-pack=
pvp=true
difficulty=1
enable-command-block=false
player-idle-timeout=0
gamemode=0
max-players=20
spawn-monsters=true
view-distance=10
generate-structures=true
motd=Welcome to\u00a74\u00a7l \u00a74\u00a7l\u00a7n$SERVERNAME\u00a7r server!
EOF

#WIP