# language: fr

Fonctionnalité: Emprunt de livres
  En tant qu'usager
  Je veux pouvoir indiquer l'emprunt de livres
  Afin de pouvoir savoir à qui je les ai prêtés

  @base
  Scénario: J'emprunte un livre sans problème et cela n'emprunte pas d'autres livres
    Etant donné que la BD existe et est vide

    Quand "tremblay" ["tremblay.guy@uqam.ca"] emprunte "Le_titre" ["Auteur"]

    Alors il y a 1 emprunt
    Et l'emprunteur de "Le_titre" est "tremblay"
    Et the exit status should be 0

  @base
  Scénario: J'emprunte plusieurs livres et tous sont indiqués (bis)
    Etant donné la BD existe et est vide

    Quand "nom1" ["@"] emprunte "titre1" ["auteurs1"]
    Et    "nom2" ["@"] emprunte "titre2" ["auteurs2"]
    Et    "nom3" ["@"] emprunte "titre3" ["auteurs3"]

    Alors il y a 3 emprunts
    Et l'emprunteur de "titre1" est "nom1"
    Et l'emprunteur de "titre2" est "nom2"
    Et l'emprunteur de "titre3" est "nom3"


  @intermediaire
  Scénario: J'emprunte plusieurs livres et tous sont indiqués mais avec des titres contenant des espaces
    Etant donné la BD existe et est vide

    Quand "nom1 prenom1" ["@"] emprunte "Un titre1" ["Les auteurs1"]
    Et    "nom2 prenom2" ["@"] emprunte "Un titre2" ["Les auteurs2"]
    Et    "nom3 prenom3" ["@"] emprunte "Un titre3" ["Les auteurs3"]

    Alors il y a 3 emprunts
    Et l'emprunteur de "Un titre1" est "nom1 prenom1"
    Et l'emprunteur de "Un titre2" est "nom2 prenom2"
    Et l'emprunteur de "Un titre3" est "nom3 prenom3"

  @intermediaire
  Scénario: J'emprunte un livre sans fournir toute l'information
    Etant donné la BD existe et est vide
    Quand j'exécute avec "emprunter tremblay tremblay.guy@uqam.ca \"Le titre\""
    Alors the exit status should not be 0
    Et stderr doit matcher /Nombre incorrect d'arguments/

  @intermediaire
  Scénario: J'emprunte un livre qui a le même titre qu'un livre déjà emprunté
    Etant donné la BD existe et est vide
    Quand "tremblay" ["tremblay.guy@uqam.ca"] emprunte "Le_Titre" ["Auteurs"]
    Et "bidon" ["@"] emprunte "Le_Titre" ["Auteurs"]
    Alors the exit status should not be 0
    Et stderr doit matcher /livre.*avec.*meme titre.*deja emprunte/
  
  @intermediaire
  Scénario: J'emprunte un livre mais avec un depot inexistant
    Etant donné a file named "_foo_.txt" should not exist
    Quand j'exécute avec "--depot=_foo_.txt emprunter tremblay tremblay.guy@uqam.ca Titre Auteurs"
    Alors the exit status should not be 0
    Et stderr doit matcher /_foo_.txt.*existe pas/

  @avance
  Scénario: J'emprunte un livre via une autre BD
    Etant donné que "autre-bd.txt" existe et est vide
    Quand j'exécute avec "--depot=autre-bd.txt emprunter tremblay tremblay.guy@uqam.ca \"Le titre\" \"Des auteurs\""
    Quand j'exécute avec "--depot=autre-bd.txt emprunteur \"Le titre\""
    Alors the stdout should contain "tremblay"
    Et the exit status should be 0

