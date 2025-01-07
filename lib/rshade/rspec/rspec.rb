# frozen_string_literal: true

module RShade
  # rubocop:disable Style/MutableConstant
  REPORTS = []
  # rubocop:enable Style/MutableConstant

  module RSpecHelper
    def rshade_reveal(options = {}, &block)
      raise 'No block given' unless block_given?

      options.merge!(formatter: Formatter::String) { |_key, v1, _v2| v1 }
      result = Trace.reveal(options, &block)
      REPORTS.push result.show
    end
  end
end

if defined? RSpec
  RSpec.configure do |c|
    c.include RShade::RSpecHelper

    c.after(:suite) do
      RShade::REPORTS.each(&method(:puts))
      RShade::REPORTS.clear
    end
  end
end
