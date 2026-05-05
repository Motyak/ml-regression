
var - (a, b):{
    a + b + b * -2
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

var input 20
var fact _
fact := {
    var n input
    var res n
    ():{
        n >= 3 && {
            n -= 1
            res *= n
            _ := fact()
        }
        tern(input == 0, 1, {
            res
        })
    }
}

var res fact()
print(res)
