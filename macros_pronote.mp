% fichier de macros METAPOST
% pour les CSV pronote
% création : novembre 2025
% david cobac

input macros_fichiers;
input macros_geo;

numeric baremes[],classement[];
string eleves[][],pronoteGstylepolice;
color pronoteGcouleurdepart,pronoteGcouleurarrivee;
boolean pronoteGnb;
pronoteNbEleves:=0;
pronoteNbNotes:=0;
pronoteGinterbarre:=20pt;
pronoteGepaisbarre:=15pt;
pronoteGstyle:=1;
pronoteGstylepolice:="\bfseries\small ";
pronoteGcouleurdepart=red;
pronoteGcouleurarrivee=green;
pronoteGnb:=false;
pronoteGlargeurtotale:=10cm;


% tracé d'un texte sous fond blanc
vardef _pronoteGtextefondblanc@#(expr s, xy)=
  save lbl;
  picture lbl;
  lbl:=image(label@#(s, xy));
  fill bbox(lbl) withcolor white;
  draw lbl;
enddef;

% tracé d'une barre pour les graphiques des classes.
vardef _pronoteGbarre(expr pct,dimtot,x,y)=
    save rect;
    path rect;
    rect := unitsquare xscaled (pct*dimtot) yscaled pronoteGepaisbarre
      shifted (x,y-pronoteGepaisbarre/2);
    rect
enddef;

% tracé d'une barre pour les graphiques des classes.
vardef _pronoteGbarrealt(expr pct,dimtot,x,y)=
  save $,limite,tranche,nb,decalage,occup,dimx,posx,reste;
  picture $;
  tranche:=5;
  occup:=5;
  nb:=100/tranche;
  limite:=floor(pct*nb);
  decalage:=((tranche-occup)/2)/100;
  dimx:=occup/100 * dimtot;
  $:=image(
    % les points entiers
      for i:=1 upto limite:
      posx:= x + decalage*dimtot + (i-1)*dimtot/nb;
      fill unitsquare xscaled dimx yscaled pronoteGepaisbarre
	shifted (posx,y-pronoteGepaisbarre/2)
	withcolor (i/nb*pronoteGcouleurarrivee+((nb-i)/nb)*pronoteGcouleurdepart);
    endfor;
    % le reste 
    reste:=pct*nb - limite;
    posx:= x + limite*dimtot/nb;
    dimx:= reste*occup/100 * dimtot;
    fill unitsquare xscaled dimx yscaled pronoteGepaisbarre
	shifted (posx,y-pronoteGepaisbarre/2)
	withcolor ((limite+1)/nb*pronoteGcouleurarrivee+((nb-(limite+1))/nb)*pronoteGcouleurdepart);
    );
  $
enddef;

% grille de fond
% k = ordinal de note
vardef _pronoteGgrille(expr k,largeurzone)=
  save l,trait;
  path trait[];
  _pronoteTraitOrdi.l(k);
  % fond
  trait0:=_pronoteGtraitv(0,largeurzone);
  trait1:=_pronoteGtraitv(1,largeurzone);
  if not pronoteGnb:
    fill (point 0 of trait0) -- (point 0 of trait1)
      -- (point 1 of trait1) -- (point 1 of trait0) -- cycle withcolor .95white;
  fi;
  % trait et graduation
  for i:=0 upto baremes[l]:
    trait0:=_pronoteGtraitv(i/baremes[l],largeurzone);
    if pronoteGnb:
      draw trait0;
    else:
      draw trait0 withcolor (i/baremes[l]*pronoteGcouleurarrivee+((baremes[l]-i)/baremes[l])*pronoteGcouleurdepart);
    fi;
    label.bot(textext(pronoteGstylepolice & decimal(i)), (0,0))
      scaled .5 shifted (point 1 of trait0);
  endfor;
enddef;

% tracé d'une barre verticale sur l'ensemble du tableau
% note : la note à mettre en évidence
% renvoie un path
vardef _pronoteGtraitv(expr pct,largeurzone)=
  (pct * largeurzone, pronoteGinterbarre)--(pct * largeurzone, -pronoteNbEleves*pronoteGinterbarre)
enddef;

% trace le graphique d'une note pour la classe
% juste les barres, pas la grille etc.
% k ordinal de la note
% classt : booléen : on dessine un classement ou pas
vardef _pronoteGbarresclasse(expr k,classt,largeurzone)=
  save l,rect,pct,notelue,p;
  picture p;
  path rect;
  %
  _pronoteTraitOrdi.l(k);
%
  if classt:
    _pronoteTri(k);
  fi;
  %
  for i:=0 upto pronoteNbEleves-1:
    j:=if classt: classement[i] else: i fi;
    %
    label.lft(textext(pronoteGstylepolice & eleves[j][1]),
	(0, -i*pronoteGinterbarre));
    %
    if _pronoteEstNoteValide(eleves[j][l]):
      notelue:=scantokens(eleves[j][l]);
      pct:=notelue/baremes[l];
      %
      if pronoteGstyle=1:
      rect:=_pronoteGbarre(pct, largeurzone, 0, -i*pronoteGinterbarre);
      %
	if pronoteGnb:
	  fill rect withcolor white;
	  draw rect withpen pensquare scaled 1bp;
	  draw meshachures(rect, 50, (.5+3*(1-pct))*1mm) withpen pensquare scaled 1bp;
	else:
	  fill rect withcolor (pct*pronoteGcouleurarrivee+(1-pct)*pronoteGcouleurdepart);
	fi;
      else:
	draw _pronoteGbarrealt(pct, largeurzone, 0, -i*pronoteGinterbarre);
      fi;
      %
      _pronoteGtextefondblanc.rt(textext(pronoteGstylepolice & eleves[j][l]),
	  (0cm, -i*pronoteGinterbarre));

    fi;
  endfor;
enddef;

vardef _pronoteGversdevoir(expr f,t,k,tri)=
  save fichier,kp,moy,l,traits,p,$;
  picture p,$;
  path traits[];
  string fichier;
  fichier:=f & "_tri" & decimal(t) & "_notes.csv";
  _pronoteCSVEleves(fichier, ";");
  %
  _pronoteTraitOrdi.l(k);
  if k=0:
    kp:=pronoteNbNotes+1;
  else:
    kp:=k;  
  fi;
  % Pour respecter la dimension pronoteGlargeurtotale venant de la
  % demande de l'utilisateur, il faut calculer la place prise par
  % les identités
  p:=image(
      for i:=0 upto pronoteNbEleves-1:
      label.lft(textext(pronoteGstylepolice & eleves[i][1]),
	  (0,0));
    endfor;
    );
  largeurZonenote:=pronoteGlargeurtotale + xpart(ulcorner p);
  % grille + traits + barres 
  $:=image(
      _pronoteGgrille(kp,largeurZonenote);
    moy:=round(100*pronoteMoyenne(kp))/100;
    %
    traits0:=_pronoteGtraitv(moy/baremes[l],largeurZonenote);
    traits1:=_pronoteGtraitv(0.5,largeurZonenote);
    if pronoteGnb:
      draw traits0 withpen pensquare scaled .7bp;
      draw traits1 withpen pensquare scaled 1bp;
    else:
      draw traits0 withcolor .5*blue dashed evenly;
      draw traits1 withcolor .5*(pronoteGcouleurarrivee+pronoteGcouleurdepart)
	withpen pensquare scaled 1bp;
    fi;
    %
    label.top(textext(pronoteGstylepolice & decimal(moy)),point 0 of traits0);
    %
    _pronoteGbarresclasse(kp,tri,largeurZonenote);
    );
  $
enddef;

% trace une représentation classique pour un devoir donné
% k : ordinal de la note
vardef pronoteGdevoir(expr f,t,k)=
  _pronoteGversdevoir(f,t,k,false)
enddef;

vardef pronoteGclassementdevoir(expr f,t,k)=
  _pronoteGversdevoir(f,t,k,true)
enddef;

% % f par exemple "seconde1"
% % k le numéro du trimestre
% vardef pronoteGtrimestre(expr f, k)=
%   pronoteGdevoir(fichier, pronoteNbNotes+1)
% enddef;

% f la chaine de la classe par exemple "seconde1"
% t numéro du trimestre
% n rang de l'élève
% largeur du cadre final
% graphique donné sous forme de pourcentages
vardef _pronoteGbilanelevetrimestre(expr f,t,n,largeur)=
  save $,l,note,pct,hauteur,barres,triangle,dep,moy,rect;
  pair dep;
  path triangle,rect;
  picture barres,$;
  string note,moy;
  %
  $:=image(
      barres:=image(
	for i:=1 upto pronoteNbNotes:
	l:=3+pronoteNbNotes-i;
	note:=eleves[n][l];
	if _pronoteEstNoteValide(note):
	  pct:=scantokens(note)/baremes[l];
	  rect:=_pronoteGbarre(pct,largeur,0,-(i-1)*pronoteGinterbarre);
	  fill rect withcolor (pct*pronoteGcouleurarrivee+(1-pct)*pronoteGcouleurdepart);
	  _pronoteGtextefondblanc.rt(
	      textext(pronoteGstylepolice & "\bfseries" & decimal(round(pct*100)) & "\%"),
	      (0, -(i-1)*pronoteGinterbarre));
	fi;
      endfor;
      );
    hauteur:=(pronoteNbNotes-1)*pronoteGinterbarre + pronoteGepaisbarre;
  % grille
    for i:=0 step 10 until 100:
      draw (largeur/100*i, pronoteGepaisbarre/2) --
	(largeur/100*i, -hauteur+pronoteGepaisbarre/2);
      label.bot(textext(pronoteGstylepolice & decimal(i) & "\%"), (0,0))
	scaled .5 shifted (largeur/100*i, -hauteur+pronoteGepaisbarre/2);
    endfor;
  % les barres
    draw barres;
  % cadre bilan
    draw unitsquare xscaled largeur yscaled hauteur
      shifted (0, -hauteur+pronoteGepaisbarre/2);
  %
    dep:=(0,-sqrt(3)/3*3mm);
    triangle:=dep--(dep rotated 120)--(dep rotated -120)--cycle;
  % positionnement moyenne élève
    moy:=eleves[n][2];
    if _pronoteEstNoteValide(moy):
      pct:=scantokens(moy)/20;
      fill triangle shifted (pct*largeur, +pronoteGepaisbarre/2-ypart(dep))
	withcolor pct*pronoteGcouleurarrivee+(1-pct)*pronoteGcouleurdepart;
    fi;
  % positionnement moyenne de classe
    moy:=eleves[pronoteNbEleves][2];
    pct:=scantokens(moy)/20;
    draw triangle shifted (pct*largeur, +pronoteGepaisbarre/2-ypart(dep))
      withcolor pct*pronoteGcouleurarrivee+(1-pct)*pronoteGcouleurdepart dashed evenly;
    );
  $
enddef;

% f la chaine de la classe par exemple "seconde1"
% t nombre de trimestre
% n rang de l'élève
% largeur du cadre final
% graphique donné sous forme de pourcentages
vardef pronoteGbilanelevetrimestre(expr f,t,n,largeur,espaceapres)=
  save tri,lbltri,$;
  picture tri,lbltri,$;
  % Identité
  _pronoteCSVEleves(f & "_tri" & decimal(1) & "_notes.csv", ";");
  $:=image(
      label.urt(textext(pronoteGstylepolice & "\bfseries " & eleves[n][1]),
	(0,pronoteGepaisbarre/2));
  % les encadrés par trimestre
    dec:=0pt;
    for i:=1 upto t:
      _pronoteCSVEleves(f & "_tri" & decimal(i) & "_notes.csv", ";");
      lbltri:=textext("\bfseries Trimestre" & decimal(i) & " : "  & eleves[n][2]);
      label.rt(lbltri, (0, dec));
      tri:=_pronoteGbilanelevetrimestre(f,i,n,largeur);
      draw tri shifted (0, dec - 12pt);
      dec:=dec + ypart(llcorner tri) - 12pt - 6pt;
    endfor;
  % espace final
    draw (0,dec)--(0,dec-espaceapres) withcolor white;
    );
  draw $;
enddef;

% renvoie une chaîne après traitement de la chaîne représentant une
% note dans un CSV pronote notamment : enlève les doubles
% guillemets. On renvoie une chaîne car parfois il n'y a plus rien
% (pas de note) auquel cas la conversion avec scantokens
% échouerait.
vardef _pronoteConversionNote(expr s)=
  save s_;
  string s_;
  s_:=virguleVersPoint(s);
  lngc:=length(s_);
  substring (1, lngc-1) of s_
enddef;

% fonction booléenne qui valide une châine comme étant valide pour
% lecture d'une note -> scantokens possible
vardef _pronoteEstNoteValide(expr s)=
  (s <> "") and (s <>"Abs") and (s <>"X")
enddef;

% Traite les notes du kieme devoir. tab[i][k] a déjà subi
% _pronoteConversionNote. La note moyenne est renvoyée sous la forme
% d'un nombre compris entre 0 et 1 : normalisée.
% tab : le tableau dim2 des notes (eleves)
% bareme : le tableau dim1  des baremes
% k  : la colonne des notes (nombre)
% tot : le nombre d'élèves dans la colonne
vardef pronoteMoyenneN(expr k)=
  save l,cumul,nb;
  _pronoteTraitOrdi.l(k);
  cumul:=0;
  nb:=0;
  for i:=0 upto pronoteNbEleves-1:
    if _pronoteEstNoteValide(eleves[i][l]):
      cumul:=cumul+scantokens(eleves[i][l])/baremes[l];
      nb:=nb+1;
    fi;
  endfor;
  cumul/nb
enddef;

vardef pronoteMoyenne(expr k)=
  save l;
  _pronoteTraitOrdi.l(k);
  pronoteMoyenneN(k) * baremes[l]
enddef;

% voir doc sur le calcul de la moyenne
% l'écart-type renvoyé est aussi entre 0 et 1
vardef pronoteEcarttype(expr k)=
  save l;
  l:=3+pronoteNbNotes-k;
  save cumul,nb,moy,notenormalisee;
  cumul:=0;
  nb:=0;
  for i:=0 upto pronoteNbEleves-1:
    if _pronoteEstNoteValide(eleves[i][l]):
      notenormalisee:=scantokens(eleves[i][l])/baremes[l];
      cumul:=cumul+notenormalisee*notenormalisee;
      nb:=nb+1;
    fi;
  endfor;
  moy:=pronoteMoyenne(k);
  sqrt(cumul/nb - moy*moy)
enddef;

% alimente le tableau global classement avec des entiers
% correspondants au rang des élèves selon leur classement par les
% notes d'ordinal k
vardef _pronoteTri(expr k)=
  save l,noteeleve, i;
  string noteeleve,noteavant;
  %
  _pronoteTraitOrdi.l(k);
  %
  classement[0]:=0;
  for i:=1 upto 28:
    noteeleve:=eleves[i][l];
    pos:=i;
    classement[i]:=pos;
    if _pronoteEstNoteValide(noteeleve):
      forever:
	exitif pos=0;
	noteavant:=eleves[classement[pos-1]][l];
	if _pronoteEstNoteValide(noteavant):
	  % comparaison
	  exitif scantokens(noteavant) >= scantokens(noteeleve);
	  tmp:=classement[pos-1];
	  classement[pos-1]:=i;
	  classement[pos]:=tmp;
	else:
	  % echange avec une note non valide
	  tmp:=classement[pos-1];
	  classement[pos-1]:=i;
	  classement[pos]:=tmp;
	fi;
	pos:=pos-1;
      endfor;
    fi;
  endfor;
enddef;

% tableau à tracer
% extrait de eleves les données à tracer :
% k : ordinale de la note
% identité, note
% vardef _pronoteTabatracer@#(expr k)=
%   for i:=0 upto pronoteNbNotes-1:
%     @#[1]:=eleves[i][1];
%     @#[2]:=eleves[i][l];
%   endfor;
% enddef;

%
vardef _pronoteTraitOrdi@#(expr k)=
  @#:=3+pronoteNbNotes-k;
  if k=0:
    @#:=2;
  fi;
enddef;

% f fichier
% d le délimiteur
vardef _pronoteCSVEleves(expr f,d)=
  save s_nb,ggnote,notegg,notegg_;
  %,eleves;
  string s_nb,ggnote,notegg,notegg_;
  %,eleves[][];
  % le tableau baremes commence à l'indice 2
  % numeric baremes[];
  cumul:=0;
  cumulcarre:=0;
  i:=0;
  j:=0;
  % lecture du fichier
  forever:
    % la variable ligne est le tableau lu
    exitunless ligneFichier.ligne(f, d);
    % ligne0 : nombre de données dans la ligne (sans ligne0)
    % ligne1 : identité
    % ligne2 : moyenne courante
    % ligne 3 ...ligne[ligne0] : les notes
    if i=0: % première ligne : dates
      % 2 colonnes ne sont pas des notes dans ligne (sans compter
      % ligne0 qui ne se compte pas lui-même)
      % la colonne des moyennes n'est pas comptabilisé dans
      % le nombre de notes suivant
      pronoteNbNotes:=scantokens(ligne0) - 2;
    elseif i=1: % deuxième ligne les coef et le barème
     % nombre d'élèves (par exemple ""29 élèves""
      splitChaine.infoNb(ligne1, " ");
      pronoteNbEleves:=scantokens(infoNb1);
     % la moyenne générale en indice 2 du CSV est sur 20
      baremes[2]:=20;
      for i:=3 upto scantokens(ligne0):
	if estDans(ligne[i], "/"):
	  splitChaine.infoNote(ligne[i], "/");
	  baremes[i]:=scantokens(infoNote2);
	else:
	  baremes[i]:=20;
	fi;
      endfor;
    elseif i>=2: % les notes des élèves
      j:=i-2;
      % découpage de l'identitév de l'élève
      splitChaine.identite(ligne1, " ");
      % variables eleve
      eleves[j][0]:=ligne0;
      eleves[j][1]:=substring (1, length(ligne1)-1) of ligne1;
      % double guillemetage !! sur les champs récupérés
      notegg:=_pronoteConversionNote(ligne2);
      % parfois pas de note -> on passe
      if notegg<>"":
	eleves[j][2]:=notegg;
	for k:=3 upto scantokens(ligne0):
	  notegg_:=_pronoteConversionNote(ligne[k]);
	  eleves[j][k]:=notegg_;
	endfor;
      else:
	for k:=2 upto scantokens(ligne0):
	  eleves[j][k]:="";
	endfor;
      fi;
    fi;
    i:=i+1;
  endfor;
enddef;
