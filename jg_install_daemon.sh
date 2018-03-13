#!/bin/sh

PROJECT_PATH=`pwd`
conf_file=$PROJECT_PATH"/jg-wallet/joltgas.conf"
joltinit="/lib/systemd/system/joltgas.service"

EXT_IP="`wget -qO- http://ipecho.net/plain`"
YOURKEY=$1
#YOURKEY="n3keTrJiu1AUGYo4iNV5LQVtFNR5EGL1KBHG1tJbtdpUTKfTdE"

if [$YOURKEY=""]; then
{
  echo "You must inter the masternode private key as argument!"
  exit 0
}
fi

apt-get update
apt-get install wget libdb5.3++ libboost-all-dev libdb5.3++ unzip libboost-all-dev dh-autoreconf build-essential libtool autotools-dev \
autoconf automake libssl-dev libboost-all-dev libevent-dev bsdmainutils \
libminiupnpc-dev libprotobuf-dev protobuf-compiler libqrencode-dev software-properties-common \
libgmp3-dev git nano -y

add-apt-repository ppa:bitcoin/bitcoin -y
apt-get update && apt-get install libdb4.8-dev libdb4.8++-dev -y

git clone https://github.com/JoltDev/Jolt-Gas
cd $PROJECT_PATH/Jolt-Gas
chmod +x ./compile-daemon.sh
./compile-daemon.sh
cd ..

killall joltgasd
sleep 5

mkdir jg-wallet
cp -f $PROJECT_PATH/Jolt-Gas/src/joltgasd $PROJECT_PATH/

echo rpcuser=user >$conf_file
echo rpcpassword=password1 >>$conf_file
echo server=1 >>$conf_file
echo listen=1 >>$conf_file
echo daemon=1 >>$conf_file
echo staking=0 >>$conf_file
echo masternode=1 >>$conf_file
echo masternodeaddr=$EXT_IP:2333 >>$conf_file
echo masternodeprivkey=$YOURKEY >>$conf_file

echo "[Unit]" >$joltinit
echo "Description=JoltGas's distributed currency daemon" >>$joltinit
echo "After=network.target" >>$joltinit
echo "" >>$joltinit
echo "[Service]" >>$joltinit
echo "" >>$joltinit
echo "Type=forking" >>$joltinit
echo "PIDFile=/var/run/joltgasd.pid" >>$joltinit
echo "ExecStart=$PROJECT_PATH/joltgasd -daemon -datadir="'"'$PROJECT_PATH"/jg-wallet"'"'" -pid=/var/run/joltgasd.pid -conf="'"'$PROJECT_PATH"/jg-wallet/joltgas.conf"'"' >>$joltinit
echo "" >>$joltinit
echo "Restart=always" >>$joltinit
echo "PrivateTmp=true" >>$joltinit
echo "TimeoutStopSec=60s" >>$joltinit
echo "TimeoutStartSec=2s" >>$joltinit
echo "StartLimitInterval=120s" >>$joltinit
echo "StartLimitBurst=5" >>$joltinit
echo "" >>$joltinit
echo "[Install]" >>$joltinit
echo "WantedBy=multi-user.target" >>$joltinit

systemctl daemon-reload
systemctl enable joltgas.service
service joltgas start

sleep 5

$PROJECT_PATH/joltgasd -datadir="$PROJECT_PATH/jg-wallet" getinfo

echo "Installation complete..."
