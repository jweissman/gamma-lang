module Gamma
  module Lang
    class Codegen
      def initialize(vm:)
        @vm = vm
      end

      def derive(ast)
        # derive code for ast, with result in _
        derive_commands(ast, destination_register: underscore_reg)
      end

      def underscore_reg
        VM::Igloo::ANON_REG_KEY
      end

      protected
      include AST
      attr_reader :vm


      # build linear code for ast
      #
      #  destination_register: target the given register for the result
      #
      def derive_commands(ast_node, destination_register:)
        case ast_node
        when Ident then
          # we need to retrieve the value and put into dst
          id = ast_node.contents
          [
            # just put the value directly in the target register
            vm.copy(destination_register, id)
          ]
        when IntLiteral then
          vm_int = VM::BuiltinTypes::GInt[ast_node.contents]
          [
            # just put the value directly in the target register
            vm.store(destination_register, vm_int)
          ]
        when FunLiteral then
          args, body = *ast_node.contents
          derived_body = derive_commands(body, destination_register: underscore_reg)
          vm_func = VM::BuiltinTypes::GFunction[args.map(&:contents), derived_body]
          [
            vm.store(destination_register, vm_func)
          ]
        when Sequence then
          # seq_target -- use dst as working register
          ast_node.contents.flat_map do |list_elem|
            derive_commands(list_elem, destination_register: destination_register)
          end
        when Operation then
          derive_operation(
            ast_node,
            left_operand_register: destination_register,
            destination_register: destination_register
          )
        when Assign then
          id, rhs = *ast_node.contents
          derive_commands(rhs, destination_register: id)
        when Funcall then
          derive_funcall(
            ast_node,
            destination_register: destination_register
          )
        else
          raise "Implement commands for node type #{ast_node.class.name.split('::').last}"
        end
      end

      def derive_operation(ast_node, left_operand_register:, destination_register:)
        op, r = *ast_node.contents
        cmds = []

        # this recursion is interesting too, it's mutually recursive with sequence
        # in a way that confuses our register targeting
        tmp_r = make_temp_id
        cmds += derive_commands(r, destination_register: tmp_r)

        cmds << case op
        when '+' then vm.add(destination_register, left_operand_register, tmp_r)
        when '-' then vm.sub(destination_register, left_operand_register, tmp_r)
        when '*' then vm.mult(destination_register, left_operand_register, tmp_r)
        when '/' then vm.div(destination_register, left_operand_register, tmp_r)
        else
          raise "No such builtin binary operation #{op}"
        end
        cmds
      end

      def derive_funcall(ast_node, destination_register:)
        ident, arglist = *ast_node.contents
        cmds = []
        method = ident.contents.to_s

        # reify args
        reified_arg_tmp_rs = arglist.map { make_temp_id }

        cmds += arglist.zip(reified_arg_tmp_rs).flat_map do |arg, tmp_r|
          derive_commands(arg, destination_register: tmp_r)
        end

        # lookup builtins
        if vm.builtin?(method)
          cmds.push(vm.call_builtin(method, reified_arg_tmp_rs, destination_register))
        else
          cmds.push(vm.call_udf(method, reified_arg_tmp_rs, destination_register))
        end

        return cmds
      end

      # temp helper?
      # this is hack-y but not sure how else
      # it does seem there should be an algo here
      # we should need exactly ONE to build a calculator, seriously
      # ...hm. (so it turns out we *could* rewrite so all tmps are implicit, but.. there are cons to that too)
      def make_temp_id; "t#{inc_tmp}" end
      def inc_tmp; @tmps ||= 0; @tmps += 1; end
    end
  end
end
