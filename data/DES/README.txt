
Il existe deux versions de ce package de courbes permettant de s'exercer aux technique de DPA/CPA.
La prmière version, complète, fait plus de 60 Mo. 
La deuxième version, allégée (6 Mo), est un sous-ensemble de la première qui contient l'essentiel.

Contenu du package
------------------

Le répertoire curves contient les courbes acquises. Ce sont des courbes RF d'une implémentation non protégée d'un DES.
Les courbes font 50 ko chacune. Il s'agit d'une portion de 100 µs échantillonnée à 500 MHz et positionnée sur la sortie des sbox du 1er tour ainsi que sur la permutation P qui les suit.
Les courbes nommées demo sont les courbes brutes acquises.
Les courbes nommées sync sont les mêmes que demo mais resynchronisées pour compenser un léger jitter d'un à deux samples (voir le fichier sync_pattern.log à la racine).
Il y a 40 courbes, ce qui est très peu par rapport à ce qui est usuellement pratiqué pour de la DPA.
D'ailleurs nous ne les exploitons pas en DPA mais en CPA qui donne de bien meilleurs résultats et pour laquelle 40 courbes suffisent.
Ceci étant, ceux qui le souhaitent peuvent opérer la DPA s'ils le souhaitent. Ils obtiendront des pics mais il leur sera peut-être difficile de déterminer en aveugle les bonnes valeurs des sous-clés (alors que c'est évident en CPA).

A la racine, les fichiers demo.in.txt, demo.key.txt et demo.out.txt contiennent respectivement les 40 inputs, la clé et les 40 outputs du DES.

Dans le répertoire cpa, le classement se fait par sbox de S1 à S8. Dans chaque Sx, on trouve :

 - des fichiers nommés outbox.64_4.sx.pyy.gzz : ils contiennent chacun la série des 40 distances de Hamming entre la valeur yy du "previous state" et la sortie de la sbox n° x lorsque l'hypothèse de sous-clé (guess) pour cette sbox est zz. Ces fichiers sont petits : 360 octets chacun. Seul le previous state égal à 0 est ici considéré puisque c'est celui qui est pertinent. Dans une attaque en aveugle concernant le chip et/ou l'implémentation, il aurait fallu exhauster l'ensemble des valeurs possibles du previous state.

 - des fichiers nommés demo.64_4.sx.pyy.gzz.cor : un par un, chacun des fichiers contenant les distances de Hamming est corrélé (sample par sample) avec l'ensemble des 40 courbes de consommation (ou plutôt d'émanation dans notre cas de figure puisqu'il s'agit de RF) nommées demo.nnnnn pour donner cette courbe de corrélation, reliée au triplet (x,yy,zz) décrit ci-dessus. Ces courbes de corrélation sont de même taille que les courbes acquises (50 ko). Dans le package complet (60 Mo), toutes les courbes de corrélation pour chaque 8 sbox et pour chaque 64 guess sont présentes. Dans le package light (6 Mo), pour chaque sbox, seule la courbe de corrélation correspondant au guess correct pour cette sbox est présente.

 - des fichiers nommés demo.64_4.sx.pyy.gzz.cor : ils correspondent en tous points aux fichiers décrits juste au dessous mais concernent la corrélation avec les courbes "sync" (resynchronisées) plutôt qu'avec les courbes "demo" (brutes). Les corrélations sont naturellement meilleures que sans la resynchro. On peut donc illustrer pédagogiquement l'intérêt de compenser un éventuel jitter avant exploitation. Ici encore seule la courbe pour le bon guess apparaît dans la version light du package. 

Dans le répertoire cpa se trouvent aussi des fichiers de résultats de corrélation :
 - chaque fichier demo.Sx.log contient sur chaque ligne la hauteur des pics positif et négatif les plus prononcés, un guess zz par ligne. Entre parenthèses se trouve le numéro du sample où se situe le pic sur la courbe. Les fichiers sync.Sx.log concernent de la même manière les corrélations avec les courbes resynchronisées.
 - les fichiers demo.all.sorted.log et sync.all.sorted.all font une synthèse des fichiers précédemment cités en regroupant dans un même fichier les résultats de chaque 8 sbox et en donnant pour chacune une liste triée des 10 meilleures corrélations.
 
Remarque importante :

Dans le DES les sorties de sbox sont sur 4 bits. Or le mot machine est sur 8 bits. En prédisant la sortie d'une sbox (grâce à un guess de sous-clé) on ne prédit que la moitié d'un mot machine. Pour obtenir une bonne corrélation avec les signaux, il est nécessaire de savoir (ou de deviner) ce que contient l'autre partie de l'octet manipulé. Dans le cas des sbox du DES, ceci dépend de la façon dont l'implémentation stocke les sbox en ROM. Voici trois façons possibles (il y en a peut-être d'autres) de stocker les sbox :

 i) La façon la plus naturelle consiste à utiliser 8 tables (une par sbox) de 64 octets. Dans la table n° 2, à l'adresse 12 se trouve la valeur de S2(12) sur un nibble, et 0 sur le nibble adjacent. Cette façon de coder les sbox est désignée "64_8" pour indiquer que les sbox utilisent 8 tables de 64 octets. On voit que cette façon naturelle de faire est inefficace en ce qu'elle gaspille la moitié de l'espace mémoire utilisé par les tables. Les deux autres manières de faire présentées ci-après pallient ce défaut.
 
 ii) Une façon de "compresser" les sbox en utilisant à 100% l'espace occupé par les tables consiste à utiliser 8 tables de 32 octets chacune (on la désigne donc par "32_8"). Dans la table n°2, à l'adresse 12 se trouvent côte à côte les valeurs de S2(24) sur le premier nibble et de S2(25) sur le deuxième nibble.
 
 iii) Une autre manière de faire est d'utiliser 4 tables de 64 octets. Chaque table contient alors deux sbox. Dans la table n° 2, à l'adresse 12, se trouvent côte à côte les valeurs de S3(12) sur le premier nibble et de S4(12) sur le deuxième nibble. Ce codage des sbox est désigné "64_4".
 
 Il se trouve que dans l'implémentation du DES qui nous occupe, les sbox sont codées de manière "64_4". Pour illustrer la perte d'efficacité lorsque l'on ne prend pas en compte l'intégralité des bits du mot machine manipulé lorsque l'on calcule la corrélation, les CPA et résultats pour les codages "64_8" et "32_8" sont présentés pour la sbox 8 seulement. On remarque pour ces codages qu'aucun guess de sous-clé ne prend le dessus sur les autres, et que le bon guess est complètement noyé dans la masse. La CPA permet ainsi (moyennant un guess d'implémentation parmi un petit nombre (ici trois) de variantes naturelles) de faire du reverse de choix d'implémentation. En l'occurence l'attaquant apprend que les sbox sont écrites en mémoire selon le plan "64_4".
 
 
 