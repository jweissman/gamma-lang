require 'parslet'

module Gamma
  module Lang
    class Grammar < Parslet::Parser
      #
      # base rules
      #
      root(:expression)

      rule(:expression) { stmt |
                          value }


      rule(:stmt) { add_exp |
                    eq_exp }

      #
      # arithmetic rules
      #

      rule(:add_exp) { mult_exp.as(:l) >> (add_op >> mult_exp.as(:r)).repeat(1) |
                       mult_exp }

      rule(:mult_exp) { value.as(:l) >> (mult_op >> value.as(:r)).repeat(1) |
                        value }

      rule(:add_op)   { match['+-'].as(:op) >> space? }
      rule(:mult_op)  { match['*/'].as(:op) >> space? }

      #
      # variables
      #

      rule(:eq_exp) { ident >> eq_op >> expression.as(:eq_rhs) }

      rule(:eq_op)    { match['='].as(:op) >> space? }

      #
      # grammar parts
      #

      rule(:subexpression) { lparens >> expression >> rparens }

      rule(:value)    { integer |
                        ident |
                        subexpression }

      rule(:integer)  { digit.repeat(1).as(:i) >> space? }

      rule(:ident) { ((alpha | underscore).repeat(1) >> (alpha | digit | underscore).repeat).as(:id) >> space? }

      #
      # 1 char rules
      #

      rule(:space)  { match['\s'].repeat }
      rule(:space?) { space.maybe }
      rule(:digit)  { match['0-9'] }
      rule(:lparens) { match['('] }
      rule(:rparens) { match[')'] }
      rule(:alpha) { match['a-zA-Z'] }
      rule(:underscore) { match['_'] }

    end
  end
end
