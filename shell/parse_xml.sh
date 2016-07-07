#!/bin/bash

set -e 

xmlFile=$1

function parseXML() {
  elemList=( $(cat $xmlFile | tr '\n' ' ' | XMLLINT_INDENT="" xmllint --format - | grep -e "</.*>$" | while read line; do \
    echo $line | sed -e 's/^.*<\///' | cut -d '>' -f 1; \
  done) )

  totalNoOfTags=${#elemList[@]}; ((totalNoOfTags--))
  suffix=$(echo ${elemList[$totalNoOfTags]} | tr -d '</>')
  suffix="${suffix}_"

  for (( i = 0 ; i < ${#elemList[@]} ; i++ )); do
    elem=${elemList[$i]}
    elemLine=$(cat $xmlFile | tr '\n' ' ' | XMLLINT_INDENT="" xmllint --format - | grep "</$elem>")
    echo $elemLine | grep -e "^</[^ ]*>$" 1>/dev/null 2>&1
    if [ "0" = "$?" ]; then
      continue
    fi
    elemVal=$(echo $elemLine | tr '\011' '\040'| sed -e 's/^[ ]*//' -e 's/^<.*>\([^<].*\)<.*>$/\1/' | sed -e 's/^[ ]*//' | sed -e 's/[ ]*$//')
    xmlElem="${suffix}$(echo $elem | sed 's/-/_/g')"
    eval ${xmlElem}=`echo -ne \""${elemVal}"\"`
    attrList=($(cat $xmlFile | tr '\n' ' ' | XMLLINT_INDENT="" xmllint --format - | grep "</$elem>" | tr '\011' '\040' | sed -e 's/^[ ]*//' | cut -d '>' -f 1  | sed -e 's/^<[^ ]*//' | tr "'" '"' | tr '"' '\n'  | tr '=' '\n' | sed -e 's/^[ ]*//' | sed '/^$/d' | tr '\011' '\040' | tr ' ' '>'))
    for (( j = 0 ; j < ${#attrList[@]} ; j++ )); do
      attr=${attrList[$j]}
      (j++)
      attrVal=$(echo ${attrList[$j]} | tr '>' ' ')
      attrName=`echo -ne ${xmlElem}_${attr}`
      eval ${attrName}=`echo -ne \""${attrVal}"\"`
    done
  done
}
parseXML
echo "$status_xyz |  $status_abc |  $status_pqr" #Variables for each  XML ELement
echo "$status_xyz_arg1 |  $status_abc_arg2 |  $status_pqr_arg3 | $status_pqr_arg4" #Variables for each XML Attribute
echo ""

#All the variables that were produced by the parseXML function
set | grep -e "^$suffix"
