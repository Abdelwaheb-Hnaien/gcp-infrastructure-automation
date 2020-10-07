#!/bin/bash
if [ "$1" = "dry-deploy" ]
then
	python /templating.py
    terraform init -reconfigure 
	terraform  plan -lock=false
        exit 0
elif [ "$1" = "deploy" ]
then
        python /templating.py
        terraform init -reconfigure
        terraform  apply -lock=false -auto-approve
        exit 0
elif [ "$1" = "clean" ]
then
        python /templating.py
        terraform init -reconfigure
        terraform  destroy -lock=false -auto-approve
        exit 0
else
	echo "N/A"
	exit 2
fi
