# language: fr

Fonctionnalité: Recherche de livres par extrait de titre
  En tant qu'usager
  Je veux pouvoir trouver tous les titres de livres qui matchent une chaine simple

  @base
  Scénario: J'emprunte plusieurs livres et il y en a un seul qui matche
    Etant donné que la BD existe et est vide
    Et "nom1" ["@"] emprunte "titre1" ["auteurs1"]
    Et "nom2" ["@"] emprunte "titre2" ["auteurs2"]

    Quand je cherche les titres contenant "titre2"
    Alors the output should contain exactly:
    """
    titre2

    """

  @base
  Scénario: J'emprunte plusieurs livres et il n'y a aucun qui matche
    Etant donné que la BD existe et est vide
    Et "nom1" ["@"] emprunte "titre1" ["auteurs1"]
    Et "nom2" ["@"] emprunte "titre2" ["auteurs2"]
    Et "nom3" ["@"] emprunte "titre3" ["auteurs3"]

    Quand je cherche les titres contenant "titre4"
    Alors the output should contain exactly:
    """
    """

  @base
  Scénario: J'emprunte plusieurs livres et il y en a plusieurs qui matchent
    Etant donné que la BD existe et est vide
    Et "nom1" ["@"] emprunte "titre1" ["auteurs1"]
    Et "nom2" ["@"] emprunte "titre2" ["auteurs2"]
    Et "nom3" ["@"] emprunte "titre3" ["auteurs3"]

    Quand je cherche les titres contenant "titre"
    Alors the output should contain exactly:
    """
    titre1
    titre2
    titre3

    """

  @intermediaire
  Scénario: J'emprunte plusieurs livres et il y en a un seul qui match et le titre contient des blancs
    Etant donné que la BD existe et est vide
    Et "nom1" ["@"] emprunte "Un titre1" ["auteurs1"]
    Et "nom2" ["@"] emprunte "Un autre titre2" ["auteurs2"]
    Et "nom3" ["@"] emprunte "Et un autre titre3" ["auteurs3"]

    Quand je cherche les titres contenant "titre1"
    Alors the output should contain exactly:
    """
    Un titre1

    """

