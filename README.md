# terratest
terratest is a simple unittesting library for use in the [terra programming language](https://github.com/terralang/terra). It is written as a language extension of terra and provides several keywords: `test`, `testenv`, `testset`, and `terradef`. `test` signals a boolean lua/terra expression, `testenv` provides a safe environment for writing tests, which may be organized in `testset`'s. Finally, `terradef` represents a block of terra code. 

## Installation and use
Simply copy paste the file `terratest` into your folder and use the library by means of the statement
```
import "terratest"
```
## Writing and evaluating tests
Tests may combine both lua and terra code. For example, the following code directly evaluates a lua statement
```
local a = 1
local b = 2
test a+1==b
```
and the following snippet involves a terra function
```
terra foo(a : int)
  return a+1
end
test f(1)==2
test f(2)==4
```
If a test fails then the linenumber and filename of the test statement is printed for convenience. For example, the above code returns
```
  test passed
  test passed
  test failed in test.t, linenumber 11
```
`test` always expects a boolean result.

### Organizing tests in `testenv`
Although tests can be used directly inline as shown above, it is useful to organize them inside a scoped environment called `testset`. This environement keeps track of some test statistics, which get printed to stdout. Here is an example
```
import "terratest"           
   
local a = 1  
local b = 3  
   
testenv "my test environement" do
  local c = 10
  terradef   
    var x = 1
    var y = 2
  end
  test a*b==3
  test a*b==4 --false
  test a+b+c==14
  test a+b+c==15 --false
  test a+b+c==x+y+11
end 
```
which prints out
```
Test Environment: 	my test environement

  inline tests
  3/5 tests passed
  2/5 tests failed

  test failed in test3.t, linenumber 13
  test failed in test3.t, linenumber 15
```
Notice that the test environment is given a name, which gets printed to stdout. Lua variables may be directly declared and terra variables are declared inside a `terradef` block. Notice that terra variables and lua variables may be logically combined and that lexical scoping rules apply.

### Organizing tests using `testset`
`testset` provides another scoped environment that can be used within a `testenv`. A testset is also given a name and test statistics are printed out separately for each testset inside a test environment. For example,
```
import "terratest"

testenv "first test environement" do
  local z = 10
  terradef
    var x = 1 
  end
 
  testset "my first testset" do
    terradef
      var y = 2 
    end 
    test x+y+z==13
  end
 
  testset "my second testset" do
    terradef
      var p = 5 
    end 
    test x+z+p==16
  end 
end
```
evaluates to stdout
```
Test Environment: 	first test environement

  testset:		my first testset
  1/1 tests passed

  testset:		my second testset
  1/1 tests passed
```
Both testsets reuse the lua and terra variables `z` and `x` defined in the beginning. In addition, the testsets have variables `y` and `p`, respectively, that can only be used inside the testset where they are defined.

### parameterized tests
It is also possible to parameterize tests. Check out the following `Vector` class and tests
```
SVector = terralib.memoize(function(T,N)
    local struct Vector{
        _data : T[N]
    }  
    local Class = {}
    Class.Vector = Vector
 
    terra Vector:size() : int
        return N 
    end
       
    Vector.metamethods.__apply = macro(function(self,idx)
        return `self._data[idx]
    end)
       
    terra Class.fill(a : T) : Vector
        var v : Vector
        for i = 0,N do
            v(i) = a
        end
        return v
    end
    return Class
end)

import "terratest" -- using the terra unit test library
       
testenv "Vector implementation" do
  testset "fill" do
    for _,T in pairs{int32,int64} do
      for N=2,3 do 
        local SVec = SVector(T,N)                      
        terradef                              
          var y = SVec.fill(3)
        end
        test y:size()==N
        for i=0,N-1 do          
          test y(i)==T(3)
        end
      end
    end
  end
end
```
which prints out the following test results
```
Test Environment: 	Vector implementation

  testset:		fill
  14/14 tests passed
```
### Future extensions
I plan the following extensions:
* A setup and teardown environment within the test environment that can be used to allocate and free heap variables.
* Better / additional test statistics
* Support for parameterized testsets or environments. Although this is already possible, the testset names and environment names are currently not parameterizable.

If you have any other useful ideas, please let me know.


