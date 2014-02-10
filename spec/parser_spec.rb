require "rspec"
require_relative "../lib/parser"

SPEC_DIR = File.expand_path('../', __FILE__)

describe Parser do 
  before(:all) { FileUtils.copy(File.join(SPEC_DIR, 'configuration.conf.test') , File.join(SPEC_DIR, 'test_configuration.conf')) }

	let(:parser) { Parser.new(File.join(SPEC_DIR, "test_configuration.conf")) }

	context "#initialize" do
		it "creates a Parser object" do
			parser.should be_an_instance_of Parser
		end

		it "requires one parameter" do
			expect { Parser.new }.to raise_error(ArgumentError)
		end

	end

	context "#get_string" do
		it "requires two parameters" do
			expect { parser.get_string("header") }.to raise_error(ArgumentError)
		end

		it "returns the string value" do
			parser.get_string("header", "project").should eq "Programming Test"
		end

		it "returns a String object" do
			string_parser = parser.get_string("header", "project")
			string_parser.should be_an_instance_of String
		end
	end

	context "#get_integer" do
		it "requires two parameters" do
			expect { parser.get_integer("header") }.to raise_error(ArgumentError)
		end

		it "returns the integer value" do
			parser.get_integer("header", "accessed").should eq 205
		end

		it "returns an Integer object" do
			integer_parser = parser.get_integer("header", "accessed")
			integer_parser.should be_an_instance_of Fixnum
		end
	end

	context "#get_float" do
		it "requires two parameters" do
			expect { parser.get_float("header") }.to raise_error(ArgumentError)
		end

		it "returns the float value" do
			parser.get_float("header", "budget").should eq 4.5
		end

		it "returns a Float object" do
			float_parser = parser.get_float("header", "budget")
			float_parser.should be_an_instance_of Float
		end
	end

	context "#set_string" do
		it "requires three parameters" do
			expect { parser.set_string("trailer", "budget") }.to raise_error(ArgumentError)
		end

		it "returns the string value" do
			parser.set_string("header", "project", "Lonely Planet test").should eq "Lonely Planet test" 
		end

		it "returns a String object" do
			string_setter = parser.set_string("header", "project", "Lonely Planet test")
			string_setter.should be_an_instance_of String
		end
	end

	context "#set_integer" do
		it "requires three parameters" do
			expect { parser.set_integer("header", "accessed") }.to raise_error(ArgumentError)
		end

		it "returns the Fixnum value" do
			parser.set_integer("header", "accessed", 187).should eq 187
		end

		it "returns an Integer object" do
			integer_setter = parser.set_integer("header", "accessed", 187)
			integer_setter.should be_an_instance_of Fixnum
		end
	end

	context "#set_float" do
		it "requires three parameters" do
			expect { parser.set_float("header", "budget") }.to raise_error(ArgumentError)
		end

		it "returns the float value" do
			parser.set_float("header", "budget", 3.7).should eq 3.7
		end

		it "returns a Float object" do
			float_setter = parser.set_float("header", "budget", 3.7)
			float_setter.should be_an_instance_of Float
		end
	end
end
