module ValidatesExistence
  module RspecMacros
    def self.included(base)
      base.extend(ClassMethods)
    end
    
    module ClassMethods
      def should_validate_existence_of(*associations)
        allow_nil = associations.extract_options![:allow_nil]

        associations.each do |association|
          it "requires #{association} exists" do
            reflection = subject.class.reflect_on_association(association)
            object = subject
            object.send("#{reflection.primary_key_name}=", 0)
            object.should_not be_valid
            object.errors[association.to_sym].should include("does not exist")
          end
        end

        if allow_nil
          associations.each do |association|
            it "allows #{association} to be nil" do
              reflection = subject.class.reflect_on_association(association)
              object = subject
              object.send("#{reflection.primary_key_name}=", nil)
              object.should be_valid
            end
          end
        end
      end
    end
  end
end