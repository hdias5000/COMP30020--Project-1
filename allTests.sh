#!/bin/bash

assign() {
  eval "$1=\$(cat; echo .); $1=\${$1%.}"
}

culprits=("SBF SBM" "SBF SRF" "SBF SRM" "SBF SDF" "SBF SDM" "SBF TBF" "SBF TBM" "SBF TRF" "SBF TRM" "SBF TDF" "SBF TDM" "SBM SRF" "SBM SRM" "SBM SDF" "SBM SDM" "SBM TBF" "SBM TBM" "SBM TRF" "SBM TRM" "SBM TDF" "SBM TDM" "SRF SRM" "SRF SDF" "SRF SDM" "SRF TBF" "SRF TBM" "SRF TRF" "SRF TRM" "SRF TDF" "SRF TDM" "SRM SDF" "SRM SDM" "SRM TBF" "SRM TBM" "SRM TRF" "SRM TRM" "SRM TDF" "SRM TDM" "SDF SDM" "SDF TBF" "SDF TBM" "SDF TRF" "SDF TRM" "SDF TDF" "SDF TDM" "SDM TBF" "SDM TBM" "SDM TRF" "SDM TRM" "SDM TDF" "SDM TDM" "TBF TBM" "TBF TRF" "TBF TRM" "TBF TDF" "TBF TDM" "TBM TRF" "TBM TRM" "TBM TDF" "TBM TDM" "TRF TRM" "TRF TDF" "TRF TDM" "TRM TDF" "TRM TDM" "TDF TDM" "SBF SBM" "SBF SRF" "SBF SRM" "SBF SDF" "SBF SDM" "SBF TBF" "SBF TBM" "SBF TRF" "SBF TRM" "SBF TDF" "SBF TDM" "SBM SRF" "SBM SRM" "SBM SDF" "SBM SDM" "SBM TBF" "SBM TBM" "SBM TRF" "SBM TRM" "SBM TDF" "SBM TDM" "SRF SRM" "SRF SDF" "SRF SDM" "SRF TBF" "SRF TBM" "SRF TRF" "SRF TRM" "SRF TDF" "SRF TDM" "SRM SDF" "SRM SDM" "SRM TBF" "SRM TBM" "SRM TRF" "SRM TRM" "SRM TDF" "SRM TDM" "SDF SDM" "SDF TBF" "SDF TBM" "SDF TRF" "SDF TRM" "SDF TDF" "SDF TDM" "SDM TBF" "SDM TBM" "SDM TRF" "SDM TRM" "SDM TDF" "SDM TDM" "TBF TBM" "TBF TRF" "TBF TRM" "TBF TDF" "TBF TDM" "TBM TRF" "TBM TRM" "TBM TDF" "TBM TDM" "TRF TRM" "TRF TDF" "TRF TDM" "TRM TDF" "TRM TDM" "TDF TDM" "SBM SBF" "SRF SBF" "SRM SBF" "SDF SBF" "SDM SBF" "TBF SBF" "TBM SBF" "TRF SBF" "TRM SBF" "TDF SBF" "TDM SBF" "SRF SBM" "SRM SBM" "SDF SBM" "SDM SBM" "TBF SBM" "TBM SBM" "TRF SBM" "TRM SBM" "TDF SBM" "TDM SBM" "SRM SRF" "SDF SRF" "SDM SRF" "TBF SRF" "TBM SRF" "TRF SRF" "TRM SRF" "TDF SRF" "TDM SRF" "SDF SRM" "SDM SRM" "TBF SRM" "TBM SRM" "TRF SRM" "TRM SRM" "TDF SRM" "TDM SRM" "SDM SDF" "TBF SDF" "TBM SDF" "TRF SDF" "TRM SDF" "TDF SDF" "TDM SDF" "TBF SDM" "TBM SDM" "TRF SDM" "TRM SDM" "TDF SDM" "TDM SDM" "TBM TBF" "TRF TBF" "TRM TBF" "TDF TBF" "TDM TBF" "TRF TBM" "TRM TBM" "TDF TBM" "TDM TBM" "TRM TRF" "TDF TRF" "TDM TRF" "TDF TRM" "TDM TRM" "TDM TDF")

ProjTest="./Proj1Test"

sum=0
tot=0

for culprit in "${culprits[@]}"
do
	echo "Testing culprits:" $culprit
	testResponse=$(eval $ProjTest $culprit)
	assign guesses < <(echo $testResponse | grep -oE '\s[0-9]{1,3}\s')
	echo -e "Culprits found in" $guesses "guesses\n"
	sum=$((sum+guesses))
	tot=$((tot+1))
done

echo -e "\n"

echo "Total tests run:" $tot
echo "Total guesses:" $sum
awk -v awksum="$sum" -v awktot="$tot" 'BEGIN {print "Average guesses to solve: " awksum/awktot}'
