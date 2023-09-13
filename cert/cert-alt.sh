#!/bin/sh
# vim:sw=4:ts=4:et


#configure aws cli with deployer credentials
aws configure set aws_access_key_id ${AWS_ACCESS_KEY_ID}
aws configure set aws_secret_access_key ${AWS_SECRET_ACCESS_KEY}
aws configure set default.region ${REGION}
aws configure set region ${REGION}
cat ~/.aws/credentials


 
output=$(aws lightsail get-certificates --region ${REGION} --include-certificate-details) 
echo "$output"
output=$(echo ${output} | jq .certificates)
if [ -z "$output" ]; then
    echo "No certs"
	  aws lightsail create-certificate --certificate-name "${CERT_NAME}" --domain-name "connorlynch.ca" --subject-alternative-names "${DOMAINS[*]}"
	  aws lightsail attach-certificate-to-distribution --distribution-name "${DISTRIBUTION}" --certificate-name  "${CERT_NAME}"
else
    echo "found certs, how many are in use ?"
	sum=$(echo ${output} | jq '[.[].certificateDetail.inUseResourceCount] | add')
	echo "$sum";
	if [ "$sum"  -lt 2 ]; then
		#map list to cert name
		certdomains=$(echo ${output} | jq '[.[] | {certificateName: .certificateName , subjectAlternativeNames: .certificateDetail.subjectAlternativeNames}]')
		echo "$certdomains"
		
		jq -c '.[]' certdomains | while read entry; do
			if [ "${domains[@]}" == "${DOMAINS[@]}" ] ; then 
				#match. attach cert with matching domains
				break
			else
				#no match 
				echo "no certificates match the domains. create and attach cert"
			    #aws lightsail create-certificate --certificate-name "${CERT_NAME}" --domain-name "connorlynch.ca" --subject-alternative-names  "${DOMAINS[*]}"
				#aws lightsail attach-certificate-to-distribution --distribution-name "${DISTRIBUTION}" --certificate-name  "${CERT_NAME}"
			fi
		done
	fi

	
fi


