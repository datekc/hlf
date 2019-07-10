# Dockerfile for Hyperledger peer image. This actually follow yeasy/hyperledger-fabric
# image and add default start cmd.
# Data is stored under /var/hyperledger/db and /var/hyperledger/production

FROM yeasy/hyperledger-fabric-base:release-v1.4
LABEL maintainer "Baohua Yang <yeasy.github.com>"

EXPOSE 7051
EXPOSE 7053
# ENV CORE_PEER_MSPCONFIGPATH $FABRIC_CFG_PATH/msp
RUN mkdir -p $FABRIC_CFG_PATH /etc/hyperledger/fabric/peer /etc/hyperledger/fabric/peer/msp

ENV CORE_VM_ENDPOINT=unix:///host/var/run/docker.sock
ENV CORE_PEER_ID=peer
ENV FABRIC_LOGGING_SPEC=info
ENV CORE_CHAINCODE_LOGGING_LEVEL=info
ENV CORE_PEER_LOCALMSPID=OrgMSP
ENV CORE_PEER_MSPCONFIGPATH=/etc/hyperledger/fabric/peer/msp
ENV CORE_PEER_ADDRESS=peer:7051
ENV CORE_PEER_CHAINCODELISTENADDRESS=0.0.0.0:7052
COPY peer/msp /etc/hyperledger/fabric/peer/msp
COPY config/channel.tx /etc/hyperledger/fabric

# install fabric peer and copy sampleconfigs
RUN cd $FABRIC_ROOT/peer \
    && go install -tags "experimental" -ldflags "$LD_FLAGS" \
    && go clean

# This will start with joining the default chain "testchainid"
# Use `peer node start --peer-defaultchain=false` will join no channel by default.
# Then need to manually create a chain with `peer channel create -c test_chain`, then join with `peer channel join -b test_chain.block`.
CMD ["peer","node","start"]
