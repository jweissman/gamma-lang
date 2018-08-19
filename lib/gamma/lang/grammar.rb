require 'parslet'

module Gamma
  module Lang
    class Grammar < Parslet::Parser
      #
      # base rules
      #
      root(:expression_list)

      rule(:expression_list) { expr.as(:stmt) >> (stmt_delim >> expr.as(:stmt)).repeat(1) |
                               expr }


      rule(:expr) { funcall |
                    eq_exp |
                    add_exp |
                    value }

      rule(:stmt_delim) { match[';'] >> space? }

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

      rule(:eq_exp) { ident >> eq_op >> expr.as(:eq_rhs) }

      rule(:eq_op)    { match['='].as(:op) >> space? }

      #
      # function calls
      #

      rule(:funcall) { ident.as(:func) >> lparens >> arglist.maybe.as(:arglist) >> rparens >> space? }

      rule(:arglist) { expr.as(:arg) >> (comma >> space? >> expr.as(:arg)).repeat >> space? }

      #
      # grammar parts
      #

      rule(:subexpression) { lparens >> expr >> rparens >> space? }

      rule(:value)    { integer |
                        ident |
                        subexpression }

      rule(:integer)  { digit.repeat(1).as(:i) >> space? }

      rule(:ident)    { ((alpha | underscore).repeat(1) >> (alpha | digit | underscore).repeat).as(:id) >> space? }

      #
      # 1 char rules
      #

      rule(:space)      { match['\s'].repeat }
      rule(:space?)     { space.maybe }
      rule(:digit)      { match['0-9'] }
      rule(:lparens)    { match['('] }
      rule(:rparens)    { match[')'] }
      rule(:alpha)      { match['a-zA-Z'] }
      rule(:underscore) { match['_'] }
      rule(:comma)      { match[','] }
    end
  end
end
