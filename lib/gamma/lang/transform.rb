require_relative 'ast'
module Gamma
  module Lang
    class Transform < Parslet::Transform
      include AST
      # ...
      rule(i: simple(:int)) { IntLiteral[int.to_i] }
      rule(op: simple(:op), r: simple(:rhs)) { Operation[[op, rhs]] }
      rule(l: simple(:lhs)) { lhs } # unwrap/pass through???

      rule(seq: sequence(:seq)) { Sequence[seq] }
      # rule(l: simple(:left), op: simple(:op), r: sequence(:r)) {

      def inspect; '(gamma-xform)' end
    end
  end
end
