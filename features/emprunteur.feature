# language: fr

Fonctionnalité: Empruneur d'un livre
  En tant qu'usager
  Je veux pouvoir trouver l'emprunteur d'un livre prete

  @base
  Scénario: J'emprunte plusieurs livres
    Etant donné que la BD existe et est vide

    Quand "nom1" ["@"] emprunte "titre1" ["auteurs1"]
    Et    "nom2" ["@"] emprunte "titre2" ["auteurs2"]
    Et    "nom3" ["@"] emprunte "titre3" ["auteurs3"]

    Alors il y a 3 emprunts
    Et l'emprunteur de "titre1" est "nom1"
    Et l'emprunteur de "titre2" est "nom2"
    Et l'emprunteur de "titre3" est "nom3"

  @intermediaire
  Scénario: J'emprunte plusieurs livres et je cherche l'emprunteur d'un livre non prete
    Etant donné que la BD existe et est vide

    Quand "nom1" ["@"] emprunte "titre1" ["auteurs1"]
    Et    "nom2" ["@"] emprunte "titre2" ["auteurs2"]

    Alors il y a 2 emprunts

    Quand on demande l'emprunteur de "titre3"
    Alors stderr doit matcher /Aucun.*livre.*emprunte.*titre3/
    Et the exit status should not be 0
