# language: fr

@avance
Fonctionnalité: Signale une erreur lorsque trop d'arguments sont spécifiés
  En tant qu'usager
  Je veux pouvoir être informé quand j'indique trop d'arguments
  Afin ...

  Scénario: J'emprunte un livre et il y a trop d'arguments
    Etant donné que la BD existe et est vide
    Et I run `./biblio.rb emprunter "nom" "@" "titre" "auteurs" "en_trop"`

    Alors the output should match /Argument\(s\) en trop: 'en_trop'/
    Et the exit status should not be 0

  Scénario: Je demande l'emprunteur d'un livre avec trop d'arguments
    Etant donné que la BD existe et est vide
    Et I run `./biblio.rb emprunter "nom" "@" "titre" "auteurs"`
    Et I run `./biblio.rb emprunteur "titre" "en_trop"`

    Alors the output should match /Argument\(s\) en trop: 'en_trop'/
    Et the exit status should not be 0

  Scénario: Je rapporte un livre avec trop d'arguments
    Etant donné que la BD existe et est vide
    Et I run `./biblio.rb emprunter "nom" "@" "titre" "auteurs"`
    Et I run `./biblio.rb rapporter "titre" "en_trop"`

    Alors the output should match /Argument\(s\) en trop: 'en_trop'/
    Et the exit status should not be 0

  Scénario: Je demande les emprunts d'un usager avec trop d'arguments
    Etant donné que la BD existe et est vide
    Et I run `./biblio.rb emprunter "nom" "@" "titre" "auteurs"`
    Et I run `./biblio.rb emprunts "nom" "en_trop"`

    Alors the output should match /Argument\(s\) en trop: 'en_trop'/
    Et the exit status should not be 0


