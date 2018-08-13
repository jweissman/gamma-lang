require 'spec_helper'
require 'gamma/lang'

include Gamma::VM
include Gamma::VM::BuiltinTypes

describe Gamma::Lang::Interpreter do
  it 'should evaluate simple values' do
    expect(subject.evaluate('1')).to eq(Result[GInt[1], '_ is now 1'])
    expect(subject.evaluate('2')).to eq(Result[GInt[2], '_ is now 2'])
  end

  it 'should evaluate a simple expression' do
    expect(subject.evaluate('1 + 2')).to eq(
      Result[GInt[3], '_ is now 3']
    )

    expect(subject.evaluate('1 + 2 + 3')).to eq(
      Result[GInt[6], '_ is now 6']
    )
  end
end
