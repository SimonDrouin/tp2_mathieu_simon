# language: fr

Fonctionnalité: Liste des emprunts de quelqu'un
  En tant qu'usager
  Je veux pouvoir connaitre tous les emprunts faits par une personne

  @base
  Scénario: J'emprunte plusieurs livres et tous sont indiqués
    Étant donné que la BD existe et est vide

    Quand "nom1" ["@"] emprunte "titre1a" ["auteurs1a"]
    Et    "nom2" ["@"] emprunte "titre2" ["auteurs2"]
    Et    "nom1" ["@"] emprunte "titre1c" ["auteurs1c"]
    Et    "nom1" ["@"] emprunte "titre1b" ["auteurs1b"]

    Quand on demande les emprunts de "nom1"
    Alors the stdout should contain exactly:
    """
    titre1a
    titre1b
    titre1c

    """
