#!/bin/bash
# This script is meant to be run in the User Data of each EC2 Instance while it's booting. The script uses the
# run-nomad and run-consul scripts to configure and start Consul and Nomad in server mode. Note that this script
# assumes it's running in an AMI built from the Packer template in examples/nomad-consul-ami/nomad-consul.json.

set -e

readonly NOMAD_ADDR='http://localhost:4646'

# Send the log output from this script to user-data.log, syslog, and the console
# From: https://alestic.com/2010/12/ec2-user-data-output/
exec > >(tee /var/log/user-data.log|logger -t user-data -s 2>/dev/console) 2>&1

# These variables are passed in via Terraform template interplation
/opt/consul/bin/run-consul --server --cluster-tag-key "${cluster_tag_key}" --cluster-tag-value "${cluster_tag_value}"
/opt/nomad/bin/run-nomad --server --num-servers "${num_servers}"
