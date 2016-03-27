# language: fr

Fonctionnalité: Des messages d'aide appropriés sont générés
  En tant qu'usager
  Je veux avoir de l'information sur les commandes disponibles
  Afin de pouvoir utiliser plus facilement le logiciel

  En tant que développeur
  Je veux m'assurer que les codes de statut appropriés sont produits
  Afin de respecter les bonnes règles Unix

  Scénario: Le lancement de l'application sans argument fournit l'aide
    Quand j'exécute sans argument
    Alors le message d'aide est généré
    Et the exit status should be 0

  Scénario: Le lancement de l'application avec aide fournit l'aide
    Quand j'exécute avec "aide"
    Alors le message d'aide est généré
    Et the exit status should be 0

  Scénario: L'application signale une erreur en cas de commande inconnue et produit l'aide
    Quand j'exécute avec "XXX"
    Alors stderr doit matcher /Commande inconnue.*XXX"
    Et le message d'aide est généré
    Et the exit status should not be 0



