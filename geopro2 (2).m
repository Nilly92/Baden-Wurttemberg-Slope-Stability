clc
clear all
close all 


data= dir('BadenWuerttemberg5m\*.tif');

% Extract numbers from file names to have a frame of Baden Wurttemberg

namedata=extractfield(data,'name');
xnumbernames=cellfun(@(f) f(2:4),namedata,'UniformOutput',false);
ynumbernames=cellfun(@(f) f(6:8),namedata,'UniformOutput',false);
x=cellfun(@str2double,xnumbernames).*1e3; 
y=cellfun(@str2double,ynumbernames).*1e3;
fig1=figure(1);
plot(x,y,'.')
axis equal
xlabel('x[m]')
ylabel('y[m]')

hold on

%%
t=0;
k=1;
while k<9
    
    % Replace Squares along with soil parameters for giving area
    % Area A,B,and C are not considered
 
    if k==1 % Area G
     sqrx= [4e5 4.5e5 4.5e5 4e5];
     sqry= [3e5 3e5+t 3.5e5 3.5e5];
     ht=patch(sqrx,sqry,'r'); 
     rhog = 19; % [kN/m^3 ]
     phi  = 37; % [?]
     c    = 0;  % [kN/m^2 ]    
    elseif k==2 %Area H
    sqrx= [4.5e5 4.5e5 5e5+t 5e5+t];
    sqry= [3e5+t 3.5e5+t 3.5e5+t 3e5+t];
    ht=patch(sqrx,sqry,'b');
     rhog = 20;   % [kN/m^3 ]
     phi  = 22.5; % [?]
     c    = 5;    % [kN/m^2 ]
%     elseif k==3 %Area C
%     sqrx= [5e5 5e5 5.7e5 5.7e5];
%     sqry= [4e5 4.5e5 4.5e5 4e5];
%     ht=patch(sqrx,sqry,'k');
    elseif k== 4 %Area E ___
    sqrx= [4.5e5 4.5e5 5e5 5e5];
    sqry= [3.5e5 4e5 4e5 3.5e5 ];
    ht=patch(sqrx,sqry,'g');      
    rhog = 20; % [kN/m^3 ]
    phi  = 30; % [?]
    c    = 5;  % [kN/m^2 ]
    elseif k==5 % Area I
    sqrx= [5e5 5e5 5.7e5 5.7e5];
    sqry= [3e5  3.5e5 3.5e5 3e5 ];      
    ht=patch(sqrx,sqry,'y');
     rhog = 20; % [kN/m^3 ]
     phi  = 30; % [?]
     c    = 0;  % [kN/m^2 ]
   
    elseif k==6 % Area F
    t=5e4;
    sqrx= [5e5 5.5e5 5.5e5 5e5];
    sqry= [3e5+t 3e5+t 3.5e5+t 3.5e5+t];
    ht=patch(sqrx,sqry,'c');
    rhog = 20; % [kN/m^3 ]
    phi  = 20; % [?]
    c    = 10; % [kN/m^2 ]
    elseif k==7 % Area D
    t=5e4;
    sqrx= [4.3e5 4.3e5 4.5e5 4.5e5];
    sqry= [3.5e5 4e5 4e5 3.5e5];
    ht=patch(sqrx,sqry,'m');
    rhog = 18.5; % [kN/m^3 ]
    phi  = 25;   % [?]
    c    = 4;    % [kN/m^2 ]
%     elseif k==8 % Area B
%     sqrx= [4.5e5 4.5e5 5e5 5e5];
%     sqry= [4e5 4.5e5 4.5e5 4e5 ];
%     ht=patch(sqrx,sqry,'w');
%     elseif k==9 %Area A
%     sqrx= [5e5 5e5 5.8e5 5.8e5];
%     sqry= [4.5e5 4.8e5 4.8e5 4.5e5 ];
%     ht=patch(sqrx,sqry,'r');
   
    end
         
    [in,on] = inpolygon(x,y,sqrx,sqry);
    t=t+5e4;
    k=k+1;
    pause(0.05)
    set(ht,'facealpha',.5)

    D='\\ufr.isi1.public.ads.uni-freiburg.de\na107\Desktop\Neuer Ordner (2)\BadenWuerttemberg5m\';
    S = dir(fullfile(D,'*.tif'));

    InsideSquareX = x(in)/1e3;
    InsideSquareY = y(in)/1e3;

    InsideX = x(in);
    InsideY = y(in);


    hold off



for i= 1:numel(InsideSquareX)
    formatSpec='x%dy%d.tif';
    xcellno=InsideSquareX(i);
    ycellno=InsideSquareY(i);
    str=sprintf(formatSpec,xcellno,ycellno);
    F = fullfile(D,str);

    I = imread(F); 
    I = flipud(I);
    count(i)= i; 
    
    
    xx=InsideX(i):5:(InsideX(i)+1e3);       % x axis values
    yy=InsideY(i):5:(InsideY(i)+1e3);       % y axis values 


    [G,ASP] = gradient8(I,5);               % slope calculation
    G=atand(G);
    
    figure(2)
    imagesc(xx,yy,G)
    set(gca,'Ydir','normal')
    bb=safety2(I,G,xx,yy,rhog,phi,c);
    o=colorbar;
    o.Label.String= 'Degree [°]';
    axis equal
    hold on

    plot(bb.xgrid(bb.RowFosLoc,bb.ColFosLoc),bb.ygrid(bb.RowFosLoc,bb.ColFosLoc),'r.','LineWidth',2)
    pause on%(0.001)
    xlabel(' x [m]')
    ylabel(' y [m]')
    legend(' Unstable Locations')






end

end
createtextbox(fig1)                        % box letters