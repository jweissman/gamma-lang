module Gamma
  module Lang
    class Interpreter
      def evaluate(str)
        matched = parser.parse(str)
        if matched.successful?
          tree = matched.match
          ast = transform.apply(tree)
          cmds = derive_commands(ast)
          #
          # binding.pry
          ret = nil
          cmds.each do |cmd|
            ret = vm.run(cmd)
          end
          ret
        else
          "(could not parse input string #{str}: #{matched.error})"
        end
      end

      protected

      def derive_commands(ast_node)
        # turn an ast node into vm commands
        # and then run them!
        #
        # i think we need to 'invert' the evaluation process
        # and emit commands where we would be reducing and eval'ing
        # directly
        #
        # binding.pry
        cmd = case ast_node
        when AST::IntLiteral then vm.put_anonymous(ast_node.contents)
        else raise "Implement commands for node type #{ast_node.class.name.split('::').last}"
        end
        # commands_from(ast_node)
        # vm.run_commands(commands)
        [cmd]
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
