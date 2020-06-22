module RShade
  REPORTS = []

  module RSpecHelper
    def rshade_reveal(options = {})
      raise 'No block given' unless block_given?
      options.merge!(formatter: Formatter::String)
      result = Trace.reveal(options) do
        yield
      end
      REPORTS.push result.show.string
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
