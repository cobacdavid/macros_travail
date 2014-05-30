% fichier de macros METAPOST
% création le 3 juillet 2003
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

input boxes;

verbatimtex
\documentclass{article}
\usepackage{prof}
\begin{document}
etex

% renvoie un chemin courbe de a vers b
vardef liencourbe (suffix a,b) =
  save theta;
  theta=angle(b.c-a.c);
  a.c{dir(theta+15)}..{dir(theta-15)}b.c cutbefore bpath.a cutafter bpath.b
enddef;

% affiche une ponderation sur un chemin courbe
vardef ponderation@# (suffix a,b)(text t) =
  save q;path q;
  q=liencourbe(a,b);
  label.@#(t,point .5 of q);
enddef;

% affiche une ponderation sur un chemin courbe
vardef pondseul@#(expr p)(text t) =
  label.@#(t,point .5 of p);
enddef;


% renvoie un segment de a vers b
vardef lien (suffix a,b) =
    a.c--b.c cutbefore bpath.a cutafter bpath.b
enddef;

% renvoie un segment orienté de a vers b
vardef lienoriente (suffix a,b) =
    a.c--b.c cutbefore bpath.a cutafter bpath.b
enddef;

% crée un sommet (petit cercle vide)
vardef sommet (suffix a) (expr couple,t) =
  circleit.a();
  if color t :
    fill bpath.a withcolor t;
    draw bpath.a;
  fi
  a.c=couple;
enddef;

vardef sommetcouleur (suffix a) (expr couple) (expr couleur) =
  circleit.a();
  a.c=couple;
  fill bpath.a withcolor couleur;
  draw bpath.a;
enddef;

verbatimtex
\end{document}
etex
