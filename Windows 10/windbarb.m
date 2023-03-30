% function windbarb(x,y,spd,dir,scale,width,color)
%
% Draw wind barb given wind speed and direction on current plot.
% The size of the barb is scaled by the diagonal length of the plot.
% x=0.35;
% y=0.5;
% spd=90;
% dir=0;
% scale=0.2;
% width=2;
% color='b';
function windbarb(x,y,spd,dir,scale,width,color)


xm = get(gca,'XLim');
ym = get(gca,'YLim');

as = pbaspect;

ll = sqrt((xm(2)-xm(1))^2+(ym(2)-ym(1))^2);
l1 = ll * scale;
l2 = 0.5 * l1;

x0 = x;
y0 = y;

% (x,y) 0/1/3/5/7/9
if dir <= 90
    x1 = x0 + l1 * abs(sin(pi*dir/180)) * (xm(2)-xm(1))/ll;
    y1 = y0 + l1 * abs(cos(pi*dir/180)) * (ym(2)-ym(1))/ll * as(1)/as(2);
elseif dir <= 180
    x1 = x0 + l1 * abs(sin(pi*dir/180)) * (xm(2)-xm(1))/ll;
    y1 = y0 - l1 * abs(cos(pi*dir/180)) * (ym(2)-ym(1))/ll * as(1)/as(2);
elseif dir <= 270
    x1 = x0 - l1 * abs(sin(pi*dir/180)) * (xm(2)-xm(1))/ll;
    y1 = y0 - l1 * abs(cos(pi*dir/180)) * (ym(2)-ym(1))/ll * as(1)/as(2);
else
    x1 = x0 - l1 * abs(sin(pi*dir/180)) * (xm(2)-xm(1))/ll;
    y1 = y0 + l1 * abs(cos(pi*dir/180)) * (ym(2)-ym(1))/ll * as(1)/as(2);
end

x3 = x0 + 0.875 * (x1-x0);
y3 = y0 + 0.875 * (y1-y0);
x5 = x0 + 0.750 * (x1-x0);
y5 = y0 + 0.750 * (y1-y0);
x7 = x0 + 0.625 * (x1-x0);
y7 = y0 + 0.625 * (y1-y0);
x9 = x0 + 0.500 * (x1-x0);
y9 = y0 + 0.500 * (y1-y0);

% (x,y) 2/4/6/8/x
l3 = sqrt(l1^2+l2^2-2*l1*l2*cos(pi*(90+30)/180));
d1 = 180/pi*acos((l1^2+l3^2-l2^2)/2/l1/l3);

d0 = dir + d1;
if d0 > 360
    d0 = d0 - 360;
end

if d0 <= 90
    x2 = x0 + l3 * abs(sin(pi*d0/180)) * (xm(2)-xm(1))/ll;
    y2 = y0 + l3 * abs(cos(pi*d0/180)) * (ym(2)-ym(1))/ll * as(1)/as(2);
elseif d0 <= 180
    x2 = x0 + l3 * abs(sin(pi*d0/180)) * (xm(2)-xm(1))/ll;
    y2 = y0 - l3 * abs(cos(pi*d0/180)) * (ym(2)-ym(1))/ll * as(1)/as(2);
elseif d0 <= 270
    x2 = x0 - l3 * abs(sin(pi*d0/180)) * (xm(2)-xm(1))/ll;
    y2 = y0 - l3 * abs(cos(pi*d0/180)) * (ym(2)-ym(1))/ll * as(1)/as(2);
else
    x2 = x0 - l3 * abs(sin(pi*d0/180)) * (xm(2)-xm(1))/ll;
    y2 = y0 + l3 * abs(cos(pi*d0/180)) * (ym(2)-ym(1))/ll * as(1)/as(2);
end

x4 = x3 + (x2 - x1);
y4 = y3 + (y2 - y1);
x6 = x5 + (x2 - x1);
y6 = y5 + (y2 - y1);
x8 = x7 + (x2 - x1);
y8 = y7 + (y2 - y1);
xx = x9 + (x2 - x1);
yx = y9 + (y2 - y1);

try
        LINE_0=evalin('base','BARBS');
catch
    LINE_0=[];
end
% wind barb
LINE0=line([x0 x1],[y0 y1],'linewidth',width,'color',color);

