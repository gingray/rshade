class TestFormatter
  attr_reader :event_store

  def call(event_store)
    @event_store = event_store
  end

  def events
    event_store.drop(1)
  end
end