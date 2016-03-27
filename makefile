###############################################################
#
# Constante a completer pour la remise de votre travail:
#  - CODES_PERMANENTS
#
###############################################################

### Vous devez completer l'une ou l'autre des definitions.   ###

# Deux etudiants:
# Si vous etes deux etudiants: Indiquer vos codes permanents.
CODES_PERMANENTS='ABCD01020304,GHIJ11121314'


# Un etudiant:
# Si vous etes seul: Supprimer le diese en debut de ligne et
# indiquer votre code permanent (sans changer le nom de la variable).
#CODES_PERMANENTS='ABCD01020304'

#--------------------------------------------------------

#TMP: tests_base

########################################################################
BIBLIO=./biblio.rb
########################################################################

.IGNORE:

default: run_lister #wip #tests



##################################
# Cibles pour les runs d'essai.
##################################

run: run_lister

run_all: 
	@echo ""
	make run_lister
	@echo ""
	make run_emprunter
	@echo ""
	make run_emprunteur
	@echo ""
	make run_emprunteur_inexistant
	@echo ""
	make run_emprunts
	@echo ""
	make run_trouver
	@echo ""
	make run_rapporter
	@echo ""
	make run_indiquer_perte
	@echo ""
	make run_autre_depot
	@echo ""
	make run_format
	@echo ""
	make run_emprunter_stdin
	@echo ""
	make run_rapporter_stdin

run_emprunter: run_init
	$(BIBLIO) emprunter "Joe Bidon" "@" "Classic Shell Scripting" "Robbins et Beebe"
	# Il devrait y avoir trois emprunts.
	$(BIBLIO) lister

run_emprunteur: run_init
	$(BIBLIO) emprunteur "The Pragmatic Programmer"

run_emprunteur_inexistant: run_init
	$(BIBLIO) emprunteur "Foo"

run_emprunts: run_init
	# Un seul emprunt = "The Pragmatic Programmer"
	$(BIBLIO) emprunts "Joe Bidon"

run_init:
	@cp -f biblio.txt.init .biblio.txt

run_lister: run_init
	# Il devrait y avoir deux emprunts: cf. .biblio.txt.init
	$(BIBLIO) lister

run_lister_perdus: run_init
	# Il devrait y avoir deux emprunts: cf. .biblio.txt.init
	$(BIBLIO) lister --inclure_perdus

run_rapporter: run_init
	$(BIBLIO) rapporter "The Pragmatic Programmer"
	# Le livre a ete rapporte.
	$(BIBLIO) lister

run_indiquer_perte: run_init
	$(BIBLIO) indiquer_perte "Programming Ruby"
	# Le livre perdu n'est pas inclus dans la liste.
	$(BIBLIO) lister
	# Le livre perdu est inclus dans la liste.
	$(BIBLIO) lister --inclure_perdus

run_trouver: run_init
	# Un titre trouve -- on ignore la casse!
	$(BIBLIO) trouver "pragmatic"
	# Deux titres trouves -- on ignore la casse.
	$(BIBLIO) trouver "prog"

run_autre_depot: run_init
	$(BIBLIO) --depot=mon-depot.txt init --detruire
	$(BIBLIO) --depot=mon-depot.txt emprunter "Mon nom" "@" "Un titre" "Les auteurs"
	$(BIBLIO) --depot=mon-depot.txt lister
	$(BIBLIO) --depot=mon-depot.txt rapporter "Un titre"
	# Sera vide... et l'autre depot aura les deux emprunts.
	$(BIBLIO) --depot=mon-depot.txt lister
	$(BIBLIO) lister

run_format: run_init
	$(BIBLIO) indiquer_perte "Programming Ruby"
	# Le livre perdu n'est pas inclus dans la liste.
	$(BIBLIO) lister --format='[%T:: %N]'
	# Le livre perdu est inclus dans la liste.
	$(BIBLIO) lister --inclure_perdus --format='[%T:: %N]'

run_emprunter_stdin: run_init
	# Devra indiquer quatre documents.
	@$(BIBLIO) emprunter < emprunts.txt
	@$(BIBLIO) lister

run_rapporter_stdin: run_init
	# Devra indiquer 0 document.
	@$(BIBLIO) rapporter < retours.txt
	@$(BIBLIO) lister


############################################
# Cibles pour les tests unitaires de Emprunt
############################################
tests_emprunt:
	ruby spec/emprunt_spec.rb

############################################
# Cibles pour les tests d'acceptation.
############################################
FORMAT=progress
COLOR=--color

wip: 
	cucumber --tags @wip --tags ~@ignore --format=$(FORMAT) $(COLOR)

tests: tests_base tests_intermediaire tests_avance

tests_base: 
	cucumber --tags @base --tags ~@ignore --format=$(FORMAT) $(COLOR)

tests_intermediaire: 
	cucumber --tags @intermediaire --tags ~@ignore --format=$(FORMAT) $(COLOR)

tests_avance: 
	cucumber --tags @avance --tags ~@ignore --format=$(FORMAT) $(COLOR)



##################################
# Nettoyage.
##################################
clean:
	@-
	rm -f *.aux *.dvi *.ps *.log *.bbl *.blg *.pdf *.out
	@+
	rm -f *~ *.bak
	rm -rf tmp

########################################################################
########################################################################

BOITE=INF600A
remise:
	PWD=$(shell pwd)
	ssh oto.labunix.uqam.ca oto rendre_tp tremblay_gu $(BOITE) $(CODES_PERMANENTS) $(PWD)/biblio.rb $(PWD)/emprunt.rb
	ssh oto.labunix.uqam.ca oto confirmer_remise tremblay_gu $(BOITE) $(CODES_PERMANENTS)

########################################################################
########################################################################

