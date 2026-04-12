
var 2times (fn):{
    fn()
    fn()
}

{
    var saysomething _
    saysomething := ():{
        print("hello")
        saysomething := ():{
            print("goodbye")
        }
    }

    2times(saysomething) -- ```
        hello
        hello
    ```

    "now saysomething() has been overwritten"

    2times(saysomething) -- ```
        goodbye
        goodbye
    ```
}

print("=========================")

{
    var saysomething _
    saysomething := ():{
        print("hello")
        saysomething := ():{
            print("goodbye")
        }
    }

    "if we pass by ref, we don't have this behavior anymore"
    2times(&saysomething) -- ```
        hello
        goodbye
    ```
}
