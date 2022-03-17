#!/bin/zsh
myQuery=$1
myOutput='grep "." "5-letter.txt"'
myFlag="notset"
for block in $myQuery
do

    for ((i=0; i<${#block}; i++)); 
        do  
        if [[ "${block:$i:1}" == [a-z] ]] || [[ "${block:$i:1}" == '.' ]] ; then  #first, setting the flag what type of block is this? one of 3 (include, exclude, literal)
            if [[ $myFlag == "notset" ]] ; then
            myFlag='literal'
            literalBlock='| grep ^"${block}" '
            
            continue
            fi
        elif [ "${block:$i:1}" == '(' ];then   #bracket, letters to be included
        
            myFlag='included'
            #echo $myFlag
            continue
        elif [ "${block:$i:1}" == '[' ];then # square bracket, to be excluded
            myFlag='excluded'
            toExclude='| grep -v  '${block}' '
            continue
                       
        elif [[ "${block:$i:1}" == *['\]'')']* ]]; then #closed bracket
        myFlag='notset'
        continue
        fi

        if [ $myFlag == 'included' ]; then
        myOutput=$myOutput" | grep "$(echo "${block:$i:1}")""
                       
        
        fi
        
        
        done


done

if [ ! -z "$literalBlock" ];then
myOutput=$myOutput$literalBlock

fi


if [ ! -z "$toExclude" ];then
myOutput=$myOutput$toExclude
fi

myResults=$(eval $myOutput)
resCount=$(echo -n "$myResults" | wc -l)
resCount=$(($resCount+1))

cat << EOB
{"items": [
EOB

for line in $myResults ; do
((myCount++))
cat << EOB


	{
		        
		"title": "$line",
		"subtitle": "$myCount/$resCount ↩️ to open in the dictionary 😀",
		"arg": "$line",

	},
EOB
done


cat << EOB
]}
EOB

