function  I = qtrapz(f,a,b)

F    = functions(f);
xi   = F.workspace{1}.xi;
fi   = F.workspace{1}.fi;
I    = trapz(xi,fi);
