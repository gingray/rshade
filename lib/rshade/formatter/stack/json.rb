# frozen_string_literal: true

module RShade
  module Formatter
    module Stack
      class Json
        attr_reader :filepath, :pretty, :variable_serializer

        def initialize(filepath:, pretty: false)
          @filepath = filepath
          @pretty = pretty
        end

        # @param [Array<RShade::StackFrame>] stack_frames
        def call(stack_frames, variable_serializer: nil)
          payload = stack_frames.map.with_index do |frame, idx|
            serialize(idx, frame, variable_serializer)
          end

          File.open(filepath, 'a+') do |file|
            record = {
              time: Time.now.getutc,
              thread_id: Thread.current,
              thread_list: Thread.list,
              frames: payload
            }
            file.puts(convert_to_json(record, pretty))
          end
        end

        private

        def convert_to_json(object, pretty)
          return JSON.pretty_generate(object) if pretty

          JSON.generate(object)
        end

        # @param [RShade::StackFrame] frame
        def serialize(idx, frame, variable_serializer)
          local_vars = variable_serializer.nil? ? frame.local_vars : variable_serializer.call(frame.local_vars)
          receiver_variables = variable_serializer.call(frame.receiver_variables) unless variable_serializer.nil?
          {
            frame: idx,
            source_location: "#{frame.source_location[:path]}:#{frame.source_location[:line]}",
            local_variables: local_vars,
            receiver_variables: receiver_variables
          }
        end
      end
    end
  end
end
