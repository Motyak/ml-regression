
```
    A132343 Output of Knuth's "man or boy" test for varying k.
    https://oeis.org/A132343

    Original (ALGOL 60): ```
        begin
            real procedure A(k, x1, x2, x3, x4, x5);
            value k; integer k;
            real x1, x2, x3, x4, x5;
            begin
                real procedure B;
                begin k := k - 1;
                    B := A := A(k, B, x1, x2, x3, x4)
                end;
                if k ≤ 0 then A := x4 + x5 else B
            end;
            outreal(1, A(10, 1, -1, -1, 1, 0))
        end
    ```

    C++ version (which i used for Monlang translation): ```
        #include <functional>
        #include <iostream>
        using cf = std::function<int()>;
        int A(int k, cf x1, cf x2, cf x3, cf x4, cf x5)
        {
            int Aval;
            cf B = [&]()
            {
                int Bval;
                --k;
                Bval = Aval = A(k, B, x1, x2, x3, x4);
                return Bval;
            };
            if (k <= 0) Aval = x4() + x5(); else B();
            return Aval;
        }
        cf I(int n) { return [=](){ return n; }; }
        int main()
        {
            for (int n=0; n<10; ++n)
                std::cout << A(n, I(1), I(-1), I(-1), I(1), I(0)) << ", ";
            std::cout << std::endl;
        } // translation of Knuth's code, Eric M. Schmidt, Jul 20 2013
    ```
```

var tern (cond, if_true, if_false):{
    var res _
    cond && {res := if_true}
    cond || {res := if_false}
    res
}

var !tern (cond, if_false, if_true):{
    tern(cond, if_true, if_false)
}

var <= (a, b):{
    a > b == $false
}

var A _
A := (k, x1, x2, x3, x4, x5):{
    var Aval _
    var B _
    B := ():{
        var Bval _
        k += -1
        Aval := A(k, B, x1, x2, x3, x4)
        Bval := Aval
        Bval
    }
    !tern(k <= 0, B(), {
        Aval := x4() + x5()
        Aval
    })
}

var I (n):{
    var fn ():{n}
    fn
}

"main, calculating from k=0 to k=10"
{
    var k 0
    var loop _
    loop := ():{
        k <= 10 && {
            var res A(k, I(1), I(-1), I(-1), I(1), I(0))
            print(k, "=>", res)
            k += 1
            loop()
        }
    }
    loop()
}
