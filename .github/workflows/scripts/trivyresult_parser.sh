#!/bin/bash

if [ ! -z "$1" ]
then
    trivyResults=$(<"$1")
    echo "Results File inserted"

    criticalFlag=false

    vulnList=$(echo $trivyResults | jq '[.Results[0] | .Vulnerabilities[] | { CVE: .VulnerabilityID, PkgID: .PkgID, Severity: .Severity, URL: .PrimaryURL}]' )


    printf '%b\n' "Severity    | CVE     | URL       " >> formattedTrivy.txt
    printf '%b\n' "------------|---------| --------- " >> formattedTrivy.txt

    for i in $(jq -c '.[]' <<< "$vulnList"); 
    do 
        if [ "$(jq -r '.Severity?' <<< "$i")" = "CRITICAL" ] ; then
            criticalFlag=true
        fi
        printf '%b\n' "$(jq -j '.Severity," | ", .CVE, " | ",  .URL' <<< "$i")" >> formattedTrivy.txt
    done 

    cat formattedTrivy.txt

    if [ "$criticalFlag" == true ]; 
    then 
        echo "Critical CVE found" ; 
        exit 1
    else 
        echo "No Critical CVE  found"; 
        exit 0
    fi
else
    echo "Results File not inserted"
fi
