#!/bin/sh
# vim:sw=4:ts=4:et

#configure aws cli with deployer credentials
aws configure set aws_access_key_id ${AWS_ACCESS_KEY_ID}
aws configure set aws_secret_access_key ${AWS_SECRET_ACCESS_KEY}
aws configure set default.region ${REGION}
aws configure set region ${REGION}
cat ~/.aws/credentials

output=$(aws lightsail get-certificates --certificate-name "${CERT_NAME}" --include-certificate-details) 
output=$(echo ${output} | jq .certificates)
if [ -z "$output" ]; then
    echo "No certs"
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
    echo "found cert, does it expire soon?"
	# get the expiry datetime from JSON. split off time and collect date
	expiry=$(echo $output | jq '.[].certificateDetail.notAfter | split("T")[0]')
	# remove quotes from string and convert to seconds
	expiry=$(date -d $(echo $expiry | tr -d '"') +%s)
	#get current date add a month and convert to seconds
	now=$(date -d "+1 month" +%s)
	if [ $now -ge $expiry ]; then
		#no match 
		echo "cert expires in 30 days, renew"
		error=$(aws lightsail detach-certificate-from-distribution --distribution-name "${DIST_NAME}"  --output text 2>&1)
		if [[ "$error" -eq 0 ]]; then
			error=$(aws lightsail delete-certificate --certificate-name "${CERT_NAME}"  --output text 2>&1)
			if [[ "$error" -eq 0 ]]; then
				error=$(aws lightsail create-certificate --certificate-name "${CERT_NAME}" --domain-name "connorlynch.ca" --subject-alternative-names  "${DOMAINS}"  --output text 2>&1)
				if [[ "$error" -eq 0 ]]; then
					error=$(aws lightsail attach-certificate-to-distribution --distribution-name "${DIST_NAME}" --certificate-name  "${CERT_NAME}"  --output text 2>&1)
					if [[ "$error" -ne 0 ]]; then
						echo "an error occured attaching certificate to distribution"
					fi
				else
					echo "an error occured creating certificate"
				fi
			else
				echo "an error occured deleting old certificate"
			fi
		else 
			echo "an error occured detaching old certificate"
		fi
	else
		echo "cert is good no need to renew"
	fi

	
fi


