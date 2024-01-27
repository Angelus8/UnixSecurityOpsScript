#!/bin/bash

group_member_script(){

    read -p "Nom du groupe: " group_name

    res=$(grep "^$group_name:" /etc/group)
    

    if [ -n "$res" ]; then
        group_member=$(echo "$res" | cut -d: -f4)
        printf "Les membres du groupe %s sont: %s.\n" "$group_name" "$group_member"
    else
        printf "Le groupe %s n'existe pas.\n" "$group_name"
    fi

}