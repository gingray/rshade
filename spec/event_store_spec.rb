RSpec.describe RShade::EventStore, focus: true do
  let(:service) { RShade::Trace.new({})  }
  let(:result) do
    service.reveal do
      TestRshade2.call
    end
  end

  it "show report" do
    result.event_store.head.each do |item|
      puts "level: #{item.level} #{item&.event&.klass}##{item&.event&.method_name}"
    end
  end
end
