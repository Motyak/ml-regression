
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
    }
    loop()
}


type Range Lambda
var .. (from, to):{
    from is 'Str && {from := Byte(from)}
    to is 'Str && {to := Byte(to)}
    var dispatcher (msg):{
        tern(msg == 'from, from, {
            tern(msg == 'to, to, {
                die("unknown range msg: `" + msg + "`")
            })
        })
    }
    Range(dispatcher)
}

var foreach {
    var List/Str::foreach (OUT list, do):{
        var nth 1
        until(():{nth > len(list)}, ():{
            do(&list[#nth])
            nth += 1
        })
        list
    }

    var Map::foreach (OUT map, do):{
        var pairs [] + map
        List/Str::foreach(pairs, (pair):{
            var key pair[#1]
            do(key, &map[key])
        })
        map
    }

    var Range::foreach (range, fn):{
        var i range('from)
        var to range('to)
        until(():{i > to}, ():{
            fn(i)
            i += 1
        })
    }

    var foreach (container, do):{
        tern(container is 'Range, Range::foreach(container, do), {
            tern(container is 'Map, Map::foreach(&container, do), {
                List/Str::foreach(&container, do)
            })
        })
    }
    (foreach)
}

{
    var list []
    foreach(1 .. 10, (n):{list += [n]})
    print(list)
}

{
    var list [1, 2, 3]
    var list2 foreach(list, (x):{x += 1})
    print('list, list)
    print('list2, list2)

    foreach(&list, (x):{x += 1})
    print('list, list)
}

{
    var str "fds"
    var str2 foreach(str, (x):{x += 1})
    print('str, str)
    print('str2, str2)

    foreach(&str, (x):{x += 1})
    print('str, str)
}

{
    var map ['a:1, 'b:2]
    var map2 foreach(map, (k, v):{
        k == 'b && {v := 777}
    })
    print('map, map)
    print('map2, map2)

    foreach(&map, (k, v):{
        k == 'b && {v := 777}
    })
    print('map, map)
}
