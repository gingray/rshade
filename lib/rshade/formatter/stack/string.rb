# frozen_string_literal: true

module RShade
  module Formatter
    module Stack
      class String
        ROOT_SEP = "---\n"

        def initialize(opts = {}); end

        # @param [RShade::EventProcessor] stack
        def call(stack)
          buffer = StringIO.new
          stack.each_with_index do |node, idx|
            depth = node.level
            event = node.value
            if depth == 1
              buffer << ROOT_SEP
              next
            end
            next unless event

            buffer.write line(idx, event, node.vlevel)
          end
          buffer.string
        end

        def line(line_idx, value, depth); end
      end
    end
  end
end
