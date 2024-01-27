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