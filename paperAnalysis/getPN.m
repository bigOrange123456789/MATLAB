function [ y] = getPN( x1,x2,y1,y2 )
y=(y2-y1)*(30-x1)/(x2-x1)+y1;
