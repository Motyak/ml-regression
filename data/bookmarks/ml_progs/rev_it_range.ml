
var - (n):{n + n * -2}
var .. List

var foreach (range, fn):{
    var i range[#1]
    var to range[#2]
    var loop _
    loop := ():{
        i > to || {
            fn(i)
            i += 1
            _ := loop()
        }
    }
    loop()
}

var list ["women", "love", "men"]

{
    var first_it $true
    foreach(1 .. len(list), (nth):{
        first_it || putstr(" ")
        putstr(list[#nth])
        first_it := $false
    })
    putstr(",\n")
}

{
    var first_it $true
    foreach(1 .. len(list), (nth):{
        var -nth -(nth)
        first_it || putstr(" ")
        putstr(list[#-nth])
        first_it := $false
    })
    putstr(",\n")
}
