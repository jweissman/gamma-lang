require 'spec_helper'

require 'gamma/lang/ast'
require 'gamma/lang/codegen'
require 'gamma/vm'

include Gamma::VM::BuiltinTypes
include Gamma::VM::Commands
include Gamma::Lang::AST

describe Gamma::Lang::Codegen do
  subject(:codegen) do
    described_class.new(vm: vm)
  end

  # magic tmp0 reg
  let(:tmp) { Gamma::VM::Igloo::ANON_REG_KEY }

  let(:virtual_machine) { Gamma::VM::Igloo.new }
  let(:vm) { virtual_machine.manager }

  # codegen only knows about vm api but we want to test against the actual code structure generated

  describe 'builds linear code from AST' do
    it 'stores int literals in anonymous register' do
      expect(subject.derive(IntLiteral[1])).to eq([
        StoreDictionaryKey[[tmp, GInt[1]]]
      ])
    end

    it 'retrieves values from named registers' do
      expect(subject.derive(Ident[:xy])).to eq([
        Copy[[tmp, :xy]]
      ])
    end

    it 'assigns values' do
      actual = subject.derive(Assign[['xy', IntLiteral[10]]])
      expected = [StoreDictionaryKey[['xy', GInt[10]]]]

      expect(actual).to eq(expected)
    end

    it 'converts sequence into list of operations' do
      expect(subject.derive(Sequence[[
        IntLiteral[2],
        Operation[['+', IntLiteral[2]]]
      ]])).to eq([
        StoreDictionaryKey[[tmp, GInt[2]]],
        StoreDictionaryKey[['t1', GInt[2]]],
        Add[[tmp, tmp, 't1']]
      ])
    end

    it 'converts sequence into list of operations' do
      expect(subject.derive(Sequence[[
        IntLiteral[2],
        Operation[['*', IntLiteral[2]]],
        Operation[['+', IntLiteral[1]]]
      ]])).to eq([
        StoreDictionaryKey[[tmp, GInt[2]]],
        StoreDictionaryKey[['t1', GInt[2]]],
        Mult[[tmp, tmp, 't1']],
        StoreDictionaryKey[['t2', GInt[1]]],
        Add[[tmp, tmp, 't2']]
      ])
    end

    it 'recursively converts nested sequences' do
      ast = Sequence[[
        IntLiteral[1],
        Operation[['+', Sequence[[
          IntLiteral[2],
          Operation[['*', IntLiteral[3]]]
        ]]]]
      ]]

      expect(subject.derive(ast)).to eq([
        # we need to figure out we have to do the inner sequence first!!
        StoreDictionaryKey[[tmp, GInt[1]]],
        StoreDictionaryKey[['t1', GInt[2]]],
        StoreDictionaryKey[['t2', GInt[3]]],
        Mult[['t1','t1','t2']],
        Add[['_','_','t1']]
      ])
    end

    it 'derives funcalls' do
      ast = Funcall[[
        Ident[:puts],
        [IntLiteral[1]]
      ]]

      expect(subject.derive(ast)).to eq([
        StoreDictionaryKey[['t1', GInt[1]]],
        CallBuiltin[['puts', ['t1'], tmp]]
      ])
    end
  end
end
