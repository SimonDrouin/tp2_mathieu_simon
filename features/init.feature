# language: fr

Fonctionnalité: L'initialisation crée correctement le fichier BD
  En tant qu'usager
  Je veux pouvoir créer ma propre BD, à l'endoit où je veux
  Afin de pouvoir avoir accès aux informations sur mes livres

  @avance
  Plan du scénario: L'initialisation crée par défaut si elle n'existe pas
    Etant donné a file named "<bd>" should not exist
    Quand j'exécute avec "<option> init"
    Alors a file named "<bd>" should exist
    Et il y a 0 emprunt dans "<bd>"

    Exemples:
      | bd          | option           |
      | .biblio.txt |                  |
      | .biblio.txt | --depot=.biblio.txt |
      | foo.txt     | --depot=foo.txt     |


  @avance
  Plan du scénario: L'initialisation crée une BD vide si le fichier existe déjà mais qu'on spécifie l'option de destruction
    Etant donné a file named "<bd>" with:
    """
    N'IMPORTE QUOI!?
    """
    Quand j'exécute avec "<option> init --detruire"
    Alors a file named "<bd>" should exist
    Et il y a 0 emprunt dans "<bd>"

    Exemples:
      | bd          | option           |
      | .biblio.txt |                  |
      | .biblio.txt | --depot=.biblio.txt |
      | foo.txt     | --depot=foo.txt     |


  Scénario: L'initialisation génère une erreur si le fichier existe déjà
    Etant donné an empty file named ".biblio.txt"
    Quand j'exécute avec "init"
    Alors a file named ".biblio.txt" should exist
    Et stderr doit matcher /fichier.*[.]biblio.txt.*existe.*utilisez.*--detruire/
    Et the exit status should not be 0

