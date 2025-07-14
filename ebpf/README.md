# eBPF

go 언어로 작성하며

## 설치

개발 환경 구축
> sudo apt update \
sudo apt install -y \
&nbsp;&nbsp;&nbsp;&nbsp;build-essential \
&nbsp;&nbsp;&nbsp;&nbsp;clang \
&nbsp;&nbsp;&nbsp;&nbsp;llvm \
&nbsp;&nbsp;&nbsp;&nbsp;libbpf-dev \
&nbsp;&nbsp;&nbsp;&nbsp;libelf-dev \
&nbsp;&nbsp;&nbsp;&nbsp;linux-headers-$(uname -r) \
&nbsp;&nbsp;&nbsp;&nbsp;pkg-config

sudo apt-get update
wget https://go.dev/dl/go1.21.0.linux-amd64.tar.gz
sudo tar -xvf go1.21.0.linux-amd64.tar.gz
sudo mv go /usr/local
export GOROOT=/usr/local/go
export GOPATH=$HOME/go
export PATH=$GOPATH/bin:$GOROOT/bin:$PATH
source ~/.profile

## references
+ [1] https://github.com/iovisor/bcc/tree/master
+ [2] https://github.com/eunomia-bpf/bpf-developer-tutorial
