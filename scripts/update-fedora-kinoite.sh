#!/bin/sh
set -ex
rpm-ostree upgrade
sudo dbus-launch flatpak update
