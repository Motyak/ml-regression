var not (bool):{
    ==($false, bool)
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

var foreach (OUT container, fn):{
    var nth 1
    until(():{nth > len(container)}, (_):{
        fn(&container[#nth])
        nth += 1
    })
    container
}

var curry (fn, args...):{
    var requiredArgs len(fn)
    var curried _
    curried := (args...):{
        tern($#varargs >= requiredArgs, fn(args...), {
            (args2...):{curried(args..., args2...)}
        })
    }
    curried
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

var |> (input, fn):{
    fn(input)
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

[3, 1, 4, 15, 9, 2, 6, 5, 35, 8, 97] |> sort(<) |> print
[3, 1, 4, 15, 9, 2, 6, 5, 35, 8, 97] |> sort(>) |> print

"Salut les amis." |> sort(<) |> print
"Salut les amis." |> sort(>) |> print
