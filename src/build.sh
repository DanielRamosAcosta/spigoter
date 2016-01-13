#!/bin/bash

# Check for dependencies
type wget >/dev/null 2>&1 || { echo >&2 "[ERROR] I require wget but it's not installed. Aborting."; exit 1; }
type java >/dev/null 2>&1 || { echo >&2 "[ERROR] I require java but it's not installed. Aborting."; exit 1; }


# [DEPEN] wget
mkdir build
cd build
wget https://hub.spigotmc.org/jenkins/job/BuildTools/lastSuccessfulBuild/artifact/target/BuildTools.jar

# [DEPEN] java
java -jar BuildTools.jar