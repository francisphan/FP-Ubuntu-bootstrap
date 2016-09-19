#!/bin/bash

cd Vagrant-VMs
i=$(ls -1 | wc -l)
i=$((i+1))
pwd
while [[ $i -gt 0 ]];do
	vm="$(pwd)/FP-Ubuntu-VM$i"
	if [[ -d "$vm" ]];then
		cd "$vm" && vagrant destroy --force
		pwd
		cd ..
		rm -rf "$vm"
		if [[ $? -eq 0 ]];then
			echo "VM$i destroyed"
		fi
	fi
	i=$((i-1))
done	


