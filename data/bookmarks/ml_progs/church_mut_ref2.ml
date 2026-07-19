
var cons (OUT x, OUT y):{
    -- x
    -- y
    var fn (m):{
        m(x, y, (n):{x := n}, (n):{y := n})
    }
    fn
}

var car (pair):{
    pair((a, d, sa, sd):{a})
}

var cdr (pair):{
    pair((a, d, sa, sd):{d})
}

var set-car (pair, val):{
    pair((a, d, sa, sd):{sa})(val)
}

var set-cdr (pair, val):{
    pair((a, d, sa, sd):{sd})(val)
}

var right 37

var pair cons(die("uninitialized"), &right)

set-car(pair, 13) -- "comment this to trigger error"
print(car(pair))
print(cdr(pair))

print("---")

right := 123
print(cdr(pair))

print("---")

set-cdr(pair, 333)
print(cdr(pair))
print(right)
