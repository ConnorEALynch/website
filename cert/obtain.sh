#!/bin/sh
# vim:sw=4:ts=4:et


#configure aws cli with deployer credentials
aws configure set aws_access_key_id ${AWS_ACCESS_KEY_ID}
aws configure set aws_secret_access_key ${AWS_SECRET_ACCESS_KEY}
aws configure set default.region ${REGION}
aws configure set region ${REGION}
cat ~/.aws/credentials


 
output=$(aws lightsail get-certificates --certificate-name "${CERT_NAME}")
output=$(echo ${output} | jq .certificates)
if [ -z "$output" ]; then
    echo "No cert with that name"
	  error=$(aws lightsail create-certificate --certificate-name "${CERT_NAME}" --domain-name "connorlynch.ca" --subject-alternative-names "${DOMAINS}" --output text 2>&1)
	  if [[ "$error" -ne 0 ]]; then
		echo "an error occured creating certificate"
	  else
		error=$(aws lightsail attach-certificate-to-distribution --distribution-name "${DIST_NAME}" --certificate-name  "${CERT_NAME}"  --output text 2>&1)
		if [[ "$error" -ne 0 ]]; then
			echo "an error occured attaching certificate"
		fi
	  fi
	  
else
    echo "found cert, is it in use ?"
	inUse=$(echo ${output} | jq '.[].certificateDetail.inUseResourceCount')
	if [ "$inUse"  -eq 0 ]; then
		echo "attach cert"
		error=$(aws lightsail attach-certificate-to-distribution --distribution-name "${DIST_NAME}" --certificate-name  "${CERT_NAME}"  --output text 2>&1)
		if [[ "$error" -ne 0 ]]; then
			echo "an error occured attaching certificate"
		fi	
	else 
		echo "the cert is already attached"
	fi
	
fi