if spd >= 90
    LINE1=line([x1 x2],[y1 y2],'linewidth',width,'color',color);
    LINE2=line([x2 x3],[y2 y3],'linewidth',width,'color',color);
    LINE3=line([x3 x4],[y3 y4],'linewidth',width,'color',color);
    LINE4=line([x5 x6],[y5 y6],'linewidth',width,'color',color);
    LINE5=line([x7 x8],[y7 y8],'linewidth',width,'color',color);
    LINE6=line([x9 xx],[y9 yx],'linewidth',width,'color',color);
    BARBS=[LINE_0;LINE0;LINE1;LINE2;LINE3;LINE4;LINE5;LINE6];
    
elseif spd >= 85
    LINE1=line([x1 x2],[y1 y2],'linewidth',width,'color',color);
    LINE2=line([x2 x3],[y2 y3],'linewidth',width,'color',color);
    LINE3=line([x3 x4],[y3 y4],'linewidth',width,'color',color);
    LINE4=line([x5 x6],[y5 y6],'linewidth',width,'color',color);
    LINE5=line([x7 x8],[y7 y8],'linewidth',width,'color',color);
    LINE6=line([x9 (xx+x9)/2],[y9 (yx+y9)/2],'linewidth',width,'color',color);
    BARBS=[LINE_0;LINE0;LINE1;LINE2;LINE3;LINE4;LINE5;LINE6]; 
elseif spd >= 80
    LINE1=line([x1 x2],[y1 y2],'linewidth',width,'color',color);
    LINE2=line([x2 x3],[y2 y3],'linewidth',width,'color',color);
    LINE3=line([x3 x4],[y3 y4],'linewidth',width,'color',color);
    LINE4=line([x5 x6],[y5 y6],'linewidth',width,'color',color);
    LINE5=line([x7 x8],[y7 y8],'linewidth',width,'color',color);
    BARBS=[LINE_0;LINE0;LINE1;LINE2;LINE3;LINE4;LINE5]; 
        
elseif spd >= 75
    LINE1=line([x1 x2],[y1 y2],'linewidth',width,'color',color);
    LINE2=line([x2 x3],[y2 y3],'linewidth',width,'color',color);
    LINE3=line([x3 x4],[y3 y4],'linewidth',width,'color',color);
    LINE4=line([x5 x6],[y5 y6],'linewidth',width,'color',color);
    LINE5=line([x7 (x8+x7)/2],[y7 (y8+y7)/2],'linewidth',width,'color',color);
    BARBS=[LINE_0;LINE0;LINE1;LINE2;LINE3;LINE4;LINE5]; 
    
elseif spd >= 70
    LINE1=line([x1 x2],[y1 y2],'linewidth',width,'color',color);
    LINE2=line([x2 x3],[y2 y3],'linewidth',width,'color',color);
    LINE3=line([x3 x4],[y3 y4],'linewidth',width,'color',color);
    LINE4=line([x5 x6],[y5 y6],'linewidth',width,'color',color);
    BARBS=[LINE_0;LINE0;LINE1;LINE2;LINE3;LINE4]; 
    
elseif spd >= 65
    LINE1=line([x1 x2],[y1 y2],'linewidth',width,'color',color);
    LINE2=line([x2 x3],[y2 y3],'linewidth',width,'color',color);
    LINE3=line([x3 x4],[y3 y4],'linewidth',width,'color',color);
    LINE4=line([x5 (x6+x5)/2],[y5 (y6+y5)/2],'linewidth',width,'color',color);
    BARBS=[LINE_0;LINE0;LINE1;LINE2;LINE3;LINE4]; 
    
elseif spd >= 60
    LINE1=line([x1 x2],[y1 y2],'linewidth',width,'color',color);
    LINE2=line([x2 x3],[y2 y3],'linewidth',width,'color',color);
    LINE3=line([x3 x4],[y3 y4],'linewidth',width,'color',color);
    BARBS=[LINE_0;LINE0;LINE1;LINE2;LINE3]; 
    
