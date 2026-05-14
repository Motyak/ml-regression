
```
    # Classic Y combinator (assumes non-strict/lazy evaluation)
    Y = lambda f: (lambda x: f(lambda v: (x(x))(v)))(lambda x: f(lambda v: (x(x))(v)))

    # Factorial via Y
    fact = Y(lambda rec: (lambda n: 1 if n == 0 else n * rec(n - 1)))

    print(fact(5))  # 120

    # Fibonacci via Y
    fib = Y(lambda rec: (lambda n:
                        0 if n == 0 else
                        1 if n == 1 else
                        rec(n - 1) + rec(n - 2)))

    print(fib(10))  # 55
```

var tern (cond, if_true, if_false):{
    var res _
    cond && {res := if_true}
    cond || {res := if_false}
    res
}

var - (a, b):{
    a + b + b * -2
}

var Y (f):{
    ((x):{f((v):{x(x)(v)})})((x):{f((v):{x(x)(v)})})
}

var fact Y((rec):{
    (n):{
        tern(n == 0, 1, {
            n * rec(n - 1)
        })
    }
})

print(fact(5))
print(fact(20))
