"=== mlp: BEGIN ./std/cond.mlp ================================================"

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

```
    tern should ALWAYS be considered before
    deciding to use a CaseAnalysis,
    as tern is easier to read and suits most situtations.

    On the other hand, CaseAnalysis is very powerful but
    require you to define an additional variable
    (two of them if you need to store a result)
```
var CaseAnalysis ():{
    var end $false
    var fn (cond, do):{
        end == $nil && {
            die("additional case succeeding a fallthrough case")
        }
        end ||= cond && {
            _ := do
            $true
        }
        "NOTE: don't eval cond if end"
        end == $false && cond == $nil && {
            _ := do
            end := $nil
        }
        ;
    }
    fn
}

"=== mlp: END ./std/cond.mlp (finally back to std.mlp) ========================"

"=== mlp: BEGIN ./std/loops.mlp ==============================================="

var while (cond, do):{
    var loop _
    loop := ():{
        cond() && {
            do()
            _ := loop()
        }
        ;
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
        ;
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

var foreach (OUT container, fn):{
    var nth 1
    until(():{nth > len(container)}, ():{
        fn(&container[#nth])
        nth += 1
    })
    container
}

"=== mlp: END ./std/loops.mlp (finally back to std.mlp) ======================="
"=== mlp: BEGIN ./std/Iterator.mlp ============================================"


"=== mlp: BEGIN ./std/Optional.mlp ============================================"


var Optional (some?, val):{
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

var none? (opt):{
    opt('none?)()
}

var some (opt):{
    opt('some)()
}

"=== mlp: END ./std/Optional.mlp (back to ./std/Iterator.mlp) ================="
"=== mlp: BEGIN ./std/LazyList.mlp ============================================"


"=== PAIR ============================="

var Pair (left, right):{
    var selector (op):{
        tern(op == 'left, left, {
            tern(op == 'right, right, {
                die("unknown Pair operation: `" + op + "`")
            })
        })
    }
    selector
}

var left (pair):{
    pair('left)
}

var right (pair):{
    pair('right)
}

"=== LAZYLIST ========================="

var Pair? (left, right):{
    Optional($true, Pair(left, right))
}

var END {
    Optional($false, _)
}

var LazyList {
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

"=== mlp: END ./std/LazyList.mlp (back to ./std/Iterator.mlp) ================="

var Some (x):{
    Optional($true, x)
}

var Iterator (subscriptable):{
    var Iterator (container):{
        container
        var nth 1
        var next (peek?):{
            tern(nth > len(container), END, {
                var res container[#nth]
                peek? || {nth += 1}
                Some(res)
            })
        }
        next
    }

    var Iterator::fromStream (stream):{
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
        next
    }

    var lambda? (x):{
        $type(x) == 'Lambda
    }
    
    var next {
        !tern(lambda?(subscriptable), Iterator(subscriptable), {
            Iterator::fromStream(subscriptable)
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

var ArgIterator (args...):{
    Iterator(LazyList(args...))
}

var SeqIterator (init, stop?, update):{
    var curr init

    var peek ():{
        Some(curr)
    }

    var next _
    next := ():{
        peek := ():{
            tern(stop?(curr), END, Some(curr))
        }
        next := ():{
            tern(stop?(curr), END, {
                update(&curr)
                Some(curr)
            })
        }
        Some(curr)
    }

    var dispatcher (op):{
        tern(op == 'peek, peek, {
            tern(op == 'next, next, {
                die("unknown SeqIterator operation: `" + op + "`")
            })
        })
    }
    dispatcher
}

var RangeIterator<= (from, to):{
    {
        "accepts as input Int, Char or Str"
        var str? (x):{
            $type(x) == 'Str
        }
        var charInputs? {
            var charInputs? $true
            charInputs? &&= str?(from) && len(from) == 1
            charInputs? &&= str?(to) && len(to) == 1
            charInputs?
        }
        from := tern(charInputs?, Char, Int)(from)
        to := tern(charInputs?, Char, Int)(to)
    }
    var >= (a, b):{
        a > b || a == b
    }
    var RangeIterator<= {
        var i from
        var stop? (i):{i >= to}
        var update (i):{i += 1}
        SeqIterator(i, stop?, update)
    }
    RangeIterator<=
}

var peek (iterator):{
    iterator('peek)()
}

var next (iterator):{
    iterator('next)()
}

-- augment foreach() from loops.mlp
{
    var Container::foreach foreach

    foreach := (OUT iterable, fn):{
        var Iterator::foreach (iterator, fn):{
            var curr next(iterator)
            until(():{none?(curr)}, ():{
                fn(some(curr))
                curr := next(iterator)
            })
        }

        var lambda? (x):{
            $type(x) == 'Lambda
        }
        tern(lambda?(iterable), Iterator::foreach(iterable, fn), {
            Container::foreach(&iterable, fn)
        })
    }
}

"=== mlp: END ./std/Iterator.mlp (finally back to std.mlp) ===================="


"=== mlp: BEGIN ./std/op.mlp =================================================="


var .. RangeIterator<=


var <> (a, b, varargs...):{
    not(==(a, b, varargs...))
}

var < (a, b, varargs...):{
    var otherArgs ArgIterator(b, varargs...)

    var ge $false
    var lhs a
    var rhs next(otherArgs)
    do_until(():{
        var rhs' some(rhs)
        tern(lhs > rhs' || lhs == rhs', {ge := $true}, {
            lhs := rhs'
            rhs := next(otherArgs)
        })
    }, ():{ge || none?(rhs)})

    not(ge)
}

var <= (a, b, varargs...):{
    var otherArgs ArgIterator(b, varargs...)

    var gt $false
    var lhs a
    var rhs next(otherArgs)
    do_until(():{
        var rhs' some(rhs)
        tern(lhs > rhs', {gt := $true}, {
            lhs := rhs'
            rhs := next(otherArgs)
        })
    }, ():{gt || none?(rhs)})

    not(gt)
}

var >= (a, b, varargs...):{
    var otherArgs ArgIterator(b, varargs...)

    var lt $false
    var lhs a
    var rhs next(otherArgs)
    do_until(():{
        var rhs' some(rhs)
        !tern(lhs > rhs' || lhs == rhs', {lt := $true}, {
            lhs := rhs'
            rhs := next(otherArgs)
        })
    }, ():{lt || none?(rhs)})

    not(lt)
}

var - {
    var neg (x):{
        x + x * -2
    }

    var sub (a, b, varargs...):{
        var otherArgs ArgIterator(b, varargs...)

        var lhs a
        var rhs next(otherArgs)
        do_until(():{
            var rhs' some(rhs)
            lhs := lhs + neg(rhs')
            rhs := next(otherArgs)
        }, ():{none?(rhs)})

        lhs
    }

    var - (x, xs...):{
        tern($#varargs == 0, neg(x), {
            sub(x, xs...)
        })
    }

    -
}

var in (elem, iterable):{
    var in (elem, container):{
        var i 1
        var found $false
        until(():{found || i > len(container)}, ():{
            found ||= container[#i] == elem
            i += 1
        })
        found
    }

    var Iterator::in (elem, iterator):{
        var found $false
        var curr next(iterator)
        until(():{found || none?(curr)}, ():{
            tern(elem == some(curr), {found := $true}, {
                curr := next(iterator)
            })
        })
        found
    }

    var lambda? (x):{
        $type(x) == 'Lambda
    }
    !tern(lambda?(iterable), in(elem, iterable), {
        Iterator::in(elem, iterable)
    })
}

"=== mlp: END ./std/op.mlp (finally back to std.mlp) =========================="

```
    perform side-effects based on conditions..
    ..and/or order of execution
```

var perform {
    var keywords ['begin, 'end, 'all, '!all, 'none, '!none]

    var perform (side-effects, input):{
        var key (nth):{
            side-effects[#nth][#1]
        }
        var val (nth):{
            side-effects[#nth][#2]
        }

        var map [:] | side-effects
        var eval (side-effect):{
            map[side-effect]? && map[side-effect](input)
            ;
        }

        var nth 1
        var all $true
        var none $true

        eval('begin)

        ; first iteration for non-keywords
        while(():{nth < len(side-effects)}, ():{
            tern(key(nth) in keywords, {nth += 1}, {
                var pred val(nth)
                nth += 1

                key(nth) in keywords && die("non-keywords must be passed as pairs; the predicate then the associated side-effect")
                var side-effect val(nth)
                nth += 1

                !tern(pred(input), {all &&= $false}, {
                    none &&= $false
                    side-effect()
                })
            })
        })

        nth == len(side-effects) && die("trailing isolated non-keyword")
        nth := 1

        ; second iteration for keywords
        while(():{nth <= len(side-effects)}, ():{
            key(nth) in keywords && {
                var keyword key(nth)
                var case CaseAnalysis()
                case(keyword == 'all, {
                    all && map['all](input)
                })
                case(keyword == '!all, {
                    not(all) && map['!all](input)
                })
                case(keyword == 'none, {
                    none && map['none](input)
                })
                case(keyword == '!none, {
                    not(none) && map['!none](input)
                })
                case(keyword in ['begin, 'end], {
                    ; dealt separately
                })
                case(_, die("bug"))
            }
            nth += 1
        })

        eval('end)
    }

    perform
}

var side-effects [
    ['begin, (i):{putstr(Str(i) + " -> ")}]
    ['end, (_):{print()}]

    ['all, (_):{;}]
    ['!all, (_):{;}]
    ['none, (i):{putstr(i)}]
    ['!none, (_):{;}]

    ['foo?, (x):{x % 5 == 0}]
    ['foo, ():{putstr("Foo")}]

    ['bar?, (x):{x % 7 == 0}]
    ['bar, ():{putstr("Bar")}]
]

foreach(1 .. 200, (i):{
    perform(side-effects, i)
})
