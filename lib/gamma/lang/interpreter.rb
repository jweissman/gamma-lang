module Gamma
  module Lang
    class Interpreter
      def evaluate(str)
        matched = parser.parse(str)
        if matched.successful?
          parse_tree = matched.match
          intermediate_ast = transform.apply(parse_tree)
          commands = codegen.derive(intermediate_ast)
          run_commands(commands)
        else
          raise "Could not parse input string #{str}: #{matched.error}"
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
      end

      private

      def parser
        Parser.new
      end

      def transform
        Transform.new
      end

      def codegen
        Codegen.new(vm: vm)
      end

      def vm
        @vm ||= VM::Igloo.new

        # always go thru manager
        @vm.manager
      end
    end
  end
end
