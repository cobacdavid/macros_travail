% fichier de macros METAPOST
% création le 4 avril 2001

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%prologues:=1;

verbatimtex
%&latex
\documentclass{article}
\usepackage{prof}
\begin{document}
etex


% Barycentre de deux points
% testé avec succés le 4 avril
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
def barydeux (expr a,alpha,b,beta) =
  ((alpha*a+beta*b) scaled (1/(alpha+beta)));
enddef;

% Barycentre de trois points
% testé avec succés le 4 avril
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
def barytrois (expr a,alpha,b,beta,c,gamma) =
  ((alpha*a+beta*b+gamma*c) scaled (1/(alpha+beta+gamma)));
enddef;

% CDG
% testé avec succés le 4 avril
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
def centredegravite (expr a,b,c) =
  ((a+b+c) scaled 1/3);
enddef;

% Orthocentre
% testé avec succés le 4 avril
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
vardef orthocentre (expr a,b,c) =
  save $;
  pair $;
  ($-a) rotated 90=whatever*(b-c);
  ($-b) rotated 90=whatever*(a-c);
  $
enddef;

% Centre Cercle Circonscrit
% testé avec succés le 4 avril
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
vardef centrecerclecirconscrit (expr a,b,c) =
  save $;
  pair $;
  ($-1/2[a,b]) rotated 90=whatever*(a-b);
  ($-1/2[a,c]) rotated 90=whatever*(a-c);
  $
enddef;

% Cercle Circonscrit
% testé avec succés le 4 avril
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
vardef cerclecirconscrit (expr a,b,c) =
  save $,p;
  pair $;
  path p;
  $=centrecerclecirconscrit(a,b,c);
  p=fullcircle scaled (2*abs($-a)) shifted $;
  p
enddef;

% Centre Cercle Inscrit
% testé avec succés le 4 avril
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
vardef centrecercleinscrit (expr a,b,c) =
  save $;
  pair $;
  ($-a)=whatever*(b-a) rotated (1/2*(angle(c-a)-angle(b-a)));
  ($-b)=whatever*(c-b) rotated (1/2*(angle(a-b)-angle(c-b)));
  $
enddef;

% Cercle inscrit
% testé avec succés le 4 avril
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
vardef cercleinscrit (expr a,b,c) =
  save I,M,p;
  pair I,M;
  path p;
  I=centrecercleinscrit(a,b,c);
  ((M-I) rotated 90)=whatever*(b-a);
  M=whatever[a,b];
  p=fullcircle scaled (2*(abs(M-I))) shifted I;
  p
enddef;

% Projeté
% testé avec succés le 4 avril
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
vardef projete (expr a,b,c) =
	% projeté de a sur (bc)
  save $;
  pair $;
  $=whatever[b,c];
  (($-a) rotated 90)=whatever*(b-c);
  $
enddef;

