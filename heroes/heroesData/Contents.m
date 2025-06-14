%   HEROES data types
%
%     he            - Helicopter data type.
%     rotor         - Rotor data type.
%     fuselage      - Fuselga data type.
%     engine        - Engine data type.
%
%  HELICOPTER DATA TYPE (shortcut he)
%
%  Every he builder should output a he data type. A he data type
%  is an structure with the following fields:
%             class: 'he'
%                id: string
%         mainRotor: [1x1 struct]
%         tailRotor: [1x1 struct]
%            engine: [1x1 struct]
%          fuselage: [1x1 struct]
%                Mf: float
%                 W: float
%              x_tr: float
%
%   class - 'he'
%         This string defines that the type of data is of a
%         helicopter class.
%
%   id - defines the particular helicopter identifier.
%
%   mainRotor - defines the main rotor as a rotor data type
%
%   tailRotor - defines the tail rotor as a rotor data type
%
%   engine -  defines the engine as an engine data type
%
%   fuselage -  defines the fuselage as an engine data type
% 
%   Mf - fuel mass [kg]
% 
%   W - helicopter weight [N]
% 
%   xTR - distance between helicopter center of mass and the tail rotor [m]
%
%
%   ROTOR DATA TYPE
%
%  Every rotor builder should output a rotor data type. A rotor data type
%  is an structure with the following fields:
%            class: 'rotor'
%               id: string
%                R: float
%                b: integer
%           cldata: [vector]
%           cddata: [vector]
%          profile: @cl1cd2
%            Omega: float
%                c: float
%            kappa: float
%                K: float
%              cd0: float
%          eta_Trp: float
%
%   class - 'rotor'
%         This string defines that the type of data is of a
%         rotor class.
%
%   id - defines the particular rotor identifier.
%
%   R - radius of the rotor [m]
% 
%   b - number of blades [-]
% 
%   Omega - angular speed of the rotor [rad/s]
%
%   c - profile chord [m]
