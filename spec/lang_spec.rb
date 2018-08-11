require 'spec_helper'
require 'gamma/lang'

describe Gamma::Lang do
  it "should have a VERSION constant" do
    expect(subject.const_get('VERSION')).to_not be_empty
  end

  describe Interpreter do
    it 'should echo back' do
      expect(subject.evaluate('hello')).to eq 'hello'
    end

    xit 'should add two ints' do
      expect(subject.evaluate('1+2')).to eq('3  # 1 + 2 = 3')
    end
  end
end
