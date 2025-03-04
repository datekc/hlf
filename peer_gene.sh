#!/bin/sh
#
# Copyright IBM Corp All Rights Reserved
#
# SPDX-License-Identifier: Apache-2.0
#
export FABRIC_CFG_PATH=${PWD}
export PATH=${PWD}:$PATH
echo $FABRIC_CFG_PATH
CHANNEL_NAME=mychannel
configtxgen -profile OneOrgChannel -outputCreateChannelTx ./config/channel.tx -channelID $CHANNEL_NAME
if [ "$?" -ne 0 ]; then
  echo "Failed to generate orderer genesis block..."
  exit 1
fi
