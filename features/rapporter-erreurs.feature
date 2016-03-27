# language: fr

@avance
Fonctionnalité: Retour d'un livre prêté
  En tant qu'usager
  Je veux pouvoir rapporter un livre

  Scénario: Je demande le retour d'un livre prete et cela ne genere pas d'erreur
    Etant donné que la BD existe et est vide
    Et "nom1" ["@"] emprunte "titre1" ["auteurs1"]

    Quand on rapporte "titre1"
    Alors the exit status should be 0

  Scénario: Je demande le retour d'un livre prete et cela ne genere aucune sortie
    Etant donné que la BD existe et est vide
    Et "nom1" ["@"] emprunte "titre1" ["auteurs1"]

    Quand on rapporte "titre1"
    Alors the output should contain exactly:
    """
    """

  Scénario: Je rapporte un pas livre emprunte avec un titre qui est un sous-titre d'un autre et cela genere une erreur
    Etant donné que la BD existe et est vide
    Et "nom1" ["@"] emprunte "Un titre plus long" ["Auteurs1"]

    Quand on rapporte "Un titre"

    Alors the exit status should not be 0
    Et  stderr doit matcher /Aucun livre.*Un titre/

  Scénario: Je rapporte un livre pas emprunte avec un titre qui est un surtitre d'un autre et cela genere une erreur
    Etant donné que la BD existe et est vide
    Et "nom1" ["@"] emprunte "Un titre" ["Auteurs1"]

    Quand on rapporte "Un titre plus long"

    Alors the exit status should not be 0
    Et  stderr doit matcher /Aucun livre.*Un titre plus long/

  Scénario: Je rapporte un livre alors qu'il y a plusieurs livres avec des titres semblables
    Etant donné que la BD existe et est vide
    Et "nom1" ["@"] emprunte "Un titre" ["Auteurs1"]
    Et "nom2" ["@"] emprunte "Un titre plus long" ["Auteurs2"]

    Quand on rapporte "Un titre"

    Alors l'emprunteur de "Un titre plus long" est "nom2"
