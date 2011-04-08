def it_should_not_have_methods(*methods)
  methods.each do |m|
    describe "instance method #{m}" do
      it "should not exist" do
        subject.should_not respond_to(m.to_sym)
      end
    end
  
  end
end

def it_should_be_enumerable
  it "should be enumerable" do
    subject.each.should be_a Enumerable::Enumerator
  end
end