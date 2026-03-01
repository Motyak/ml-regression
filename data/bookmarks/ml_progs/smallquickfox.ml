var not (bool):{
    ==($false, bool)
}

var <> (a, b):{
    a == b == $false
}

var <= (a, b):{
    a > b == $false
}

var >= (a, b):{
    a > b || a == b
}

var < (a, b):{
    (a > b || a == b) == $false
}

var tern (cond, if_true, if_false):{
    var res _
    cond && {res := if_true}
    cond || {res := if_false}
    res
}

var !tern (cond, if_false, if_true):{
    tern(cond, if_true, if_false)
}

var until (cond, do):{
    var 1st_it? $true
    var loop _
    loop := ():{
        cond() || {
            do(1st_it?)
            1st_it? := $false
            _ := loop()
        }
    }
    loop()
    ;
}

var - {
    var sub-1 (n):{
        n + n * -2
    }
    var sub-2 (a, b):{
        a + b + b * -2
    }
    var - (varargs...):{
        tern($#varargs == 1, sub-1(varargs...), {
            tern($#varargs == 2, sub-2(varargs...), {
                die("-() takes either 1 or 2 args")
            })
        })
    }
    -
}

var .. (from, to):{
    $type(from) == 'Str && {from := Byte(from)}
    $type(to) == 'Str && {to := Byte(to)}
    var dispatcher (msg):{
        tern(msg == 'from, from, {
            tern(msg == 'to, to, {
                die("unknown range msg: `" + msg + "`")
            })
        })
    }
    dispatcher
}

var foreach {
    var Container::foreach (OUT container, fn):{
        var nth 1
        until(():{nth > len(container)}, (_):{
            fn(&container[#nth])
            nth += 1
        })
        container
    }

    var Range::foreach (range, fn):{
        var i range('from)
        var to range('to)
        until(():{i > to}, (_):{
            fn(i)
            i += 1
        })
    }

    var foreach (iterable, fn):{
        tern($type(iterable) == 'Lambda, Range::foreach(iterable, fn), {
            Container::foreach(&iterable, fn)
        })
    }

    (foreach)
}

var in {
    var Container::in (elem, container):{
        var nth 1
        var found $false
        until(():{found || nth > len(container)}, (_):{
            found := container[#nth] == elem
            nth += 1
        })
        found
    }

    var Range::in (elem, range):{
        elem >= range('from) && elem <= range('to)
    }

    var in (elem, iterable):{
        tern($type(iterable) == 'Lambda, Range::in(elem, iterable), {
            Container::in(elem, iterable)
        })
    }

    in
}

"autocurries until the nb of required args has been reached"
var curry_required (requiredArgs, fn):{
    var curried _
    curried := (args...):{
        tern($#varargs >= requiredArgs, fn(args...), {
            (args2...):{curried(args..., args2...)}
        })
    }
    curried
}

"calling curry on a function with no required argument.."
"..has no effect => use curry_required instead"
var curry (fn, args...):{
    curry_required(len(fn), fn)(args...)
}

var map {
    var map (fn, iterable):{
        var str? $type(iterable) == 'Str
        var res tern(str?, "", [])
        foreach(iterable, (x):{
            res += tern(str?, fn(x), [fn(x)])
        })
        res
    }
    curry(map)
}

var filter {
    var filter (pred, iterable):{
        var str? $type(iterable) == 'Str
        var res tern(str?, "", [])
        foreach(iterable, (x):{
            pred(x) && {
                res += tern(str?, x, [x])
            }
        })
        res
    }
    curry(filter)
}

var reduce {
    var reduce (acc, fn, iterable):{
        foreach(iterable, (curr):{
            acc := fn(acc, curr)
        })
        acc
    }
    curry(reduce)
}

var compose (fn1, fn2, fns...):{
    var compose (fn1, fn2):{
        fn1
        fn2
        (x):{fn2(fn1(x))}
    }
    reduce(fn1, compose, List(fn2, fns...))
}

var |> (input, fn):{
    fn(input)
}

var >> {
    var rightshift >> -- builtin

    var >> (arg1, arg2, args...):{
        tern($type(arg1) == 'Lambda, compose(arg1, arg2, args...), {
            "special case, for conveniency"
            tern($type(arg1) == '$nil && $#varargs == 0, arg2, {
                rightshift(arg1, arg2, args...)
            })
        })
    }
    >>
}

var sort {
    var List::sort _
    List::sort := (precedes?, list):{
        tern(len(list) < 2, list, {
            var mid list[#1]
            var left list[#2..-1] |> filter((x):{precedes?(x, mid)})
            var right list[#2..-1] |> filter((x):{not(precedes?(x, mid))})
            List::sort(precedes?, left) + [mid] + List::sort(precedes?, right)
        })
    }

    var Str::sort _
    Str::sort := (precedes?, str):{
        tern(len(str) < 2, str, {
            var mid str[#1]
            var left str[#2..-1] |> filter((x):{precedes?(x, mid)})
            var right str[#2..-1] |> filter((x):{not(precedes?(x, mid))})
            Str::sort(precedes?, left) + mid + Str::sort(precedes?, right)
        })
    }

    var sort (precedes?, container):{
        tern($type(container) == 'Str, Str::sort(precedes?, container), {
            List::sort(precedes?, container)
        })
    }
    curry(sort)
}

var lower? (c):{
    c in 'a .. 'z
}

var upper (OUT c):{
    len(Str(c)) == 1 || die("more than 1 char")
    !tern(lower?(c), c, {
        var res Byte(c) - (Byte('a) - Byte('A))
        c := res
        res
    })
}

"The quick brown fox jumps over the lazy dog" |> {
    var remove_spaces {
        filter((c):{c <> " "})
    }

    var remove_dup {
        reduce("", (lhs, rhs):{
            tern(rhs in lhs, lhs, lhs + rhs)
        })
    }

    var uppercase {
        map(upper)
    }

    var fn _
    fn >>= remove_spaces
    fn >>= uppercase
    fn >>= remove_dup
    fn >>= sort(<)
    fn >>= print
    fn
}
