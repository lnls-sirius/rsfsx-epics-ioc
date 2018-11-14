#!/bin/sh

set -e
set +u

# Source environment
. ./checkEnv.sh

# Parse command-line options
. ./parseCMDOpts.sh "$@"

# Check last command return status
if [ $? -ne 0 ]; then
	echo "Could not parse command-line options" >&2
	exit 1
fi

if [ -z "$IPADDR" ]; then
    echo "\$IPADDR is not set, Please use -i option" >&2
    exit 2
fi

if [ -z "${DEVICE_TYPE}" ]; then
    echo "Device not set. Please use -d option or set \$DEVICE_TYPE environment variable" >&2
    exit 3
fi

if [ "${DEVICE_TYPE}" != "FSL" ] && [ "${DEVICE_TYPE}" != "FSV" ]; then
    echo "Device must be either \"FSL\" or \"FSV.\" Please use -d option or set \$DEVICE_TYPE environment variable" >&2
    exit 4
fi

if [ -z "$EPICS_CA_MAX_ARRAY_BYTES" ]; then
    export EPICS_CA_MAX_ARRAY_BYTES="50000000"
fi

ST_CMD_FILE=
case ${DEVICE_TYPE} in
    FSL)
        ST_CMD_FILE=stRSFSL.cmd
        ;;

    FSV)
        ST_CMD_FILE=stRSFSV.cmd
        ;;

    *)
        echo "Invalid Device type: "${DEVICE_TYPE} >&2
        exit 1
        ;;
esac

echo "Using st.cmd file: "${ST_CMD_FILE}

cd "$IOC_BOOT_DIR"

P="$P" R="$R" IPADDR="$IPADDR" "$IOC_BIN" ${ST_CMD_FILE}
