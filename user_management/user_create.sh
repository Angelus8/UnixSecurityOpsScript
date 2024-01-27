#!/bin/bash

#ma fonction user create
user_create_script() {

    while true; do
        read -p "Nom de l'utilisateur: " username
        #verification des valeurs
        if [ -z "$username" ]; then
            printf "Le nom d'utilisateur est obligatoire.\n"
        else
            break
        fi
    done

    read -p "User ID (facultatif): " uid
    read -p "Group ID (facultatif): " gid
    read -p "Home directory (facultatif): " homedirectory
    read -p "User Shell (facultatif): " usershell

    if [ -z "$uid" ] && [ -z "$gid" ] && [ -z "$homedirectory" ] && [ -z "$usershell" ]; then
        printf "Username: %s.\n" "$username"
    elif [ -n "$uid" ] && [ -z "$gid" ] && [ -z "$homedirectory" ] && [ -z "$usershell" ]; then
        printf "Username: %s \tUID: %d.\n" "$username" "$uid"
    elif [ -z "$uid" ] && [ -n "$gid" ] && [ -z "$homedirectory" ] && [ -z "$usershell" ]; then
        printf "Username:  %s\tGID: %d.\n" "$username" "$gid"
    elif [ -z "$uid" ] && [ -z "$gid" ] && [ -n "$homedirectory" ] && [ -z "$usershell" ]; then
        printf "Username: %s \tHome Directory: %s.\n" "$username" "$homedirectory"
    elif [ -z "$uid" ] && [ -z "$gid" ] && [ -z "$homedirectory" ] && [ -n "$usershell" ]; then
        printf "Username: %s \tUser Shell: %s.\n" "$username" "$usershell"
    else
        printf "Username: %s\tUID: %d\tGID: %d\tHome Directory: %s\tUser Shell: %s.\n" "$username" "$uid" "$gid" "$homedirectory" "$usershell"
    fi




}
