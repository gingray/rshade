RSpec.describe RShade, focus: true do
  let(:result) do
    RShade::Trace.reveal do
      TestRshade.call
    end
  end

  it "show report" do
    expect(result).to be_kind_of RShade::Trace
    result.show
  end
end
