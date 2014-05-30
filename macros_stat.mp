% fichier de macros METAPOST
% création le 6 juin 2001

verbatimtex
\documentclass{article}
\usepackage{david}
\begin{document}
etex

% Boîte à moustache
% paramètres : vmin vmax q1 med q3 largeurboite hauteurboite positiondepart(blft)
% testé avec succès le 16 mai 2001
vardef bam (expr vmin,vmax,un,med,trois,larg,haut,pos) =
		path rect;
		save z,u;
		pair z[];
		pen avant;
		picture fig,boite;
		%%%%%%%%%%%%%%%%%%%%%%%%%%%
		avant=currentpen;
		fig=currentpicture;
		currentpicture:=nullpicture;
		%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		% les taquets (3mm de diff)
		u:=1mm;
		z0=pos shifted (5*u,8*u);
		z1=pos shifted (5*u,haut-6*u+8*u);
		z2=pos shifted (5*u+larg,8*u);
		z3=pos shifted (5*u+larg,haut-6*u+8*u);
		draw z0--z1;
		draw z2--z3;
		
		% les positions clés des quartiles
		z4=pos shifted (5*u,haut/2+5*u);
		z5=pos shifted (5*u+(un-vmin)*larg/(vmax-vmin),haut/2+5*u);
		z6=pos shifted (5*u+(trois-vmin)*larg/(vmax-vmin),haut/2+5*u);
		z7=pos shifted (larg+5*u,haut/2+5*u);
		draw z4--z5 withpen pencircle scaled 1.5bp;
		draw z6--z7 withpen pencircle scaled 1.5bp;
		
		% le rectangle
		draw (z5 shifted (0,haut/2))--(z6 shifted (0,haut/2))
		--(z6 shifted (0,-haut/2))--(z5 shifted (0,-haut/2))--cycle
		 withpen pencircle scaled 1.5bp;
		
		% la médiane
		z8=pos shifted (5*u+(med-vmin)*larg/(vmax-vmin),haut+5*u);
		draw z8--(z8 shifted (0,-haut)) withpen pencircle scaled 1.5bp;
		
		% les étiquettes
		label.lft(btex min etex,z4);
		label.rt(btex max etex,z7);
		label.ulft(btex $Q_1$ etex,z5);
		label.urt(btex $Q_3$ etex,z6);
		label.ulft(btex $Me$ etex,(z8 shifted (0,-haut/2)));
		%%%%%%%%%%%%%%%%%%%%%%%%%%%%
		boite=currentpicture;
		currentpicture:=nullpicture;
		draw fig;
		boite
enddef;

verbatimtex
\end{document}
etex
