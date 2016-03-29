# -*- coding: utf-8 -*-

ADRESSE_COURRIEL = /([\w\.]*@[\w\.]*)/

#
# Objet pour modeliser un Emprunt d'un livre.
#
# Tous les champs sont immuables (non modifiables) à l'exception du
# champ qui indique si le document est perdu.
#
class Emprunt
  include Comparable

  attr_reader :nom, :courriel, :titre, :auteurs

  def initialize( nom, courriel, titre, auteurs, perdu = false )
    fail "Format invalide de courriel: #{courriel}!?" unless courriel =~ ADRESSE_COURRIEL

    @nom = nom
    @courriel = courriel
    @titre = titre
    @auteurs = auteurs
    @perdu = perdu
  end


  #
  # Formate un emprunt selon les indications spécifiées par le_format:
  #   - %N: Nom de l'emprunteur
  #   - %C: Courriel de l'emprunteur
  #   - %T: Titre du document emprunté
  #   - %A: Auteurs du document emprunté
  #
  # Des indications de largeur, justification, etc. peuvent aussi être
  # spécifiées, par exemple, %-10A, %-.10A, etc.
  #
  # %[flags][width][.precision]type
  def to_s(le_format = nil)
    # Format simple par defaut, pour les cas de tests de base.a
    perdu = perdu? ? ' [[PERDU]]' : ''
    if le_format.nil?
      return format('%s :: [ %-10s ] "%s"', nom, auteurs, titre) << perdu
    end

    elems_format = []
    new_format = le_format.gsub(/%(-?\.?\d+)?\D/) do |match|
      elems_format.push(format_value(match[-1]))

      match.gsub(/[NCTA]/, "s")
    end

    return (new_format % elems_format) << perdu
  end


  #
  # Ordonne les emprunts selon le nom en premier, puis selon le titre.
  #
  def <=>( autre )
    return nil if autre.nil?
    return nil unless autre.class == self.class

    nameComparison = self.nom <=> autre.nom
    return nameComparison unless nameComparison == 0

    titleComparison = self.titre <=> autre.titre
    titleComparison == 0 ? nil : titleComparison
  end

  #
  # Indique la perte d'un document.
  #
  def indiquer_perte
    @perdu = true
  end

  # Attribut booleen, donc nom avec '?'.
  def perdu?
    @perdu
  end
end

private

def format_value(letter)
  case letter
    when 'N'
      @nom
    when 'C'
      @courriel
    when 'T'
      @titre
    when 'A'
      auteurs
    else
      fail "Cas non traite: to_s( #{letter} )"
  end
end
