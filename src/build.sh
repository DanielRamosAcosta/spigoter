#!/bin/bash

# Goto strick
#if false; then # GOTO SKIP
#fi             # :SKIP

# Check for dependencies
type wget >/dev/null 2>&1 || { echo >&2 "[ERROR] I require wget but it's not installed. Aborting."; exit 1; }
type java >/dev/null 2>&1 || { echo >&2 "[ERROR] I require java but it's not installed. Aborting."; exit 1; }
type screen >/dev/null 2>&1 || { echo >&2 "[ERROR] I require screen but it's not installed. Aborting."; exit 1; }

PREFIX_INFO="[\e[34mINFO\e[0m]"
PREFIX_INPUT="[\e[32mQUESTION\e[0m]"
PREFIX_ERROR="[\e[31mERROR\e[0m]"
TIMESTAMP=$(date)

function yes_or_no(){
	local resp=""
	while [[ $resp != "y" && $resp != "yes" && $resp != "n" && $resp != "no" ]]; do
		echo -e -n "$PREFIX_INPUT $1 yes/no: "
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

function create_screen(){
	screen -d -m -S $1
}

function remove_screen(){
	screen -S $1 -p 0 -X stuff "exit$(printf \\r)"
}

function execute_command(){
	screen -S $1 -p 0 -X stuff "$2$(printf \\r)"
}

function get_pid(){
	local pid=$(ps -A -o pid,cmd|grep $1 | grep -v grep |head -n 1 | awk '{print $1}')
	echo "$pid"
}

function wait_pid(){
	status=0
	while [[ $status == 0 ]]; do
		sleep 1
		dummy=$(ps -aux | awk '{print $2}' | grep $1)
		status=$?
		echo -n "."
	done
	echo "."
}

function run_and_close_server(){
	create_screen minecraft
	execute_command minecraft ./start.sh
	sleep 7s
	execute_command minecraft stop
	pid=$(get_pid spigot)
	wait_pid $pid
	remove_screen minecraft
}

# ============================================================================ Main script

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

create_screen buildtools
execute_command buildtools "java -jar BuildTools.jar"
sleep 1s
pid=$(get_pid BuildTools)
wait_pid $pid
remove_screen buildtools

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
yes_or_no "Do you accept the EULA (https://account.mojang.com/documents/minecraft_eula)?"
EULA=$?
if [[ $EULA == "1" ]]; then
	exit_error "You must accept the EULA in order to proceed"
fi
say "EULA accepted, continuing..."

say "Setting EULA to true in eula.txt"
sed -i -e 's/eula=false/eula=true/g' eula.txt

# ============================================================================ Start server again to generate all files

say "Starting server to generate config files"

run_and_close_server

say "Files are now generated"
# World cleanup

say "Cleaning default world"
rm -rf world
rm -rf world_nether
rm -rf world_the_end

# ============================================================================ server.properties questions

ask "What's the server name? [SuperServer]" SERVERNAME
ask "Is an online or offline server? [true]" ONLINEMODE

if [ -z "$SERVERNAME" ]; then
	SERVERNAME="SuperServer"
fi
if [ -z "$ONLINEMODE" ]; then
	ONLINEMODE="true"
fi

say "Configuring server.properties"
sed -i -e "s/motd=A Minecraft Server/motd=Welcome to\\\u00a74\\\u00a7l \\\u00a74\\\u00a7l\\\u00a7n$SERVERNAME\\\u00a7r server!/g" server.properties
sed -i -e "s/online-mode=true/online-mode=$ONLINEMODE/g" server.properties
sed -i -e "s/level-name=world/level-name=spawn/g" server.properties
sed -i -e "s/allow-nether=true/allow-nether=false/g" server.properties # Delegate world managment to Multiverse Plugin

say "Configuring bukkit.yml"
sed -i -e "s/allow-end: true/allow-end: false/g" bukkit.yml # Delegate world managment to Multiverse Plugin
sed -i -e "s/shutdown-message: Server closed/shutdown-message: Server closed\\n  world-container: worlds/g" bukkit.yml # Make a diractory for world

# ============================================================================ create spawn world

say "Generating spawn world..."

# TODO: make a welcome message in the spawn
mkdir worlds
mv spawn.tar.gz worlds
cd worlds
tar -zxvf spawn.tar.gz > /dev/null 2>&1 # Clean output
rm spawn.tar.gz

say "Done"

# ============================================================================ Import MultiVerse plugin