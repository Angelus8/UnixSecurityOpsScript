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

#notre fonction d'ajout du mot de passe
check_password_policy() {
    local password="$1"

    # Vérification de la longueur minimale
    if [ ${#password} -lt 8 ]; then
        printf "La longueur minimale du mot de passe est de 8 caractères.\n"
        return 1
    fi

    # Vérification des différents types de caractères
    if ! [[ "$password" =~ [0-9] ]]; then
        printf "Le mot de passe doit contenir au moins un chiffre.\n"
        return 1
    fi

    if ! [[ "$password" =~ [[:upper:]] ]]; then
        printf "Le mot de passe doit contenir au moins une lettre majuscule.\n"
        return 1
    fi

    if ! [[ "$password" =~ [[:lower:]] ]]; then
        printf "Le mot de passe doit contenir au moins une lettre minuscule.\n"
        return 1
    fi

    if ! [[ "$password" =~ [[:punct:]] ]]; then
        printf "Le mot de passe doit contenir au moins un caractère spécial.\n"
        return 1
    fi

    return 0
}
user_addPassword_script() {
    #variable local
    user_name=$1

    #affichage de la politique
    printf "Politique de mot de passe :\n"
    printf " - Longueur minimale : 8 caractères\n"
    printf " - Au moins un chiffre\n"
    printf " - Au moins une lettre majuscule\n"
    printf " - Au moins une lettre minuscule\n"
    printf " - Au moins un caractère spécial\n"

    #verification de la reponse
    while true; do
        read -s -p "Nouveau mot de passe pour l'utilisateur $user_name : " new_password
        echo
        read -s -p "Confirmez le nouveau mot de passe : " confirm_password
        echo

        # Vérification que les mots de passe correspondent
        if [ "$new_password" != "$confirm_password" ]; then
            printf "Les mots de passe ne correspondent pas. Réessayez.\n"
        else
            # Vérification de la politique de mot de passe
            if check_password_policy "$new_password"; then
                break
            else
                printf "Le mot de passe ne respecte pas la politique définie.\n"
            fi
        fi
    done

    # Utilisation de chpasswd pour changer le mot de passe
    echo "$user_name:$new_password" | sudo chpasswd

    if [ $? -eq 0 ]; then
        printf "Mot de passe de l'utilisateur %s crée avec succès.\n" "$user_name"
    else
        printf "Erreur lors de la création du mot de passe.\n"
    fi

}

#ma fonction user create
user_create_script() {
    exit_code=0

    while true; do
        read -p "Nom de l'utilisateur: " user_name
        #verification des valeurs
        if [ -z "$user_name" ]; then
            printf "Le nom d'utilisateur est obligatoire.\n"
        else
            break
        fi
    done

    read -p "User ID (facultatif): " uid
    read -p "Primary group name (facultatif): " gid
    read -p "Home directory (facultatif): " homedirectory
    read -p "User Shell (facultatif): " usershell

    verify_user=$(grep "^$user_name:" /etc/passwd)
    if [ -n "$verify_user" ]; then
        printf "L'utilisateur %s existe deja\n" "$verify_user"
        read -p "Voulez-vous créer un autre utilisateur ? (oui/non): " choice_other
        if is_yes "$choice_other"; then
            user_create_script
        elif is_no "$choice_other"; then
            exit
        else
            printf "Reponse non valide.\n"
        fi
    else
        user_created=false
        if [ -z "$uid" ] && [ -z "$gid" ] && [ -z "$homedirectory" ] && [ -z "$usershell" ]; then
            if sudo useradd "$user_name" 2>/dev/null; then
                printf "L'utilisateur %s a été crée avec succès.\n" "$user_name"
                user_created=true
            else
                exit_code=$?
                if [ $exit_code -ne 0 ]; then
                    printf "Vous n'avez pas les permissions necessaires!\nContactez l'administrateur.\n"
                fi
            fi
        elif [ -n "$uid" ] && [ -z "$gid" ] && [ -z "$homedirectory" ] && [ -z "$usershell" ]; then
            if sudo useradd -u "$uid" "$user_name" 2>/dev/null; then
                printf "L'utilisateur %s a été crée avec succès.\n" "$user_name"
                user_created=true
            else
                exit_code=$?
                if [ $exit_code -ne 0 ]; then
                    printf "Vous n'avez pas les permissions necessaires!\nContactez l'administrateur.\n"
                fi
            fi
        elif [ -z "$uid" ] && [ -n "$gid" ] && [ -z "$homedirectory" ] && [ -z "$usershell" ]; then
            if grep -q "^$gid" /etc/group; then
                if sudo useradd -g "$gid" "$user_name" 2>/dev/null; then
                    printf "L'utilisateur %s a été crée avec succès.\n" "$user_name"
                    user_created=true
                else
                    exit_code=$?
                    if [ $exit_code -ne 0 ]; then
                        printf "Vous n'avez pas les permissions necessaires!\nContactez l'administrateur.\n"
                    fi
                fi
            else
                printf "Le groupe %s n'existe pas\n" "$gid"
            fi
        elif [ -z "$uid" ] && [ -z "$gid" ] && [ -n "$homedirectory" ] && [ -z "$usershell" ]; then
            if sudo useradd -m -d "$homedirectory" "$user_name" 2>/dev/null; then
                printf "L'utilisateur %s a été crée avec succès.\n" "$user_name"
                user_created=true
            else
                exit_code=$?
                if [ $exit_code -ne 0 ]; then
                    printf "Vous n'avez pas les permissions necessaires!\nContactez l'administrateur.\n"
                fi
            fi
        elif [ -z "$uid" ] && [ -z "$gid" ] && [ -z "$homedirectory" ] && [ -n "$usershell" ]; then
            if sudo useradd -s "$usershell" "$user_name" 2>/dev/null; then
                printf "L'utilisateur %s a été crée avec succès.\n" "$user_name"
                user_created=true
            else
                exit_code=$?
                if [ $exit_code -ne 0 ]; then
                    printf "Vous n'avez pas les permissions necessaires!\nContactez l'administrateur.\n"
                fi
            fi
        else
            if grep -q "^$gid" /etc/group; then
                if sudo useradd -u "$uid" -g "$gid" -d "$homedirectory" -s "$usershell" -m "$user_name" 2>/dev/null; then
                    printf "L'utilisateur %s a été crée avec succès.\n" "$user_name"
                    user_created=true
                else
                    exit_code=$?
                    if [ $exit_code -ne 0 ]; then
                        printf "Vous n'avez pas les permissions necessaires!\nContactez l'administrateur.\n"
                    fi
                fi
            else
                printf "Le groupe %s n'existe pas\n" "$gid"
            fi
        fi

        #proposition de la creation du mot de passe
        if [ "$user_created" = true ]; then
            read -p "Voulez-vous modifie le mot de passe: " choix_pass
            if is_yes "$choix_pass"; then

                user_addPassword_script "$user_name"

            elif is_no "$choix_pass"; then
                printf "Modification du mot de passe de %s annulée.\n" "$user_name"
            else
                echo "Reponse invalide"
            fi
        fi

    fi
}

user_liste_script() {
    awk -F: '{print "Username:",$1}' /etc/passwd
}

user_lock_script() {
    while true; do
        read -p "Nom de l'utilisateur : " user_name

        # Vérification des valeurs
        if [ -z "$user_name" ]; then
            printf "Le nom d'utilisateur est obligatoire.\n"
        else
            break
        fi
    done

    res_user=$(grep "^$user_name:" /etc/passwd)
    if [ -n "$res_user" ]; then
        if sudo passwd -l "$user_name" &>/dev/null; then
            printf "L'utilisateur %s a été vérouille avec succès\n" "$user_name"
        else
            exit_code=$?
            if [ $exit_code -ne 0 ]; then
                printf "Vous n'avez pas les permissions nécessaires !\nContactez l'administrateur.\n"
            fi
        fi
    else
        printf "L'utilisateur %s n'existe pas.\n" "$user_name"
    fi
}

user_unlock_script() {
    while true; do
        read -p "Nom de l'utilisateur : " user_name

        # Vérification des valeurs
        if [ -z "$user_name" ]; then
            printf "Le nom d'utilisateur est obligatoire.\n"
        else
            break
        fi
    done

    res_user=$(grep "^$user_name:" /etc/passwd)
    if [ -n "$res_user" ]; then
        if sudo passwd -u "$user_name" &>/dev/null; then
            printf "L'utilisateur %s a été vérouille avec succès\n" "$user_name"
        else
            exit_code=$?
            if [ $exit_code -ne 0 ]; then
                printf "Vous n'avez pas les permissions nécessaires !\nContactez l'administrateur.\n"
            fi
        fi
    else
        printf "L'utilisateur %s n'existe pas.\n" "$user_name"
    fi
}
