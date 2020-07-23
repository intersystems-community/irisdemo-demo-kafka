FROM intersystemsdc/irisdemo-base-irisint-community:version-1.6

# Name of the project folder ex.: my-atelier-project
#ARG IRIS_PROJECT_FOLDER_NAME=iris-opcua-oee
ARG IRIS_PROJECT_FOLDER_NAME=src 

# Adding source code that will be loaded by the installer
ADD --chown=irisowner:irisuser ./${IRIS_PROJECT_FOLDER_NAME}/ $IRIS_APP_SOURCEDIR

ADD --chown=irisowner:irisuser ./us_states.json /tmp/

# Running the installer. This will load the source from our project.
RUN /usr/irissys/demo/irisdemoinstaller.sh 

ADD --chown=irisowner:irisuser ./html/landing-page.png $ISC_PACKAGE_INSTALLDIR/csp/appint/
ADD --chown=irisowner:irisuser ./html/image-map-resizer/js/imageMapResizer.min.js $ISC_PACKAGE_INSTALLDIR/csp/appint/
ADD --chown=irisowner:irisuser ./html/image-map-resizer/js/imageMapResizer.map $ISC_PACKAGE_INSTALLDIR/csp/appint/
