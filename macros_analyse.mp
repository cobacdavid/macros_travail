% fichier de macros METAPOST
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

verbatimtex
\documentclass{article}
\usepackage{prof}
\begin{document}
etex


vardef exp (expr x) = (mexp(256)**x) enddef;
vardef ln  (expr x) = (mlog(x)/256)  enddef;
vardef log (expr x) = (ln(x)/ln(10)) enddef;

vardef trace (suffix f)(expr a,b,inc) =
    save i; numeric i;
    for i=a step inc until b:
      (i, f(i)) ..
    endfor (b, f(b))
  enddef;

vardef pointTrace (suffix f)(expr x) =
  (x,f(x))
enddef;
  
vardef suite (suffix f)(expr debut,nb) =
  save x,c;
  path c;
  x=debut;
  for i=0 upto nb :
    c:= if i=0 :(x,0) else : c fi --(x,f(x))--(f(x),f(x));
    x:=f(x);
  endfor;
  c
enddef;

vardef tangente (suffix f)(expr x)=
  save b,d,v,c,T;
  pair d;
  path v,c,T;
  
  v=(x,-infinity)--(x,+infinity);
  c=trace(f,x-.1,x+.1,.001);
  (whatever,t) = v intersectiontimes c;
  d=unitvector(direction t of c);
  %%(b,0) - (point t of c) = whatever*d;
  T=(-d--d) shifted (point t of c);
  %%T = (point t of c) -- (b,0);
  T
enddef;

vardef pointTangente (suffix f)(expr x)=
  save b,d,v,c;
  pair d,p;
  path v,c;
  
  v=(x,-infinity)--(x,+infinity);
  c=trace(f,x-.1,x+.1,.001);
  (whatever,t) = v intersectiontimes c;
  d=unitvector(direction t of c);
  %%(b,0) - (point t of c) = whatever*d;
  p=(point t of c) shifted d;
  %%T = (point t of c) -- (b,0);
  p
enddef;

verbatimtex
\end{document}
etex
