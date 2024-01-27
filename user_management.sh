#!/bin/bash
#import
source "user_management/user_create.sh"
source "user_management/user_research.sh"
source "user_management/user_delete.sh"

user_management_script() {


    while true; do
        clear
        printf "Gestion des utilisateurs\n"
        #Affichage du menu
        printf "1. Creation d'user\n"
        printf "2. Liste des users\n"
        printf "3. Information d'un user\n"
        printf "4. Suppression d'un user\n"
        printf "5. Quitter\n\n"

        #le choix de l'utilisateur
        read -p "Choisissez une option(1-5): " choice

        #structure de controle selon le choix
        case $choice in
        1)
            user_create_script
            ;;
        2)
            user_liste_script
            ;;
        3)
            user_research_script
            ;;
        4)
            user_delete_script
            ;;
        5)
            printf "Aurevoir\n"
            exit 0
            ;;
        *)
            printf "Choix invalide. Choisir une option entre 1 et 5.\n"
            ;;
        esac

        read -p "Appuyer sur Entrée pour continuer..."

    done

}
