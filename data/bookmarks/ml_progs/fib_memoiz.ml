var tern (cond, if_true, if_false):{
    var res _
    cond && {res := if_true}
    cond || {res := if_false}
    res
}

var < (a, b):{
    (a > b || a == b) == $false
}

var - (a, b):{
    a + b + b * -2
}

var fib _
fib := (n):{
    tern(n < 2, 1, {
        fib(n - 2) + fib(n - 1)
    })
}

var memoized (fn):{
    ```
        eval fn right away, so we can do
        `fn := memoized(fn)` without
        creating an infinite loop
        (stores the original fn as a state variable)

        Otherwise we would've been forced to do:
        fn := {
            var oldfn fn
            memoized(oldfn)
        }
    ```
    fn
    var cache [:]
    var memoized_fn (args...):{
        var args List(args...)
        cache[args]? || {
            cache[args] := fn(args...)
        }
        cache[args]
    }
    memoized_fn
}


; copy => doesn't work
-- var newfib memoized(fib)
-- print(newfib(50))

; shadowing => doesn't work
-- {
    -- var fib memoized(fib)
    -- print(fib(50))
}

; modifying => work
fib := memoized(fib)
print(fib(50))
