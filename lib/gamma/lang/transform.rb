require_relative 'ast'
require_relative 'util/transform_helper'
module Gamma
  module Lang
    class Transform < Parslet::Transform
      include AST

      rule(id: simple(:id)) { Ident[id.to_sym] }
      rule(i: simple(:int)) { IntLiteral[int.to_i] }

      # should be Assign[[Ident]]... single we swallow id xform!
      rule(id: simple(:id), op: '=', eq_rhs: subtree(:rhs)) { Assign[[id, rhs]] }

      rule(op: simple(:op), r: simple(:rhs)) { Operation[[op, rhs]] }

      # unwrap/pass through???
      rule(l: simple(:lhs)) { lhs }

      rule(func: simple(:method), arglist: subtree(:arglist)) {
        args = TransformHelper
          .normalize_list(arglist)
          .map { |it| it[:arg] }

        Funcall[[ method, args ]]
      }

      rule(expr_list: subtree(:stmts)) {
        expression_list = TransformHelper
          .normalize_list(stmts)
          .map { |it| it[:stmt] }

        Sequence[expression_list]
      }

      rule(fn_lit: subtree(:fn)) {
        args = TransformHelper
          .normalize_list(fn[:arglist])
          .map { |it| it[:arg] }

        FunLiteral[[
          args,
          fn[:body]
        ]]
      }

      rule(sequence(:seq)) { Sequence[seq] }

      def inspect; '(gamma-xform)' end
    end
  end
end
