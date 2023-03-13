#!/bin/bash

trivyResults=$(<"$1")

criticalFlag=false

vulnList=$(echo $trivyResults | jq '[.Results[0] | .Vulnerabilities[] | { CVE: .VulnerabilityID, PkgID: .PkgID, Severity: .Severity, URL: .PrimaryURL}]' )

rm formattedTrivy.txt

printf '%b\n' "Severity    | CVE     | URL       " >> formattedTrivy.txt
printf '%b\n' "------------|---------| --------- " >> formattedTrivy.txt

for i in $(jq -c '.[]' <<< "$vulnList"); 
do 
    if [ "$(jq -r '.Severity?' <<< "$i")" = "CRITICAL" ] ; then
        criticalFlag=true
    fi
    printf '%b\n' "$(jq -j '.Severity," | ", .CVE, " | ",  .URL' <<< "$i")" >> formattedTrivy.txt
done 

echo $criticalFlag


