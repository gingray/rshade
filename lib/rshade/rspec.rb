module RShade
  REPORTS = []

  module RSpecHelper
    def rshade_reveal(type = ::RShade::ONLY_APP_CODE, &block)
      raise 'No block given' unless block_given?

      trace = Trace.new
      trace.reveal do
        yield
      end

      REPORTS.push trace.show(type)
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