elseif spd >= 55
    LINE1=line([x1 x2],[y1 y2],'linewidth',width,'color',color);
    LINE2=line([x2 x3],[y2 y3],'linewidth',width,'color',color);
    LINE3=line([x3 (x4+x3)/2],[y3 (y4+y3)/2],'linewidth',width,'color',color);
    BARBS=[LINE_0;LINE0;LINE1;LINE2;LINE3]; 
    
elseif spd >= 50
    LINE1=line([x1 x2],[y1 y2],'linewidth',width,'color',color);
    LINE2=line([x2 x3],[y2 y3],'linewidth',width,'color',color);
    BARBS=[LINE_0;LINE0;LINE1;LINE2]; 
    
elseif spd >= 45
    LINE1=line([x1 x2],[y1 y2],'linewidth',width,'color',color);
    LINE2=line([x3 x4],[y3 y4],'linewidth',width,'color',color);
    LINE3=line([x5 x6],[y5 y6],'linewidth',width,'color',color);
    LINE4=line([x7 x8],[y7 y8],'linewidth',width,'color',color);
    LINE5=line([x9 (xx+x9)/2],[y9 (yx+y9)/2],'linewidth',width,'color',color);
    BARBS=[LINE_0;LINE0;LINE1;LINE2;LINE3;LINE4;LINE5]; 
    
elseif spd >= 40
    LINE1=line([x1 x2],[y1 y2],'linewidth',width,'color',color);
    LINE2=line([x3 x4],[y3 y4],'linewidth',width,'color',color);
    LINE3=line([x5 x6],[y5 y6],'linewidth',width,'color',color);
    LINE4=line([x7 x8],[y7 y8],'linewidth',width,'color',color);
    BARBS=[LINE_0;LINE0;LINE1;LINE2;LINE3;LINE4]; 
    
elseif spd >= 35
    LINE1=line([x1 x2],[y1 y2],'linewidth',width,'color',color);
    LINE2=line([x3 x4],[y3 y4],'linewidth',width,'color',color);
    LINE3=line([x5 x6],[y5 y6],'linewidth',width,'color',color);
    LINE4=line([x7 (x8+x7)/2],[y7 (y8+y7)/2],'linewidth',width,'color',color);
    BARBS=[LINE_0;LINE0;LINE1;LINE2;LINE3;LINE4]; 
    
elseif spd >= 30
    LINE1=line([x1 x2],[y1 y2],'linewidth',width,'color',color);
    LINE2=line([x3 x4],[y3 y4],'linewidth',width,'color',color);
    LINE3=line([x5 x6],[y5 y6],'linewidth',width,'color',color);
    BARBS=[LINE_0;LINE0;LINE1;LINE2;LINE3]; 
    
elseif spd >= 25
    LINE1=line([x1 x2],[y1 y2],'linewidth',width,'color',color);
    LINE2=line([x3 x4],[y3 y4],'linewidth',width,'color',color);
    LINE3=line([x5 (x6+x5)/2],[y5 (y6+y5)/2],'linewidth',width,'color',color);
    BARBS=[LINE_0;LINE0;LINE1;LINE2;LINE3]; 
    
elseif spd >= 20
    LINE1=line([x1 x2],[y1 y2],'linewidth',width,'color',color);
    LINE2=line([x3 x4],[y3 y4],'linewidth',width,'color',color);
    BARBS=[LINE_0;LINE0;LINE1;LINE2]; 
    
elseif spd >= 15
    LINE1=line([x1 x2],[y1 y2],'linewidth',width,'color',color);
    LINE2=line([x3 (x4+x3)/2],[y3 (y4+y3)/2],'linewidth',width,'color',color);
    BARBS=[LINE_0;LINE0;LINE1;LINE2]; 
    
elseif spd >= 10
    LINE1=line([x1 x2],[y1 y2],'linewidth',width,'color',color);
    BARBS=[LINE_0;LINE0;LINE1]; 
    
elseif spd >= 5
    LINE1=line([x1 (x2+x1)/2],[y1 (y2+y1)/2],'linewidth',width,'color',color);
    BARBS=[LINE_0;LINE0;LINE1]; 
    
else
    LINE1=line([x1 (x2+3*x1)/4],[y1 (y2+3*y1)/4],'linewidth',width,'color',color);
    BARBS=[LINE_0;LINE0;LINE1]; 
    
end
assignin('base','BARBS',BARBS);
