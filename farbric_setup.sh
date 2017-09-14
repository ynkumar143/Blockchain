#!/bin/bash
echo "Displaying Ubutu Properties"
echo "===================================================="
cat /etc/*-release
echo "===================================================="
echo "Check for Properties and Proceed further"
read -n1 -r -p "Press Y to continue..." key
echo " "
if [ "$key" = 'Y' ] || [ "$key" = 'y' ]; then
    # Space pressed, do something
    # If ubuntu version is 16.04 you have to add repository
    wget https://storage.googleapis.com/golang/go1.8.3.linux-amd64.tar.gz && \
    sudo tar -C /usr/local -xzf go1.8.3.linux-amd64.tar.gz && \
    rm go1.8.3.linux-amd64.tar.gz && \
    echo 'export PATH=$PATH:/usr/local/go/bin' | sudo tee -a /etc/profile && \
    echo 'export GOPATH=$HOME/go' | tee -a $HOME/.bashrc && \
    echo 'export PATH=$PATH:$GOROOT/bin:$GOPATH/bin' | tee -a $HOME/.bashrc && \
    source ~/.profile
    source ~/.bashrc
    mkdir -p $HOME/go/{src,pkg,bin}
    echo "Displaying go environment"
    go env
    echo "===================================================="
    echo "Install Docker platform on ubuntu"
    sudo apt install docker.io
    echo "Checking docker vesion infor"
    docker version
    echo "Install Docker-compose platform on ubuntu"
    sudo apt install docker-compose
    echo "Checking docker-compose version info"
    docker-compose version
    echo "Moving to go source folder"
    mkdir -p $GOPATH/src/github.com/hyperledger && \
    cd $GOPATH/src/github.com/hyperledger && \
    git clone https://github.com/hyperledger/fabric.git && \
    git clone https://github.com/hyperledger/fabric-samples.git && \
    cd fabric-samples
    curl -sSL https://goo.gl/Gci9ZX | bash
    export PATH=$GOPATH/src/github.com/hyperledger/fabric-samples/bin:$PATH
    echo "Testing your First network on Hyperledger"
    cd first-network
    ./byfn.sh -m generate
    echo "If the above step is successfull."
    ./byfn.sh -m up 
else
    # Anything else pressed, do whatever else.
     echo "Please install correct ubuntu distribution"
fi