% Rotation
% testé avec succès le 11 juin
% modifié le 16 juin
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
vardef rotation@# (expr p,o) =
	% image de p (pair, path ou picture)
	% dans la rotation (o,theta)
	% X'=MX-MA+A(=MX-(M-I)A)
  transform T;
  pair d[];
  save $;
  if path p :	path $;
  elseif picture p : picture $;
  else : pair $;
  fi 
  xxpart T=yypart T=cosd(@#);
  -xypart T=yxpart T=sind(@#);
  xpart T=ypart T=0;
  d0=o transformed T;
  d1=-d0+o;
  $=p transformed T shifted d1;
  $
enddef;

% Symétrie Axiale
% testé avec succés le 4 avril
% amélioré le 11 juin
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
vardef symetrieaxiale (expr p,a,b) =
	% symétrique de p (pair, path ou picture)
	% par rapport à (ab)
	% X'=P-1MP.X-P-1MP.A+A
  transform T;
  pair d[];
  save theta,$;
  if path p :	path $;
  elseif picture p : picture $;
  else : pair $;
  fi 
  theta=2*angle(b-a);
  xxpart T=-yypart T=cosd(theta);
  xypart T=yxpart T=sind(theta);
  xpart T=ypart T=0;
  d0=a transformed T;
  d1=-d0+a;
  $=p transformed T shifted d1;
  $
enddef;

% Symétrie Centrale
% testé avec succés le 4 avril
% amélioré le 11 juin
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
vardef symetriecentrale (expr p,o) =
	% symétrique de p par rapport à o
  rotation180(p,o)
enddef;

% repérage d'angle
% modifié le 17 juin 2001
% testé avec succès le 2 juin
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
vardef note_angle@# (expr a,o,b,e) =
	% flêche sur le secteur angulaire
	% orienté (vec(oa),vec(ob))
	% avec éloignement barycentrique 
	% de la flêche du centre du secteur
	% angulaire
  save fig,$;
  picture fig,$;
  pair d[];
  numeric ang[];
  fig=currentpicture;currentpicture:=nullpicture;
  ang1=angle(a-o);
  ang2=angle(b-o);
  for i:=0 upto (@#-1) :
    d[2*i-1]=(e*(1+0.1*i))[o,a];
    (d[2*i]-o)=(d[2*i-1]-o) rotated (ang2-ang1);
    draw d[2*i-1]{dir (ang1+90)}..d[2*i]{dir (ang2+90)};
  endfor;
  $=currentpicture;currentpicture:=nullpicture;
  draw fig;
  $
enddef;

vardef noteangle (expr a,o,b,e) =
  save $,d,ang;
  path $;
  pair d[];
  numeric ang[];
  ang1=angle(a-o);
  ang2=angle(b-o);
  d1=o+e*unitvector(a-o);
  (d2-o)=(d1-o) rotated (ang2-ang1);
  $=d1{dir (ang1+90)}..d2{dir (ang2+90)};
  $
enddef;

% chemin flêché
% testé avec succès le 2 juin
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
vardef cheminfleche (expr a,b,e) =
	% flêche sur le segment [ab]
	% avec éloignement barycentrique
  save $;
  path $;
  $=b--a--e[a,b];
  $
enddef;

% notation d'angle droit
% testé avec succès le 2 juin
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
vardef noteangledroit (expr a,o,b,e) =
	% petit carré de l'angle droit
	% avec éloignement  e
  save $;
  path $;
  pair d[];
  d1=o+e*unitvector(a-o);
  (d2-o)=(d1-o) rotated 90;
  (d3-o)=(d1-o)+(d2-o);
  $=d1--d3--d2;
  $
enddef;

% tracé de droite
% testé avec succès le 24 octobre
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
vardef droite@# (expr a,b) =
	% droite qui dépasse de 15%
	% aux extrêmités données
  save $,t;
  path $;
  t=@#/100;
  $=(1+t)[a,b]--(-t)[a,b];
  $
enddef;

% tracé d'un cube sans points   
% testé avec succès le 31 août 2002
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
vardef cube (expr depart,dimarete) =
  save fig,cube,chemin;
  pair sommetCube[];
  path chemin;
  picture fig,cube;
  fig=currentpicture;
  currentpicture:=nullpicture;
  sommetCube[0]=depart;
  sommetCube[1]=sommetCube[0] shifted (dimarete,0);
  (sommetCube[3]-sommetCube[0])=(sommetCube[1]-sommetCube[0]) scaled .5 rotated 35;
  (sommetCube[2]-sommetCube[1])=(sommetCube[0]-sommetCube[1]) scaled .5 rotated (-145);		
  for i:=0 upto 3 :
    sommetCube[i+4]=sommetCube[i] shifted (0,dimarete);
  endfor
  draw sommetCube[0]--sommetCube[1]--sommetCube[2]--sommetCube[6]--
  sommetCube[5]--sommetCube[4]--cycle;
  draw sommetCube[1]--sommetCube[5];
  draw sommetCube[0]--sommetCube[3]--sommetCube[7] dashed evenly;
  draw sommetCube[2]--sommetCube[3] dashed evenly;
  draw sommetCube[4]--sommetCube[7]--sommetCube[6];
  cube=currentpicture;
  currentpicture:=fig;
  cube
enddef;

% nommage d'un cube
% testé avec succès le 31 août 2002
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
def nommecube =
  label.llft(btex $A$ etex, sommetCube[0]);
  label.lrt(btex $B$ etex, sommetCube[1]);
  label.rt(btex $C$ etex, sommetCube[2]);
  label.lft(btex $D$ etex, sommetCube[3]);
  label.ulft(btex $E$ etex, sommetCube[4]);
  label.top(btex $F$ etex, sommetCube[5]);
  label.urt(btex $G$ etex, sommetCube[6]);
  label.ulft(btex $H$ etex, sommetCube[7]);
enddef;



% tracé d'un téraèdre style
% testé avec succès le 31 août 2002
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
vardef tetraedre (expr depart,unite) =
  save fig,tetra,chemin;
  pair sommetTetraedre[];
  path chemin;
  picture fig,tetra;
  fig=currentpicture;
  currentpicture:=nullpicture;
  sommetTetraedre[0]=depart;
  sommetTetraedre[1]=sommetTetraedre[0] shifted (2.5unite,-1unite);
  sommetTetraedre[2]=sommetTetraedre[0] shifted (4.5unite,0.5unite);
  sommetTetraedre[3]=sommetTetraedre[0] shifted (2.8unite,3unite);
  draw sommetTetraedre[0]--sommetTetraedre[1]--sommetTetraedre[2]
  --sommetTetraedre[3]--cycle;
  draw sommetTetraedre[1]--sommetTetraedre[3];
  draw sommetTetraedre[0]--sommetTetraedre[2] dashed evenly;
  tetra=currentpicture;
  currentpicture:=fig;
  tetra
enddef;

vardef tetraedreregulier (expr depart,unite) =
  save fig,tetra,chemin;
  pair sommetTetraedre[];
  path chemin;
  picture fig,tetra;
  fig=currentpicture;
  currentpicture:=nullpicture;
  sommetTetraedre[0]=depart;
  sommetTetraedre[1]=sommetTetraedre[0] shifted (2.8unite,-1unite);
  sommetTetraedre[2]=sommetTetraedre[0] shifted (5unite,0);
  sommetTetraedre[3]=sommetTetraedre[0] shifted (2.5unite,3unite);
  draw sommetTetraedre[0]--sommetTetraedre[1]--sommetTetraedre[2]
  --sommetTetraedre[3]--cycle;
  draw sommetTetraedre[1]--sommetTetraedre[3];
  draw sommetTetraedre[0]--sommetTetraedre[2] dashed evenly;
  tetra=currentpicture;
  currentpicture:=fig;
  tetra
enddef;
% nommage d'un tétraèdre
% testé avec succès le 31 août 2002
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
def nommetetraedre =
  label.top(btex $A$ etex, sommetTetraedre[3]);
  label.llft(btex $B$ etex, sommetTetraedre[0]);
  label.bot(btex $C$ etex, sommetTetraedre[1]);
  label.rt(btex $D$ etex, sommetTetraedre[2]);
enddef;

% marque un segment

marksize=4pt;
vardef draw_mark (expr p,a) =
  pair dm;
  save t, dm;
  t=arctime a of p;
  dm=univector direction t of p rotated 90;
  draw (-.5dm.. .5dm) shifted point t of p;
enddef;

vardef draw_marked (expr p,n) =
  save amid;
  amid=.5*arclength p;
  for i=-(n-1)/2 upto (n-1)/2 :
    draw_mark(p, amid+.6marksize*i);
  endfor
%  draw p;
enddef;



% macro de V. Zonnekind.
vardef patate =
  save i; numeric i;
  for i=0 upto 10:
    ( (.5+uniformdeviate(.2), 0) rotated (360/10*i) ) ..
  endfor cycle
enddef;

% macro de C. Poulain
vardef hachurage(expr chemin, angle, ecart, trace)suffix couleur =
  save $;
  picture $;
  path support;
  support=(((-37cm,0))--((37cm,0))) rotated angle;
  if trace=1:
    drawoptions(dashed evenly);
  elseif trace=2:
    drawoptions(dashed dashpattern(on12bp off6bp on3bp off6bp));
  fi;
  $ = image(
    for j=-200 upto 200:
      if ((support shifted (ecart*j*(1,0))) intersectiontimes chemin)<>(-1,-1):
	draw support shifted (ecart*j*(1,0)) 
	withcolor if str couleur="":(0,0,0) else:couleur fi;
      fi
    endfor;
    );
  clip $ to chemin;
  drawoptions();
  $
enddef;

%% mes hachures à moi que j'ai !
vardef meshachures(expr chemin, angle, ecart)suffix motif  =
  save $,c,segment,K,debut,fin,l;
  picture $,c;
  path segment;
  pair debut,fin,K;

  if str motif="" : drawoptions(dashed evenly) else :
    drawoptions(dashed dashpattern(motif));
  fi;
  
  c:=image(draw chemin);
  if angle>=0 :
    K=whatever[ulcorner(c),llcorner(c)]
    =whatever[lrcorner(c),(llcorner(c) rotatedaround (lrcorner(c),angle))];
    segment := ulcorner(c)--K
  else : 
    K=whatever[urcorner(c),lrcorner(c)]
    =whatever[llcorner(c),(lrcorner(c) rotatedaround (llcorner(c),angle))];
    segment := urcorner(c)--K
  fi;

  l:=ecart/cosd(angle);

  $:=image(
    i:=0;
    forever :
      if i=0 : debut = point 0 of segment else :
	debut := debut shifted (0,-l) fi;
      i:=1;
      
      if angle >=0 :
	fin:=whatever[urcorner(c),lrcorner(c)]
	=whatever[debut,(debut shifted (lrcorner(c)-llcorner(c)) rotatedaround(debut,angle))]
      else:
	fin:=whatever[ulcorner(c),llcorner(c)]
	=whatever[debut,(debut shifted (llcorner(c)-lrcorner(c)) rotatedaround(debut,angle))]
      fi;
      
      exitif ypart debut < ypart K;
      draw debut--fin;
    endfor
    );
  clip $ to chemin;
  drawoptions();
  $
enddef;


%% vonkoch, j est le niveau de récursivité
%% testé avec succès le 11 avril 2004
vardef vonkoch (expr i,j) =
  save base,c,n;
  path base,c[];
  pair n[];
  %% arrivé à j=0, on arrête
  if j=0 : i else :
    %% n0 et n1 désigne les extrêmités du "motif"
    n0:=point 0 of i;
    n3:=point infinity of i;
    n1:=(1/3)[n0,n3];
    n2:=(2/3)[n0,n3];
    %% construction du nouveau motif
    base=i shifted -n0 scaled (1/3) shifted n0;
    c0=base shifted (n1-n0) rotatedaround(n1,60);
    c1=base shifted (n1-n0) rotatedaround(n2,-60);
    c2=base shifted (n2-n0);
    %% récursivité
    vonkoch(base--c0--c1--c2,j-1)
  fi
enddef;

verbatimtex
\end{document}
etex
