#!/usr/bin/env ruby

require 'fileutils'
require_relative 'emprunt'

###################################################
# CONSTANTES GLOBALES.
###################################################
SEPARATEUR = '%'

SEP = SEPARATEUR  # Un alias pour alleger les expr. reg.

DEPOT_PAR_DEFAUT = '.biblio.txt'

###################################################
# Fonctions pour debogage et traitement des erreurs.
###################################################

# Pour generer ou non des traces de debogage avec la function debug,
# il suffit d'ajouter/retirer '#' devant '|| true'.
DEBUG=false #|| true

def debug( *args )
  return unless DEBUG

  puts "[debug] #{args.join(' ')}"
end

def erreur( msg )
  STDERR.puts "*** Erreur: #{msg}"
  STDERR.puts

  puts aide if /Commande inconnue/ =~ msg

  exit 1
end

def erreur_nb_arguments( *args )
  erreur "Nombre incorrect d'arguments: <<#{args.join(' ')}>>"
end

###################################################
# Fonction d'aide: fournie, pour uniformite.
###################################################

def aide
    <<EOF
NOM
  #{$0} -- Script pour la gestion de prets de livres

SYNOPSIS
  #{$0} [--depot=fich] commande [options-commande] [argument...]

COMMANDES
  aide           - Emet la liste des commandes
  emprunter      - Indique l'emprunt d'un (ou plusieurs) livre(s)
  emprunteur     - Emet l'emprunteur d'un livre
  emprunts       - Emet les livres empruntes par quelqu'un
  init           - Cree une nouvelle base de donnees pour gerer des livres empruntes
                   (dans './#{DEPOT_PAR_DEFAUT}' si --depot n'est pas specifie)
  indiquer_perte - Indique la perte du livre indique
  lister         - Emet l'ensemble des livres empruntes
  rapporter      - Indique le retour d'un (ou plusieurs) livre(s)
  trouver        - Trouve le titre complet d'un livre
                   ou les titres qui contiennent la chaine
EOF
end

###################################################
# Fonctions pour manipulation du depot.
#
# Fournies pour simplifier le devoir et assurer au depart un
# fonctionnement minimal du logiciel.
###################################################

def definir_depot
  depot ||= DEPOT_PAR_DEFAUT

  depot
end

def init( depot )

  if File.exists? depot
    if detruire
      FileUtils.rm_f depot # On detruit le depot existant si --detruire est specifie.
    else
      erreur "Le fichier '#{depot}' existe.
              Si vous voulez le detruire, utilisez 'init --detruire'."
    end
  end
  FileUtils.touch depot
end

def charger_emprunts( depot )
  erreur "Le fichier '#{depot}' n'existe pas!" unless File.exists? depot

  # On lit les emprunts du fichier.
  IO.readlines( depot ).map do |ligne|
    # On ignore le saut de ligne avec chomp.
    nom, courriel, titre, auteurs, perdu = ligne.chomp.split(SEP)
    Emprunt.new( nom, courriel, titre, auteurs, perdu == 'PERDU' )
  end
end

def sauver_emprunts( depot, les_emprunts )
  # On cree une copie de sauvegarde.
  FileUtils.cp depot, "#{depot}.bak"

  # On sauve les emprunts dans le fichier.
  #
  # Ici, on aurait aussi pu utiliser map plutot que each. Toutefois,
  # comme la collection resultante n'aurait pas ete utilisee,
  # puisqu'on execute la boucle uniquement pour son effet de bord
  # (ecriture dans le fichier), ce n'etait pas approprie.
  #
  File.open( depot, "w" ) do |fich|
    les_emprunts.each do |e|
      perdu = e.perdu? ? 'PERDU' : ''
      fich.puts [e.nom, e.courriel, e.titre, e.auteurs, perdu].join(SEP)
    end
  end
end


#################################################################
# Les fonctions pour les diverses commandes de l'application.
#################################################################

def lister( les_emprunts )
  #
  # Remarque (difference par rapport a la version biblio.sh):
  # Si le livre est perdu, alors l'annotation utilisee est [[PERDU]]!
  # (Pcq. sinon la mise en page emacs n'est pas bonne avec <<PERDU>>!)
  #

  listing = '' # A MODIFIER!
  [les_emprunts, listing]
end


def emprunter( les_emprunts )
  [les_emprunts, nil] # A MODIFIER!
end

def emprunts( les_emprunts )
  liste_emprunts = '' # A MODIFIER!
  [les_emprunts, liste_emprunts]
end

def rapporter( les_emprunts )
  [les_emprunts, nil] # A MODIFIER!
end

def trouver( les_emprunts )
  liste_titres = '' # A MODIFIER!
  [les_emprunts, liste_titres]
end

def indiquer_perte( les_emprunts )
  [les_emprunts, nil]
end

def emprunteur( les_emprunts )
  nom_emprunteur = "\n"  # A MODIFIER!

  [les_emprunts, nom_emprunteur]
end



#######################################################
# Les differentes commandes possibles.
#######################################################
COMMANDES = [:emprunter,
             :emprunteur,
             :emprunts,
             :init,
             :lister,
             :indiquer_perte,
             :rapporter,
             :trouver,
            ]

#######################################################
# Le programme principal
#######################################################

#
# La strategie utilisee pour uniformiser le traitement des commandes
# est la suivante (strategie differente de celle utilisee par
# biblio.sh dans le devoir 1).
#
# Une commande est mise en oeuvre par une fonction auxiliaire.
# Contrairement au devoir 1, c'est cette fonction *qui modifie
# directement ARGV* (ceci est possible en Ruby, alors que ce ne
# l'etait pas en bash), et ce en fonction des arguments consommes.
#
# La fonction ne retourne donc pas le nombre d'arguments
# utilises. Comme on desire utiliser une approche fonctionnelle, la
# fonction retourne plutot deux resultats (tableau de taille 2):
#
# 1. La liste des emprunts resultant de l'execution de la commande
#    (donc liste possiblement modifiee)
#
# 2. L'information a afficher sur stdout (nil lorsqu'il n'y a aucun
#    resultat a afficher).
#

# On definit le depot a utiliser, possiblement via l'option.
depot = definir_depot

debug "On utilise le depot suivant: #{depot}"

# On analyse la commande indiquee en argument.
commande = (ARGV.shift || :aide).to_sym
(puts aide; exit 0) if commande == :aide

erreur "Commande inconnue: '#{commande}'" unless COMMANDES.include? commande

# La commande est valide: on l'execute et on affiche son resultat.
if commande == :init
  init( depot )
else
  les_emprunts = charger_emprunts( depot )
  les_emprunts, resultat = send commande, les_emprunts
  print resultat if resultat   # Note: print n'ajoute pas de saut de ligne!
  sauver_emprunts( depot, les_emprunts )
end

erreur "Argument(s) en trop: '#{ARGV.join(' ')}'" unless ARGV.empty?
