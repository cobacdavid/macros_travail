vardef TEX primary s =
  write "verbatimtex"   to "mptextmp.mp";
  write "\documentclass{article}"  to "mptextmp.mp";
  write "\usepackage{aeguill}" to "mptextmp.mp";
  write "\usepackage[frenchb]{babel}" to "mptextmp.mp";
  write "\usepackage{numprint}" to "mptextmp.mp";
  write "\begin{document}"  to "mptextmp.mp";
  write "etex"    to "mptextmp.mp";
  write "btex " & s & " etex" to "mptextmp.mp";
  write EOF to "mptextmp.mp";
  scantokens "input mptextmp"
enddef;
input metaobj;
input latexmp;
input macros_analyse;
input macros_const;
input macros_geo;
input macros_graphe;
input macros_repere;
%input macros_stat;
input macros_metaobj;
