
var cons (x, y):{
    x
    y
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

var pair cons(13, 37)
print(car(pair))
set-car(pair, 777)
print(car(pair))
