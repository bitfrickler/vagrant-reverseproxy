#!/bin/bash

sudo apt-get -y install golang

echo "export GOPATH=/vagrant/src/go" >> ~/.profile
echo "export PATH=$PATH:$GOPATH/bin" >> ~/.profile