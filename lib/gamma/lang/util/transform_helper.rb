module Gamma
  module Lang
    module TransformHelper
      class << self
        include AST
        def normalize_list(maybe_nil_or_singleton)
          if maybe_nil_or_singleton.nil?
            []
          elsif maybe_nil_or_singleton.is_a?(Array)
            maybe_nil_or_singleton
          else # assume singleton + wrap
            [maybe_nil_or_singleton]
          end
        end
      end
    end
  end
end
