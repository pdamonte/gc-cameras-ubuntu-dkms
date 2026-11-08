#!/usr/bin/env bash
set -euo pipefail

PACKAGE_NAME=gc-cameras
PACKAGE_VERSION=0.2.0

if [ "$(id -u)" -ne 0 ]; then
	echo "Run as root: sudo $0" >&2
	exit 1
fi

modprobe -r gc8034 gti5035 intel_ipu6_isys intel_ipu6 ipu_bridge 2>/dev/null || true
dkms remove -m "${PACKAGE_NAME}" -v "${PACKAGE_VERSION}" --all || true
rm -f /etc/modules-load.d/gc-cameras.conf
rm -rf "/usr/src/${PACKAGE_NAME}-${PACKAGE_VERSION}"
depmod
