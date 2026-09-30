

var nth 1
var loop _
loop := ():{
    nth > 3 || {
        ; doit
        print("outer hello")
        {
            var nth 1
            var loop _
            loop := ():{
                nth > 2 || {
                    print("> inner hello")
                    nth += 1
                    _ := loop()
                }
            }
            loop()
        }
        nth += 1
        _ := loop()
    }
}
loop()
