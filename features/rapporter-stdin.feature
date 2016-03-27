# language: fr

Fonctionnalité: Emprunt de nombreux livres
  En tant qu'usager
  Je veux pouvoir indiquer les emprunts de plusieurs livres en une seule fois
  Afin que cela soit plus simple

 @intermediaire
  Scénario: Je retourne un livre, indiqué dans un fichier
    Etant donné que la BD existe et est vide
    Quand "Nom 1" ["@"] emprunte "Tres Long Titre" ["Auteurs 2"]
    Et    "Nom 1" ["@"] emprunte "Titre 1" ["Auteurs 1"]
    Et    "Nom 0" ["@"] emprunte "Titre 0" ["Auteurs 0"]

    Soit a file named "cmds.txt" with:
    """
    "Titre 1"


    """

    Quand j'execute "rapporter" en lisant du fichier "cmds.txt"

    Alors the exit status should be 0
    Et il y a 2 emprunts

    Quand on demande l'emprunteur de "Titre 1"
    Alors stderr doit matcher /Aucun.*livre.*emprunte.*Titre 1/
    Et the exit status should not be 0

 @intermediaire
  Scénario: Je retourne plusieurs livres, indiqués dans un fichier, qui contient des lignes vides et 
             des lignes avec juste des blancs, donc lignes qui doivent etre ignorees
    Etant donné que la BD existe et est vide
    Quand "Nom 1" ["@"] emprunte "Tres Long Titre" ["Auteurs 2"]
    Et    "Nom 1" ["@"] emprunte "Titre 1" ["Auteurs 1"]
    Et    "Nom 0" ["@"] emprunte "Titre 0" ["Auteurs 0"]

    Soit a file named "cmds.txt" with:
    """
    "Titre 1"
           
    "Tres Long Titre"

    "Titre 0"

    """

    Quand j'execute "rapporter" en lisant du fichier "cmds.txt"

    Alors the exit status should be 0
    Et il y a 0 emprunt


 @avance
 Scénario: Trop d'arguments sur une des lignes
    Etant donné que la BD existe et est vide
    Quand "Nom 1" ["@"] emprunte "Tres Long Titre" ["Auteurs 2"]

    Soit a file named "cmds.txt" with:
    """
    "Nom 1" @ "Titre 1" "Auteurs 1" "Arg en trop"
    """

    Quand j'execute "rapporter" en lisant du fichier "cmds.txt"
    Alors stderr doit matcher /Nombre incorrect.*arguments/

 @avance
 Scénario: Une des commandes est incorrecte, donc fait avorter l'ensemble
    Etant donné que la BD existe et est vide
    Quand "Nom 1" ["@"] emprunte "Tres Long Titre" ["Auteurs 2"]

    Soit a file named "cmds.txt" with:
    """
    "Tres Long Titre"
    "Nom 1" @ "Titre 1" "Auteurs 1" "Arg en trop"
    """

    Quand j'execute "rapporter" en lisant du fichier "cmds.txt"
    Alors stderr doit matcher /Nombre incorrect.*arguments/

    Quand on demande l'emprunteur de "Tres Long Titre"
    Alors l'emprunteur de "Tres Long Titre" est "Nom 1"
    Et the exit status should be 0

 @avance
 Scénario: Un retour est invalide parce que pas emprunte, donc fait avorter l'ensemble
    Etant donné que la BD existe et est vide
    Quand "Nom 1" ["@"] emprunte "Tres Long Titre" ["Auteurs 2"]

    Soit a file named "cmds.txt" with:
    """
    "Un Titre"
    """

    Quand j'execute "rapporter" en lisant du fichier "cmds.txt"

    Alors stderr doit matcher /Aucun livre.*Un Titre/
    Et il y a 1 emprunts
    Et l'emprunteur de "Tres Long Titre" est "Nom 1"


