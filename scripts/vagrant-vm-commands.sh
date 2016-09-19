#!/bin/bash

echo $user
echo $vmdir

echo "====> Running initial Vagrant Up"
i='no'
echo "Running 'vagrant destroy' just in case"
cd $vmdir && vagrant destroy --force

while [[ $i = 'no' ]];do
	cd $vmdir && vagrant up --destroy-on-error
	if [[ $? -eq 0 ]];then
		i='yup'
	else
		echo "====> Rerunning vagrant up"
	fi
done

echo "====> Installing brew to Virtual Machine"
cd $vmdir && vagrant ssh -c "sudo apt-get -y install git"
cd $vmdir && vagrant ssh -c "git clone \"https://github.com/francisphan/FP-Ubuntu-bootstrap.git\""

