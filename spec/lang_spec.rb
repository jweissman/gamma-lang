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

    it 'is resilient to whitespace' do
      expect(geval('(2*1) + 3')).to eq(GInt[5])

      # i'm not sure i want this right now!
      # expect(geval('1 + ( 2 * 1 ) + 3 / ( 3 * 1 ) + 1')).to eq(GInt[5]) # 1 + 2 + 1 + 1
    end

    it 'should call builtins' do
      # no side effect, returns Nothing
      expect(geval('puts()')).to eq(GNothing[])
      expect(geval('puts(0)')).to eq(GNothing[])
      expect(geval('puts(1,2)')).to eq(GNothing[])
      expect(geval('puts(1+2,2+4,4+5)')).to eq(GNothing[])
      expect(geval('puts(puts(1))')).to eq(GNothing[])
    end

    it 'should run multiple commands' do
      expect(geval("a=1;b=2\na+b")).to eq(GInt[3])
      expect(geval("a=1;\nb=2;\n\na+b")).to eq(GInt[3])
      expect(geval("a=1;\nb=2;\n\na+b;")).to eq(GInt[3])
    end

    it 'should define and use (single-line) functions' do
      expect(geval('square = (x) -> x * 2; square(2)')).to eq(GInt[4])
      expect(geval('square = (x) -> x * 2; square(square(4))')).to eq(GInt[16])
    end

    it 'should define and use (multi-line) funcs' do
      expect(geval('square(x) { puts(x); x * x }; square(2)')).to eq(GInt[4])
    end
  end
end
