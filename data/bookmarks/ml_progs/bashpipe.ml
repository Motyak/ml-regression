

var fn1 (val):{
    print("fn1> BEGIN")
    print(val)
    print("fn1> END")
}

var fn2 ():{
    print("fn2> Computing fn2() ...")
    var res 123
    print("fn2> DONE")
    res
}

fn1(fn2()) -- ```
    similar to Bash `fn2 | fn1`
    ..in the sense that both "programs" (here functions)..
    ..are ran at the same time. The pipe completes..
    ..after all the functions returned (from left to right)
```

"we can mimic Bash pipe syntax with operator `|>`"
-- {
    "create an 'autocurry' version of fn1"
    var fn1 {
        "this is the function directly extracted from Monlang's std"
        var curry {
            var tern (cond, if_true, if_false):{
                var res _
                cond && {res := if_true}
                cond || {res := if_false}
                res
            }

            -- autocurries until the nb of required args has been reached
            var curry_required (requiredArgs, fn):{
                var >= (a, b):{
                    a > b || a == b
                }
                var - (a, b):{
                    a + b + b * -2
                }

                var curried _
                curried := (args...):{
                    tern($#varargs - requiredArgs >= 0, fn(args...), {
                        (args2...):{curried(args..., args2...)}
                    })
                }
                curried
            }

            -- calling curry on a function with no required argument..
            -- ..has no effect => use curry_required instead
            var curry (fn, args...):{
                curry_required(len(fn), fn)(args...)
            }

            curry
        }
        curry(fn1)
    }

    var |> (input, fn):{
        fn(input)
    }

    fn2() |> fn1()
}
