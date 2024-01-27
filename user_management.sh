#!/bin/bash
#import
source "./user_management/user_create.sh"
source "./user_management/user_research.sh"
source "./user_management/user_delete.sh"

user_management_script() {


    while true; do
        clear
        printf "Bienvenue a la gestion des utilisateurs\n"
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
            printf "Creation d'un user\n"
            user_create_script
            ;;
        2)
            printf "Liste des users\n"
            awk -F: '{print "Username:",$1}' /etc/passwd
            ;;
        3)
            printf "Information d'un user\n"
            read -p "Username: " user_search
            user_research_script "$user_search"
            ;;
        4)
            read -p "L'utilisateur a supprimé: " user_del
            user_delete_script "$user_del"
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
