#!/bin/bash
touch finalCity_tax_Records.txt
touch Addresses.txt
awk '{print$2"_"$3"_"$4 ":" 0.2*$5 ":" $6}' City_tax_Records.txt | sort -V | grep No > cleanCity_tax_Records.txt

for person in $(cat cleanCity_tax_Records.txt)
do
    Address="$(echo $person | awk -F: '{print $1}')"
    Tax_Due_ofperson="$(echo -e $person | awk -F: '{print $2}')"
    check_address=$(tail -n 1 Addresses.txt)  # Use tail -n 1 to get the last line
    if [[ "$Address" != "$check_address" ]]
    then
        echo "$Address" >> Addresses.txt
        echo "$Address : $Tax_Due_ofperson" >> finalCity_tax_Records.txt
    else
        old_total=$(tail -n 1 finalCity_tax_Records.txt | awk -F: '{print $2}')  # Fix variable assignment
        new_total=$(echo "$old_total+$Tax_Due_ofperson"|bc)
        # Use sed to replace the old value with the new total
        sed -i "s/$old_total/$new_total/g" finalCity_tax_Records.txt
    fi
done
