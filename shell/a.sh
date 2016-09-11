#!/bin/bash

set -e 

declare -a array1=(1 2 3 4 5)
declare -a array2=(1 2 3 4 5)

count=0

for num1 in ${array1[@]}
do
    for num2 in ${array2[@]}
    do
        sum=$((num1 + num2)) 
        if [ $sum -eq 6 ];then
            count=$(($count + 1))
        fi
    done
done
echo $count

