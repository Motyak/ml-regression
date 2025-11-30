
var true (x, y):{x}
var false (x, y):{y}
var tern (cond, if_true, if_false):{
    cond(if_true, if_false)
}

var == {
    var tern (cond, if_true, if_false):{
        var res _
        cond && {res := if_true}
        cond || {res := if_false}
        res
    }

    var == (a, b):{
        tern(a == b, true, false)
    }
    ==
}

var res {
    tern(1 == 2, 10, 20)
}

print(res)
