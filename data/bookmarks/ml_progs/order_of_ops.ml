
var || (a, b):{
    print("entering ||()")
    ||(a, b)
}

var > (a, b):{
    print("entering >()")
    >(a, b)
}

var == (a, b):{
    print("entering ==()")
    ==(a, b)
}

var >= (a, b):{
    print("entering >=()")
    a > b || a == b
}

var id (x):{
    print("evaluating " + x)
    x
}

-- id(10) >= id(7)
id(10) >= id(100)
-- die() >= id(7)
