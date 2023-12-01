import "terratestlang"

local a = 1
local b = 3 

test a*b==3
test a+b==5


testenv "first test environement" do

local c = 10

terradef
  var x = 1
  var y = 2
  y = 3
end

test x*y==2

testset "my first testset" do

  terradef
    var p = 0
  end

  test a+b+p==4
  test a*b==3
  test a+b+c==14
end

terradef
  var z = 2.0
end

test z==2

testset "my second testset"  do

  terradef
    var t1 = 1
    var t2 = 2
  end

  local k = 10

  test 2*t1+t2+k==4+k
  test t1+t2==3
end

end



testenv "second test environement" do
             
terradef      
  var x = 1   
  var y = 3       
end           
              
test x*y==3

testset "first testset" do
    terradef 
	var z = 4
    end
    test x*y*z==12
end

end
