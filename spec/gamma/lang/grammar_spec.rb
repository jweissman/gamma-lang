require 'spec_helper'
require 'gamma/lang/grammar'

describe Gamma::Lang::Grammar do
  context 'arithmetic' do
    describe 'digits' do
      let(:digit) { subject.digit }
      it 'matches digits' do
        expect(digit.parse('1')).to eq('1')
        expect{digit.parse('_')}.to raise_error(Parslet::ParseFailed)
      end
    end

    describe 'integer literals' do
      let(:integer) { subject.integer }
      it 'matches ints' do
        expect(integer.parse('123')).to eq(i: '123')
      end
    end

    describe 'addition' do
      let(:add_op) { subject.add_op }
      let(:add_exp ) { subject.add_exp }
      it 'matches add ops' do
        expect(add_op.parse('+')).to eq(op: '+')
        expect{add_op.parse('*')}.to raise_error(Parslet::ParseFailed)
      end

      it 'matches expressions with additions' do
        expect(add_exp.parse('1+2')).to eq([
          {l: {i: '1'}},
          {op: '+', r: {i: '2'}}
        ])
      end
    end
  end
end
