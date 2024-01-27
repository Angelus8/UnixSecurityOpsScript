#!/bin/bash

user_research_script(){

    read -p "Username: " user_search

    res=$(grep "^$user_search" /etc/passwd)

    #recuperation des information sur l'user
    home_directory=$(echo "$res "| cut -d: -f6)
    shell_defaut=$(echo "$res "| cut -d: -f7)
    primary_group_name=$(id -gn "$user_search")
    secondary_group_name=$(id -Gn "$user_search" | awk '{$1=""; print $0}' | sed 's/^[ \t]*//' | sed 's/ /,/g')
    

    if [ -n "$res" ]; then
        uid=$(echo "$res" | cut -d: -f3)
        printf "Username %s --> UID: %d.\nHome Directory: %s\n User Shell: %s\nGroupe Primaire: %s\n Groupe Secondaire: %s\n\n" "$user_search" "$uid" "$home_directory" "$shell_defaut" "$primary_group_name" "$secondary_group_name"
    else
        printf "L'utilisateur %s n'existe pas.\n" "$user_search"
    fi

}