

var id (x):{
    print("eval: " + x)
    x
}

print(id(1) + id(2) * id(3))
print("---")
print(id(2) * id(3) + id(1))
