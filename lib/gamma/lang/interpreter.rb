module Gamma
  module Lang
    class Interpreter
      include AST

      def evaluate(str)
        matched = parser.parse(str)
        if matched.successful?
          parse_tree = matched.match
          intermediate_ast = transform.apply(parse_tree)
          commands = derive_commands(intermediate_ast)
          run_commands(commands)
        else
          "(could not parse input string #{str}: #{matched.error})"
        end
      end

      protected

      def run_commands(cmds)
        ret = nil
        cmds.each do |cmd|
          ret = execute_command(cmd)
        end
        ret
      end

      def execute_command(cmd)
        vm.run(cmd)
      # rescue => ex
      #   binding.pry
      end

      # build linear code for ast
      #
      #  register: target the given register (for the implicit base + result)
      #
      def derive_commands(ast_node, register: VM::Igloo::ANON_REG_KEY)
        case ast_node
        when IntLiteral then
          vm_int = VM::BuiltinTypes::GInt[ast_node.contents]
          [ vm.store(register, vm_int) ]
        when Sequence then
          ast_node.contents.flat_map do |seq_node|
            derive_commands(seq_node)
          end
        when Operation then
          op, r = *ast_node.contents
          cmds = []
          cmds += derive_commands(r, register: 't1')
          cmds << case op
            when '+' then vm.add(register, 't1', register)
            when '*' then vm.mult(register, 't1', register)
          else
            raise "Implement vm operation #{op}"
          end
          cmds
        else
          raise "Implement commands for node type #{ast_node.class.name.split('::').last}"
        end
      end

      private

      def parser
        Parser.new
      end

      def transform
        Transform.new
      end

      def vm
        @vm ||= VM::Igloo.new

        # always go thru manager
        @vm.manager
      end
    end
  end
end
