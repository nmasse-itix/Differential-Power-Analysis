function [ power ] = dpa_des_get_power( block )
%DES_GET_POWER COMPUTES THE POWER TRACE FROM A BIT BLOCK)

psize = 10000;

%power = rand(1, psize) * 0.5;
power = rand(1, psize);

for j = 1:64;
    i = floor(j * psize / 65);
    power(i : i + psize / 1000) = power(i : i + psize / 1000) + ((0.5 - block(j)) * 0.3);
end

%{

on définit 64 morceau  de 10 bits consécutifs sur la trace de courant
à chaque bit d'un morceau est ajouté la valeur (coefficientée) du bit du block
correspondant à ce morceau

exemple, la valeur du bit 8 du bloc de données d'entrée
est ajoutée au 10 bits du 8ème bloc de la trace de courant,
c'est a dire les bits allant de 8 * (10000/65) a (10000/65) + 10

%}

