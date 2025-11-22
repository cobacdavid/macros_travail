% fichier de macros METAPOST
% création : novembre 2025
% david cobac

boolean debugFichier;
debugFichier:=false;

% teste l'existence d'un caractère dans une chaine
vardef estDans(expr s,c)=
  save i;
  i:=0;
  forever:
    exitif (i>length(s)) or (substring(i,i+1) of s=c);
    i:=i+1;
  endfor;
  i<=length(s)
enddef;


% Splite une chaine s selon un délimiteur d, les résultats vont dans
% un tableau de strings stockés avec le suffixe passé
% renvoie le nombre d'éléments trouvés
% @#[0] contient le nombre n d'éléments
% @#[1]...@#[n] sont les éléments
vardef splitChaine@#(expr s,d) =
  save n,i,j;
  string @#[];
  n:=0;
  i:=0;
  j:=0;
  forever:
    exitif i >= length(s);
    %
    forever:
      exitif (substring(j, j+1) of s = d) or (j > length(s));
      j:=j+1;
    endfor;
    %
    @#[incr n]=substring(i, j) of s;
    i:=j+1;      
    j:=i;
  endfor;
  % on stocke le nombre de données sous forme de string
  % utilisation de scantokens pour récupérer l'entier
  @#[0]:=decimal(n);
enddef;

% convertit le caractère c en caractère d dans la chaine s
vardef caraVersCara(expr s, c, d) =
  save result_s, cara;
  string result_s, cara;
  result_s := ""; 
  for i=0 upto length(s):
    cara := substring(i,i+1) of s;
    if cara=c:
      result_s := result_s & d;
    else:
      result_s :=result_s & cara;
    fi;
  endfor;
  result_s
enddef;

% Fonction raccourci pour transformer les , en .
vardef virguleVersPoint(expr s)=
  caraVersCara(s, ",", ".")
enddef;


