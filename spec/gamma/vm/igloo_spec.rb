require 'spec_helper'
require 'gamma/vm'

include Gamma::VM
include Gamma::VM::BuiltinTypes

describe Igloo do
  let(:igloo) { described_class.new }
  let(:vm)    { igloo.manager }

  def rc(cmd); vm.run(cmd) end

  it 'should store a value' do
    expect(rc(
      vm.store('a', GInt[12345])
    )).to eq(Result[
      GInt[12345],
      "a is now 12345"
    ])

    expect(
      vm.run(vm.retrieve('a'))
    ).to eq(
      Result[
        GInt[12345],
        "a is 12345"
      ]
    )
  end

  it 'should increment a value' do
    rc(vm.store('a', GInt[2]))
    expect(rc(vm.increment('a'))).to eq(Result[
      GInt[3],
      "a is now 3"
    ])
    expect(rc(vm.retrieve('a'))).to eq(Result[GInt[3], "a is 3"])
  end

  it 'should add integers' do
    rc(vm.store('a', GInt[2]))
    rc(vm.store('b', GInt[3]))
    expect(
      # c = a + b
      rc(vm.add('c', 'a', 'b')) #Int[2], Int[3]))
    ).to eq(Result[
      GInt[5],
      "c is now 5"
    ])
  end

  it 'should multiply integers' do
    rc(vm.store('a', GInt[2]))
    rc(vm.store('b', GInt[3]))
    expect(
      rc(vm.mult('c', 'a', 'b'))
    ).to eq(Result[
      GInt[6],
      "c is now 6"
    ])
  end

  it 'should subtract integers' do
    rc(vm.store('a', GInt[3]))
    rc(vm.store('b', GInt[2]))
    expect(rc(vm.sub('c', 'a', 'b'))).to eq(Result[GInt[1], "c is now 1"])
  end

  it 'should divide integers' do
    rc(vm.store('a', GInt[4]))
    rc(vm.store('b', GInt[2]))
    expect(rc(vm.div('c', 'a', 'b'))).to eq(Result[GInt[2], "c is now 2"])
  end
end
