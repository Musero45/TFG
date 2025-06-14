function v = myIfft(V)

V(1)   = 0;
V(end) = 0;
nf     = length(V);
vreal  = real(V);
vimag  = imag(V);
v      = zeros(1,2*nf+1);

        % **   a partir de aqui no estoy muy seguro de que este bien
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        for it=1:2*nf+1
            % ***  se hace el sumatorio de 1 a nf porque se suman de dos en dos
            % ***  para que se anule la parte imaginaria
            tfrad = 2*pi*(it-1)*((1:nf)-1)./(2*nf);
            tfi   = sin(tfrad);
            tfr   = cos(tfrad);
            su    = 2.*(vreal.*tfr - vimag.*tfi);
            sums  = sum(su);
            v(it)=sums/(2*nf);
        end
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
