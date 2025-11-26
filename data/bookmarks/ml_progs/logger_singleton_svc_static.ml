
var >= (a, b):{
    a > b || a == b
}

var LogLevel::NONE 0

var LogLevel::ERROR 1
var LogLevel::WARNING 2
var LogLevel::INFO 3
var LogLevel::DEBUG 4

var LogLevel::ALL 9999

var Log _
{
    let self Log
    self := [:]

    self['LEVEL] := LogLevel::INFO
    self['log] := print
    
    self['err] := (msg):{
        self.LEVEL >= LogLevel::ERROR && {
            self.log("ERR " + msg)
        }
    }

    self['warn] := (msg):{
        self.LEVEL >= LogLevel::WARNING && {
            self.log("WARN " + msg)
        }
    }

    self['info] := (msg):{
        self.LEVEL >= LogLevel::INFO && {
            self.log("INFO " + msg)
        }
    }

    self['debug] := (msg):{
        self.LEVEL >= LogLevel::DEBUG && {
            self.log("DEBUG " + msg)
        }
    }
}

Log.info("some msg")
Log.LEVEL := LogLevel::WARNING
Log.info("some msg")

var out ""
Log.log := (msg):{
    out += msg + "\n"
}

Log.err("some msg")
Log.info("some msg")
print("out: `" + out + "`")
