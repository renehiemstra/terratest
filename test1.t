import "terratest"

terra set(x: &int)
  @x = 1
end

testenv "array" do
  terracode
    var n = 1
    -- Doesn't work
    -- var x: int[n]
    var x: int[1]
    set(&x[0])
    var y = x[0]
  end
  -- Doesn't work
  test @x == 1
  test y == 1
end

