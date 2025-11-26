var tern (cond, if_true, if_false):{
    var res _
    cond && {res := if_true}
    cond || {res := if_false}
    res
}

var !tern (cond, if_false, if_true):{
    tern(cond, if_true, if_false)
}

var not (bool):{
    tern(bool, $false, $true)
}

var while (cond, do):{
    var loop _
    loop := ():{
        cond() && {
            do()
            _ := loop()
        }
    }
    loop()
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
}

var do_while (do, cond):{
    do()
    while(cond, do)
}

var do_until (do, cond):{
    do()
    until(cond, do)
}

var < (a, b):{
    (a > b || a == b) == $false
}

var <= (a, b):{
    a > b == $false
}

var <> (a, b):{
    a == b == $false
}

'===ITERATOR===

var Optional _
var none? _
var some _
{
    Optional := (some?, val):{
        var none? ():{
            not(some?)
        }
        var some ():{
            some? || {
                die("calling some() on empty Optional")
            }
            val
        }
        var dispatcher (op):{
            tern(op == 'none?, none?, {
                tern(op == 'some, some, {
                    die("unknown Optional operation: `" + op + "`")
                })
            })
        }
        dispatcher
    }

    none? := (opt):{
        opt('none?)()
    }

    some := (opt):{
        opt('some)()
    }
}

var Pair _
var left _
var right _
{
    Pair := (left, right):{
        var selector (op):{
            tern(op == 'left, left, {
                tern(op == 'right, right, {
                    die("unknown Pair operation: `" + op + "`")
                })
            })
        }
        selector
    }

    left := (pair):{
        pair('left)
    }

    right := (pair):{
        pair('right)
    }
}

var Pair? _
var END _
var LazyList _
{
    Pair? := (left, right):{
        Optional($true, Pair(left, right))
    }

    END := {
        Optional($false, _)
    }

    LazyList := {
        var LazyList-1+ _

        var LazyList (xs...):{
            tern($#varargs == 0, END, {
                LazyList-1+(xs...)
            })
        }

        LazyList-1+ := (x, xs...):{
            Pair?(x, LazyList(xs...))
        }

        LazyList
    }
}

var Some _
var Iterator _
var peek _
var next _
{
    Some := (x):{
        Optional($true, x)
    }

    Iterator := (stream):{
        stream
        var next (peek?):{
            tern(none?(stream), END, {
                var res left(some(stream))
                peek? || {
                    stream := right(some(stream))
                }
                Some(res)
            })
        }
        
        var dispatcher (op):{
            tern(op == 'next, ():{next(0)}, {
                tern(op == 'peek, ():{next(1)}, {
                    die("unknown iterator operation: `" + op + "`")
                })
            })
        }
        dispatcher
    }

    peek := (iterator):{
        iterator('peek)()
    }

    next := (iterator):{
        iterator('next)()
    }
}

var ArgIterator (args...):{
    Iterator(LazyList(args...))
}

var all {
    var List::all (unary_pred, list):{
        var all $true
        var nth 1
        while(():{all && nth <= len(list)}, ():{
            unary_pred(list[#nth]) || {
                all := $false
            }
            nth += 1
        })
        all
    }

    var List::all' (binary_pred, list):{
        tern(len(list) < 2, $true, {
            var all $true
            var nth 2
            var lhs list[#1]
            do_while(():{
                binary_pred(lhs, list[#nth]) || {
                    all := $false
                }
                lhs := list[#nth]
                nth += 1
            }, ():{all && nth <= len(list)})
            all
        })
    }

    var Iterator::all (unary_pred, it):{
        var any_false $false
        var curr next(it)
        until(():{any_false || none?(curr)}, ():{
            !tern(unary_pred(some(curr)), {any_false := $true}, {
                curr := next(it)
            })
        })
        not(any_false)
    }

    var Iterator::all' (binary_pred, it):{
        var any_false $false
        var curr next(it)
        var lhs {
            !tern(none?(curr), some(curr), {
                die("iterator needs at least 2 elements")
            })
        }
        curr := next(it)
        none?(curr) && {
            die("iterator needs at least 2 elements")
        }
        do_until(():{
            !tern(binary_pred(lhs, some(curr)), {any_false := $true}, {
                lhs := some(curr)
                curr := next(it)
            })
        }, ():{any_false || none?(curr)})
        not(any_false)
    }

    var dispatch [
        0b00 => List::all
        0b01 => List::all'
        0b10 => Iterator::all
        0b11 => Iterator::all'
    ]

    var all (pred, iterable):{
        var all dispatch[(Int($type(iterable) <> 'List) << 1) + Int(len(pred) == 2)]
        all(pred, iterable)
    }

    all
}



'===MAIN===

var even? (n):{
    print("evaluating even?(" + n + ")")
    n % 2 == 0
}

var == (a, b):{
    print("evaluating ==(" + a + ", " + b + ")")
    a == b
}

-- {
    -- var res List::all(even?, [1, 2, 2])
    var res all(even?, [1, 2, 2])
    print(res)
}

-- {
    -- var res List::all'(==, [1, 2, 1])
    var res all(==, [1, 2, 1])
    print(res)
}

var id (x):{
    print("evaluating " + x)
    x
}

-- {
    -- var res Iterator::all(even?, ArgIterator(1, id(4), 6))
    var res all(even?, ArgIterator(1, id(4), 6))
    print(res)
}

{
    -- var res Iterator::all'(==, ArgIterator(1, 2, id(3)))
    var res all(==, ArgIterator(1, 2, id(3)))
    print(res)
}
