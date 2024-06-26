#!/bin/bash
#import de mes fonction
source "group_management/group_create.sh"
source "group_management/group_delete.sh"
source "group_management/group_member.sh"
source "group_management/group_verify.sh"

group_management_script() {


    while true; do
        clear
        printf "Gestion des groupes\n"
        #Affichage du menu
        printf "1. Creation d'un groupe\n"
        printf "2. Verification d'un groupe\n"
        printf "3. Voir les membres d'un groupe\n"
        printf "4. Ajout d'un user à un groupe\n"
        printf "5. Suppression d'un groupe\n"
        printf "6. Quitter\n\n"

        #le choix de l'utilisateur
        read -p "Choisissez une option(1-6): " choice

        #structure de controle selon le choix
        case $choice in
        1)
            group_create_script
            ;;
        2)
            group_verify_script
            ;;
        3)
            group_member_script
            ;;
        4)
            group_add_script
            ;;
        5)
            group_delete_script
            ;;
        6)
            printf "Aurevoir\n"
            exit 0
            ;;
        *)
            printf "Choix invalide. Choisir une option entre 1 et 6.\n"
            ;;
        esac

        read -p "Appuyer sur Entrée pour continuer..."

    done

}