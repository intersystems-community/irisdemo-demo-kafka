
# This makefile will be run by the build script or docker autobuild hooks to produce the app.jar file we need
# for this worker. 
build:
	(cd /usr/projects/ingest-worker-project && mvn clean generate-sources package)

	# This parent project has many modules. Each module is a type of worker with exceptio of app-module
	# that has the shared code base for all workers.

	# Add a cp command here for each type of worker that has been created. 
	# We are eliminating the version number.
	cp /usr/projects/ingest-worker-project/payment-kafka-ingest-worker/target/payment-kafka-ingest-worker-*.jar /usr/projects/payment-kafka-ingest-worker.jar
	cp /usr/projects/ingest-worker-project/banksim-kafka-ingest-worker/target/banksim-kafka-ingest-worker-*.jar /usr/projects/banksim-kafka-ingest-worker.jar
	