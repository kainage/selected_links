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
        end
      end
    end
  end

  describe "with valid options" do
    before :each do
      @link = SelectedLinks::Link.new('Name', 'options', :source => '/foo', :matcher => 'foo')
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
    describe "with default class name" do
      context "with a matcher link" do
        it "should have a class of active added" do
          @link = SelectedLinks::Link.new('Name', 'options', :source => '/foo', :matcher => 'foo').generate
          @link.html_options[:class].should =~ /active/
        end

        it "should not have a class of active if there was not a match" do
          @link = SelectedLinks::Link.new('Name', 'options', :source => '/foo', :matcher => 'bar').generate
          @link.html_options[:class].should_not =~ /active/
        end
      end

      context "with a named link" do
        it "should have a class of active added" do
          @link = SelectedLinks::Link.new('Foo', 'options', :source => '/foo').generate
          @link.html_options[:class].should =~ /active/
        end

        it "should not have a class of active if there was not a match" do
          @link = SelectedLinks::Link.new('Bar', 'options', :source => '/foo').generate
          @link.html_options[:class].should_not =~ /active/
        end
      end

      context "with an existing class" do
        it "should have a class of active added" do
          @link = SelectedLinks::Link.new('Name', 'options', :source => '/foo', :matcher => 'foo', :class => 'nav').generate
          @link.html_options[:class].should =~ /active/
        end

        it "should not have a class of active if there was not a match" do
          @link = SelectedLinks::Link.new('Name', 'options', :source => '/foo', :matcher => 'bar', :class => 'nav').generate
          @link.html_options[:class].should_not =~ /active/
        end

        it 'should have a space between the existing classes and the active class' do
          @link = SelectedLinks::Link.new('Name', 'options', :source => '/foo', :matcher => 'foo', :class => 'nav').generate
          @link.html_options[:class].should == 'nav active'
        end
      end
    end

    describe "with a passed in class name" do
      context "with a matcher link" do
        it "should have a class of passed added" do
          @link = SelectedLinks::Link.new('Name', 'options', :source => '/foo', :matcher => 'foo', :class_name => 'passed').generate
          @link.html_options[:class].should =~ /passed/
        end

        it "should not have a class of passed if there was not a match" do
          @link = SelectedLinks::Link.new('Name', 'options', :source => '/foo', :matcher => 'bar', :class_name => 'passed').generate
          @link.html_options[:class].should_not =~ /passed/
        end
      end

      context "with a named link" do
        it "should have a class of passed added" do
          @link = SelectedLinks::Link.new('Foo', 'options', :source => '/foo', :class_name => 'passed').generate
          @link.html_options[:class].should =~ /passed/
        end

        it "should not have a class of passed if there was not a match" do
          @link = SelectedLinks::Link.new('Bar', 'options', :source => '/foo', :class_name => 'passed').generate
          @link.html_options[:class].should_not =~ /passed/
        end
      end

      context "with an existing class" do
        it "should have a class of passed added" do
          @link = SelectedLinks::Link.new('Name', 'options', :source => '/foo', :matcher => 'foo', :class_name => 'passed', :class => 'nav').generate
          @link.html_options[:class].should =~ /passed/
        end

        it "should not have a class of passed if there was not a match" do
          @link = SelectedLinks::Link.new('Name', 'options', :source => '/foo', :matcher => 'bar', :class_name => 'passed', :class => 'nav').generate
          @link.html_options[:class].should_not =~ /passed/
        end

        it 'should have a space between the existing classes and the passed class' do
          @link = SelectedLinks::Link.new('Name', 'options', :source => '/foo', :matcher => 'foo', :class_name => 'passed', :class => 'nav').generate
          @link.html_options[:class].should == 'nav passed'
        end
      end
    end

    describe "with a overridden default class name" do
      before :each do
        SelectedLinks.default_class_name = 'selected'
      end

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
end
