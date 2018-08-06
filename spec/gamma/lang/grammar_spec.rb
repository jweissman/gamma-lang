require 'spec_helper'

describe Grammar do
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
        expect(integer.parse('123')).to eq(int: '123')
      end
    end

    describe 'addition' do
      let(:add_op) { subject.add_op }
      let(:add_exp ) { subject.add_exp }
      it 'matches expressions with additions' do
        expect(add_op.parse('+')).to eq(op: '+')
        expect{add_op.parse('*')}.to raise_error(Parslet::ParseFailed)
      end
    end
  end
end
