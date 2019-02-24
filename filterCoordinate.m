function value = filterCoordinate(c,m)
if c < 0
    value = 0;
else if c > m
        value= m;
    else
		value= c;
    end
end