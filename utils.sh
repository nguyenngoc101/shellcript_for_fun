#!/bin/bash

#join string with delimiter
join(){
    delimiter=$1
    shift;
    conv_str=""
    for ele in $@
    do
        [ ! "$conv_str" ] && conv_str=$ele || conv_str=$conv_str$delimiter$ele
    done
    echo "$conv_str"
}


#split string with delimiter
split(){
    delimiter=$1
    input=$2
    IFS="$1" read -r -a fields <<< "$input"
    echo "${fields[@]}"
}

#split $@
