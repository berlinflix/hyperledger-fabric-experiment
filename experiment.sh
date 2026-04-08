#!/bin/bash
export PATH="$HOME/bin:$HOME/fabric-samples/test-network/../bin:$PATH"
export FABRIC_CFG_PATH="$HOME/fabric-samples/test-network/../config/"
export CORE_PEER_TLS_ENABLED=true
export CORE_PEER_LOCALMSPID="Org1MSP"
export CORE_PEER_TLS_ROOTCERT_FILE="$HOME/fabric-samples/test-network/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt"
export CORE_PEER_MSPCONFIGPATH="$HOME/fabric-samples/test-network/organizations/peerOrganizations/org1.example.com/users/Admin@org1.example.com/msp"
export CORE_PEER_ADDRESS=localhost:7051

ORDERER_CA="$HOME/fabric-samples/test-network/organizations/ordererOrganizations/example.com/orderers/orderer.example.com/msp/tlscacerts/tlsca.example.com-cert.pem"
ORG1_CA="$HOME/fabric-samples/test-network/organizations/peerOrganizations/org1.example.com/peers/peer0.org1.example.com/tls/ca.crt"
ORG2_CA="$HOME/fabric-samples/test-network/organizations/peerOrganizations/org2.example.com/peers/peer0.org2.example.com/tls/ca.crt"

echo "=== Cleaning up previous run ==="
peer chaincode invoke \
  -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com \
  --tls --cafile "$ORDERER_CA" \
  -C mychannel -n basic \
  --peerAddresses localhost:7051 --tlsRootCertFiles "$ORG1_CA" \
  --peerAddresses localhost:9051 --tlsRootCertFiles "$ORG2_CA" \
  -c '{"function":"DeleteAsset","Args":["Asset-2"]}' 2>/dev/null || true
sleep 3

echo "=== Step 1: InitLedger ==="
peer chaincode invoke \
  -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com \
  --tls --cafile "$ORDERER_CA" \
  -C mychannel -n basic \
  --peerAddresses localhost:7051 --tlsRootCertFiles "$ORG1_CA" \
  --peerAddresses localhost:9051 --tlsRootCertFiles "$ORG2_CA" \
  -c '{"function":"InitLedger","Args":[]}' 2>&1
sleep 3

echo ""
echo "=== Step 2: CreateAsset (ID=Asset-2, Owner=Suyash) ==="
peer chaincode invoke \
  -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com \
  --tls --cafile "$ORDERER_CA" \
  -C mychannel -n basic \
  --peerAddresses localhost:7051 --tlsRootCertFiles "$ORG1_CA" \
  --peerAddresses localhost:9051 --tlsRootCertFiles "$ORG2_CA" \
  -c '{"function":"CreateAsset","Args":["Asset-2","blue","5","Suyash","10000"]}' 2>&1
sleep 3

echo ""
echo "=== Step 3: ReadAsset ==="
peer chaincode query -C mychannel -n basic -c '{"Args":["ReadAsset","Asset-2"]}' 2>&1 | python3 -m json.tool
echo ""
sleep 10

echo ""
echo "=== Step 4: TransferAsset (Suyash -> Arun) ==="
peer chaincode invoke \
  -o localhost:7050 --ordererTLSHostnameOverride orderer.example.com \
  --tls --cafile "$ORDERER_CA" \
  -C mychannel -n basic \
  --peerAddresses localhost:7051 --tlsRootCertFiles "$ORG1_CA" \
  --peerAddresses localhost:9051 --tlsRootCertFiles "$ORG2_CA" \
  -c '{"function":"TransferAsset","Args":["Asset-2","Arun"]}' 2>&1
sleep 3

echo ""
echo "=== Step 5: ReadAsset ==="
peer chaincode query -C mychannel -n basic -c '{"Args":["ReadAsset","Asset-2"]}' 2>&1 | python3 -m json.tool
echo ""
sleep 10

echo ""
echo "=== Step 6: GetAllAssets ==="
peer chaincode query -C mychannel -n basic -c '{"Args":["GetAllAssets"]}' 2>&1 | python3 -m json.tool
echo ""
sleep 10

echo ""
echo "=== EXPERIMENT COMPLETE ==="
