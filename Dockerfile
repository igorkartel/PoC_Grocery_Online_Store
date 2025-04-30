FROM intersystemsdc/iris-ml-community:2024.3-zpm

USER root

WORKDIR /opt/irisapp

RUN chown ${ISC_PACKAGE_MGRUSER}:${ISC_PACKAGE_IRISGROUP} /opt/irisapp && \
    mkdir -p /external/durable && \
    chown ${ISC_PACKAGE_MGRUSER}:${ISC_PACKAGE_IRISGROUP} /external/durable && \
    mkdir -p /code/storeCode && \
    chown ${ISC_PACKAGE_MGRUSER}:${ISC_PACKAGE_IRISGROUP} /code/storeCode

USER ${ISC_PACKAGE_MGRUSER}

COPY src src
COPY module.xml module.xml
COPY iris.script /tmp/iris.script
COPY App.Installer.cls App.Installer.cls

RUN iris start IRIS && \
    iris session IRIS < /tmp/iris.script && \
    iris stop IRIS quietly