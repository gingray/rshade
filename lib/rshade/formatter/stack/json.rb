# frozen_string_literal: true

module RShade
  module Formatter
    module Stack
      class Json
        attr_reader :filepath

        def initialize(filepath: )
          @filepath = filepath
        end

        # @param [Array<RShade::StackFrame>] stack_frames
        def call(stack_frames)
          payload = stack_frames.map.with_index do |frame, idx|
            serialize(idx, frame)
          end

          File.open(filepath, 'w+') do |file|
            record = {
              time: Time.now.getutc,
              frames: payload
            }
            file.write(JSON.pretty_generate(record))
          end
        end
        
        private
        
        # @param [RShade::StackFrame] frame
        def serialize(idx, frame)
          {
            frame: idx,
            source_location: "#{frame.source_location[:path]}:#{frame.source_location[:line]}",
            local_variables: frame.local_vars
          }
        end
      end
    end
  end
end
