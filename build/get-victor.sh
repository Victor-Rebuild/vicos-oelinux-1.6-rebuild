#!/bin/bash

VICTOR_LINK="https://github.com/Switch-modder/vicos-oelinux-1.6-rebuild/releases/download/victor-submodule/wire-victor.tar.gz"
VICTOR_NAME="wire-victor.tar.gz"

if [[ ! -d anki/anki-ble ]]; then
    echo "Error. This script must be run in the vicos-oelinux folder"
    exit 1
fi

if [[ -f anki/victor/EXTERNALS/animation-assets/anim_manifest.json ]]; then
	echo "Victor already downloaded and extracted"
	exit 0
else
	echo "Getting victor"
	rm -rf anki/victor/ anki/$VICTOR_NAME
	cd anki/
	wget $VICTOR_LINK
	tar -xzf $VICTOR_NAME
	rm $VICTOR_NAME
	echo "Victor downloaded"
fi
