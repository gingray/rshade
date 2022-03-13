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
    inner2
    1 * -1
  rescue => e
    "catch exception #{e.message}"
    1 * -1
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

class TestRshade3
  def some(x)
  end

  def self.call
    new.some(3)
  end
end


