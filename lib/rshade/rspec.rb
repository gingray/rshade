if defined? RSpec
  RSpec.configure do |c|
    c.around(:each, rshade: true) do |example|
      trace = RShade::Trace.new
      trace.reveal do
        example.run
      end
      puts trace.show
    end
  end
end
