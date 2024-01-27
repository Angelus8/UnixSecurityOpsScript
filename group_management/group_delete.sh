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
group_delete_script(){

    read -p "Nom du groupe: " group_name

    #recherche d'un user dans le fichier /etc/passwd
    res=$(grep "^$group_name" /etc/passwd)

    if [ -n "$res" ]; then
        read -p "Voulez-vous vraiment supprimer l'user $group_name(oui/non): " user_answer

        #verification de la reponse
        if is_yes "$user_answer"; then

            if sudo groupdel "$group_name" 2>/dev/null; then
                printf "Suppression de groupe %s effectué.\n" "$group_name"
            else
                exit_code=$?
                if [ $exit_code -ne 0 ]; then
                    printf "Vous n'avez pas les permissions necessaires!\nContactez l'administrateur.\n"
                fi
            fi

        elif is_no "$user_answer"; then
            printf "Suppression de %s annulé.\n" "$group_name"
        else
            echo "Reponse invalide"
        fi

    else
        printf "Le groupe %s n'existe pas.\n" "$group_name"
    fi

}