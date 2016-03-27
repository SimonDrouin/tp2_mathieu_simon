# -*- coding: utf-8 -*-

#############
# REMARQUE:
#  Dans ce qui suit, j'utilise 'Soit' meme si les scénarios utilisent 'Etant donné ' car
#  sinon cela ne semblait pas fonctionner -- à cause de problème d'accents!?
#############

BIBLIO = './biblio.rb'

####################
# Preconditions
####################

Quand(/^j'execute "([^"]*)" en lisant du fichier "([^"]*)"$/) do |arg1, arg2|
  step %(I run `#{BIBLIO} #{arg1}` interactively)
  step %(I pipe in the file "#{arg2}")
end

Quand(/^j'exécute sans argument$/) do
  step %(I run `#{BIBLIO}`)
end

Quand(/^j'exécute (?:avec )?"(.*?)"$/) do |arg2|
  step %(I run `#{BIBLIO} #{arg2}`)
end

Soit(/^(?:que )?"(.*)" existe et est vide$/) do |fich|
  step %{I successfully run `#{BIBLIO} --depot=#{fich} init --detruire`}
end

Soit(/^(?:que )?la BD existe et est vide$/) do
  step %{I successfully run `#{BIBLIO} init --detruire`}
end

Soit(/^(?:que )?"(.*?)" existe et contient le titre "(.*?)"$/) do |depot, titre|
  step %{"#{depot}" existe et est vide}
  step %{j'exécute avec "--depot=#{depot} emprunter nom @ '#{titre}' auteurs"}
end

Quand(/^"(.*?)" \["(.*?)"\] emprunte "(.*?)" \["(.*?)"\]$/) do |nom, courriel, titre, auteurs|
  step %(I run `#{BIBLIO} emprunter "#{nom}" "#{courriel}" "#{titre}" "#{auteurs}"`)
end

Quand(/^on rapporte "(.*?)"$/) do |titre|
  step %(I run `#{BIBLIO} rapporter "#{titre}"`)
end

Quand(/^on demande l'emprunteur de "(.*?)"$/) do |titre|
  step %(I run `#{BIBLIO} emprunteur "#{titre}"`)
end

Quand(/^on demande les emprunts de "(.*?)"$/) do |nom|
  step %(I run `#{BIBLIO} emprunts "#{nom}"`)
end

Quand(/^on liste tous les emprunts$/) do
  step %(I run `#{BIBLIO} lister`)
end

Quand(/^on indique la perte de "(.*?)"$/) do |titre|
  step %(I run `#{BIBLIO} indiquer_perte "#{titre}"`)
end

Quand(/^on rappelle "(.*?)"$/) do |titre|
  step %(I run `#{BIBLIO} rappeler "#{titre}"`)
end

Quand(/^(?:je|on) cherche les titres contenant "(.*?)"$/) do |titre|
  step %(I run `#{BIBLIO} trouver "#{titre}"`)
end


####################
# Postconditions
####################

Alors(/^le message d'aide est généré$/) do
  step %{the stdout should contain "NOM"}
  step %{the stdout should contain "SYNOPSIS"}
  step %{the stdout should contain "COMMANDES"}
end

Alors(/^l'emprunteur de "(.*?)" est "(.*?)"(?: dans "(.*?)")?$/) do |titre, nom, depot|
  option_depot = if depot then "--depot=#{depot}" else "" end

  step %{j'exécute avec "#{option_depot} emprunteur \"#{titre}\""}
  step %{the exit status should be 0}
  step %{the stdout should contain "#{nom}"}
end

UN_NOMBRE = Transform /^\d+$/ do |nb|
  nb.to_i
end

Alors(/il y a(?: maintenant)? (#{UN_NOMBRE}) emprunts?(?: dans "(.*?)")?$/) do |nb, depot|
  option_depot = if depot then "--depot=#{depot}" else "" end
  cmd = "#{BIBLIO} #{option_depot} lister"
  step %(I run `#{cmd}`)
  nb_lignes = output_from(cmd).chomp.split("\n").size
  expect( nb_lignes ).to eq nb
end

Alors(/^stderr doit matcher \/([^\/]*)\/$/) do |regex|
  #step %(the output should match /#{regex}/)
  assert_matching_output( regex, all_stderr )
end
