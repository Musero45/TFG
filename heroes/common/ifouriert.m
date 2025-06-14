function [t,x]=ifouriert(freq,H)

% IFOURIER   Inverse Fourier transformation
%            [t,x] = ifourier(f,X) gives the Inverse Fourier transformed of X
%            according x = ifft(X);
%
% INPUT:     f = frequency [Hz]               (N points)
%            X = Fourier transformed signal   (N points)
%
% OUTPUT:    t = time                         (2*N points)
%            x = time signal                  (2*N points)
%  
% Author     ir. Peter W.A. Zegelaar
%            Delft University of Technology
%            Vehicle Research Laboratory
%            Mekelweg 2, 2628 CD DELFT, The Netherlands
%            Phone: +31-15-2786637,   Telefax: +31-15-2781397
%
% Last update: 10-11-95                                            (c) PWAZ '95

% ------ Pre-processing -------------------------------------------------------

[n1 n2] = size(H);
if n2==1
   H=H.';
end

df = freq(2)-freq(1);       % frequency step
N  = floor(length(H))*2;    % number of points
t  = (0:N-1)/(N*df);        % time vector

% ------- The real and imaginary part -----------------------------------------

HR = real(H);               % Real part of half the spectrum
HI = imag(H);               % Imaginary part of half the spectrum

% ------- Flipping the real and imaginary part --------------------------------

nmax = length(H);           % number of points

if rem(nmax,2)==0,          % length of H is even
  GR = [HR HR(nmax) fliplr(HR(2:nmax))];
  GI = [HI    0    -fliplr(HI(2:nmax))];
else                        % length of H is odd
  GR = [HR(1:nmax) HR(nmax) fliplr(HR(2:nmax))];
  GI = [HI(1:nmax)    0    -fliplr(HI(2:nmax))];
end

% ------- Fourier transformation ----------------------------------------------

G = GR+i*GI;
x = real(ifft(G));

