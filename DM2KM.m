function DM = DM2KM(DM, sigma)
% DM is nXn distance matrix: n are # of time series

[n, ncolumns]=size(DM);

for i=1:n
       for j=1:ncolumns
            %DM(i,j) = exp(-DM(i,j).^2/(2*sigma^2));
            DM(i,j) = exp(-sigma*DM(i,j).^2);
       end    
end

end