
var tern (cond, if_true, if_false):{
    var res _
    cond && {res := if_true}
    cond || {res := if_false}
    res
}

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

var flatten (list):{
    var res []
    foreach(list, (x):{
        tern($type(x) == 'List, {res += x}, {
            res += [x]
        })
    })
    res
}

var res flatten([
    1
    []
    [2]
    [3, 4]
    [[], [1], [1, 2]]
])

print(res)
