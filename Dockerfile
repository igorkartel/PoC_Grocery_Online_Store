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

RUN iris start IRIS && \
    iris session IRIS < /opt/irisapp/src/iris-install.script && \
    iris stop IRIS quietly && \
    iris start IRIS && \
    iris session IRIS < /opt/irisapp/src/iris-load.script && \
    iris stop IRIS quietly