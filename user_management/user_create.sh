#!/bin/bash

#validation des choix de l'user
is_yes(){
    case "$1" in
        o|O|y|Y|oui|Oui|OUI) return 0 ;;
        *) return 1;;
    esac
}

is_no(){
    case "$1" in
        n|N|non|Non|NON) return 0 ;;
        *) return 1;;
    esac
}

#notre fonction de modification du mot de passe
user_addPassword_script(){
    #variable local
    user_name=$2
    user_response=$1

    #verification de la reponse
        if is_yes "$user_response"; then

            if sudo passwd "$user_name" 2>/dev/null; then
                printf "Mot de passe de l'utilisateur %s modifié avec succès.\n" "$user_name"
            else
                exit_code=$?
                if [ $exit_code -ne 0 ]; then
                    printf "Vous n'avez pas les permissions necessaires!\nContactez l'administrateur.\n"
                fi
            fi

        elif is_no "$user_response"; then
            printf "Modification du mot de passe de %s annulée.\n" "$user_name"
        else
            echo "Reponse invalide"
        fi

}

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
        read -p "Voulez-vous modifie le mot de passe: " user_pass
        user_addPassword_script "$user_pass" "$username"
    elif [ -n "$uid" ] && [ -z "$gid" ] && [ -z "$homedirectory" ] && [ -z "$usershell" ]; then
        printf "Username: %s \tUID: %d.\n" "$username" "$uid"
        read -p "Voulez-vous modifie le mot de passe: " user_pass
        user_addPassword_script "$user_pass" "$username"
    elif [ -z "$uid" ] && [ -n "$gid" ] && [ -z "$homedirectory" ] && [ -z "$usershell" ]; then
        printf "Username:  %s\tGID: %d.\n" "$username" "$gid"
        read -p "Voulez-vous modifie le mot de passe: " user_pass
        user_addPassword_script "$user_pass" "$username"
    elif [ -z "$uid" ] && [ -z "$gid" ] && [ -n "$homedirectory" ] && [ -z "$usershell" ]; then
        printf "Username: %s \tHome Directory: %s.\n" "$username" "$homedirectory"
        read -p "Voulez-vous modifie le mot de passe: " user_pass
        user_addPassword_script "$user_pass" "$username"
    elif [ -z "$uid" ] && [ -z "$gid" ] && [ -z "$homedirectory" ] && [ -n "$usershell" ]; then
        printf "Username: %s \tUser Shell: %s.\n" "$username" "$usershell"
        read -p "Voulez-vous modifie le mot de passe: " user_pass
        user_addPassword_script "$user_pass" "$username"
    else
        printf "Username: %s\tUID: %d\tGID: %d\tHome Directory: %s\tUser Shell: %s.\n" "$username" "$uid" "$gid" "$homedirectory" "$usershell"
        read -p "Voulez-vous modifie le mot de passe: " user_pass
        user_addPassword_script "$user_pass" "$username"
    fi
}

user_liste_script(){
    awk -F: '{print "Username:",$1}' /etc/passwd
}
