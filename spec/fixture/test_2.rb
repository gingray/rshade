# frozen_string_literal: true

class TestRshade4
  reveal :call
  def call(x)
    inner_method(x, 0)
  end

  def inner_method(x, _y)
    x + 2 + inner_method_2(x)
  end

  def inner_method_2(x)
    x - x
  end
end
