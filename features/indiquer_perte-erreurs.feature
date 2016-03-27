# language: fr

@avance
Fonctionnalité: Indicate de perte d'un document
  En tant qu'usager
  Je veux pouvoir indiquer qu'un livre avec un titre specifique est perdu

  Scénario: J'indique la perte d'un livre et cela ne genere pas d'erreur
    Etant donné que la BD existe et est vide
    Et "nom1" ["@"] emprunte "titre1" ["auteurs1"]

    Quand on indique la perte de "titre1"
    Alors the exit status should be 0

  Scénario: J'indique la perte d'un livre prete et cela ne genere aucune sortie
    Etant donné que la BD existe et est vide
    Et "nom1" ["@"] emprunte "titre1" ["auteurs1"]

    Quand on indique la perte de "titre1"
    Alors the output should contain exactly:
    """
    """
  Scénario: J'indique la perte d'un livre avec un titre qui est un sous-titre d'un autre
    Etant donné que la BD existe et est vide
    Et "nom1" ["@"] emprunte "Un titre plus long" ["Auteurs1"]

    Quand on indique la perte de "Un titre"

    Alors the exit status should not be 0
    Et  stderr doit matcher /Aucun livre.*Un titre/

  Scénario: J'indique la perte d'un livre avec un titre qui est un suritre d'un autre
    Etant donné que la BD existe et est vide
    Et "nom1" ["@"] emprunte "Un titre" ["Auteurs1"]

    Quand on indique la perte de "Un titre plus long"

    Alors the exit status should not be 0
    Et  stderr doit matcher /Aucun livre.*Un titre plus long/

  Scénario: J'indique la perte d'un livre alors qu'il y a plusieurs livres avec des titres semblables
    Etant donné que la BD existe et est vide
    Et "nom1" ["@"] emprunte "Un titre" ["Auteurs1"]
    Et "nom2" ["@"] emprunte "Un titre plus long" ["Auteurs2"]

    Quand on indique la perte de "Un titre"

    Quand on liste tous les emprunts
    Alors the stdout should contain exactly:
    """
    nom2 :: [ Auteurs2   ] "Un titre plus long"

    """
