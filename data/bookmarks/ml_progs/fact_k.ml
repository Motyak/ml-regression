
var tern (cond, if_true, if_false):{
    var res _
    cond && {res := if_true}
    cond || {res := if_false}
    res
}

var fact _
fact := (n, k):{
    tern(n == 0, k(1), {
        fact(n + -1, (r):{k(n * r)})
    })
}

var n 4
-- var k (r):{n * r}
var k (r):{r}
var res fact(n, k)
print(res)
