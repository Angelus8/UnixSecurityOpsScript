#!/bin/bash

#fonction de pour verifier la reponse d'un utilisateur
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

#ma fonction de suppression
user_delete_script(){

    local user_search=$1

    #recherche d'un user dans le fichier /etc/passwd
    res=$(grep "^$user_search" /etc/passwd)

    if [ -n "$res" ]; then
        read -p "Voulez-vous vraiment supprimer l'user $user_search(oui/non): " user_answer

        #verification de la reponse
        if is_yes "$user_answer"; then

            if sudo userdel -r "$user_search" 2>/dev/null; then
                printf "Suppression de l'user %s effectué.\n" "$user_search"
            else
                exit_code=$?
                if [ $exit_code -ne 0 ]; then
                    printf "Vous n'avez pas les permissions necessaires!\nContactez l'administrateur.\n"
                fi
            fi

        elif is_no "$user_answer"; then
            printf "Suppression de %s annulé.\n" "$user_search"
        else
            echo "Reponse invalide"
        fi

    else
        printf "L'utilisateur %s n'existe pas.\n" "$user_search"
    fi

}