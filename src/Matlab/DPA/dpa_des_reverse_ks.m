function [ masterKeys64 ] = dpa_des_reverse_ks( lastKey48 )
%DES_REVERSE_KS(LAST_SUBKEY48) Recover a part of the master key using the
%last subkey. Returns the list of all possible subkeys.

% IPC2 is the reverse of PC2, its computation can be done using :
%{
IPC2 = zeros(1,56);
for i = [1:48]; IPC2(PC2(i)) = i; end
%}

IPC2 = [5 24 7 16 6 10 20 18 0 12 3 15 23 1 9 19 2 0 14 22 11 0 13 4 0 17];
IPC2 = [IPC2 21 8 47 31 27 48 35 41 0 46 28 0 39 32 25 44 0 37 34 43 29];
IPC2 = [IPC2 36 38 45 33 26 42 0 30 40];

% We do not need to invert the shifts since C and D are 28bits wide and 
% there are 28 shifts between C0 (resp. D0) and C16 (resp. D16).

% IPC1 is the reverse of PC1, its computation can be done using :
%{
IPC1 = zeros(1,64);
for i = [1:56]; IPC1(PC1(i)) = i; end
%}

IPC1 = [8 16 24 56 52 44 36 0 7 15 23 55 51 43 35 0 6 14 22 54 50 42];
IPC1 = [IPC1 34 0 5 13 21 53 49 41 33 0 4 12 20 28 48 40 32 0 3 11 19 27];
IPC1 = [IPC1 47 39 31 0 2 10 18 26 46 38 30 0 1 9 17 25 45 37 29 0];

% Computes the composition "invP = IPC1 o IPC2"
invP = zeros(1,64);
for i = [1:64];
    j = IPC1(i);
    if j ~= 0;
        k = IPC2(j);
        if k ~= 0;
            invP(i) = k;
        end
    end
end


% Find the free variables
freePos = [];
for i = [1:64];
    if invP(i) == 0 && rem(i, 8) ~= 0;
        freePos = [freePos i];
    end
end

% Find 48 bits of the master key
incompleteKey = zeros(1,64);
for i = [1:64];
    if (invP(i) ~= 0);
        incompleteKey(i) = lastKey48(invP(i));
    end
end

% 256 keys
masterKeys64 = zeros(256, 64);

% Find the 256 possible keys
for i = [0:255];
    v = bitget(uint8(i), 8:-1:1);
    masterKeys64(i + 1, :) = incompleteKey;
    for j = [1:8];
        masterKeys64(i + 1, freePos(j)) = v(j);
    end
end

%{
key = 0;
keyRef = round(rand(1,64));
keyRef(8:8:64) = 0;
keysRef = des_key_schedule(keyRef);
lastKeyRef = keysRef(16,:);
keys = dpa_des_reverse_ks(lastKeyRef);
for i = [1:256]; if all(keys(i,:) == keyRef); key = keys(i,:); break; end; end;
key
%}
