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

  describe 'parsing addition expressions' do
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

  describe 'parsing multiplication expressions' do
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

  describe 'parsing equations' do
    it 'parses 1+2*3' do
      expect(subject).to parse '1+2*3'
      p subject.parse('1+2*3')
    end
  end
end
