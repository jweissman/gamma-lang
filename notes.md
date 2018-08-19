

square = x -> x * 2

# js/c-style
square(x) { x * 2 }

# es6 (anon fn lit)
(x) => { x * 2 }


### what is the LITERAL representation of a function?

defun square(x)
  2 * x
end

#########

1. square x = 2 * x

**2. square = (x) => { |x| 2 * x }

3. square = { |x| 2 * x }

# interesting, make use of anon reg?
# seems kind of 'tricky'
square = _ * _

pattern matching args??

fib 0 = 1
fib 1 = 1
fib n = fib(n-2) + fib(n-1)

fib =
  | 0 -> 1
  | 1 -> 1
  | n -> fib(n-2) + fib(n+1)

#######
# square x, y =
#   2 * x




