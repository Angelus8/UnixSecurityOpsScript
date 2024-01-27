#!/bin/bash

group_create_script() {

    while true; do
        read -p "Nom du groupe: " group_name
        #verification des valeurs
        if [ -z "$group_name" ]; then
            printf "Le nom du groupe est obligatoire.\n"
        else
            break
        fi
    done

    read -p "ID du groupe: " group_id

    if [ -z "$group_id" ] ; then
        groupadd -g $group_id $group_name
    else
        groupadd $group_name
    fi
}
