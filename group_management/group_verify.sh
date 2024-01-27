#!/bin/bash

group_verify_script(){

    read -p "Nom du groupe: " group_name

    res=$(grep "^$group_name:" /etc/group)
    

    if [ -n "$res" ]; then
        gid=$(echo "$res" | cut -d: -f3)
        printf "Groupe: %s --> UID: %d.\n" "$group_name" "$gid"
    else
        printf "Le groupe %s n'existe pas.\n" "$group_name"
    fi

}