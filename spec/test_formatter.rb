# frozen_string_literal: true

class TestFormatter
  attr_reader :event_tree

  def call(event_tree)
    @event_tree = event_tree
  end
end
