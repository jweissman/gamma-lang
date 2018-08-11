require 'spec_helper'

require 'gamma/lang'

include Gamma::VM

describe Gamma::Lang::Interpreter do
  it 'should evaluate simple values' do
    expect(subject.evaluate('1')).to eq(Result[1, '_ is now 1'])
    expect(subject.evaluate('2')).to eq(Result[2, '_ is now 2'])
  end
end
