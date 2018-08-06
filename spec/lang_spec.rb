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
  end
end
