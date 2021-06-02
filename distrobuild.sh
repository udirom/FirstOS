#!/bin/bash

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )"
DISTRO=$(lsb_release -i | awk '{print $3}')


if [ "$DISTRO" == "Fedora" ]
then
	bash -c "$SCRIPT_DIR/fedorabuild.sh"
else
	# Assume Debian based.
	# TBD: make things explicit
	bash -c "$SCRIPT_DIR/debianbasedbuild.sh"
fi