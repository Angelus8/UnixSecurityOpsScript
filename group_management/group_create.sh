#!/bin/bash

#validation des choix de l'user
is_yes() {
    case "$1" in
    o | O | y | Y | oui | Oui | OUI) return 0 ;;
    *) return 1 ;;
    esac
}

is_no() {
    case "$1" in
    n | N | non | Non | NON) return 0 ;;
    *) return 1 ;;
    esac
}

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

    verify_group=$(grep "^username" /etc/group)

    if [ -n "$verify_group" ]; then
        printf "Le groupe %s existe deja\n" "$verify_group"
        read -p "Voulez-vous créer un autre groupe ? (oui/non): " choice_other
        if is_yes "$choice_other"; then
            group_create_script
        elif is_no "$choice_other"; then
            exit
        else
            printf "Reponse non valide.\n"
        fi
    else
        if [ -z "$group_id" ]; then
            groupadd -g $group_id $group_name
        else
            groupadd $group_name
        fi
    fi
}

group_add_script() {

    while true; do
        read -p "Nom de l'utilisateur: " user_name
        #verification des valeurs
        if [ -z "$user_name" ]; then
            printf "Le nom du groupe est obligatoire.\n"
        else
            break
        fi
    done

    while true; do
        read -p "Nom du groupe: " group_name
        #verification des valeurs
        if [ -z "$group_name" ]; then
            printf "Le nom du groupe est obligatoire.\n"
        else
            break
        fi
    done

    res_user=$(grep "^$user_name:" /etc/passwd)
    res_group=$(grep "^$group_name:" /etc/group)

    if [ -n "$res_user" ] && [ -n "$res_group" ]; then

        if sudo usermod -aG "$user_name" "$group_name" 2>/dev/null; then
            printf "L'utilisateur %s a été ajouté au groupe %s avec succès.\n" "$user_name" "$group_name"
        else
            exit_code=$?
            if [ $exit_code -ne 0 ]; then
                printf "Vous n'avez pas les permissions necessaires!\nContactez l'administrateur.\n"
            fi
        fi
    elif [ -z "$res_user" ] && [ -n "$res_group" ]; then
        printf "L'utilisateur %s n'existe pas.\n" "$res_user"
    elif [ -n "$res_user" ] && [ -z "$res_group" ]; then
        printf "Le groupe %s n'existe pas.\n" "$res_group"
    else
        printf "L'utilisateur %s et le groupe %s n'existe pas.\n" "$res_user" "$res_group"
    fi

}
