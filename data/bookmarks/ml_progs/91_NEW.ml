
var <> (a, b):{
    a == b == $false
}

var < (a, b):{
    (a > b || a == b) == $false
}

var - (a, b):{
    a + b + b * -2
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

var .. (i, to):{
    var res []
    until(():{i > to}, ():{
        res += [i]
        i += 1
    })
    res
}

var foreach (OUT list, do):{
    var nth 1
    until(():{nth > len(list)}, ():{
        list[#nth] := do(&list[#nth])
        nth += 1
    })
}

var filter (OUT list, pred):{
    var new_list []
    foreach(list, (x):{
        pred(x) && {
            new_list += [x]
        }
    })
    list := new_list
}

var res _

res := 1 .. 90
filter(&res, (n):{n // 10 + n % 10 < 10})
filter(&res, (n):{n % 10 <> 0})

-- foreach(&res, (n):{n * 11 - 1})
-- foreach(&res, (n):{(n + 1) * 999})
-- foreach(&res, (n):{n / 999'999})
-- foreach(&res, (n):{Str(n)[#3..8]})

print("" + len(res) + " element(s): " + res)
foreach(res, print)
