
var gt >
var lt (a, b):{
    (a > b || a == b) == $false
}
var >= (a, b):{
    a > b || a == b
}
var <= (a, b):{
    a > b == $false
}

var > (x, _):{print(x)}
"Hello, world!" > stdout
gt(1, 2) > stdout
gt(2, 2) > stdout
gt(3, 2) > stdout


var < (fn, file):{
    fn(slurpfile(file))
}
len < $srcname > stdout
lt(1, 2) > stdout
lt(2, 2) > stdout
lt(3, 2) > stdout
