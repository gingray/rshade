RSpec.describe RShade::EventStore, focus: true do
  let(:service) { RShade::Trace.new({})  }
  let(:result) do
    service.reveal do
      TestRshade.call
    end
  end

  it "show report" do
    result
    binding.pry
  end
end
