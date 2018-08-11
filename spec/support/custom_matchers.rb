RSpec.configure do |config|
  config.expect_with :rspec do |c|
    # verbose custom matchers
    c.include_chain_clauses_in_custom_matcher_descriptions = true
  end
end

#
# 'parse' -- idiomatically test strings for parse-ability
#
#  usage:
#
#    expect(...).to parse(...)
#
#    expect([parser]).to parse([test_string])
#
#    expect(integer).to parse '6589'
#
RSpec::Matchers.define :parse do |test_string|
  match do |parser|
    expect(parser.parse(test_string)).to be_successful
  end
end

#
# 'transform' -- idiomatically test parse-to-ast conversion
#
# expect(...).to transform(...).into(...)
#
# expect([transform]).to transform([tree]).into([intermediate])
#
# expect(subject).to transform(i: '123').into(IntLiteral[123])
#
RSpec::Matchers.define :transform do |tree|
  match do |the_transform|
    actual = the_transform.apply(tree)
    expected = @result
    expect(actual).to eq(expected)
  end

  chain :into do |result|
    @result = result
  end

  failure_message do |the_transform|
    actual = the_transform.apply(tree)
    expected = @result
    "expected #{tree} to turn into\n\n    #{expected.inspect}\n\n  but instead got\n\n    #{actual.inspect}\r\n\r\n"
  end
end
