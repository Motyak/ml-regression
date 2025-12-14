
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

'========================================

var Set (elems...):{
    var map [:]
    foreach(List(elems...), (elem):{map[elem] := _})
    var res []
    foreach([] + map, (pair):{res += [pair[#1]]})
    res
}

var Set! (val):{
    $type(val) == 'List || die("not a Set")
    var list val
    var map [:]
    foreach(list, (elem):{map[elem] := _})
    len(map) == len(list) || die("not a Set")
    ;
}

var print_set (set):{
    Set!(set)
    print(set)
}

-- print_set([1, 2, 3, 3])
print_set(Set(1, 2, 3, 3))
