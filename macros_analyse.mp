% fichier de macros METAPOST
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

maux:=1cm;
mauy:=1cm;

vardef exp (expr x) = (mexp(256)**x) enddef;
vardef ln  (expr x) = (mlog(x)/256)  enddef;
vardef log (expr x) = (ln(x)/ln(10)) enddef;

vardef trace (suffix f)(expr a,b,inc) =
  save i; numeric i;
  for i=a step inc until b:
    (i, f(i)) --
  endfor (b, f(b))
enddef;

vardef fonctionTab@#(suffix f)(expr a,b,inc)=
  j:=0;
  for i:=a step inc until b:
    j:=j+1;
    @#[j]:=f(i);
  endfor;
  @#[0]:=j;
enddef;

vardef lemax@#=
  save lm;
  lm:=@#[1];
  for i:=1 upto @#[0]:
    if @#[i] > lm:
      lm:=@#[i];
    fi;
  endfor;
  lm
enddef;

vardef lemin@#=
  save lm;
  lm:=@#[1];
  for i:=1 upto @#[0]:
    if @#[i] < lm:
      lm:=@#[i];
    fi;
  endfor;
  lm
enddef;

vardef pointTrace (suffix f)(expr x) =
  (x,f(x))
enddef;

% cette macro utilise deux variables globales
% maux l'unité sur x
% mauy l'unité sur y
vardef fonctiontrace(suffix f)(expr a,b,incx,incy)text options=
  save tab,courbe,p;
  picture p[];
  path courbe;
  numeric tab[];
%
  fonctionTab.tab(f)(a,b,incx);
  monmax:=round(lemax.tab+.5);
  monmin:=round(lemin.tab-.5);
  if lemax.tab = round(lemax.tab):
  monmax:=lemax.tab;
  fi;
  if lemin.tab = round(lemin.tab):
  monmin:=lemin.tab;
  fi;
%
  dpctx:=(b-a)/10;
  dpcty:=(monmax-monmin)/10;
  p1:=axeh.ticks(a-dpctx,b+dpctx,incx,maux);
  p2:=axev.ticks(monmin-dpcty,monmax+dpcty,incy,mauy);
  %
  courbe:= trace(fonctionds)(a,b,(b-a)/100) xscaled maux yscaled mauy;
  %
  quadrillagerepere.limites(a,b,incx,monmin,monmax,incy) withcolor .6white;
  draw p1 withpen pencircle scaled 1bp;
  draw p2 withpen pencircle scaled 1bp;
  draw courbe options;
  draw (point 0 of courbe) withpen pencircle scaled 3bp;
  draw (point infinity of courbe) withpen pencircle scaled 3bp;
  courbe
enddef;


vardef quadrillagerepere@#(expr xmin, xmax, incx, ymin, ymax, incy)text options=
  @#[0]:=xmin-incx;
  @#[1]:=xmax+incx;
  @#[2]:=ymin-incy;
  @#[3]:=ymax+incy;
  for i:=@#[0] step incx until @#[1]:
    draw (i*maux,@#[2]*mauy)--(i*maux,@#[3]*mauy) options;
  endfor;
  for i:=@#[2] step incy until @#[3]:
    draw (@#[0]*maux,i*mauy)--(@#[1]*maux,i*mauy) options;
  endfor;
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
