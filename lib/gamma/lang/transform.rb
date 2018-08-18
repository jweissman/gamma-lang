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
      rule(l: simple(:lhs)) { lhs } # unwrap/pass through???

      rule(func: simple(:func), arglist: subtree(:arglist)) {
        Funcall[[
          func,
          TransformHelper.normalize_list(arglist).map do |arg|
            arg[:arg]
          end
        ]]
      }

      rule(sequence(:seq)) { Sequence[seq] }

      def inspect; '(gamma-xform)' end
    end
  end
end
