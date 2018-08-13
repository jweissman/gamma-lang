require 'spec_helper'
require 'gamma/lang'

include Gamma
include Gamma::VM::BuiltinTypes

describe Lang do
  it "should have a VERSION constant" do
    expect(subject.const_get('VERSION')).to_not be_empty
  end

  describe Lang::Interpreter do
    it 'should echo back' do
      expect(subject.evaluate('1')).to eq VM::Result[GInt[1], '_ is now 1']
    end

    it 'should add two ints' do
      expect(subject.evaluate('1+2')).to eq VM::Result[GInt[3], '_ is now 3']
    end
  end
end
