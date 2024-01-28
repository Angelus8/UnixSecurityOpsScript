#!/bin/bash

#appel de mes fonctions
source "user_management.sh"
source "group_management.sh"
source "password_management.sh"

while true; do
    clear
    #Affichage du menu
    printf "1. Gestion des users\n"
    printf "2. Gestion des groupes\n"
    printf "3. Gestion des mots de passes\n"
    printf "4. Quitter\n\n"

    #le choix de l'utilisateur
    read -p "Choisissez une option(1-4): " choice

    #structure de controle selon le choix
    case $choice in
        1)
            user_management_script
            ;;
        2)
            group_management_script
            ;;
        3)
            password_management_script
            ;;
        4)
            exit 0
            ;;
        *)
            printf "Choix invalide. Choisir une option entre 1 et 4.\n"
            ;;
    esac

    read -p "Appuyer sur Entrée pour continuer..."

done