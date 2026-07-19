
var >= (a, b):{
    a > b || a == b
}

enum LogLevel {
    NONE = 0

    ERROR = 1
    WARNING = 2
    INFO = 3
    DEBUG = 4

    ALL = 9999
}

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
