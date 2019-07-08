# Dockerfile for Hyperledger fabric-orderer image.

FROM yeasy/hyperledger-fabric-base:release-v1.4
LABEL maintainer "Baohua Yang <yeasy.github.com>"

EXPOSE 7050

#ENV FABRIC_CFG_PATH /etc/hyperledger/fabric
#ENV ORDERER_GENERAL_GENESISPROFILE=SampleInsecureSolo
RUN mkdir -p $FABRIC_CFG_PATH /etc/hyperledger/fabric/orderer /etc/hyperledger/fabric/orderer/msp
#ENV ORDERER_GENERAL_LOCALMSPDIR $FABRIC_CFG_PATH/msp
ENV FABRIC_LOGGING_SPEC=info
ENV ORDERER_GENERAL_LISTENADDRESS=0.0.0.0
ENV ORDERER_GENERAL_GENESISMETHOD=file
ENV ORDERER_GENERAL_GENESISFILE=/etc/hyperledger/fabric/genesis.block
ENV ORDERER_GENERAL_LOCALMSPID=OrgMSP
ENV ORDERER_GENERAL_LOCALMSPDIR=/etc/hyperledger/fabric/orderer/msp
COPY  orderer/msp /etc/hyperledger/fabric/orderer/msp
COPY  config/genesis.block /etc/hyperledger/fabric
# ENV CONFIGTX_ORDERER_ORDERERTYPE=solo

#RUN mkdir -p $FABRIC_CFG_PATH /etc/hyperledger/fabric/orderer /etc/hyperledger/fabric/orderer/msp

# install hyperledger fabric orderer
RUN cd $FABRIC_ROOT/orderer \
        && CGO_CFLAGS=" " go install -tags "experimental" -ldflags "$LD_FLAGS -linkmode external -extldflags '-static -lpthread'" \
        && go clean

CMD ["orderer", "start"]
