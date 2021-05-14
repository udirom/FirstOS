#!/bin/bash

sudo apt-get install -y nvidia-detect; \
	
export NVIDIA_DRIVER_PACKAGE=`nvidia-detect 2>/dev/null | tail -n 2 | head -n 1 | xargs`; \
echo "$NVIDIA_DRIVER_PACKAGE" | grep nvidia-; \
if [ $? -eq 0 ]; then \
    export DEBIAN_ARCH_NAME=`uname -r | rev | cut -d- -f1 | rev`; \
    export DEBIAN_ARCH_NAME_FALLBACK=`uname -r | rev | cut -d- -f1,2 | rev`; \
    sudo apt-get install -y build-essential ${NVIDIA_DRIVER_PACKAGE} && \
    sudo apt-get autoremove -y; \
else \
    echo "No nvidia GPU was detected."; \
fi
