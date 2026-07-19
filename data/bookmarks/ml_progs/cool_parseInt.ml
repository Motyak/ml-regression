
var <= (a, b):{
    a > b == $false
}

var >= (a, b):{
    a > b || a == b
}

var tern (cond, if_true, if_false):{
    var res _
    cond && {res := if_true}
    cond || {res := if_false}
    res
}

var until (cond, do):{
    var loop _
    loop := ():{
        cond() || {
            do()
            _ := loop()
        }
    }
    loop()
    ;
}

var foreach {
    var List/Str::foreach (OUT container, fn):{
        var nth 1
        until(():{nth > len(container)}, ():{
            fn(&container[#nth])
            nth += 1
        })
        container
    }

    var Map::foreach (OUT map, fn):{
        var pairs [] + map
        List/Str::foreach(pairs, (pair):{
            var key pair[#1]
            fn(key, &map[key])
        })
        map
    }

    var Range::foreach (range, fn):{
        var i range('from)
        var to range('to)
        until(():{i > to}, ():{
            fn(i)
            i += 1
        })
    }

    var foreach (iterable, fn):{
        tern(iterable is 'Range, Range::foreach(iterable, fn), {
            tern(iterable is 'Map, Map::foreach(&iterable, fn), {
                List/Str::foreach(&iterable, fn)
            })
        })
    }
    (foreach)
}

var in {
    var Container::in (elem, container):{
        var nth 1
        var found $false
        until(():{found || nth > len(container)}, ():{
            found := container[#nth] == elem
            nth += 1
        })
        found
    }

    var Range::in (elem, range):{
        elem >= range('from) && elem <= range('to)
    }

    var in (elem, iterable):{
        tern(iterable is 'Range, Range::in(elem, iterable), {
            Container::in(elem, iterable)
        })
    }

    in
}

var !in (elem, container):{
    elem in container == $false
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

type Range Lambda
var .. (from, to):{
    from is 'Str && {from := Byte(from)}
    to is 'Str && {to := Byte(to)}
    var dispatcher (msg):{
        tern(msg == 'from, from, {
            tern(msg == 'to, to, {
                die("unknown range msg: `" + msg + "`")
            })
        })
    }
    Range(dispatcher)
}

var apply {
    var apply (fn, args):{
        var acc curry_required(len(args), fn)
        var nth 1
        var loop _
        loop := ():{
            nth > len(args) || {
                var x args[#nth]
                acc := acc(x)
                nth += 1
                _ := loop()
            }
        }
        loop()
        acc
    }
    curry(apply)
}

var parseInt (OUT str):{
    var acc []
    until(():{len(str) == 0 || str[#1] !in '0 .. '9}, ():{
        foreach(&acc, (n):{n *= 10})
        acc += [Int(str[#1] - Byte("0"))]
        str := tern(len(str) == 1, "", str[#2..-1])
    })
    apply(+, acc)
}

var str "123,321"
-- var str "9223372036854775807"

var int parseInt(&str)

print($type(str), str)
print($type(int), int)
