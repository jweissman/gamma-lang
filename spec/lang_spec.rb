require 'spec_helper'
require 'gamma/lang'

include Gamma
include Gamma::VM::BuiltinTypes

describe Lang do
  def gamma_eval(str)
    res = subject.evaluate(str)
    res.ret_value
  end
  alias :geval :gamma_eval

  describe Lang::Interpreter do
    it 'should echo back (wrap in builtin types)' do
      expect(geval('1')).to eq GInt[1]
    end

    it 'should add two ints' do
      expect(geval('1+2')).to eq GInt[3]
    end

    it 'should multiply two ints' do
      expect(geval('4*5')).to eq GInt[20]
    end

    it 'should add AND multiply ints' do
      expect(geval('1+2*3')).to eq(GInt[7])
    end

    it 'should subtract two ints' do
      expect(geval('1-2')).to eq(GInt[-1])
    end

    it 'should compute arithmetic expressions containing parentheses' do
      expect(geval('2*(1+3)')).to eq(GInt[8])
      expect(geval('(2+1)*3')).to eq(GInt[9])
    end

    it 'should handle variables' do
      expect(geval('a = 2')).to eq(GInt[2])
      expect(geval('a')).to eq(GInt[2])
      expect(geval('a * 3')).to eq(GInt[6])
    end

    # todo just need a bit more tolerance
    xit 'is resilient to whitespace' do
      expect(geval('(2*1) + 3')).to eq(GInt[6])
    end

  end
end
