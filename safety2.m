classdef safety2
 
    properties
        surfx;
        surfz;
        circx;
        circr;
        circz;
        maxdalpha;
        xgrid;
        ygrid;
        RowFosLoc;
        ColFosLoc;
        foS;       
 
    end
    
    methods
    function bb=safety2(I,G,xx,yy,rhog,phi,c)
 
    MatrixWindow = ones(3);
    RestElementsH = ones(1,8);

    SlopeWindow = ones(3);
    RestElementsofSlope = ones(1,8);

    [bb.xgrid,bb.ygrid]=meshgrid(xx,yy);

    xxWindow = ones(3);
    RestElementsofXX = ones(1,8);

    t=1;
    j=1;

while t< 201  
  
    MatrixWindowProcess = I(t:t+2,j:j+2).*MatrixWindow; 
    SlopeWindowProcess  = G(t:t+2,j:j+2).*SlopeWindow;
    xxWindowProcess     = bb.xgrid(t:t+2,j:j+2).*xxWindow;
          
 
    
    % SlipCircle Calculation
    
    Mid_elementH  = MatrixWindowProcess(2,2);
    RestElementsH = [MatrixWindowProcess(1,1:3) MatrixWindowProcess(2,1:2:3)  MatrixWindowProcess(3,1:3)];
    
    Mid_elementSlope  = SlopeWindowProcess(2,2);
    RestElementsSlope = [SlopeWindowProcess(1,1:3) SlopeWindowProcess(2,1:2:3)  SlopeWindowProcess(3,1:3)];
    
    Mid_XX  = xxWindowProcess(2,2);
    RestElementsofXX = [xxWindowProcess(1,1:3) xxWindowProcess(2,1:2:3)  xxWindowProcess(3,1:3)];

 
    % Parameters of Slip Circle Profile 
    

        [MaxRest,idx]=max(RestElementsH);
        H=abs(Mid_elementH-MaxRest);
        if any(idx== [1,3,6,8]) 
            bb.surfx=[-2 0 (5*sqrt(2)) 9];
        else
            bb.surfx=[-2 0 5 7];
        end
     
        if MaxRest > Mid_elementH
             
         bb.surfz= [ MaxRest  MaxRest  (tand(RestElementsSlope(idx))*H+Mid_elementH) (tand(RestElementsSlope(idx))*H+Mid_elementH) ];
         bb.circz= MaxRest ;
        else
            bb.surfz= [Mid_elementH  Mid_elementH (tand(Mid_elementSlope).*H+MaxRest ) (tand(Mid_elementSlope).*H+MaxRest ) ];
            bb.circz= Mid_elementH;
            
        end
        
    
   
   
   
    bb.circx= (bb.surfx(3)^2+H^2)/(2*bb.surfx(3));
    bb.circr= (bb.surfx(3)^2+H^2)/(2*bb.surfx(3));
    bb.maxdalpha=10;
    
    s=SlipCircle ( bb.surfx, bb.surfz, bb.circx, bb.circz, bb.circr, bb.maxdalpha); % Slip Circle Plot
    ff=fellenius(s,rhog,phi,c); % FoS calculation
    bb.foS=ff.foS;
    if bb.foS<1    
      [bb.RowFosLoc,bb.ColFosLoc]=find(I==Mid_elementH);
    end
 
     j=j+2;    
    if j==201 
       t=t+2;
       j=1;
   end
end
 
    end
 
    end
end

