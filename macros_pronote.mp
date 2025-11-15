% fichier de macros METAPOST
% pour les CSV pronote
% création : novembre 2025
% david cobac

input macros_fichiers;
input boxes;

numeric baremes[];
boolean pronoteGbilanelevemultipage;
string eleves[][],pronoteGtaillepolice;
pronoteNbEleves:=0;
pronoteNbNotes:=0;
pronoteGinterbarre:=20pt;
pronoteGepaisbarre:=15pt;
pronoteGtaillepolice:="\small";
pronoteGbilanelevemultipage:=true;

% tracé d'un texte sous fond blanc
vardef _pronoteGtextefondblanc@#(expr s, xy)=
  save lbl;
  picture lbl;
  lbl:=image(label@#(s, xy));
  fill bbox(lbl) withcolor white;
  draw lbl;
enddef;

% tracé d'une barre pour la moyenne élève
vardef _pronoteGbarre(expr note,notemax,x,y)=
  save rect;
  path rect;
  rect := unitsquare xscaled (note * .5cm) yscaled pronoteGepaisbarre shifted (x, y-pronoteGepaisbarre/2);
  fill rect withcolor (note/notemax*green+((notemax-note)/notemax)*red);
enddef;

% tracé d'une barre pour la moyenne élève
% renvoie une image à tracer
vardef __pronoteGbarre(expr note,notemax,x,y)=
  save rect,pic,pct;
  picture pic;
  path rect;
  pct:=note/notemax;
  pic:=image(
      rect := unitsquare xscaled pct yscaled pronoteGepaisbarre shifted (x, y-pronoteGepaisbarre/2);
    fill rect withcolor (note/notemax*green+((notemax-note)/notemax)*red);
    );
  pic
enddef;

% tracé d'une marque pour une note obtenue
vardef _pronoteGnote(expr note,notemax,y)=
  fill unitsquare yscaled pronoteGepaisbarre shifted (note * .5cm, y-pronoteGepaisbarre/2);
enddef;

% grille de fond
% k = ordinal de note
vardef pronoteGgrille(expr k)=
  save l;
  l:=3+pronoteNbNotes-k;
  for i:=0 upto baremes[l]:
    draw pronoteGtraitv(i)
      withcolor (i/baremes[l]*green+((baremes[l]-i)/baremes[l])*red);
  endfor;
enddef;

% tracé d'une barre verticale sur l'ensemble du tableau
% note : la note à mettre en évidence
% renvoie un path
vardef pronoteGtraitv(expr note)=
  (note*.5cm, pronoteGinterbarre)--(note*.5cm, -pronoteNbEleves*pronoteGinterbarre)
enddef;

% trace le graphique d'une note pour la classe
% k ordinal de la note
vardef pronoteGclasse(expr k)=
  save l;
  l:=3+pronoteNbNotes-k;
  save interespace,notelue;
  interespace:=pronoteGinterbarre;
  for i:=0 upto pronoteNbEleves-1:
    label.lft(textext(pronoteGtaillepolice & "\bfseries " & eleves[i][1]), (0, -i*interespace));
    if _pronoteEstNoteValide(eleves[i][l]):
      notelue:=scantokens(eleves[i][l]);
      _pronoteGbarre(notelue,baremes[l], 0, -i*interespace);
    fi;
    _pronoteGtextefondblanc.rt(textext(pronoteGtaillepolice & "\bfseries " & eleves[i][l]), (0cm, -i*interespace));
  endfor;
enddef;

% trace une représentation classique pour un devoir donné
% k : ordinal de la note
vardef pronoteGdevoir(expr f,k)=
  save moy,juste,l,traits;
  path traits[];
  l:=3+pronoteNbNotes-k;
  pronoteCSVEleves(f, ";");
  pronoteGgrille(k);
  moy:=round(100*pronoteMoyenne(k))/100;
  traits0:=pronoteGtraitv(moy);
  draw traits0 withcolor .5*blue dashed evenly;
  label.top(textext(pronoteGtaillepolice & decimal(moy)),point 0 of traits0);
  juste:=baremes[l]/2;
  traits1:=pronoteGtraitv(juste);
  draw traits1 withcolor .5*blue withpen pensquare scaled 1bp;
  label.top(textext(pronoteGtaillepolice & decimal(juste)),point 0 of traits1);
  pronoteGclasse(k);
enddef;

vardef pronoteGtrimestre(expr f)=
  pronoteGdevoir(f, pronoteNbNotes+1);
enddef;

% f la chaine de la classe par exemple "seconde1"
% t numéro du trimestre
% n rang de l'élève
% largeur du cadre final
% graphique donné sous forme de pourcentages
vardef _pronoteGbilanelevetrimestre(expr f,t,n,largeur)=
  save $,l,note,pct,hauteur,barres,triangle,dep,moy;
  pair dep;
  path triangle;
  picture barres,$;
  string note,moy;
  %
  pronoteCSVEleves(f & "_tri" & decimal(t) & "_notes.csv", ";");
  %
  $:=image(
      barres:=image(
	for i:=1 upto pronoteNbNotes:
	l:=3+pronoteNbNotes-i;
	note:=eleves[n][l];
	if _pronoteEstNoteValide(note):
	  pct:=round(scantokens(note)/baremes[l]*100);
	  draw __pronoteGbarre(pct, 100, 0, -(i-1)*pronoteGinterbarre) xscaled largeur;
	  _pronoteGtextefondblanc.rt(textext(pronoteGtaillepolice & "\bfseries" & decimal(pct) & "\%"),
	      (0, -(i-1)*pronoteGinterbarre));
	fi;
      endfor;
      );
    hauteur:=(pronoteNbNotes-1)*pronoteGinterbarre + pronoteGepaisbarre;
  % grille
    for i:=0 step 10 until 100:
      draw (largeur/100*i, pronoteGepaisbarre/2)--(largeur/100*i, -hauteur+pronoteGepaisbarre/2);
      label.bot(textext(pronoteGtaillepolice & decimal(i) & "\%"), (0,0))
	scaled .5 shifted (largeur/100*i, -hauteur+pronoteGepaisbarre/2);
    endfor;
  % les barres
    draw barres;
  % cadre bilan
    draw unitsquare xscaled largeur yscaled hauteur shifted (0, -hauteur+pronoteGepaisbarre/2);
  %
    dep:=(0,-sqrt(3)/3*3mm);
    triangle:=dep--(dep rotated 120)--(dep rotated -120)--cycle;
  % positionnement moyenne élève
    moy:=eleves[n][2];
    if _pronoteEstNoteValide(moy):
      pct:=scantokens(moy)/20;
      fill triangle shifted (pct*largeur, +pronoteGepaisbarre/2-ypart(dep))
	withcolor pct*green+(1-pct)*red;
    fi;
  % positionnement moyenne de classe
    moy:=eleves[pronoteNbEleves][2];
    pct:=scantokens(moy)/20;
    draw triangle shifted (pct*largeur, +pronoteGepaisbarre/2-ypart(dep))
      withcolor pct*green+(1-pct)*red dashed evenly;
    );
  $
enddef;

% f la chaine de la classe par exemple "seconde1"
% t nombres de trimestre
% n rang de l'élève
% largeur du cadre final
% graphique donné sous forme de pourcentages
vardef pronoteGbilanelevetrimestre(expr f,t,n,largeur,espaceapres)=
  picture tri;
  if pronoteGbilanelevemultipage:
    draw (0,0)--(0,-29cm) withcolor white;
  fi;
  % Identité
  label.urt(textext(pronoteGtaillepolice & "\bfseries " & eleves[n][1]), (0,pronoteGepaisbarre/2));
  % les encadrés par trimestre
  dec:=0pt;
  for i:=1 upto t:
    label.rt(textext("\bfseries Trimestre" & decimal(i)), (0, dec));
    tri:=_pronoteGbilanelevetrimestre(f,i,n,largeur);
    draw tri shifted (0, dec - 12pt);
    dec:=dec + ypart(llcorner tri) - 12pt - 6pt;
  endfor;
  % espace final
  draw (0,dec)--(0,dec-espaceapres) withcolor white;
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
  save l;
  l:=3+pronoteNbNotes-k;
  save cumul,nb;
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
  l:=3+pronoteNbNotes-k;
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

% f fichier
% d le délimiteur
vardef pronoteCSVEleves(expr f,d)=
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
