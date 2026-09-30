
var for (from, to, do):{
    var nth from
    var loop _
    loop := ():{
        nth > to || {
            do(nth)
            nth += 1
            _ := loop()
        }
    }
    loop()
}

var .. (from, to):{
    var res []
    for(from, to, (nth):{
        res += [nth]
    })
    res
}

var zip (list1, list2):{
    var res [:]
    for(1, len(list1), (nth):{
        res[list1[#nth]] := list2[#nth]
    })
    res
}

var enumerate (list):{
    zip(0 .. len(list) + -1, list)
}

var map enumerate([
    'fds
    'sdf
    'aaaa
])

var print (xs...):{
    print(+("", xs...))
}

for(0, 7, (nth):{
    print(nth, " => ", map[nth % len(map)])
})
