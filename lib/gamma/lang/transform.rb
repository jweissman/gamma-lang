require_relative 'ast'
require_relative 'util/transform_helper'
module Gamma
  module Lang
    class Transform < Parslet::Transform
      include AST

      rule(id: simple(:id)) { Ident[id.to_sym] }
      rule(i: simple(:int)) { IntLiteral[int.to_i] }
      rule(id: simple(:id), op: '=', eq_rhs: subtree(:rhs)) { Assign[[id, rhs]] }
      rule(op: simple(:op), r: simple(:rhs)) { Operation[[op, rhs]] }

      # unwrap/pass through???
      rule(l: simple(:lhs)) { lhs }

      rule(func: simple(:method), arglist: subtree(:arglist)) {
        args = TransformHelper
          .normalize_list(arglist)
          .map { |a| a[:arg] }

        Funcall[[ method, args ]]
      }

      rule(sequence(:seq)) { Sequence[seq] }

      def inspect; '(gamma-xform)' end
    end
  end
end
