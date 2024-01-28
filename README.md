# UnixSecurityOpsScript
PROJET D’AUTOMATISATION ADMINISTRATION LINUX (USERS, GROUPES, PASSWORD) 

Objectif : 

    Ce projet vise à créer une automatisation pour la gestion des utilisateurs, la gestion des groupes et des mots de passe sous linux. 

    Ce projet a été fait sous Ubuntu 22.04 en programmation Shell. Ce projet aura 2 versions (une version Shell et une version graphique). 

    N.B: pour le moment nous parlons de la première version : version Shell 

Fonctionnement : 

    Le script sera lance sous forme de menu. Nous aurons d’abord un menu principal afin de nous permettre de sélectionner la partie que nous voulons administrer. Et chaque partie contient des sous-parties. 

 

Version Shell 

Gestion des utilisateurs 

    Dans la gestion des utilisateurs, nous aurons la possibilité de : 

    ** Créer un nouvel utilisateur (création de l’utilisateur et la possibilité de lui créer un mot de passe) 

    ** Voir la liste des utilisateurs sous le système (uniquement les usernames seront affichés) 

    ** Voir les informations sur un utilisateur spécifique (nous afficherons l’username, son ID, son répertoire, son Shell, son groupe primaire et ses groupes secondaires) 

    ** Supprimer un utilisateur 

    ** Verrouiller et déverrouiller le compte d’un utilisateur 

 

Gestion des groupes 

    Dans cette section, l’administrateur aura la possibilité de : 

    ** Créer un groupe 

    ** Vérifier si un groupe précis existe sur le système 

    ** Voir les membres d’un groupe spécifique 

    ** Ajouter un utilisateur a un groupe 

    ** Supprimer un groupe 

 

Gestion des mots de passe 

Dans cette dernière partie, nous avons la possibilité de : 

    ** Créer ou modifier le mot de passe d’un utilisateur 

    ** Définir la date d’expiration du mot de passe d’un utilisateur 

    ** Définir le nombre de jour avant changement du mot de passe 

    ** Définir le nombre de jours avant avertissement 

    ** Définir le nombre de jours d'inactivité avant verrouillage 

    ** Désactiver le compte d’un utilisateur 

    ** Voir les informations sur le mot de passe d'un utilisateur 