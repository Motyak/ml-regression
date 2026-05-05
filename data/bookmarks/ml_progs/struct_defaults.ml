
type MyList List
type MyMap Map

struct Fds {}

struct MyStruct {
    Bool _bool
    Byte _byte
    Int _int
    Float _float
    Str _str
    List _list
    Map _map
    Lambda _lambda
    MyList _mylist
    Fds _fds
    _ _any
}

var mystruct MyStruct()
-- mystruct._any := 'fds
-- mystruct._any := 123

print("_bool", mystruct._bool)
print("_byte", mystruct._byte)
print("_int", mystruct._int)
print("_float", mystruct._float)
print("_str", mystruct._str)
print("_list", mystruct._list)
print("_map", mystruct._map)
print("_lambda", mystruct._lambda)
print("_mylist", mystruct._mylist)
print("_fds", mystruct._fds)
print("_any", mystruct._any)
