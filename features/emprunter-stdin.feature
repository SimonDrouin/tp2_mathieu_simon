# language: fr

Fonctionnalité: Emprunt de nombreux livres
  En tant qu'usager
  Je veux pouvoir indiquer les emprunts de plusieurs livres en une seule fois
  Afin que cela soit plus simple

 @intermediaire
  Scénario: J'emprunte un livre, indiqué dans un fichier
    Soit ".biblio.txt" existe et est vide
    Soit a file named "cmds.txt" with:
    """
    "Nom 1" @ "Titre 1" "Auteurs 1"
    """

    Quand j'execute "emprunter" en lisant du fichier "cmds.txt"

    Alors the exit status should be 0
    Et il y a 1 emprunt
    Et l'emprunteur de "Titre 1" est "Nom 1"

 @intermediaire
  Scénario: J'emprunte des livres, indiqués dans un fichier, qui contient des lignes vides et 
             des lignes avec juste des blancs, donc lignes qui doivent etre ignorees
    Soit ".biblio.txt" existe et est vide
    Soit a file named "cmds.txt" with:
    """
    "Nom 1" @ "Titre 1" "Auteurs 1"

    "Nom 2" @ "Titre 2" "Auteurs 2"
          

    "Nom 1" @ "Titre 3" "Auteurs 3"
    """

    Quand j'execute "emprunter" en lisant du fichier "cmds.txt"

    Alors the exit status should be 0
    Et il y a 3 emprunts
    Et l'emprunteur de "Titre 1" est "Nom 1"
    Et l'emprunteur de "Titre 2" est "Nom 2"
    Et l'emprunteur de "Titre 3" est "Nom 1"

 @avance
 Scénario: Trop d'arguments sur une des lignes

    Soit ".biblio.txt" existe et est vide
    Soit a file named "cmds.txt" with:
    """
    "Nom 1" @ "Titre 1" "Auteurs 1" "Arg en trop"
    """

    Quand j'execute "emprunter" en lisant du fichier "cmds.txt"
    Alors stderr doit matcher /Nombre incorrect.*arguments/


 @avance
 Scénario: Adresse de courriel invalide sur une des lignes
    Soit ".biblio.txt" existe et est vide
    Soit a file named "cmds.txt" with:
    """
    "Nom 1" "BB" "Titre 1" "Auteurs 1"
    """

    Quand j'execute "emprunter" en lisant du fichier "cmds.txt"
    Alors stderr doit matcher /Format.*incorrect/


 @avance
 Scénario: Une des commandes est incorrecte, donc fait avorter l'ensemble
    Soit ".biblio.txt" existe et est vide
    Soit a file named "cmds.txt" with:
    """
    "Nom 1" @ "Titre 1" "Auteurs 1"
    "Nom 1" "XX" "Titre 2" "Auteurs 2"
    """

    Soit ".biblio.txt" existe et est vide

    Quand j'execute "emprunter" en lisant du fichier "cmds.txt"
    Alors stderr doit matcher /Format.*incorrect/

    Quand on demande l'emprunteur de "Titre 1"
    Alors stderr doit matcher /Aucun.*livre.*emprunte.*Titre 1/
    Et the exit status should not be 0


 @avance
  Scénario: Je tente d'emprunter un livre deja emprunte
    Etant donné que la BD existe et est vide
    Quand "Nom 1" ["@"] emprunte "Tres Long Titre" ["Auteurs 2"]
    Et    "Nom 1" ["@"] emprunte "Titre 1" ["Auteurs 1"]

    Soit a file named "cmds.txt" with:
    """
    "Nom 3" tremblay.guy@uqam.ca "Titre 1" "Auteurs 1"
    """

    Quand j'execute "emprunter" en lisant du fichier "cmds.txt"

    Alors stderr doit matcher /meme titre.*deja emprunte/
    Et il y a 2 emprunts
    Et l'emprunteur de "Titre 1" est "Nom 1"


