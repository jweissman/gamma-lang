require_relative 'grammar'

module Gamma
  # parsing in gamma is a lightweight wrapper
  # around parslet grammar, providing a match
  # object and uniform api
  module Lang
    Match = Struct.new(:match, :error) do
      def successful?
        error.nil?
      end

      def inspect
        error.nil? ? "MatchSucceeded[#{match}]"
        : "MatchFailed[#{error}]"
      end
    end

    module MatchWrapping
      def wrap_match(&block)
        begin
          Match[block.call]
        rescue Parslet::ParseFailed => ex
          Match[nil, ex]
        end
      end
    end

    class PartMatcher < Struct.new(:grammar, :part_sym)
      include MatchWrapping
      def parse(str)
        wrap_match do
          grammar.send(part_sym).parse(str)
        end
      end
    end

    class Parser
      include MatchWrapping
      def parse(str)
        wrap_match { grammar.parse(str) }
      end

      def method_missing(meth, *args, &blk)
        if grammar.respond_to?(meth)
          # assume meth is grammar part
          part = meth
          PartMatcher[grammar, part]
        else
          super(meth, *args, &blk)
        end
      end

      private

      def grammar
        @grammar ||= Grammar.new
      end
    end
  end
end
