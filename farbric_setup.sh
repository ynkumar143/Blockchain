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
    # If ubuntu version is 16.04 you have to add 
    echo "Checking for go lang installation"
    go version
    echo "Do you want to install/update"  
    read -n1 -r -p "Press Y to continue..." key
      if [ "$key" = 'Y' ] || [ "$key" = 'y' ]; then
        echo " "
        echo "Un-installing go lang if any"
        sudo apt-get remove golang-go
        sudo rm -rvf /usr/local/go/
        echo "Installing 1.8.3 go language"
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
      else
        echo "Continue with further installation"
      fi

    echo "Checking for docker installation"
    docker version
    echo "Do you want to install/update"  
    read -n1 -r -p "Press Y to continue..." key
      if [ "$key" = 'Y' ] || [ "$key" = 'y' ]; then
        echo " "
        sudo apt install docker.io
      else 
        echo "Continue with further installation"
      fi

    echo "Checking for docker-composer installation"
    docker-compose version
    echo "Do you want to install/update"  
    read -n1 -r -p "Press Y to continue..." key
      if [ "$key" = 'Y' ] || [ "$key" = 'y' ]; then
        echo " "
        sudo apt install docker-compose
      else 
        echo "Continue with further installation"
      fi


    echo "Moving to go source folder"
    if [ ! -d "$GOPATH/src/github.com/hyperledger" ]; then
       mkdir -p $GOPATH/src/github.com/hyperledger
    fi
    
    cd $GOPATH/src/github.com/hyperledger

    if [ ! -d "$GOPATH/src/github.com/hyperledger/fabric" ]; then
       git clone https://github.com/hyperledger/fabric.git
    fi

    if [ ! -d "$GOPATH/src/github.com/hyperledger/fabric-samples" ]; then
       git clone https://github.com/hyperledger/fabric-samples.git
    fi

    if [ -d "$GOPATH/src/github.com/hyperledger/fabric-samples" ]; then
       if [ ! -d "$GOPATH/src/github.com/hyperledger/fabric-samples/bin" ]; then
       curl -sSL https://goo.gl/Gci9ZX | bash
       export PATH=$GOPATH/src/github.com/hyperledger/fabric-samples/bin:$PATH
       fi    
       echo "Testing your First network on Hyperledger"
       cd $GOPATH/src/github.com/hyperledger/fabric-samples/first-network
       ./byfn.sh -m generate
       echo "If the above step is successfull."
       ./byfn.sh -m up 
    fi
else
    # Anything else pressed, do whatever else.
     echo "Please install correct ubuntu distribution"
fi
