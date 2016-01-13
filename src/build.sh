#!/bin/bash

# Check for dependencies
type wget >/dev/null 2>&1 || { echo >&2 "[ERROR] I require wget but it's not installed. Aborting."; exit 1; }
type java >/dev/null 2>&1 || { echo >&2 "[ERROR] I require java but it's not installed. Aborting."; exit 1; }

function yes_or_no(){
	local resp=""
	while [[ $resp != "y" && $resp != "yes" && $resp != "n" && $resp != "no" ]]; do
		echo "$1 yes/no"
		read resp
	done
	if [[ $resp == "y" || $resp == "yes" ]]; then
		return 0
	else
		return 1
	fi
}

function exit_error(){
	echo "[ERROR] $1. Aborting."
	exit 1
}

# ============================================================================ Main script

# [DEPEN] wget
# mkdir build
cd build
wget https://hub.spigotmc.org/jenkins/job/BuildTools/lastSuccessfulBuild/artifact/target/BuildTools.jar

# [DEPEN] java
java -jar BuildTools.jar

cd .. # Return to main directory

cp build/spigot-*.jar spigot.jar

cat << EOF > start.sh
#!/bin/bash
java -Xms512M -Xmx1024M -jar spigot.jar
EOF

# We start the server
./start.sh

# Accept EULA
yes_or_no "Do you accept EULA (https://account.mojang.com/documents/minecraft_eula)?"
EULA=$?
if [[ $EULA == "1" ]]; then
	exit_error "You must accept EULA in order to proceed"
fi
echo "EULA accepted, continuing..."