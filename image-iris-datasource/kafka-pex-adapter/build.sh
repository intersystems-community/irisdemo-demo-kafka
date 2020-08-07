#!/bin/bash

# mvn clean package

PROJECT_FOLDER=$PWD
COMPILER_CONTAINER=kafka-pex-adapter-compiler

exit_if_error() {
	if [ $(($(echo "${PIPESTATUS[@]}" | tr -s ' ' +))) -ne 0 ]; then
		echo ""
		echo "ERROR: $1"
		echo ""
		exit 1
	fi
}

rm -f ../kafka-pex-adapter.jar

echo "#" 
echo "# Starting container $COMPILER_CONTAINER to recompile jar..."
echo "#" 
docker ps -a | grep $COMPILER_CONTAINER > /dev/null

if [ $? -eq 0 ]; then
    # This will reuse the mavenc container that we used previously to compile the project
    # This way, we avoid redownloading all the depedencies!

    docker start -i $COMPILER_CONTAINER
    exit_if_error "Could not start container $COMPILER_CONTAINER"
else
    # First tiem trying to compile a project, let's create the mavenc container
    # It will download all the dependencies of the project
    docker run -i \
        -v ${PROJECT_FOLDER}:/usr/projects \
        --name $COMPILER_CONTAINER intersystemsdc/irisdemo-base-mavenc:version-1.4.0
    exit_if_error "Could not create and run container $COMPILER_CONTAINER"
fi

mv ./kafka-pex-adapter.jar ../