#!/bin/bash

# http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -euo pipefail
IFS=$'\n\t'

#
# https://docs.docker.com/install/linux/docker-ce/debian/#install-docker-ce-1
#
apt-get -y remove \
	docker \
	docker-engine \
	docker.io

apt-get update &&
	apt-get install -y \
		apt-transport-https \
		ca-certificates \
		gnupg2 \
		wget \
		curl \
		software-properties-common

curl -fsSL https://download.docker.com/linux/$(
	. /etc/os-release
	echo "$ID"
)/gpg | apt-key add -

add-apt-repository \
	"deb [arch=amd64] https://download.docker.com/linux/$(
		. /etc/os-release
		echo "$ID"
	) \
   $(lsb_release -cs) \hheh
   stable"
apt-get update && apt-get -y install docker-ce

sudo systemctl enable docker

#
# https://docs.docker.com/compose/install/#install-compose
#
compose_install_url=https://github.com/docker/compose/releases/download/1.19.0/docker-compose-$(uname -s)-$(uname -m)
curl -L ${compose_install_url} -o /usr/local/bin/docker-compose && chmod +x /usr/local/bin/docker-compose
