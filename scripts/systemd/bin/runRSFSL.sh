#!/usr/bin/env bash
	
set -u

if [ -z "$RSFSL_INSTANCE" ]; then
    echo "RSFSL_INSTANCE environment variable is not set." >&2
    exit 1
fi

export RSFSL_CURRENT_PV_AREA_PREFIX=RSFSL_${RSFSL_INSTANCE}_PV_AREA_PREFIX
export RSFSL_CURRENT_PV_DEVICE_PREFIX=RSFSL_${RSFSL_INSTANCE}_PV_DEVICE_PREFIX
export RSFSL_CURRENT_DEVICE_IP=RSFSL_${RSFSL_INSTANCE}_DEVICE_IP
export RSFSL_CURRENT_DEVICE_TELNET_PORT=RSFSL_${RSFSL_INSTANCE}_TELNET_PORT
# Only works with bash
export RSFSL_PV_AREA_PREFIX=${!RSFSL_CURRENT_PV_AREA_PREFIX}
export RSFSL_PV_DEVICE_PREFIX=${!RSFSL_CURRENT_PV_DEVICE_PREFIX}
export RSFSL_DEVICE_IP=${!RSFSL_CURRENT_DEVICE_IP}
export RSFSL_DEVICE_TELNET_PORT=${!RSFSL_CURRENT_DEVICE_TELNET_PORT}

if [ -z "${RSFSL_CURRENT_DEVICE_TELNET_PORT}" ]; then
    echo "TELNET port is not set." >&2
    exit 1
fi

./runProcServ.sh \
    -t "${RSFSL_DEVICE_TELNET_PORT}" \
    -i "${RSFSL_DEVICE_IP}" \
    -P "${RSFSL_PV_AREA_PREFIX}" \
    -R "${RSFSL_PV_DEVICE_PREFIX}"

