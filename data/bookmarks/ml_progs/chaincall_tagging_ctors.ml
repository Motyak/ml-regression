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

"================================="

type UInt Int
{
    var tag UInt
    UInt := (n):{
        n > 0 || die("UInt")
        tag(n)
    }
}

type %2==0 Int
{
    var tag %2==0
    %2==0 := (n):{
        n % 2 == 0 || die("%2==0")
        tag(n)
    }
}

type MyType UInt %2==0
MyType := UInt >> %2==0 >> MyType

-- MyType(-3)
-- MyType(3)
var res MyType(2)

print(res)
print($type(res))

print(res is 'MyType)
print(res is 'UInt)
print(res is '%2==0)
print(res is 'Int)
print(res is 'Str)

print(Int(res))
