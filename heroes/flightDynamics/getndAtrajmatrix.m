function ndAtr = getndAtrajmatrix(ueORe,weORe,Thetae,veORe,Phie,Psie)
% getndAtrajmatrix obtains the [3x9] extra matrix part of the Linear 
% problem Stability Matrix due to considering trajectory variables as part
% of the state vector. The result is a [12x12] matrix:
% 
%                     |  A [9x9]  zeros(9,3) |
%                     | Atr[3x9]  zeros(3,3) |
% 
% Atr is calculated for a known Trim State with a velocity vector = (ueORe,
% veORe,weORe) and Euler angles equal to (Phie,Thetae,Psie).

ndAtr = zeros(3,9);
u_u     = cos(Thetae)*cos(Psie);
u_w     = cos(Phie)*sin(Thetae)*cos(Psie)+sin(Phie)*sin(Psie);
u_Theta = (cos(Thetae)*cos(Phie)*cos(Psie)*weORe+...
          cos(Psie)*cos(Thetae)*sin(Phie)*veORe-...
          cos(Psie)*sin(Thetae)*ueORe);
u_v     = sin(Thetae)*cos(Psie)*sin(Phie)-cos(Phie)*sin(Psie);
u_Phi   = (cos(Phie)*sin(Thetae)*cos(Psie)*veORe-...
          cos(Psie)*sin(Thetae)*sin(Phie)*weORe+...
          sin(Psie)*cos(Phie)*weORe+sin(Psie)*sin(Phie)*veORe);
u_Psi   = (-sin(Psie)*sin(Thetae)*cos(Phie)*weORe-...
          sin(Psie)*sin(Thetae)*sin(Phie)*veORe-...
          cos(Psie)*cos(Phie)*veORe+cos(Psie)*sin(Phie)*weORe-...
          sin(Psie)*cos(Thetae)*ueORe);
    
v_u     = cos(Thetae)*sin(Psie);
v_w     = cos(Phie)*sin(Thetae)*sin(Psie)-sin(Phie)*cos(Psie);
v_Theta = (cos(Thetae)*cos(Phie)*sin(Psie)*weORe+...
          cos(Thetae)*sin(Phie)*sin(Psie)*veORe-...
          sin(Psie)*sin(Thetae)*ueORe);
v_v     = sin(Phie)*sin(Thetae)*sin(Psie)+cos(Phie)*cos(Psie);
v_Phi   = ((cos(Phie)*sin(Thetae)*sin(Psie)-...
          sin(Phie)*cos(Psie))*veORe+(-sin(Phie)*sin(Thetae)*sin(Psie)-...
          cos(Phie)*cos(Psie))*weORe);
v_Psi   = (cos(Thetae)*cos(Psie)*ueORe+(sin(Thetae)*cos(Psie)*sin(Phie)-...
          cos(Phie)*sin(Psie))*veORe+(cos(Phie)*sin(Thetae)*cos(Psie)+...
          sin(Phie)*sin(Psie))*weORe);

w_u     = -sin(Thetae);
w_w     = cos(Phie)*cos(Thetae);
w_Theta = (-sin(Thetae)*cos(Phie)*weORe-sin(Thetae)*sin(Phie)*veORe-...
          cos(Thetae)*ueORe);
w_v     = sin(Phie)*cos(Thetae);
w_Phi   = (cos(Thetae)*cos(Phie)*veORe-cos(Thetae)*sin(Phie)*weORe);
w_Psi   = 0;

ndAtr(1,1)= u_u;
ndAtr(1,2)= u_w;
ndAtr(1,4)= u_Theta;
ndAtr(1,5)= u_v;
ndAtr(1,7)= u_Phi;
ndAtr(1,9)= u_Psi;

ndAtr(2,1)= v_u;
ndAtr(2,2)= v_w;
ndAtr(2,4)= v_Theta;
ndAtr(2,5)= v_v;
ndAtr(2,7)= v_Phi;
ndAtr(2,9)= v_Psi;

ndAtr(3,1)= w_u;
ndAtr(3,2)= w_w;
ndAtr(3,4)= w_Theta;
ndAtr(3,5)= w_v;
ndAtr(3,7)= w_Phi;
ndAtr(3,9)= w_Psi;


end

