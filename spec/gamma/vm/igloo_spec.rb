require 'spec_helper'

include Gamma::VM
include Gamma::VM::BuiltinTypes

describe Igloo do
  let(:igloo) { described_class.new }
  let(:vm)    { igloo.manager }

  it 'should store a value' do
    expect(
      vm.store('a', Int[12345])
    ).to eq(Result[
      Int[12345],
      "a is now 12345"
    ])

    expect(
      vm.retrieve('a')
    ).to eq(
      Result[
        Int[12345],
        "a is 12345"
      ]
    )
  end

  it 'should increment a value' do
    vm.store('a', Int[2])
    expect(vm.increment('a')).to eq(Result[
      Int[3],
      "a is now 3"
    ])
    expect(vm.retrieve('a')).to eq(Result[Int[3], "a is 3"])
  end

  it 'should add integers' do
    expect(
      vm.add_integers(Int[2], Int[3])
    ).to eq(Result[
      Int[5],
      "2 + 3 = 5"
    ])
  end

  it 'should multiply integers' do
    expect(
      vm.multiply_integers(Int[5], Int[6])
    ).to eq(Result[
      Int[30],
      "5 * 6 = 30"
    ])
  end
end
