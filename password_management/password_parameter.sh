#!/bin/bash

# Fonction pour saisir et vérifier le nom d'utilisateur
saisirEtVerifierNomUtilisateur() {
    while true; do
        read -p "Nom de l'utilisateur : " user_name

        # Vérification des valeurs
        if [ -z "$user_name" ]; then
            printf "Le nom d'utilisateur est obligatoire.\n"
        else
            # Vérification de l'existence de l'utilisateur
            echo "$user_name"
            break
        fi
    done
}

# Fonction pour saisir et vérifier le nombre de jours
saisirEtVerifierNombreDeJours() {
    while true; do
        read -p "Veuillez entrer un nombre de jours : " input_day

        # Vérification des valeurs
        if [ -z "$input_day" ]; then
            printf "Le nombre de jours est obligatoire.\n"
        elif ! [[ $input_day =~ ^[0-9]+$ ]]; then
            printf "Erreur : Veuillez entrer un nombre valide.\n"
        else
            input_day=$(echo "$input_day" | sed 's/^0*//') # Supprimer les zéros initiaux
            break
        fi
    done

    # Retourner le nombre de jours
    echo "$input_day"
}

# Fonction pour saisir et vérifier la date d'expiration
saisirEtVerifierDateExpiration() {
    while true; do
        read -p "Date d'expiration(format: YYYY-MM-JJ): " expire_date

        # Vérification des valeurs
        if [ -z "$expire_date" ]; then
            printf "Le date d'expiration est obligatoire.\n"
        elif [[ ! $expire_date =~ ^[0-9()]{4}-(0[1-9]|1[0-2])-([0-2][0-9]|3[0-1])$ ]]; then
            printf "Format de date incorrect. Utilisez le format YYYY-MM-JJ.\n"
        else
            #extraction de l'annee, mois et jour
            year=$(echo "$expire_date" | cut -d'-' -f1)
            month=$(echo "$expire_date" | cut -d'-' -f2)
            day=$(echo "$expire_date" | cut -d'-' -f3)

            #verification des mois entre 01 et 12
            if ((10#$month < 1 || 10#$month > 12)); then
                printf "Mois invalide. Doit etre entre 01 et 12.\n"
                continue
            fi

            #verification des jours en fonction des mois
            case "$month" in
            01 | 03 | 05 | 07 | 08 | 10 | 12)
                if ((10#$day < 1 || 10#$day > 31)); then
                    printf "Jour invalide pour un mois de 31 jours. Doit etre entre 01 et 31.\n"
                    continue
                fi
                ;;
            02)
                #verification des annees bissextiles
                if (((10#$year % 4 == 0 && 10#$year % 100 != 0) || (10#$year % 400 == 0))); then
                    if ((10#$day < 1 || 10#$day > 29)); then
                        printf "Jour invalide pour un jour de 29 jours.\n"
                        continue
                    fi
                else
                    if ((10#$day < 1 || 10#$day > 28)); then
                        printf "Jour invalide pour un jour de 28 jours.\n"
                        continue
                    fi
                fi
                ;;
            *)
                printf "Mois invalide. Doit etre entre 01 et 12.\n"
                continue
                ;;
            esac
            #si tout est vrai, retourne la date
            echo "$expire_date"
            break
        fi
    done
}

# Fonction pour gérer les commandes de changement de mot de passe
gererCommandeChage() {
    local user_name=$3
    local command_option=$1
    local value=$2

    # Vérification et exécution de la commande
    if sudo chage "$command_option" "$value" "$user_name" 2>/dev/null; then
        printf "Opération réussie pour l'utilisateur %s.\n" "$user_name"
    else
        exit_code=$?
        if [ $exit_code -ne 0 ]; then
            printf "Vous n'avez pas les permissions nécessaires !\nContactez l'administrateur.\n"
        fi
    fi
}

# Fonction pour gérer la date d'expiration
password_expire_script() {
    user_name=$(saisirEtVerifierNomUtilisateur)
    expire_date=$(saisirEtVerifierDateExpiration)
    res_user=$(grep "^$user_name:" /etc/passwd)
    if [ -n "$res_user" ]; then
        # L'utilisateur existe, retourne le nom de l'utilisateur
        gererCommandeChage "-E" "$expire_date" "$user_name"
    else
        printf "L'utilisateur %s n'existe pas.\n" "$user_name"
    fi
}

# Fonction pour gérer le changement de mot de passe
password_change_script() {
    user_name=$(saisirEtVerifierNomUtilisateur)
    change_day=$(saisirEtVerifierNombreDeJours)

    res_user=$(grep "^$user_name:" /etc/passwd)
    if [ -n "$res_user" ]; then
        # L'utilisateur existe, retourne le nom de l'utilisateur
        gererCommandeChage "-M" "$change_day" "$user_name"
    else
        printf "L'utilisateur %s n'existe pas.\n" "$user_name"
    fi
}

# Fonction pour gérer l'avertissement de mot de passe
password_warning_script() {
    user_name=$(saisirEtVerifierNomUtilisateur)
    warn_day=$(saisirEtVerifierNombreDeJours)

    res_user=$(grep "^$user_name:" /etc/passwd)
    if [ -n "$res_user" ]; then
        # L'utilisateur existe, retourne le nom de l'utilisateur
        gererCommandeChage "-W" "$warn_day" "$user_name"
    else
        printf "L'utilisateur %s n'existe pas.\n" "$user_name"
    fi
}

# Fonction pour gérer l'inactivité avant verrouillage
password_inactive_script() {
    user_name=$(saisirEtVerifierNomUtilisateur)
    inactive_day=$(saisirEtVerifierNombreDeJours)

    res_user=$(grep "^$user_name:" /etc/passwd)
    if [ -n "$res_user" ]; then
        # L'utilisateur existe, retourne le nom de l'utilisateur
        gererCommandeChage "-I" "$inactive_day" "$user_name"
    else
        printf "L'utilisateur %s n'existe pas.\n" "$user_name"
    fi
}

# Fonction pour désactiver un compte
password_deactivate_script() {
    user_name=$(saisirEtVerifierNomUtilisateur)

    res_user=$(grep "^$user_name:" /etc/passwd)
    if [ -n "$res_user" ]; then
        # L'utilisateur existe, retourne le nom de l'utilisateur
        gererCommandeChage "-E" "0" "$user_name"
    else
        printf "L'utilisateur %s n'existe pas.\n" "$user_name"
    fi
}

password_information_script() {
    user_name=$(saisirEtVerifierNomUtilisateur)

    res_user=$(grep "^$user_name:" /etc/passwd)
    if [ -n "$res_user" ]; then
        if sudo chage -l "$user_name" &>/dev/null; then
            printf "\nInformations de gestion des mots de passe pour l'utilisateur : %s\n" "$user_name"
            sudo chage -l "$user_name"
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
