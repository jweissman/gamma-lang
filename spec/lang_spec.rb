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

    xit 'should add AND multiply ints' do
      expect(geval('1+2*3')).to eq(GInt[7])
    end
  end
end
