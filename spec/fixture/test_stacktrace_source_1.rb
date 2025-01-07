# frozen_string_literal: true

class TestStacktraceSourceOne
  def call(x)
    inner_method(x, 0)
  end

  def inner_method(x, _y)
    x + 2 + inner_method2(x)
  end

  def inner_method2(x)
    ::RShade::Stack.trace
    x
  end
end
