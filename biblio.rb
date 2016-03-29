#!/usr/bin/env ruby

require 'fileutils'
require_relative 'emprunt'

###################################################
# CONSTANTES GLOBALES.
###################################################
SEPARATEUR = '%'

SEP = SEPARATEUR  # Un alias pour alleger les expr. reg.

DEPOT_PAR_DEFAUT = '.biblio.txt'

OPTIONS = {
  depot: DEPOT_PAR_DEFAUT
}

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
  <<-EOF
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

def init
  depot = OPTIONS[:depot]
  detruire = OPTIONS[:detruire]

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

def charger_emprunts
  depot = OPTIONS[:depot]
  erreur "Le fichier '#{depot}' n'existe pas!" unless File.exists? depot

  # On lit les emprunts du fichier.
  IO.readlines( depot ).map do |ligne|
    # On ignore le saut de ligne avec chomp.
    nom, courriel, titre, auteurs, perdu = ligne.chomp.split(SEP)
    Emprunt.new( nom, courriel, titre, auteurs, perdu == 'PERDU' )
  end
end

def sauver_emprunts(les_emprunts )
  depot = OPTIONS[:depot]

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
  emprunts = les_emprunts.map {|emprunt| emprunt.to_s(OPTIONS[:format]) }

  [les_emprunts, emprunts.join("\n")]
end


def emprunter( les_emprunts )
  erreur "Nombre incorrect d'arguments" unless ARGV.size % 4  == 0

  erreur = false
  nouveaux_emprunts =
    if ARGV.size > 0
      (1..ARGV.size / 4).collect do
        nom, courriel, titre, auteurs = ARGV.shift(4)

        Emprunt.new(nom, courriel, titre, auteurs)
      end
    else
      lines = STDIN.readlines
      lines.map do |line|
        line = line.strip
        if line != ""
          val = nil #TODO

          motif = /\"(.*)\" (.*@.*) \"(.*)\" \"(.*)\"/
          parsed_line = motif.match line

          if parsed_line && parsed_line.size == 5
            nom, courriel, titre, auteurs = parsed_line[1], parsed_line[2], parsed_line[3], parsed_line[4]
            val = Emprunt.new(nom, courriel, titre, auteurs)
          else # ligne non vide mais invalide.
            erreur = true
          end

          val
        end
      end
    end

  titres = nouveaux_emprunts.select{|e| not(e.nil?)}.map{|e| e.titre}
  erreur "livre avec le meme titre deja emprunte" if les_emprunts.detect{|e| titres.include?(e.titre)}

  les_emprunts = les_emprunts + nouveaux_emprunts.select{|e| not e.nil?} unless erreur
  #p les_emprunts
  [les_emprunts, nil]
end

def emprunts( les_emprunts )
  nom = ARGV.shift
  erreur "Emprunteur absent" unless nom

  titres = les_emprunts.select {|e| e.nom == nom }.map {|e| e.titre }

  [les_emprunts, titres.join("\n")]
end

def rapporter( les_emprunts )
  titre = ARGV.shift
  erreur "titre manquant" unless titre

  emprunt = les_emprunts.select{ |emprunt| emprunt.titre == titre }.first
  les_emprunts.delete(emprunt)

  [les_emprunts, nil]
end

def trouver( les_emprunts )
  query = ARGV.shift
  error "mot cle(s) invalide(s)" unless query

  titres = les_emprunts.select do |e|
    q = query.downcase
    e.titre.downcase =~ /[^(#{q})]*#{q}.*/
  end.map{ |e| e.titre }

  [les_emprunts, titres.join("\n")]
end

def indiquer_perte( les_emprunts )
  [les_emprunts, nil]
end

def emprunteur( les_emprunts )
  titre = ARGV.shift
  erreur "titre absent" unless titre

  nom_emprunteur = les_emprunts.select do |emprunt|
    emprunt.titre == titre
  end.first.nom

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

def get_commande_and_parse_options
  commande = nil

  (1..ARGV.size).collect do
    if ARGV.detect {|arg| arg =~ /--.*/ || COMMANDES.include?(arg.to_sym) }
      arg = (ARGV.shift || :aide)

      if COMMANDES.include? arg.to_sym
        erreur "Commande en trop" if commande
        commande = arg.to_sym
      else
        case arg
        when "--detruire"
          OPTIONS[:detruire] = true
        when /--depot=.*/
          # On definit le depot a utiliser, possiblement via l'option.
          OPTIONS[:depot] = arg.scan(/[^=]*$/).first

          debug "On utilise le depot suivant: #{OPTIONS.fetch(:depot)}"
        when /--format=.*/
          OPTIONS[:format] = arg.scan(/[^=]*$/).first
        end
      end

      (puts aide; exit 0) if commande == :aide
    end
  end

  erreur "Aucune commande passée en paramètres" if commande.nil?
  commande
end

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


# On analyse la commande indiquee en argument.
commande = get_commande_and_parse_options

# La commande est valide: on l'execute et on affiche son resultat.
if commande == :init
  init
else
  les_emprunts = charger_emprunts
  les_emprunts, resultat = send commande, les_emprunts
  print resultat + "\n" if resultat && resultat != ""
  sauver_emprunts les_emprunts.sort
end

erreur "Argument(s) en trop: '#{ARGV.join(' ')}'" unless ARGV.empty?
