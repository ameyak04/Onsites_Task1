#!/bin/sh
        PATH=$PATH:$HOME
        #Create Directories and files for studetnts
        rm -r $HOME/Tax
        rm -r $HOME/Taxpending
        mkdir $HOME/Tax
        mkdir $HOME/Taxpending 
        echo " Creating Household member file based on $HOME/City_tax_Records.txt \n"
        awk '{print$1":"$2":"$3":"$4":"$5":"$6":"}' $HOME/City_tax_Records.txt > $HOME/lean_City_tax_Records.txt
        for member in $(cat $HOME/Clean_City_tax_Records.txt)
        do
        Name="$(echo $member | awk -F:  '{print $1}')"
        HouseNumber="$(echo $member | awk -F:  '{print $2}')"
        District="$(echo $member | awk -F:  '{print $3}')"
        City="$(echo $member | awk -F:  '{print $4}')"
        Income="$(echo $member | awk -F:  '{print $5}')"
        Taxpaidstatus="$(echo $member | awk -F:  '{print $6}')"
        echo "$Name:$Income:$Taxpaidstatus">>$HOME/Tax/$HouseNumber"_"$District"_"$City
        done
        for House in $(ls $HOME/Tax/*)
        do
                Taxpending=0
                for member in $(cat $House)
                do
                Name="$(echo $member | awk -F:  '{print $1}')"
                Income="$(echo $member | awk -F:  '{print $2}')"
                Taxpaidstatus="$(echo $member | awk -F:  '{print $3}')"
                echo " I am in $member"
                if [ "$Taxpaidstatus" = "No" ];
                then
                Taxformember="$(echo $Income*0.2|bc)"
                echo $Taxformember
                echo $Taxpending
                Taxpending=$(echo "$Taxformember + $Taxpending" |bc )
                echo $Taxpending
                fi
                done
                FileName="$(echo $House | awk -F/  '{print $5}')"
                echo "House Address is : $FileName" > $HOME/Taxpending/$FileName"_Taxdue"
                echo " TaxPending is : $Taxpending" >> $HOME/Taxpending/$FileName"_Taxdue"
        done 
