
var input slurpfile($srcname)

var key "motyak"
var key' key * (len(input) // len(key) + 1)

var nth 1
var loop _
loop := ():{
    nth > len(input) || {
        input[#nth] := Byte(input[#nth]) ^ key'[#nth]
        nth += 1
        _ := loop()
    }
}
loop()

nth := 1
-- loop()

print(input)
