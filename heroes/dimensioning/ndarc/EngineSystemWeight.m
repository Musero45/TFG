function y = EngineSystemWeight(input, performances,engine)
%
% NDARC, NASA Design and Analysis of Rotorcraft (2009)
% Wayne Johnson
%  
% ENGINE SYSTEM WEIGHT (parametric method AFDD82)(Johnson 19-7.1)(page 157)
%
% Input and output variables expressed in International System 
%
% Initial version: Emory et al
% International System Version 
%      11/03/2014 Sergio Nadal Mu\~noz s.nadal@alumnos.upm.es
%

kgf2N = 9.8; %Gravitational acceleration

chieng = input.technologyFactors.mainEngine;
chiexh = input.technologyFactors.engineExhaustSystem;
chiacc = input.technologyFactors.engineAccesories;
K0exh = input.options.K0exh;
K1exh = input.options.K1exh;

WoneengN = engine.weight; %Weight of one engine in N
Woneeng = WoneengN/kgf2N; %Mass of one engine in kg 
Neng = engine.numEngines;
Tto = performances.TakeOffTransmissionRating; %Watts

%pasamos a sistema imperial
Woneeng_ = Woneeng*2.205; %Pounds
Tto_ = Tto/745.7; %Horse Power

%ENGINE SUPPORT STRUCTURE
%Weng=Weight all main engines
%Neng=Number of Main Engines
weng_ = Neng*(Woneeng_/Neng);
Weng_ = chieng*weng_;

%ENGINE-EXHAUST SYSTEM
%Neng=Number of Main Engines
%(K0exh,K1exh)=Engine exhaust weight vs. power, constants
%P=Installed takeoff power (SLS static, specified rating) per engine
wexh_= Neng*(K0exh+K1exh*Tto_);
Wexh_ = chiexh*wexh_;

%ENGINE ACCESSORIES
%MTOW= maximuntakeoff weight
if input.options.flub == true
    flub=1;%if the lubrication system weight is in the engine weight
else
    flub = 1.4799;%if the accessory weight includes the lubrication system weight
end
wacc_ = 2.0088*flub*((Weng_/Neng)^0.5919)*(Neng^0.7858);
Wacc_ = chiacc*wacc_;

%pasamos a SI(kg)
Wengkg = Weng_*0.4536;
Wexhkg = Wexh_*0.4536;
Wacckg = Wacc_*0.4536;

%pasamos a SI(N)
Weng=Wengkg*kgf2N;
Wexh=Wexhkg*kgf2N;
Wacc=Wacckg*kgf2N;

y = struct (...
    'WmainEngines', Weng,...
    'WengineExhaustSystem', Wexh,...
    'WengineAccesories', Wacc ...
);







