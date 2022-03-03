class TestRshade
  def some(x)
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
  def some(x)
    val = 2 + 2
    inner + val
  end

  def inner
    1 * -1
  rescue => e
    "catch exception #{e.message}"
  end

  def inner2
    inner3
  end

  def inner3
    raise "exception"
  end

  def self.call
    new.some(3)
  end
end

