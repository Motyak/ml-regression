

var until (cond, do):{
    var loop _
    loop := ():{
        cond() || {
            do()
            _ := loop()
        }
        ;
    }
    loop()
}

var foreach (OUT container, fn):{
    var nth 1
    until(():{nth > len(container)}, ():{
        fn(&container[#nth])
        nth += 1
    })
    container
}

var .. (a, b):{
    var res []
    until(():{a > b}, ():{
        res += [a]
        a += 1
    })
    res
}

var < (a, b):{
    (a > b || a == b) == $false
}

var >= (a, b):{
    a > b || a == b
}

var - (a, b):{
    a + b + b * -2
}

'===MAIN===

var swap (OUT a, OUT b):{
    var tmp a
    a := b
    b := tmp
}

var sort (OUT list):{
    len(list) >= 2 && {
        foreach(1 .. len(list) - 1, (start):{
            var min_index start
            var min list[#start]
            foreach(start + 1 .. len(list), (nth):{
                list[#nth] < min && {
                    min_index := nth
                    min := list[#nth]
                }
            })
            swap(&list[#start], &list[#min_index])
        })
        ;
    }
    list
}

var keys (map):{
    var res []
    foreach([] + map, (kv):{
        res += [kv[#1]]
    })
    res
}

var map [
    'a => [13, 2, 55, 54]
    'b => [3, 1, 2]
    'c => [2, 1]
]

foreach(keys(map), (key):{
    sort(&map[key])
})

print(map)
