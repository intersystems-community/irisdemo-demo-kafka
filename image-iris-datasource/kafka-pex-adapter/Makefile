
# This makefile will be run by the build script or docker autobuild hooks to produce the app.jar file we need
# for this worker. 
build:
	(cd /usr/projects && mvn clean package)

	# We are eliminating the version number.
	cp /usr/projects/target/kafka-pex-adapter-*-jar-with-dependencies.jar /usr/projects/kafka-pex-adapter.jar

	