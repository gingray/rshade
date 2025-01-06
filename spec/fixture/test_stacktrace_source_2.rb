# frozen_string_literal: true

class TestStacktraceSourceJsOn
  def call(x)
    inner_method(x, 0)
  end

  def inner_method(x, _y)
    x + 2 + inner_method_2(x)
  end

  def inner_method_2(x)
    config = ::RShade::Config::StackStore.new
    config.set_formatter(::RShade::Formatter::Stack::Json.new(filepath: '/Users/gingray/github/rshade/spec/store/json_store.json'))
    ::RShade::Stack.trace(config: config)
    x
  end
end
