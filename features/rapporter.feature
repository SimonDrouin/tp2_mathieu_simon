# language: fr

Fonctionnalité: Retour de livres
  En tant qu'usager
  Je veux pouvoir indiquer les livres qui me sont rapportés

  @base
  Scénario: J'emprunte plusieurs livres et j'en rapporte un seul
    Etant donné que la BD existe et est vide

    Quand "nom1" ["@"] emprunte "titre1" ["auteurs1"]
    Et    "nom2" ["@"] emprunte "titre2" ["auteurs2"]
    Et    "nom3" ["@"] emprunte "titre3" ["auteurs3"]

    Alors il y a 3 emprunts

    Quand on rapporte "titre2"

    Alors il y a maintenant 2 emprunts
    Et l'emprunteur de "titre1" est "nom1"
    Et l'emprunteur de "titre3" est "nom3"

  @intermediaire
  Scénario: Je rapporte un livre qui n'a pas été emprunté
    Etant donné que la BD existe et est vide

    Quand "nom1" ["@"] emprunte "Le livre 1" ["auteurs1"]
    Et    "nom2" ["@"] emprunte "Le livre 2" ["auteurs2"]
    Et on rapporte "Le livre 3"

    Alors stderr doit matcher /Aucun livre.*avec.*titre.*Le livre 3/
    Et the exit status should not be 0

  @avance
  Scénario: J'emprunte et je retourne un livre via une autre BD
    Etant donné que "autre-bd.txt" existe et est vide
    Quand j'exécute avec "--depot=autre-bd.txt emprunter tremblay tremblay.guy@uqam.ca \"Le titre\" \"Des auteurs\""
    Quand j'exécute avec "--depot=autre-bd.txt rapporter \"Le titre\""
    Quand j'exécute avec "--depot=autre-bd.txt emprunteur \"Le titre\""
    Alors stderr doit matcher /Aucun livre.*Le titre/
    Et the exit status should not be 0
