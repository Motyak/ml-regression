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

var memoized (OUT fn):{
    var old_fn fn
    var cache [:]
    var memoized_fn (args...):{
        var args List(args...)
        cache[args]? || {
            cache[args] := old_fn(args...)
        }
        cache[args]
    }
    fn := memoized_fn
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
memoized(&fib)
print(fib(50))

; also works for copying/shadowing
var msleep memoized(sleep)
msleep(2)
msleep(2)
