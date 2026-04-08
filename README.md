# Hyperledger Fabric: Building a Private Blockchain

This repository contains the experiment script used in the article  
**"Hyperledger Fabric: Building a Private Blockchain"**  
published in Open Source For You (OSFY) Magazine.

## What This Does

Runs a complete digital asset lifecycle on a local Hyperledger Fabric network:
- Creates an asset owned by Suyash
- Verifies it on the ledger
- Transfers ownership to Arun
- Audits the full ledger state

## Prerequisites

- Windows 11 with WSL 2
- Docker Desktop with WSL 2 backend enabled
- Hyperledger fabric-samples installed at `~/fabric-samples`

## Setup

Download Hyperledger Fabric binaries and images:

```bash
cd ~
curl -sSLO https://raw.githubusercontent.com/hyperledger/fabric/main/scripts/install-fabric.sh
chmod +x install-fabric.sh
./install-fabric.sh docker samples binary
