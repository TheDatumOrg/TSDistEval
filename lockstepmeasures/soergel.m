function d = soergel(P, Q)
%P=mat2gray(P);
%Q=mat2gray(Q);
d = sum(abs(P - Q)) / sum(max(P, Q));
end