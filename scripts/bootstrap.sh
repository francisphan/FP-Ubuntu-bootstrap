#!/bin/bash
abort(){
	echo "========="
	echo "==ABORT=="
	echo "========="
	exit 1
}

echo "Who are you?"
echo -e "I am: \c"
read user

sudo chown -R $(whoami) /usr/local
if [[ -z $(which brew) ]];then
	/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi

echo "====> Installing needed items for Virtual Machine"
brew tap caskroom/cask
if [[ ! -e '/usr/local/bin/VBoxManage' ]];then
	brew cask install virtualbox
else
	echo -e "\t Virtualbox already installed. Using version $(VboxManage -v)"
fi
if [[ ! -e '/usr/local/bin/vagrant' ]];then
	brew cask install vagrant
	vagrant plugin install vagrant-vbox-snapshot
	vagrant plugin install vagrant-vbguest
else
	echo -e "\t Vagrant already installed. Using version $(vagrant -v)"
fi

echo "====> Finding suitable name for Virtual Machine directory"
i=1
vmdir="$(pwd)/Vagrant-VMs/FP-Ubuntu-VM$i"
while [[ -d "$vmdir" ]];do
	echo -e "\t FP-Ubuntu-VM$i already exists"
	i=$((i+1))
	vmdir="$(pwd)/Vagrant-VMs/FP-Ubuntu-VM$i"
done

echo "====> Virtual Machine located in Vagrant-VMs/FP-Ubuntu-VM$i"
mkdir -p -- "$vmdir"


echo "====> Finding open port for SFTP connection"
port22=3022
testPort22=$(lsof -i:$port22)
portGroup=3
while [[ ! -z $testPort22 || $portGroup -gt 25 ]];do
	echo -e "\t $port22 currently in use"
	portGroup=$((portGroup+1))
	port22="${portGroup}022"
	testPort22=$(lsof -i:$port22)
done


cd $vmdir && vagrant init
cd ../..
cp $(pwd)/config/Vagrantfile $vmdir/Vagrantfile

if [[ $(vagrant -v) = "Vagrant 1.8.5" ]];then

	sed -i '' -e '16 i\'$'\n'' config.ssh.insert_key = false' $vmdir/Vagrantfile
fi

echo "====> Forwarding VM Port 22 to Port $port22 on Host machine"
echo ''
sed -i '' -e "s/guest: 22, host: .*/ guest: 22, host: $port22/" $vmdir/Vagrantfile

export PATH=$PATH:.
export vmdir=$vmdir
export user=$user

scripts/vagrant-vm-commands.sh

trap : 0
echo "============"
echo "=== DONE ==="
echo "============"

