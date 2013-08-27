require 'spec_helper'

describe SelectedLinks::Link do
  describe "constructing a link" do
    context "without a block" do
      context "with valid options" do
        before :each do
          @link = SelectedLinks::Link.new('Name', 'options', :source => '/foo', :matcher => 'foo')
        end

        it "should have a name" do
          @link.name.should eq 'Name'
        end

        it "should have options" do
          @link.options.should eq 'options'
        end

        it "should have have html_options of a hash with two items" do
          @link.html_options.should be_a(Hash)
          @link.html_options.size.should eq 2
        end
      end

      context "with a block" do
        context "with valid options" do
          before :each do
            @link = SelectedLinks::Link.new 'options', :source => '/foo', :matcher => 'foo' do
              'Block Content'
            end
          end

          it "should not have a name" do
            @link.name.should be_nil
          end

          it "should have options" do
            @link.options.should eq 'options'
          end

          it "should have have html_options of a hash with two items" do
            @link.html_options.should be_a(Hash)
            @link.html_options.size.should eq 2
          end
        end
      end
    end
  end

  describe "with valid options" do
    before :each do
      @link = SelectedLinks::Link.new('Name', 'options', :source => '/foo', :matcher => 'foo')
    end

    it "should remove source option" do
      @link.send(:remove_source)
      @link.html_options.has_key?(:source).should be_false
    end

    it "should remove matcher option" do
      @link.send(:remove_matcher)
      @link.html_options.has_key?(:matcher).should be_false
    end

    it "should remove both source and matcher options" do
      @link.send(:cleanup)
      @link.html_options.has_key?(:source).should be_false
      @link.html_options.has_key?(:matcher).should be_false
    end

    describe "url_match?" do
      it "should return true when url matches given strig" do
        @link.send(:url_match?, '/hello', 'hello').should be_true
      end

      it "should return true when url partially matches string" do
        @link.send(:url_match?, '/hello', 'ell').should be_true
      end

      it "should return false when string does not match" do
        @link.send(:url_match?, '/hello', 'world').should be_false
      end
    end

    context "for a matcher match" do
      it "should return true for a match" do
        @link.send(:is_match?).should be_true
      end

      it "should return false for a non match" do
        @link = SelectedLinks::Link.new('Name', 'options', :source => '/bar', :matcher => 'foo')
        @link.send(:is_match?).should be_false
      end
    end

    context "for a named match" do
      it "should return true for a named match" do
        @link = SelectedLinks::Link.new('Foo', 'options', :source => '/foo')
        @link.send(:is_match?).should be_true
      end

      it "should return false for a non match" do
        @link = SelectedLinks::Link.new('Bar', 'options', :source => '/foo')
        @link.send(:is_match?).should be_false
      end
    end

    context "fallback to named path" do
      it "should not fallback by default" do
        @link = SelectedLinks::Link.new('Foo', 'options', :source => '/foo', :matcher => 'bar')
        @link.send(:is_match?).should be_false
      end

      it "should fallback when setting is on" do
        SelectedLinks.fallback_to_name = true
        @link = SelectedLinks::Link.new('Foo', 'options', :source => '/foo', :matcher => 'bar')
        @link.send(:is_match?).should be_true
      end
    end
  end

  describe "fully constructed link" do
    context "with a matcher link" do
      it "should have a class of selected added" do
        @link = SelectedLinks::Link.new('Name', 'options', :source => '/foo', :matcher => 'foo').generate
        @link.html_options[:class].should =~ /selected/
      end

      it "should not have a class of selected if there was not a match" do
        @link = SelectedLinks::Link.new('Name', 'options', :source => '/foo', :matcher => 'bar').generate
        @link.html_options[:class].should_not =~ /selected/
      end
    end

    context "with a named link" do
      it "should have a class of selected added" do
        @link = SelectedLinks::Link.new('Foo', 'options', :source => '/foo').generate
        @link.html_options[:class].should =~ /selected/
      end

      it "should not have a class of selected if there was not a match" do
        @link = SelectedLinks::Link.new('Bar', 'options', :source => '/foo').generate
        @link.html_options[:class].should_not =~ /selected/
      end
    end

    context "with an existing class" do
      it "should have a class of selected added" do
        @link = SelectedLinks::Link.new('Name', 'options', :source => '/foo', :matcher => 'foo', :class => 'nav').generate
        @link.html_options[:class].should =~ /selected/
      end

      it "should not have a class of selected if there was not a match" do
        @link = SelectedLinks::Link.new('Name', 'options', :source => '/foo', :matcher => 'bar', :class => 'nav').generate
        @link.html_options[:class].should_not =~ /selected/
      end

      it 'should have a space between the existing classes and the selected class' do
        @link = SelectedLinks::Link.new('Name', 'options', :source => '/foo', :matcher => 'foo', :class => 'nav').generate
        @link.html_options[:class].should == 'nav selected'
      end
    end
  end
end
