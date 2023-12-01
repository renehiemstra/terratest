# terratest
terratest is a simple unittesting library for use in the [terra programming language](https://github.com/terralang/terra). It is written as a language extension of terra and provides several keywords: `test`, `testenv`, `testset`, and `terradef`. `test` signals a boolean terra expression, `testenv` provides a safe environment for writing tests, that may be organized in `testset`'s and `terradef` represents a block of terra code. 

## Installation and use
Simply copy paste the file `terratestlang` into your folder and use the library by means of the statement
```
1 import "terratestlang"
```
## Writing and evaluating tests
Tests may combine both lua and terra code. For example, the following code directly evaluates a lua statement
```
3 local a = 1
4 local b = 2
5 test a+1==b
```
and the following snippet involves a terra function
```
7  terra foo(a : int)
8    return a+1
9  end
10  test f(1)==2
11  test f(2)==4
```
If a test fails then the linenumber and filename of the test statement is printed for convenience. For example, the above code returns
```
  test passed
  test passed
  test failed in test.t, linenumber 11
```


`test` always expect a boolean result.

### Organizing tests in `testenv`
Although tests can be used directly inline

Test statistics are printed when testing is performed within the `testenv` environment. If a test fails, the linenumber and filename are printed for convenience. Here follow some examples  

##

