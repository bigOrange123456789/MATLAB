function test2()
[v,f]=objRead("man3");

[ v,f] = simplification( v,f,0.5 );
objWrite("result",v,f);
end