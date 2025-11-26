


var n 0

var loop1 _

var loop2 ():{
    n == 10000 || {
        n += 1
        print(n)
        loop1()
    }
}

loop1 := ():{
    n == 10000 || {
        n += 1
        -- print(n)
        _ := loop2()
    }
}

loop1()
