#!/bin/bash

set -euo pipefail

# Authors:
# (C) 2021 Idea an concept by Christian Zengel <christian@sysops.de>
# (C) 2021 Script design and prototype by Markus Helmke <m.helmke@nettwarker.de>
# (C) 2021 Script rework and documentation by Thorsten Spille <thorsten@spille-edv.de>

source /root/functions.sh
source /root/zamba.conf
source /root/constants-service.conf

wget -qO - https://adoptopenjdk.jfrog.io/adoptopenjdk/api/gpg/key/public | apt-key add -
add-apt-repository --yes https://adoptopenjdk.jfrog.io/adoptopenjdk/deb/

wget -O - https://www.mongodb.org/static/pgp/server-7.0.asc | gpg --dearmor > /usr/share/keyrings/mongodb-server-7.0.gpg
echo "deb [ signed-by=/usr/share/keyrings/mongodb-server-7.0.gpg ] http://repo.mongodb.org/apt/debian bookworm/mongodb-org/7.0 main" | sudo tee /etc/apt/sources.list.d/mongodb-org-7.0.list

apt update

DEBIAN_FRONTEND=noninteractive DEBIAN_PRIORITY=critical apt install -y -qq default-jre-headless jsvc mongodb-org

DL=$(wget -O - -q  https://www.tp-link.com/de/support/download/omada-software-controller/ 2>/dev/null | grep -m1 -o "https.*Omada_SDN_Controller.*linux_x64.deb")

wget -O /tmp/omada.deb -q $DL

DEBIAN_FRONTEND=noninteractive DEBIAN_PRIORITY=critical apt install -y -qq /tmp/omada.deb