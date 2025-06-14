function f = Rand2(lambda_i,CT,mux,muWx,muy,muWy,muzp)
% ALVARO: FIXME: There is problem in te transition from turbulent wake
% to brake windmild. Probably due to the fact that the RAND model is 
% C1 (the first derivative is not continuous). The transition from
% moderate vortex ring state to hover and ascend do not show any problem
% A NEW MODEL WITH CONTINUOUS DERIVATIVES MUST BE DEVELOPED

%if (muzp >= sqrt(2*CT))%Nano

if (muzp > sqrt(2*abs(CT)))%Alvaro
    
    lambda0 = 0.5*(-muzp+sqrt(muzp^2-2*CT));
    
%elseif (muzp > 0)%Nano

elseif (muzp > 0 && muzp<=sqrt(2*abs(CT)))%alvaro
    
    %Old lambda0 from Rand original paper
    %lambda0 = -sign(CT)*sqrt(abs(CT)/2)-0.5*muzp-25/12*muzp^2*sign(CT)*sqrt(2/abs(CT))+7/6*muzp^3*2/CT;
    
    %New lambda0 from Rand personal comunication
    lambda0 = -sign(CT)*sqrt(abs(CT)/2)-0.5*muzp-59/36*muzp^2*sign(CT)*sqrt(2/abs(CT))+17/18*muzp^3*2/CT;
    
else
    
    lambda0 = -0.5*(muzp+sqrt(muzp^2+2*abs(CT)));
end

%f = lambda_i - lambda0/sqrt(1+((mux+muWx)^2+(muy+muWy)^2)*2/abs(CT));

f = lambda_i - lambda0/sqrt(1+((mux+muWx)^2+(muy+muWy)^2));%AlVARO
% 2014/12/30 probably 2/abs(CT) must be removed