% inspiré de Grdln_@# du fichier graph.mp
% lecture d'une ligne du fichier f comportant des données séparées
% par un délimiteur d, les résultats vont dans un tableau dont le
% nom est donné par le suffixe.
vardef ligneFichier@#(expr f,d) =
  save s_,n_;
  string s_;
  s_ = readfrom f;
  if s_<>EOF:
    splitChaine@#(s_, d);
    % @# est un tableau de strings -> conversion en int
    n_:=scantokens(@#[0]);
    if debugFichier:
      string t_;
      t_:= "ligne " & s_ & " : " & decimal(n_) & " données lues";
      show t_;
    fi;
    @#1 <> ""
  else:
    false
  fi
enddef;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
pronoteNbEleves:=0;
pronoteNbNotes:=0;

% tracé d'une barre pour la moyenne élève
vardef pronoteGbarre(expr note,notemax,x,y)=
  save rect;
  path rect;
  rect := unitsquare xscaled (note * .5cm) yscaled 6pt shifted (x, y-3pt);
  fill rect withcolor (note/notemax*green+((notemax-note)/notemax)*red);
enddef;

% tracé d'une marque pour une note obtenue
vardef pronoteGnote(expr note,notemax,y)=
  fill unitsquare yscaled 6pt shifted (note * .5cm, y-3pt);
enddef;

% grille de fond
vardef pronoteGgrille(expr k, notemax)=
  for i:=0 upto notemax:
    draw pronoteGtraitv(i)
      withcolor (i/notemax*green+((notemax-i)/notemax)*red);
  endfor;
enddef;

% tracé d'une barre verticale sur l'nsemble du tableau
vardef pronoteGtraitv(expr note)=
  (note*.5cm, 10pt)--(note*.5cm, -pronoteNbEleves*10pt)
enddef;

% trace le graphique d'une note pour la classe
% tab: tableau des élèves
% k : colonne de notes à représenter
vardef pronoteGclasse(suffix tab, bareme)(expr k)=
  save interespace,notelue;
  interespace:=10pt;
  for i:=0 upto pronoteNbEleves-1:
    label.lft(textext("\tiny\bfseries " & tab[i][1]), (0, -i*interespace));
    if (tab[i][k] <> "") and (tab[i][k]<>"Abs") and (tab[i][k]<>"X"):
      notelue:=scantokens(tab[i][k]);
      pronoteGbarre(notelue,bareme[k], 0, -i*interespace);
    fi;
    label.rt(textext("\tiny\bfseries " & tab[i][k]), (0cm, -i*interespace));
  endfor;
enddef;

% renvoie une chaîne après traitement de la chaîne représentant une
% note dans un CSV pronote notamment : enlève les doubles
% guillemets. On renvoie une chaîne car parfois il n'y a plus rien
% (pas de note) auquel cas la conversion avec scantokens
% échouerait.
vardef pronoteConversionNote(expr s)=
  save s_;
  string s_;
  s_:=virguleVersPoint(s);
  lngc:=length(s_);
  substring (1, lngc-1) of s_
enddef;

% Traite les notes du kieme devoir. tab[i][k] a déjà subi
% pronoteConversionNote. La note moyenne est renvoyée sous la forme
% d'un nombre compris entre 0 et 1.
% tab : le tableau dim2 des notes (eleves)
% bareme : le tableau dim1  des baremes
% k  : la colonne des notes (nombre)
% tot : le nombre d'élèves dans la colonne
vardef pronoteMoyenne(suffix tab, bareme)(expr k)=
  save cumul,nb;
  cumul:=0;
  nb:=0;
  for i:=0 upto pronoteNbEleves-1:
    if (tab[i][k] <> "") and (tab[i][k]<>"Abs") and (tab[i][k]<>"X"):
      cumul:=cumul+scantokens(tab[i][k])/bareme[k];
      nb:=nb+1;
    fi;
  endfor;
  cumul/nb
enddef;

% voir doc sur le calcul de la moyenne
% l'écart-type renvoyé est aussi entre 0 et 1
vardef pronoteEcarttype(suffix tab, bareme)(expr k)=
  save cumul,nb,moy,notenormalisee;
  cumul:=0;
  nb:=0;
  for i:=0 upto pronoteNbEleves-1:
    if (tab[i][k] <> "") and (tab[i][k]<>"Abs") and (tab[i][k]<>"X"):
      notenormalisee:=scantokens(tab[i][k])/bareme[k];
      cumul:=cumul+notenormalisee*notenormalisee;
      nb:=nb+1;
    fi;
  endfor;
  moy:=pronoteMoyenne(tab, bareme)(k, tot);
  sqrt(cumul/nb - moy*moy)
enddef;

% f fichier
% d le délimiteur
vardef pronoteCSVEleves(expr f,d)=
  save s_nb,ggnote,notegg,notegg_,eleves;
  string s_nb,ggnote,notegg,notegg_,eleves[][];
  % le tableau bareme commence à l'indice 2
  numeric bareme[];
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
      % ligne0 qui ne se sompte as lui-même)
      pronoteNbNotes:=scantokens(ligne0) - 2;
    elseif i=1: % deuxième ligne les coef et le barème
     % nombre d'élèves (par exemple ""29 élèves""
      splitChaine.infoNb(ligne1, " ");
      pronoteNbEleves:=scantokens(infoNb1);
     % la moyenne générale en indice 2 du CSV est sur 20
      bareme[2]:=20;
      for i:=3 upto scantokens(ligne0):
	if estDans(ligne[i], "/"):
	  splitChaine.infoNote(ligne[i], "/");
	  bareme[i]:=scantokens(infoNote2);
	else:
	  bareme[i]:=20;
	fi;
      endfor;
    elseif i>=2: % les notes des élèves
      j:=i-2;
      % découpage de l'identitév de l'élève
      splitChaine.identite(ligne1, " ");
      % variables eleve
      eleves[j][0]:=ligne0;
      eleves[j][1]:=substring (1, length(ligne1)-1) of ligne1;
      % nb:=scantokens(identite[0]);
      % double guillemetage !! sur les champs récupérés
      notegg:=pronoteConversionNote(ligne2);
      % prenom:= substring (0, length(identite[nb]) - 1) of identite[nb];
      % label.lft(textext(prenom), (0, -j*10pt));
      % parfois pas de note -> on passe
      if notegg<>"":
	eleves[j][2]:=notegg;
        % prenom en fin de champs -> on doit enlever le guillemet de fin
	note:=scantokens(notegg);
        % on divise les notes par 20 -> on évite "Value is too Large"
	% cumul:=cumul+note/20;
	% cumulcarre:=cumulcarre+note*note/400;
	% tracé pour un élève
        % tracé de la barre -> une fonction à la place ?
	  % pronoteGmoyenne(note,0,-j*10pt);
	% Un point permet de visualiser une note
	for k:=3 upto scantokens(ligne0):
	  notegg_:=pronoteConversionNote(ligne[k]);
	  eleves[j][k]:=notegg_;
	  %if (notegg_<>"") and (notegg_<>"Abs") and (notegg_<>"X"):
	      %notetempo:=scantokens(notegg_)/bareme[k]*20;
	      %pronoteGnote(notetempo, bareme[k], -j*10pt);
	  %fi;
	endfor;
	%
        % on conserve la dernière note moyenne pour l'enlever au cumul
        % la dernière ligne est celle de la moyenne de classe
	derniereNote:=note/20;
	nbPresents:= nbPresents+1;
      else:
	for k:=2 upto scantokens(ligne0):
	  eleves[j][k]:="";
	endfor;
      fi;
    fi;
    i:=i+1;
  endfor;

  % la grille
  pronoteGgrille(pronoteNbEleves, 30);
  % moyenne : on enlève la dernière ligne
  % moynorm:=(cumul-derniereNote)/(nbPresents-1); % vérifiée
  % moyenne:=20*moynorm; % vérifiée
  % ecart-type
  % et:=20*sqrt((cumulcarre-derniereNote*derniereNote)/(nbPresents-1)-moynorm*moynorm); % vérifié
  
  % Ligne verticale globale de la Moyenne
  % on a retiré 2 lignes
  % k:=i-2;
  % label.lft(textext("\bfseries Moyenne"), (0, (-k+1)*10pt));
  % draw (moyenne * .5cm, 10pt)--(moyenne * .5cm, -k*10pt)
  %   dashed withdots withpen pencircle scaled 2.5pt
  %   withcolor white;
  % draw (moyenne * .5cm, 10pt)--(moyenne * .5cm, -k*10pt)
  %   dashed withdots withpen pencircle scaled 2pt
  %   withcolor (moyenne/20*green+((20-moyenne)/20)*red);

  % Ligne verticale globale de 10
  % draw (10 * .5cm, 10pt)--(10 * .5cm, -k*10pt)
  %   withpen pensquare scaled 2.5pt
  %   withcolor white;
  % draw (10 * .5cm, 10pt)--(10 * .5cm, -k*10pt)
  %   withpen pensquare scaled 2pt
  %   withcolor .5*(red+green);

  %
  pronoteGclasse(eleves, bareme)(3);
enddef;
