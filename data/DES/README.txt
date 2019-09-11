
Il existe deux versions de ce package de courbes permettant de s'exercer aux technique de DPA/CPA.
La prmi�re version, compl�te, fait plus de 60 Mo. 
La deuxi�me version, all�g�e (6 Mo), est un sous-ensemble de la premi�re qui contient l'essentiel.

Contenu du package
------------------

Le r�pertoire curves contient les courbes acquises. Ce sont des courbes RF d'une impl�mentation non prot�g�e d'un DES.
Les courbes font 50 ko chacune. Il s'agit d'une portion de 100 �s �chantillonn�e � 500 MHz et positionn�e sur la sortie des sbox du 1er tour ainsi que sur la permutation P qui les suit.
Les courbes nomm�es demo sont les courbes brutes acquises.
Les courbes nomm�es sync sont les m�mes que demo mais resynchronis�es pour compenser un l�ger jitter d'un � deux samples (voir le fichier sync_pattern.log � la racine).
Il y a 40 courbes, ce qui est tr�s peu par rapport � ce qui est usuellement pratiqu� pour de la DPA.
D'ailleurs nous ne les exploitons pas en DPA mais en CPA qui donne de bien meilleurs r�sultats et pour laquelle 40 courbes suffisent.
Ceci �tant, ceux qui le souhaitent peuvent op�rer la DPA s'ils le souhaitent. Ils obtiendront des pics mais il leur sera peut-�tre difficile de d�terminer en aveugle les bonnes valeurs des sous-cl�s (alors que c'est �vident en CPA).

A la racine, les fichiers demo.in.txt, demo.key.txt et demo.out.txt contiennent respectivement les 40 inputs, la cl� et les 40 outputs du DES.

Dans le r�pertoire cpa, le classement se fait par sbox de S1 � S8. Dans chaque Sx, on trouve :

 - des fichiers nomm�s outbox.64_4.sx.pyy.gzz : ils contiennent chacun la s�rie des 40 distances de Hamming entre la valeur yy du "previous state" et la sortie de la sbox n� x lorsque l'hypoth�se de sous-cl� (guess) pour cette sbox est zz. Ces fichiers sont petits : 360 octets chacun. Seul le previous state �gal � 0 est ici consid�r� puisque c'est celui qui est pertinent. Dans une attaque en aveugle concernant le chip et/ou l'impl�mentation, il aurait fallu exhauster l'ensemble des valeurs possibles du previous state.

 - des fichiers nomm�s demo.64_4.sx.pyy.gzz.cor : un par un, chacun des fichiers contenant les distances de Hamming est corr�l� (sample par sample) avec l'ensemble des 40 courbes de consommation (ou plut�t d'�manation dans notre cas de figure puisqu'il s'agit de RF) nomm�es demo.nnnnn pour donner cette courbe de corr�lation, reli�e au triplet (x,yy,zz) d�crit ci-dessus. Ces courbes de corr�lation sont de m�me taille que les courbes acquises (50 ko). Dans le package complet (60 Mo), toutes les courbes de corr�lation pour chaque 8 sbox et pour chaque 64 guess sont pr�sentes. Dans le package light (6 Mo), pour chaque sbox, seule la courbe de corr�lation correspondant au guess correct pour cette sbox est pr�sente.

 - des fichiers nomm�s demo.64_4.sx.pyy.gzz.cor : ils correspondent en tous points aux fichiers d�crits juste au dessous mais concernent la corr�lation avec les courbes "sync" (resynchronis�es) plut�t qu'avec les courbes "demo" (brutes). Les corr�lations sont naturellement meilleures que sans la resynchro. On peut donc illustrer p�dagogiquement l'int�r�t de compenser un �ventuel jitter avant exploitation. Ici encore seule la courbe pour le bon guess appara�t dans la version light du package. 

Dans le r�pertoire cpa se trouvent aussi des fichiers de r�sultats de corr�lation :
 - chaque fichier demo.Sx.log contient sur chaque ligne la hauteur des pics positif et n�gatif les plus prononc�s, un guess zz par ligne. Entre parenth�ses se trouve le num�ro du sample o� se situe le pic sur la courbe. Les fichiers sync.Sx.log concernent de la m�me mani�re les corr�lations avec les courbes resynchronis�es.
 - les fichiers demo.all.sorted.log et sync.all.sorted.all font une synth�se des fichiers pr�c�demment cit�s en regroupant dans un m�me fichier les r�sultats de chaque 8 sbox et en donnant pour chacune une liste tri�e des 10 meilleures corr�lations.
 
Remarque importante :

Dans le DES les sorties de sbox sont sur 4 bits. Or le mot machine est sur 8 bits. En pr�disant la sortie d'une sbox (gr�ce � un guess de sous-cl�) on ne pr�dit que la moiti� d'un mot machine. Pour obtenir une bonne corr�lation avec les signaux, il est n�cessaire de savoir (ou de deviner) ce que contient l'autre partie de l'octet manipul�. Dans le cas des sbox du DES, ceci d�pend de la fa�on dont l'impl�mentation stocke les sbox en ROM. Voici trois fa�ons possibles (il y en a peut-�tre d'autres) de stocker les sbox :

 i) La fa�on la plus naturelle consiste � utiliser 8 tables (une par sbox) de 64 octets. Dans la table n� 2, � l'adresse 12 se trouve la valeur de S2(12) sur un nibble, et 0 sur le nibble adjacent. Cette fa�on de coder les sbox est d�sign�e "64_8" pour indiquer que les sbox utilisent 8 tables de 64 octets. On voit que cette fa�on naturelle de faire est inefficace en ce qu'elle gaspille la moiti� de l'espace m�moire utilis� par les tables. Les deux autres mani�res de faire pr�sent�es ci-apr�s pallient ce d�faut.
 
 ii) Une fa�on de "compresser" les sbox en utilisant � 100% l'espace occup� par les tables consiste � utiliser 8 tables de 32 octets chacune (on la d�signe donc par "32_8"). Dans la table n�2, � l'adresse 12 se trouvent c�te � c�te les valeurs de S2(24) sur le premier nibble et de S2(25) sur le deuxi�me nibble.
 
 iii) Une autre mani�re de faire est d'utiliser 4 tables de 64 octets. Chaque table contient alors deux sbox. Dans la table n� 2, � l'adresse 12, se trouvent c�te � c�te les valeurs de S3(12) sur le premier nibble et de S4(12) sur le deuxi�me nibble. Ce codage des sbox est d�sign� "64_4".
 
 Il se trouve que dans l'impl�mentation du DES qui nous occupe, les sbox sont cod�es de mani�re "64_4". Pour illustrer la perte d'efficacit� lorsque l'on ne prend pas en compte l'int�gralit� des bits du mot machine manipul� lorsque l'on calcule la corr�lation, les CPA et r�sultats pour les codages "64_8" et "32_8" sont pr�sent�s pour la sbox 8 seulement. On remarque pour ces codages qu'aucun guess de sous-cl� ne prend le dessus sur les autres, et que le bon guess est compl�tement noy� dans la masse. La CPA permet ainsi (moyennant un guess d'impl�mentation parmi un petit nombre (ici trois) de variantes naturelles) de faire du reverse de choix d'impl�mentation. En l'occurence l'attaquant apprend que les sbox sont �crites en m�moire selon le plan "64_4".
 
 
 