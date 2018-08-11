module Gamma
  module Lang
    class Grammar < Parslet::Parser
      #
      # base rules
      #
      root(:expression)

      rule(:expression) { stmt |
                          value }


      rule(:stmt) { add_exp }

      #
      # arithmetic rules
      #

      rule(:add_exp) { mult_exp.as(:l) >> (add_op >> mult_exp.as(:r)).repeat(1) |
                       mult_exp }

      rule(:mult_exp) { value.as(:l) >> (mult_op >> value.as(:r)).repeat(1) |
                        value }

      #
      # grammar parts
      #

      rule(:add_op)   { match['+-'].as(:op) }
      rule(:mult_op)  { match['*/'].as(:op) }

      rule(:value)    { integer }

      rule(:integer)  { digit.repeat(1).as(:i) }


      #
      # 1 char rules
      #

      rule(:space)  { match['\s'].repeat }
      rule(:space?) { space.maybe }
      rule(:digit)  { match['0-9'] }


    end
  end
end
