require 'parslet'

require 'spec_helper'

require 'gamma/lang/ast'
require 'gamma/lang/transform'

include Gamma::Lang::AST
describe Gamma::Lang::Transform do
  it 'transforms ids' do
    expect(subject).to transform(id: 'abc').into(Ident[:abc])
  end

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

  it 'transforms assignments' do
    expect(subject).to transform(
      id: 'abc',
      op: '=',
      eq_rhs: '3+5'
    ).into(
      Assign[['abc', '3+5']]
    )
  end

  it 'unwraps left-operand ' do
    expect(subject).to transform(l: 'operand').into('operand')
  end


  describe 'arithmetic' do
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

    it 'transforms nested arithmetic' do
      tree = [
        {:l=>{:i=>"1"}},
        {:op=>"+", :r=>[
          {:l=>{:i=>"2"}},
          {:op=>"*", :r=>{:i=>"3"}}
        ]}
      ]

      expect(subject).to transform(tree).into(
        Sequence[[
          IntLiteral[1],
          Operation[['+', Sequence[[
            IntLiteral[2],
            Operation[['*', IntLiteral[3]]]
          ]]]]
        ]]
      )
    end
  end
end
