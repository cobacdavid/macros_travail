% vardef TEX primary s =
%   write "verbatimtex"   to "mptextmp.mp";
%   write "\documentclass{article}"  to "mptextmp.mp";
%   write "\usepackage{aeguill}" to "mptextmp.mp";
%   write "\begin{document}"  to "mptextmp.mp";
%   write "etex"    to "mptextmp.mp";
%   write "btex " & s & " etex" to "mptextmp.mp";
%   write EOF to "mptextmp.mp";
%   scantokens "input mptextmp"
% enddef;

vardef newArbreDeProba@# (expr tr,ta,tb) text options=
  ExecuteOptions(@#)(options);
  assignObj(@#,"ArbreDeProba");
  StandardInterface;
%% les boites et arbres
  forsuffixes $= boiteR,boiteA,boiteNonA,boiteB,boiteNonB,boiteBB,boiteNonBB,root,brancheH,brancheB :
    save $;
    string $;
    $=newobjstring_;
  endfor;
%% les options, le texte  et eq
  forsuffixes $= tmp,ftmp, atmp, ttmp, vtmp, eq :
    save $;
    string $;
  endfor;
%% la gestion des options
  ftmp = if OptionValue@#("framed") :
      "framed(true)"
  else :
    "framed(false)"
  fi;
  atmp = "arrows("   & OptionValue@#("arrows")   & ")";
  ttmp = "treemode(" & OptionValue@#("treemode") & ")";
  vtmp = "vbsep(" & OptionValue@#("vbsep") & ")";
%% Boxes
  tmp = "$" & tr & "$";
  newBox.obj(boiteR)(textext(tmp)) ftmp;
  tmp:= "$" & ta & "$";
  newBox.obj(boiteA)(textext(tmp)) ftmp;
  tmp:= "$\overline{" & ta & "}$";
  newBox.obj(boiteNonA)(textext(tmp)) ftmp;
  tmp:= "$" & tb & "$";
  newBox.obj(boiteB)(textext(tmp)) ftmp;
  duplicateObj(obj(boiteBB),obj(boiteB));
  tmp:= "$\overline{" & tb & "}$";
  newBox.obj(boiteNonB)(textext(tmp)) ftmp;
  duplicateObj(obj(boiteNonBB),obj(boiteNonB));
%% Trees
  newTree.obj(brancheH)(obj(boiteA))(obj(boiteNonB),obj(boiteB)) ttmp, atmp, vtmp ;
  newTree.obj(brancheB)(obj(boiteNonA))(obj(boiteNonBB),obj(boiteBB)) ttmp, atmp, vtmp;
  newTree.obj(root)(obj(boiteR))(obj(brancheB),obj(brancheH)) ttmp, atmp, vtmp;
%% Subobjects
  SubObject(root,obj(root));

  eq = "@#c=obj(root).c;@#ne=obj(root).ne";

  ObjCode StandardEquations, eq;
  StandardTies;
enddef;
%%
def BpathArbreDeProba(suffix n)=
  StandardBpath(n)
enddef;
%%
def drawArbreDeProba (suffix n) =
  drawObj(obj(n.root));
  if OptionValue.n("Framed") :
    draw BpathArbreDeProba(n);
  fi;
enddef;
%%
setObjectDefaultOption("ArbreDeProba")("treemode")("R");
setObjectDefaultOption("ArbreDeProba")("framed")(false);
setObjectDefaultOption("ArbreDeProba")("arrows")("draw");
setObjectDefaultOption("ArbreDeProba")("Framed")(false);
setObjectDefaultOption("ArbreDeProba")("vbsep")("5mm");
%%
%%
%%
%%
%
vardef newCadreGraphique@# (expr l,L,xo,yo,ux,uy) text options =
  ExecuteOptions(@#)(options);
  assignObj(@#,"CadreGraphique");
  StandardInterface;
  %
  picture pp;
  pp=TEX "A";
  ObjPicture p;
  setPicture(p)(pp);
  newBox.n(pp);
  SubObject(subn,n);
  %
  ObjCode StandardEquations,
    "@#c=obj(@#subn).c" , "@#ne=obj(@#subn).ne" ;
  StandardTies;
enddef;

def BpathCadreGraphique(suffix n)=
  StandardBpath(n)
enddef;

vardef drawCadreGraphique (suffix n) =
  drawObj(obj(n.subn));
enddef;

% beginfig(1);
%   u=1cm;
%   newCadreGraphique.c(10,5,1,1,u,u/2);
%   c.c=origin;
%   drawObj(c);
% endfig;

% end
