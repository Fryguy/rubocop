# encoding: utf-8

module Rubocop
  module Cop
    module Style
      # Checks for uses of the character literal ?x.
      class CharacterLiteral < Cop
        MSG = 'Do not use the character literal - use string literal instead.'

        def on_str(node)
          # Constants like __FILE__ and __DIR__ are created as strings,
          # but don't respond to begin.
          return unless node.loc.respond_to?(:begin)

          if node.loc.begin.is?('?')
            add_offence(:convention, node.loc.expression, MSG)
            do_autocorrect(node)
          end
        end

        alias_method :on_dstr, :ignore_node
        alias_method :on_regexp, :ignore_node

        def autocorrect_action(node)
          string = node.loc.expression.source[1]

          replace(node.loc.expression, "'#{string}'")
        end
      end
    end
  end
end