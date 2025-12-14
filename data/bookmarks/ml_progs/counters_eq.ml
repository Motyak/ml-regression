

var create-counter ():{
    var i 0
    var counter ():{
        i += 1
        i
    }
    counter
}

var c1 create-counter()
var c2 create-counter()
var c3 c1

print('c1, c1())
print('c1, c1())
print('c2, c2())
print('c3, c3())
print('c1, c1())
print('c2, c2())

print("c1 == c2", c1 == c2)
print("c2 == c3", c2 == c3)
print("c1 == c3", c1 == c3)
