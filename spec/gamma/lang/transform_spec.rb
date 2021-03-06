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

  it 'unwraps left-operand ' do
    expect(subject).to transform(l: 'operand').into('operand')
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

  describe 'function calls' do
    it 'transforms a function call' do
      tree = {
        :func=>{:id=>"puts"},
        :arglist=>[
          {:arg=>{:i=>"1"}},
          {:arg=>{:i=>"2"}},
          {:arg=>[{:l=>{:i=>"3"}},{:op=>"+", :r=>{:i=>"4"}}]},
          {:arg=>{:i=>"5"}}
        ]
      }

      expect(subject).to transform(tree).into(
        Funcall[[
          Ident[:puts],
          [
            IntLiteral[1],
            IntLiteral[2],
            Sequence[[IntLiteral[3], Operation[["+", IntLiteral[4]]]]],
            IntLiteral[5]
          ]
        ]]
      )
    end
  end

  describe 'expression lists' do
    it 'transforms a list of expressions' do
      tree = {
        expr_list: [
          {:stmt=>{:id=>"a", :op=>"=", :eq_rhs=>{:i=>"1"}}},
          {:stmt=>[{:l=>{:id=>"a"}}, {:op=>"+", :r=>{:i=>"5"}}]}
        ]
      }
      expect(subject).to transform(tree).into(
        Sequence[[
          Assign[[ 'a', IntLiteral[1] ]],
          Sequence[[Ident[:a], Operation[[ '+', IntLiteral[5] ]]]]
        ]]
      )
    end
  end

  describe 'function literals' do
    it 'transforms a function literal' do
      tree = {
        fn_lit: {
          :arglist=>{:arg=>{:id=>"x"}},
          :body=>[
            {:l=>{:id=>"x"}},
            {:op=>"*", :r=>{:i=>"2"}}
          ]
        }
      }
      expect(subject).to transform(tree).into(
        FunLiteral[[
          [Ident[:x]],
          Sequence[[
            Ident[:x],
            Operation[['*', IntLiteral[2] ]]
          ]]
        ]]
      )
    end
  end

  describe 'named functions' do
    it 'transforms defun' do
      tree = {
        defun: { :id=>"square" },
        arglist: {:arg=>{:id=>"x"}},
        body: {
          expr_list: [
            {:stmt=>{:func=>{:id=>"puts"}, :arglist=>{:arg=>{:id=>"x"}}}},
            {:stmt=>[{:l=>{:id=>"x"}}, {:op=>"*", :r=>{:id=>"x"}}]}
          ]
        }
      }

      expect(subject).to transform(tree).into(
        Defun[[
          Ident[:square],
          [Ident[:x]],
          Sequence[[
            Funcall[[Ident[:puts], [Ident[:x]]]],
            Sequence[[Ident[:x], Operation[["*", Ident[:x]]]]]
          ]]
        ]]
      )
    end
  end
end
