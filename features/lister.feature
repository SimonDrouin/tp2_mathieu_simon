# language: fr

Fonctionnalité: Listage des livres empruntés
  En tant qu'usager
  Je veux pouvoir connaitre les divers livres que j'ai prêtés

  @base
  Scénario: Il n'y a aucun livre emprunté et je fais un listing
    Etant donné que la BD existe et est vide

    Quand on liste tous les emprunts
    Alors the stdout should not contain anything

  @base
  Scénario: J'emprunte plusieurs livres et je fais un listing
    Etant donné que la BD existe et est vide

    Quand "Nom1" ["@"] emprunte "tres_long_titre2" ["Auteurs2"]
    Et    "Nom1" ["@"] emprunte "titre1" ["Auteurs1"]
    Et    "Nom0" ["@"] emprunte "titre0" ["Auteurs0"]

    Quand on liste tous les emprunts
    Alors the stdout should contain exactly:
    """
    Nom0 :: [ Auteurs0   ] "titre0"
    Nom1 :: [ Auteurs1   ] "titre1"
    Nom1 :: [ Auteurs2   ] "tres_long_titre2"

    """

  @avance
  Scénario: J'emprunte plusieurs livres, dont un devient perdu, et je fais un listing normal
    Etant donné que la BD existe et est vide

    Quand "Nom1" ["@"] emprunte "tres_long_titre2" ["Auteurs2"]
    Et    "Nom1" ["@"] emprunte "titre1" ["Auteurs1"]
    Et    "Nom0" ["@"] emprunte "titre0" ["Auteurs0"]
    Et on indique la perte de "titre0"

    Quand on liste tous les emprunts
    Alors the stdout should contain exactly:
    """
    Nom1 :: [ Auteurs1   ] "titre1"
    Nom1 :: [ Auteurs2   ] "tres_long_titre2"

    """

  @avance
  Scénario: J'emprunte plusieurs livres, dont un devient perdu, et je fais un listing avec l'option --inclure_perdus
    Etant donné que la BD existe et est vide

    Quand "Nom1" ["@"] emprunte "tres_long_titre2" ["Auteurs2"]
    Et    "Nom0" ["@"] emprunte "titre0" ["Auteurs0"]
    Et on indique la perte de "titre0"

    Quand j'exécute avec "lister --inclure_perdus"
    Alors the stdout should contain exactly:
    """
    Nom0 :: [ Auteurs0   ] "titre0" [[PERDU]]
    Nom1 :: [ Auteurs2   ] "tres_long_titre2"

    """

  @intermediaire
  Scénario: J'emprunte plusieurs livres et je fais un listing avec un format explicite
    Etant donné que la BD existe et est vide

    Quand "Nom1" ["@"] emprunte "Tres Long Titre2" ["Auteurs2"]
    Et    "Nom0" ["@"] emprunte "Titre0" ["Auteurs0"]

    Quand j'exécute avec "lister --format='[<<%T>> => %N]'"
    Alors the stdout should contain exactly:
    """
    [<<Titre0>> => Nom0]
    [<<Tres Long Titre2>> => Nom1]

    """

  @intermediaire
  Scénario: J'emprunte plusieurs livres et je fais un listing avec un format explicite cadre a gauche ou a droite
    Etant donné que la BD existe et est vide

    Quand "Nom1" ["@"] emprunte "Tres Long Titre2" ["Auteurs2"]
    Et    "Nom0" ["@"] emprunte "Titre0" ["Auteurs0"]

    Quand j'exécute avec "lister --format='[\"%-20T\" => %10N]'"
    Alors the stdout should contain exactly:
    """
    ["Titre0              " =>       Nom0]
    ["Tres Long Titre2    " =>       Nom1]

    """

  @avance
  Scénario: J'emprunte plusieurs livres et je fais un listing avec un format explicite mais en incluant les perdus
    Etant donné que la BD existe et est vide

    Quand "Nom1" ["@"] emprunte "Tres Long Titre2" ["Auteurs2"]
    Et    "Nom0" ["@"] emprunte "Titre0" ["Auteurs0"]
    Et    "Nom0" ["@"] emprunte "Autre titre1" ["Auteurs1"]
    Et on indique la perte de "Autre titre1"

    Quand j'exécute avec "lister --format='[<<%T>> => %N]' --inclure_perdus"
    Alors the stdout should contain exactly:
    """
    [<<Autre titre1>> => Nom0] [[PERDU]]
    [<<Titre0>> => Nom0]
    [<<Tres Long Titre2>> => Nom1]

    """



