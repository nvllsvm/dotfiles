#!/usr/bin/env sh
set -ex
sudo rm -rf /usr/lib/firmware/ath10k/QCA6174/hw3.0/board-2.bin
sudo cp board.bin /usr/lib/firmware/ath10k/QCA6174/hw3.0/board.bin
