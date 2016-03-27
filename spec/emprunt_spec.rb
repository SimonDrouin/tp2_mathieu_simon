require_relative 'spec-helper'
require_relative '../emprunt'

describe Emprunt do
  let(:emp){ Emprunt.new( "Guy T.", "guy_t@gmail.com", "Titre 1", "Les auteurs" ) }

  describe "#to_s -- tests_base" do
    it "genere par defaut une forme simple avec des guillemets pour titre et auteurs" do
      emp.to_s.must_equal 'Guy T. :: [ Les auteurs ] "Titre 1"'
    end

    it "produit la chaine du format quand aucun element n'est indique" do
      emp.to_s( "ABC" ).must_equal "ABC"
    end

    it "produit les bons elements, meme lorsqu'utilise plusieurs fois un item" do
      emp.to_s( "%N %N %C %T %A" ).must_equal "Guy T. Guy T. guy_t@gmail.com Titre 1 Les auteurs"
    end

    it "inclut les chaines qui ne sont pas des formats" do
      emp.to_s( "'%T' => %N (%C)" ).must_equal "'Titre 1' => Guy T. (guy_t@gmail.com)"
    end
  end

  describe "#to_s -- tests_intermediaire" do
    it "traite les justifications et la largeur maximum" do
      emp.to_s( "%5N:%-4N:%.4N" ).must_equal "Guy T.:Guy T.:Guy "
    end

    it "indique qu'il est perdu lorsque c'est le cas" do
      emp.indiquer_perte
      emp.to_s( "%N %C %T" ).must_equal "Guy T. guy_t@gmail.com Titre 1 [[PERDU]]"
    end

    it "genere une erreur quand une specification de champ non valide est indiquee" do
      lambda { emp.to_s( "xxx %N %s %T" ) }.must_raise RuntimeError
      lambda { emp.to_s( "xxx %d %T %T" ) }.must_raise RuntimeError
    end
  end

  #@-
  describe "#to_s -- prives" do
    it "assure que le format n'est pas modifie par une utilisation" do
      format = "%T => %N"
      emp.to_s( format ).must_equal "Titre 1 => Guy T."
      format.must_equal "%T => %N"
    end
  end
  #@+

  describe "#<=>" do
    it "compare tout d'abord par rapport aux noms" do
      e1 = Emprunt.new( "Guy T.", "@", "Titre 1", "Les auteurs" )
      e2 = Emprunt.new( "Thomas D.", "@", "t2", "Les auteurs" )

      assert e1 == e1
      assert e1 < e2
      assert e1 <= e2
    end

    it "compare tout d'abord par rapport aux noms puis par rapport aux titres" do
      e1 = Emprunt.new( "Guy T.", "@", "Titre 1", "Les auteurs 1" )
      e2 = Emprunt.new( "Guy T.", "@", "Titre 2", "Les auteurs 2" )

      assert e1 < e2
      assert e1 <= e2
    end

    it "retourne nil si les champs autres que le nom et le titre sont differents" do
      e1 = Emprunt.new( "Guy T.", "@", "Titre 1", "Les auteurs" )
      e2 = Emprunt.new( "Guy T.", "@", "Titre 1", "Autres auteurs" )

      assert (e1 <=> e2).nil?
    end
  end


  describe "#perdu?" do
    it "n'est pas perdu lorsqu'on le cree" do
      e = Emprunt.new( "n1", "foo@bar", "Titre 1", "Les auteurs" )
      refute e.perdu?
    end

    it "devient perdu que si on l'indique explicitement" do
      e = Emprunt.new( "n1", "foo@bar", "Titre 1", "Les auteurs" )
      refute e.perdu?

      e.indiquer_perte
      assert e.perdu?
    end
  end
end
