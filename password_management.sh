#!/bin/bash
#import de mes fonction
source "password_management/password_parameter.sh"
source "password_management/password_create.sh"

password_management_script() {


    while true; do
        clear
        printf "Gestion des mots de passe d'un utilisateur\n"
        #Affichage du menu
        printf "1. Creation d'un mot de passe\n"
        printf "2. Definir date d'expiration\n"
        printf "3. Definir le nombre de jour avant changement du mot de passe\n"
        printf "4. Definir le nombre de jours avant avertissement\n"
        printf "5. Definir le nombre de jours d'inactivite avant verouillage\n"
        printf "6. Desactiver un compte\n"
        printf "7. Information du mot de passe d'un utilisateur\n"
        printf "8. Quitter\n\n"

        #le choix de l'utilisateur
        read -p "Choisissez une option(1-8): " choice

        #structure de controle selon le choix
        case $choice in
        1)
            password_create_script
            ;;
        2)
            password_expire_script
            ;;
        3)
            password_change_script  
            ;;
        4)
            password_warning_script
            ;;
        5)
            password_inactive_script
            ;;
        6)
            password_deactivate_script
            ;;
        7)
            password_information_script
            ;;
        8)
            exit 0
            ;;
        *)
            printf "Choix invalide. Choisir une option entre 1 et 7.\n"
            ;;
        esac
        printf "\n"
        read -p "Appuyer sur Entrée pour continuer..."

    done

}