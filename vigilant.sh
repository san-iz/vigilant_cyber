#!/bin/bash

# vigilant.sh
# A basic script to run Nmap scans

# Function to display usage information
usage() {
    echo "Usage: $0 -t <target> [-p <ports>] [-s <scan_type>]"
    echo "  -t <target>     Target IP or domain name"
    echo "  -p <ports>      Comma-separated list of ports to scan (e.g., 22,80,443)"
    echo "  -s <scan_type>  Type of scan (e.g., SYN scan, TCP connect)"
    echo "  -h              Display this help message"
    exit 1
}

# Parse command-line options
while getopts ":t:p:s:h" opt; do
    case ${opt} in
        t )
            target=$OPTARG
            ;;
        p )
            ports=$OPTARG
            ;;
        s )
            scan_type=$OPTARG
            ;;
        h )
            usage
            ;;
        \? )
            echo "Invalid option: -$OPTARG" 1>&2
            usage
            ;;
        : )
            echo "Invalid option: -$OPTARG requires an argument" 1>&2
            usage
            ;;
    esac
done
shift $((OPTIND -1))

# Check if the target is provided
if [ -z "$target" ]; then
    echo "Error: Target is required."
    usage
fi

# Build the Nmap command based on options
nmap_cmd="nmap"

if [ -n "$ports" ]; then
    nmap_cmd+=" -p $ports"
fi

if [ -n "$scan_type" ]; then
    case $scan_type in
        SYN)
            nmap_cmd+=" -sS"
            ;;
        TCP)
            nmap_cmd+=" -sT"
            ;;
        *)
            echo "Invalid scan type: $scan_type"
            usage
            ;;
    esac
fi

# Run the Nmap scan
echo "Running Nmap scan on target: $target"
$nmap_cmd $target

# End of script
