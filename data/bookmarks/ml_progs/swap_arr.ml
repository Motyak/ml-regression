
var swap (OUT a, OUT b):{
    var tmp a
    a := b
    b := tmp
}

var arr [3, 2, 1]
var i 1

print(arr, i)

{
    var i' i
    -- swap(&arr[#i'], &i)
    swap(&i, &arr[#i'])
}

print(arr, i)
