
var tern (cond, if_true, if_false):{
    var res _
    cond && {res := if_true}
    cond || {res := if_false}
    res
}

var even? _
var odd? _
{
    even? := (n):{
        tern(n == 0, $true, {
            odd?(n) == $false
        })
    }

    odd? := (n):{
        even?(n + -1)
    }
}

var res {
    even?(100)
}
print(res)
