module RShade
  class RSpecListener
    attr_reader :trace

    NOTIFICATIONS = %i[
        example_started
        example_finished
      ].freeze


    def example_started(notification)
      return unless notification.example.metadata[:rshade]

      @trace = RShade::Trace.new
      @trace.start
    end

    def example_finished
      return unless @trace

      trace.stop
    end

    def report
      return unless @trace

      puts trace.show
    end
  end

  module RSpecHelper
    def rshade_reveal(&block)
      raise 'No block given' unless block_given?

      trace = Trace.new
      trace.reveal do
        yield
      end
      puts trace.show
    end
  end
end

if defined? RSpec
  RSpec.configure do |c|
    listener = nil
    c.include RShade::RSpecHelper
    c.before(:suite) do
      listener = RShade::RSpecListener.new
      c.reporter.register_listener(
          listener, *RShade::RSpecListener::NOTIFICATIONS
      )
    end

    c.after(:suite) { listener.try(:report) }
  end
end
