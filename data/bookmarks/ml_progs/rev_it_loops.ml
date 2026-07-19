
var list ["women", "love", "men"]

{
    var first_it? $true
    var nth 1
    var loop _
    loop := ():{
        nth > len(list) || {
            first_it? || putstr(" ")
            putstr(list[#nth])
            nth += 1
            first_it? := $false
            _ := loop()
        }
        putstr(",\n")
    }
    loop()
}

{
    var first_it? $true
    var nth len(list)
    var loop _
    loop := ():{
        nth == 0 || {
            first_it? || putstr(" ")
            putstr(list[#nth])
            nth += -1
            first_it? := $false
            _ := loop()
        }
        putstr(".\n")
    }
    loop()
}
