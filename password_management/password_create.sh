#!/bin/bash

# Fonction pour afficher la politique de mot de passe
print_password_policy() {
    printf "Politique de mot de passe :\n"
    printf " - Longueur minimale : 8 caractères\n"
    printf " - Au moins un chiffre\n"
    printf " - Au moins une lettre majuscule\n"
    printf " - Au moins une lettre minuscule\n"
    printf " - Au moins un caractère spécial\n"
}

# Fonction pour vérifier la politique de mot de passe
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

# Fonction pour changer le mot de passe de l'utilisateur
password_create_script() {
    print_password_policy  # Afficher la politique de mot de passe

    while true; do
        # Saisie sécurisée du nom d'utilisateur
        read -p "Nom de l'utilisateur : " user_name
        if [ -z "$user_name" ]; then
            printf "Le nom d'utilisateur est obligatoire.\n"
        else
            break
        fi
    done

    # Vérification de l'existence de l'utilisateur
    if id "$user_name" &>/dev/null; then
        # Saisie sécurisée du nouveau mot de passe
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
            printf "Mot de passe de l'utilisateur %s changé avec succès.\n" "$user_name"
        else
            printf "Erreur lors du changement du mot de passe.\n"
        fi
    else
        printf "L'utilisateur %s n'existe pas.\n" "$user_name"
    fi
}