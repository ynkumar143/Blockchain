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
        echo "Updating softwares in ubuntu"
        sudo apt-get update
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
        #For clear understanding follow the article 
        #https://docs.docker.com/engine/installation/linux/docker-ce/ubuntu/#install-using-the-repository
          
        echo "Uninstalling docker-ce version"
        sudo apt-get purge docker-ce

        sudo rm -rf /var/lib/docker

        echo "Updating apt package"
        sudo apt-get update
        
        echo "Install packages to allow apt to use repository over HTTPS"

        sudo apt-get install \
        apt-transport-https \
        ca-certificates \
        curl \
        software-properties-common
        
        echo "Add Docker official GPG key"

        curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

        echo " "
        echo "Verify the fingerprint is as below"

        echo "9DC8 5822 9FC7 DD38 854A E2D8 8D81 803C 0EBF CD88"
         

        read -n1 -r -p "Press Space to continue..." key
          if [ "$key" = ' ' ] ; then
             echo "Continuing...."
          fi

          sudo apt-key fingerprint 0EBFCD88
             
          echo "Type of Distribution...."   

          echo " amd64 - A"
          echo " armhf - B"
          echo " s390x - C"
          read -n1 -r -p "Press appropriate key to continue..." key

          if [ "$key" = 'A' ]; then
             sudo add-apt-repository \
             "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
             $(lsb_release -cs) \
             stable"
          fi

          if [ "$key" = 'B' ]; then
             sudo add-apt-repository \
             "deb [arch=armhf] https://download.docker.com/linux/ubuntu \
             $(lsb_release -cs) \
             stable"
          fi

          if [ "$key" = 'C' ]; then
             sudo add-apt-repository \
             "deb [arch=s390x] https://download.docker.com/linux/ubuntu \
             $(lsb_release -cs) \
             stable"
          fi

        sudo apt-get update
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
        sudo apt-get update
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
       cd $GOPATH/src/github.com/hyperledger/fabric-samples
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
