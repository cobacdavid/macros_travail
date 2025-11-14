% fichier de macros METAPOST
% création le 16 mai 2001
%% modification février 2007



verbatimtex
%&latex
\documentclass{article}
\usepackage[T1]{fontenc}
\usepackage{aeguill}
\begin{document}
etex


% suffixe : aucun ou couleur
% Papier Millimétré
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
vardef papiermi@# (expr larg,long)   =
%% larg et long sans unite
  save pap,u,coul;
  path traitv,traith;
  picture pap;
  color coul;
  u:=1mm;v:=1cm;
  
  if str @#="" : coul:=(210/255,125/255,45/255)
  else : coul:=@#
  fi;

  traitv:=(0,0)--(0,long*v);
  traith:=(0,0)--(larg*v,0);
      
  pap=image(
%% millimétrique
    drawoptions(withpen pencircle scaled 0.1mm withcolor coul); 
    for i=0 upto (larg*10) :
      if i mod 5 <>0 : draw traitv shifted (i*u,0) fi;
    endfor
    for i=0 upto (long*10) :
      if i mod 5 <>0 : draw traith shifted (0,i*u) fi;
    endfor
    
%% demi-centimétrique
    drawoptions(withpen pencircle scaled 0.15mm withcolor coul);
    for i=0 upto larg*2 :
      if i mod 10 <>0 :	draw traitv shifted (5*i*u,0) fi;
    endfor
    for i=0 upto long*2 :
      if i mod 10 <>0 :	draw traith shifted (0,5*i*u) fi;
    endfor
    
%% centimétrique
    drawoptions(withpen pensquare scaled 0.20mm withcolor coul);
    for i=0 upto larg :
	  if i mod 5 <> 0 :
		draw traitv shifted (10*i*u,0);
	  else :
		draw traitv shifted (10*i*u,0) withpen pensquare scaled 0.35mm;
	  fi;
	endfor
    for i=0 upto long :
	  if i mod 5 <>0 :
		draw traith shifted (0,10*i*u);
	  else :
		draw traith shifted (0,10*i*u) withpen pensquare scaled 0.35mm;
	  fi;
	endfor;
	drawoptions();
    );
  pap
enddef;


% quadrillage
% suffixe : aucun
%           "ptg"    pour quadrillage + pointage
%           "ptgex"  pour pointage seul
% testé avec succès le 2 juin
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
vardef quadrillage@# (expr larg,long,espace) =
	% dessine un réseau espacé
	% larg et long sans unite
	% espace en cm
  save qua;
  picture qua;		
	%show str @#;
  qua:=image(
	for i=0 upto larg :
	  if (str @# ) <> "ptgex" :
		draw (i*espace,0)--(i*espace,long*espace);
	  fi;
	  if (str @# = "ptg") or (str @# = "ptgex")  :
		for j=0 upto long :
		  draw (i*espace,j*espace) withpen pencircle scaled 2bp;
		endfor;
	  fi;
	endfor;
	if str @# <> "ptgex" :
	  for i=0 upto long :
		draw (0,i*espace)--(larg*espace,i*espace);
	  endfor;
	fi;
	);
  qua
enddef;



% base
% suffixe : aucun
%           "ss" pour n'avoir que deux traits d'unité
% testé avec succès le 2 juin
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
vardef base@# (expr unitex,unitey) =
	% unitex et unitey en cm
  save rep,p;
  path p;
  picture rep;

  p:=(unitex,0)--(0,0)--(0,unitey);
  rep:=image(
	if str @# <> "ss" :
	  drawdblarrow p;
	  label.llft(btex $O$ etex,(0,0));
	  label.bot(btex $\vec \imath$ etex,(unitex/2,0));
	  label.lft(btex $\vec \jmath$ etex,(0,unitey/2));
	else :
	  draw p;
	fi;
	);
  rep
enddef;

vardef quadrillagesimple (expr larg,long,espace) =
	% dessine un réseau espacé
	% larg et long sans unite
	% espace en cm
  save qua;
  picture qua;		

  qua:=image(
	for i=0 upto larg :
	  draw (i*espace,0)--(i*espace,long*espace);
	endfor;
	for i=0 upto long :
	  draw (0,i*espace)--(larg*espace,i*espace);
	endfor;
	);
  qua
enddef;

vardef quadrillagesimple (expr larg,long,espaceX,espaceY) =
	% dessine un réseau espacé
	% larg et long sans unite
	% espaceX en cm
        % espaceY en cm
  save qua;
  picture qua;		

  qua:=image(
	for i=0 upto larg :
	  draw (i*espaceX,0)--(i*espaceX,long*espaceY);
	endfor;
	for i=0 upto long :
	  draw (0,i*espaceX)--(larg*espaceX,i*espaceY);
	endfor;
	);
  qua
enddef;


vardef axeh@# (expr xmin, xmax, inc, u) =
  save i,t,nb,s;
  picture axe;
  path t;
  string s;
  t=(0,0)--(0,-.04cm);
    axe = image(%
	drawarrow (xmin*u,0)--(xmax*u,0);
    if (str @# ) = "ticks" :
      nb=floor((xmax-xmin)/inc);
      for i=0 upto nb :
	z[i]=(xmin+i*inc,0) scaled u;
	if x[i] <> 0 :
	  draw t shifted z[i];
	  s:="\small\nombre{" & decimal( round(100*(xmin+i*inc))/100 ) & "}";
	  label.bot( TEX s, z[i]);
	  %%label.bot(textext(s),z[i]);
	fi;
      endfor;
    fi;
      );
  axe
enddef;

vardef axev@# (expr ymin, ymax, inc, u) =
  save i,t,nb,s,A;
  picture axe;
  pair A[];
  path t;
  string s;
  t=(0,0)--(-.04cm,0);
  axe = image(%
      drawarrow (0,ymin*u)--(0,ymax*u) ;
    if (str @# ) = "ticks" :
      nb:=floor((ymax-ymin)/inc);
      for i=0 upto nb :
	A[i]=(0,ymin+i*inc) scaled u;
	if ypart A[i] <> 0 :
	  draw t shifted A[i];
	  s:="\small\nombre{" & decimal( round(100*(ymin+i*inc))/100 ) & "}";
	  label.lft( TEX s, A[i]);
	  %% label.lft(textext(s), A[i]);
	fi;
      endfor;
    fi;
    );
  axe
enddef;
