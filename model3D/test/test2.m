function test2()
[v,f]=objRead("man");
[ v,f] = simplification2( v,f,0.3 );
objWrite("result",v,f);
end