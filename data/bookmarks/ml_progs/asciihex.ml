
var tern (cond, if_true, if_false):{
    var res _
    cond && {res := if_true}
    cond || {res := if_false}
    res
}

```
    constructs a Range object
    that returns a List when called without arg
```
var .. {
    var char? (x):{
        $type(x) == 'Str && len(x) == 1
    }

    var .. (from, to):{
        var charInputs? {
            char?(from) && char?(to)
        }

        "setup params"
        {
            from := tern(charInputs?, Char, Int)(from)
            to := tern(charInputs?, Char, Int)(to)
        }

        "build the res list using loop"
        var res []
        {
            let curr from
            var loop _
            loop := ():{
                curr > to || {
                    res += [curr]
                    charInputs? && {res[#-1] := Str(res[#-1])}
                    curr += 1
                    loop()
                }
            }
            loop()
        }

        ():{res}
    }
    ..
}

```
    shadows List() so that passing a single Lambda arg..
    ..pulls the list out of the range object
```
var List {
    var List-1 (arg):{
        tern($type(arg) == 'Lambda, arg(), {
            "non-lambda arg => fallback to original List()"
            List(arg)
        })
    }

    var List (args...):{
        tern($#varargs == 1, List-1(args...), {
            "handle 2+ args => fallback to original List()"
            List(args...)
        })
    }
    List
}

var as_hex {
    var hex {
        List(0 .. 9) + List('A .. 'F)
    }

    var as_hex (byte):{
        var i byte / 16 + 1
        var j byte % 16 + 1
        "0x" + hex[#i] + hex[#j]
    }
    as_hex
}

var i Byte(0)
var loop _
loop := ():{
    print(i, as_hex(i), "`" + Char(i) + "`")
    i += 1
    i == 0 || loop()
}

loop()
