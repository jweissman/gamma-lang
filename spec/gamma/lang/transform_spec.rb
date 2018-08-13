require 'parslet'

require 'spec_helper'

require 'gamma/lang/ast'
require 'gamma/lang/transform'

include Gamma::Lang::AST
describe Gamma::Lang::Transform do
  it 'transforms ints' do
    expect(subject).to transform(i: '1234').into(IntLiteral[1234])
  end

  it 'transforms operations' do
    expect(subject).to transform(
      op: 'some-operation',
      r: 'the-rhs'
    ).into(
      Operation[['some-operation', 'the-rhs']]
    )
  end

  it 'unwraps left-operand ' do
    expect(subject).to transform(l: 'operand').into('operand')
  end

  it 'transforms arithmetic expressions' do
    tree = [
      { l: { i: '1' } },
      { op: '+', r: { i: '2' } }
    ]

    expect(subject).to transform(tree).into(
      Sequence[[
        IntLiteral[1],
        Operation[[ '+', IntLiteral[2] ]]
      ]]
    )
  end
end
