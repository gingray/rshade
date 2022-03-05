class Object
  def reveal(&block)
    trace = ::RShade::Trace.reveal do
      block.call
    end
    trace.show
  end
end