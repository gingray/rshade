# frozen_string_literal: true

class TestRshade
  def some(_x)
    val = 2 + 2
    another + val
  end

  def another
    1 * -1
  end

  def self.call
    new.some(3)
  end
end

class TestRshade2
  def some(_x)
    val = 2 + 2
    inner + val
  end

  def inner
    inner2
    1 * -1
  rescue StandardError
    1 * -1
  end

  def inner2
    inner3
  end

  def inner3
    raise 'exception'
  end

  def self.call
    new.some(3)
  end
end

class TestRshade3
  def some(x); end

  def self.call
    new.some(3)
  end
end
