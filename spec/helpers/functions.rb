shared_examples_for "any function" do
  describe "instance method" do
    describe "'f'" do
      it "should return 0 for a large negative number" do
        subject.f(-10000).should == -1
      end
      
      it "should return 1 for a large positivie number" do
        subject.f(10000).should == 1
      end
    end
  end
end