require 'spec_helper'
require 'gamma/lang/parser'

describe Gamma::Lang::Parser do
  let(:parser) { described_class.new }

  # parts of speech
  let(:digit)    { parser.digit }
  let(:integer)  { parser.integer }
  let(:add_op)   { parser.add_op }
  let(:add_exp ) { parser.add_exp }
  let(:mult_exp) { parser.mult_exp }
  let(:ident)    { parser.ident }

  it 'parses digits' do
    expect(digit).to parse '1'
    expect(digit).to parse '4'
    expect(digit).not_to parse '_'
    expect(digit).not_to parse 'a'
  end

  it 'parses integer literals' do
    expect(integer).to parse '123'
    expect(integer).to parse '6589'
    expect(integer).not_to parse '123abc'
    expect(integer).not_to parse 'hello'
  end

  it 'parses addition operators' do
    expect(add_op).to parse '+'
    expect(add_op).to parse '-'
    expect(add_op).not_to parse '*'
    expect(add_op).not_to parse '1'
  end

  describe 'addition expressions' do
    it 'parses 1+1' do
      expect(add_exp).to parse '1+1'
    end

    it 'parses 1 (just an int value)' do
      # parses just an int value
      expect(add_exp).to parse('1')
    end

    it 'parses 1+2+3 (a longer sequence)' do
      # parses a longer sequence
      expect(add_exp).to parse('1+2+3')
    end
  end

  describe 'multiplication expressions' do
    it 'parses 1*2' do
      expect(mult_exp).to parse '1*2'
      expect(mult_exp).to parse '1/2'
    end

    it 'parses 1 (a single int lit)' do
      expect(mult_exp).to parse '1'
      expect(mult_exp).to parse '42'
    end

    it 'parses 1*2/3 (a complex expression)' do
      expect(mult_exp).to parse '1*2/3'
    end
  end

  describe 'equations' do
    it 'parses 1+2*3' do
      expect(subject).to parse '1+2*3'
    end

    it 'parses 2*(1+3)' do
      expect(subject).to parse('2*(1+3)')
    end
  end

  describe 'variables' do
    it 'parses identifiers' do
      expect(ident).to parse 'abc'
      expect(ident).to parse 'camelCased'
      expect(ident).to parse 'under_scores'
      expect(ident).to parse 'trailingNumbers123'
      expect(ident).not_to parse 'names.with.dots'
      expect(ident).not_to parse '96leading_numbers'
    end

    it 'parses assignment' do
      expect(subject).to parse('a=1')
      expect(subject).to parse('b = 1')
    end
  end

  describe 'function calls' do
    subject(:funcall) { parser }
    it 'parses funcall' do
      expect(funcall).to parse('puts()')
      expect(funcall).to parse('puts(1)')
      expect(funcall).to parse('puts(1, 2)')
      expect(funcall).to parse('puts(1 + 2)')
      expect(funcall).to parse('puts(1, 2, 3 + 4)')
      expect(funcall).to parse('puts(1, 2, puts(3 + 4))')
    end
  end

  describe 'blocks' do
    it 'parses multiple statements' do
      expect(parser).to parse('a=1;a+5')
      expect(parser).to parse('a=1; a+5')
    end

    it 'parses (short) fn lit' do
      fun_lit = '(x)->x*2'
      expect(parser).to parse(fun_lit)
      p parser.parse(fun_lit)
    end

    it 'should parse short fn lit assignment' do
      defun = 'square = (x) -> x * 2'
      expect(parser).to parse(defun)
      p parser.parse(defun)
    end
  end
end
