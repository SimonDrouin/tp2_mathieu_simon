# language: fr

@avance
Fonctionnalité: Emprunteur un livre prêté
  En tant qu'usager
  Je veux pouvoir trouver l'emprunteur un livre

  Scénario: Je demande l'emprunteur de livres avec des titre qui sont semblables
    Etant donné que la BD existe et est vide
    Et "nom1" ["@"] emprunte "Un titre" ["Auteurs1"]
    Et "nom2" ["@"] emprunte "Un titre plus long" ["Auteurs2"]

    Alors l'emprunteur de "Un titre" est "nom1"
    Et l'emprunteur de "Un titre plus long" est "nom2"
    Et the exit status should be 0

  Scénario: Je demande l'emprunteur d'un livre avec un sous-titre
    Etant donné que la BD existe et est vide
    Et "nom1" ["@"] emprunte "Un titre" ["Auteurs1"]

    Quand on demande l'emprunteur de "Un titre plus long"
    Alors the exit status should not be 0
    Et stderr doit matcher /Aucun livre.*Un titre plus long/

  Scénario: Je demande l'emprunteur d'un livre avec un surtitre
    Etant donné que la BD existe et est vide
    Et "nom1" ["@"] emprunte "Un titre plus long" ["Auteurs1"]

    Quand on demande l'emprunteur de "Un titre"
    Alors the exit status should not be 0
    Et stderr doit matcher /Aucun livre.*Un titre/
