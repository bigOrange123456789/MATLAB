m=Mesh("man")
p=0.005
m.simplify(p)
m.write("man"+p+"_save",m.V,m.F);
