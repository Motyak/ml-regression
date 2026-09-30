
var - (a, b):{
    a + b + b * -2
}

var >= (a, b):{
    a > b || a == b
}

var <= (a, b):{
    a > b == $false
}

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

var input slurpfile($srcname)

var nwhite 0
var nother 0
var ndigit [:]
for(0, 9, (i):{
    ndigit[i] := 0
})

for(1, len(input), (nth):{
    var c input[#nth]
    var last $false
    last ||= c >= '0 && c <= '9 && {
        ndigit[Int(c - Byte('0))] += 1
        $true
    }
    last ||= (c == " " || c == "\n") && {
        nwhite += 1
        $true
    }
    last ||= {
        nother += 1
        $true
    }
})

putstr("digits =")
for(0, 9, (i):{
    putstr(" " + ndigit[i])
})
print(", white space = " + nwhite + ", other = " + nother)
