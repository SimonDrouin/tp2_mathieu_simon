# language: fr

@avance
Fonctionnalité: Emprunt d'un livre pas prêté
  En tant qu'usager
  Je veux pouvoir emprunter un livre

  Scénario: J'emprunte un livre pas emprunte et cela ne genere pas d'erreur
    Etant donné que la BD existe et est vide
    Et "nom1" ["@"] emprunte "titre1" ["auteurs1"]

    Alors the exit status should be 0


  Scénario: J'emprunte un livre pas emprunte et cela ne genere aucune sortie
    Etant donné que la BD existe et est vide
    Et "nom1" ["@"] emprunte "titre1" ["auteurs1"]

    Alors the output should contain exactly:
    """
    """

  Scénario: J'emprunte un livre pas emprunte avec un titre qui est un sous-titre d'un autre et cela ne genere aucune sortie
    Etant donné que la BD existe et est vide
    Et "nom1" ["@"] emprunte "Un titre plus long" ["Auteurs1"]
    
    Quand "nom2" ["@"] emprunte "Un titre" ["Auteurs1"]

    Alors l'emprunteur de "Un titre" est "nom2"
    Et the exit status should be 0


  Scénario: J'emprunte un livre pas emprunte avec un titre qui est un sur-titre d'un autre et cela ne genere aucune sortie
    Etant donné que la BD existe et est vide
    Et "nom1" ["@"] emprunte "Un titre" ["Auteurs1"]
    
    Quand "nom2" ["@"] emprunte "Un titre plus long" ["Auteurs1"]

    Alors l'emprunteur de "Un titre plus long" est "nom2"
    Et the exit status should be 0


