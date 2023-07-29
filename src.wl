
(* constants *)

(* the emplacement where the axiom is placed *)
BASEEMP = <|"Pxy" -> {0, -Sqrt[2]/2}, "Pangle" -> 0, "Pradius" -> 1, 
   "Pnsides" -> 4, "PsideIndex" -> 1, "hastexture" -> False|>;


(* geometric Part *)
ClearAll[polyreg, getAngle, getIntRad, getPoly];

(* return a rotated RegularPolygon, where an edge is parallel to the \
y axis *)
polyreg[xy_, {r_, a_}, n_] := RegularPolygon[xy, {r, Pi/n + a}, n];
(* return the angle of a regular polygon *)
getAngle[nsides_] := Pi/2 - Pi/nsides;
(* Return the internal radiusof the polygon *)
getIntRad[extRad_, nsides_] := extRad * Sin[getAngle[nsides]];
(* a transformer that place a regular polygon and find the newest \
emplacements *)
getPoly = With[
    {
     angle = #Pangle + 2 #PsideIndex Pi/#Pnsides,
     mradius = #Pradius * #Mcoef
     },
    With[
     {
      xy = #Pxy
        + {Cos[angle], Sin[angle]} * (
          getIntRad[#Pradius, #Pnsides]
           + getIntRad[mradius, #Mnsides]
           + #Mxy[[2]]*mradius
          )
        + {Sin[angle], -Cos[angle]} * #Mxy[[1]]*mradius,
      mangletotal = angle + Pi + #Mangle
      },
     {
      {
       If[
        #hastexture,
        Polygon[  (* slower, but supports textures *)
         
         CirclePoints[
          xy, {mradius, Pi/#Mnsides + mangletotal}, #Mnsides], 
         
         VertexTextureCoordinates -> 
          CirclePoints[{1/2, 1/2}, {1/2, Pi/#Mnsides - Pi/2}, #Mnsides]
         ],
        RegularPolygon[
         xy, {mradius, Pi/#Mnsides + mangletotal}, #Mnsides] (* 
        faster *)
        ]
       }, 
      Table[
       <| 
        "Pnsides" -> #Mnsides,
        "Pxy" -> xy,
        "Pangle" -> mangletotal,
        "Pradius" -> mradius, 
        "PsideIndex" -> i,
        "hastexture" -> False
        |>,
       {i, 1, #MnbEdges}
       ]
      }
     ]
    ] &;

(* matcher conversions *)
ClearAll[creatematcher];

MATCHERRENAMINGS = {poly -> Pnsides, edge -> PsideIndex}; 

(* creatematcher return a function f(emplacement) -> bool *)
creatematcher[option_ -> value_List] :=  
  empl |-> MemberQ[value, empl[option // ToString]];
creatematcher[custom -> f_] :=  
  emp |-> Quiet[Check[f[emp], False , Function::slota], 
    Function::slota];
creatematcher[proba -> p_] :=  emp |-> RandomReal[] < p;
creatematcher[option_ -> value_] := 
  empl |-> empl[option // ToString] == value;
creatematcher[optionlist_List] :=
  With[{matchers = optionlist // Map[creatematcher]}, 
   empl |-> AllTrue[#[empl] & /@ matchers, TrueQ]]; 

(* transformer conversion *)
ClearAll[createtransformer, colorier, polyT, bordersT, 
  createTransformerAss, EmptyT, AndT, addVarT, evolveVarT, valueFunc, 
  textureT];

(* the color transformer *)
colorierT[c_, t_] := emp |-> With[
    {res = t[emp], color = c[emp]},
    {Prepend[res[[1]], color], 
     res[[2]] // Map[Append["color" -> color]]}
    ];
(* the border transformer *)
bordersT[c_, t_] := emp |-> With[
    {res = t[emp], color = c[emp]},
    {Prepend[res[[1]], (EdgeForm[color] /. None -> Sequence[])], 
     res[[2]] // Map[Append["edgeform" -> color]]}
    ];
(* the texture transformer *)
textureT[c_, t_] := emp |-> With[
    {res = t[Append[emp, "hastexture" -> True]], text = c[emp]},
    {Prepend[res[[1]], Texture[text]], 
     res[[2]] // Map[Append["texture" -> text]]}
    ];
(* the texture transformer *)
opacityT[o_, t_] := emp |-> With[
    {res = t[emp], op = o[emp]},
    {Prepend[res[[1]], Opacity[op]], 
     res[[2]] // Map[Append["opacity" -> op]]}
    ];
(* the poly transformer *)
polyT[nsides_, coef_, xy_, angle_, nbEdges_] := emp |-> Join[
     emp, 
     <|"Mnsides" -> nsides[emp], "Mcoef" -> coef[emp], 
      "Mxy" -> xy[emp], "Mangle" -> angle[emp], 
      "MnbEdges" -> nbEdges[emp]|>
     ] // getPoly;
(* multiple shapes at the same emplacement *)
AndT[ts_] := emp |-> With[
    {
     rs = Through[ts[emp]]
     },
    {Flatten[rs[[All, 1]]], Flatten[rs[[All, 2]]]}
    ];
(* do not create anything *)
emptyT := emp |-> {{}, {}};
(* add a var to all new emplacements *)
addVarT[vars_Association, t_] := With[
   {vals = vars /. {(key_ -> val_) -> (ToString[key] -> val)}},
   emp |-> With[
     {res = t[emp]},
     {res[[1]], res[[2]] // Map[newemp |-> Join[newemp, vars]]}
     ]
   ];
addVarT[vars_List, t_] := addVarT[vars // Association, t];
addVarT[var_Rule, t_] := addVarT[{var} // Association, t];
(* evolve a var, adding it from all new emplacements using the last \
value *)
evolverT[ev_Function, t_] := emp |-> With[
    {
     res = t[emp], 
     vals = ev[emp]
     },
    {res[[1]], res[[2]] // Map[newemp |-> Join[newemp, vals]]}
    ];

(* convert any user value into a function emp->value *)
valueFunc[v_Function] := v;
valueFunc[v_] := emps |-> v;

(* convert any type of raw transformer into an association *)
createtransformer[a_ && b_] := AndT[createtransformer /@ {a, b}];
createtransformer[custom[f_]] := 
  emp |-> Quiet[Check[f[emp], False , Function::slota], 
    Function::slota];
createtransformer[v_List] := createTransformerAss[Association[v]];
createtransformer[v_Association] := createTransformerAss[v];
createtransformer[v_Rule] := createTransformerAss[Association[{v}]];

(* main function *)
createTransformerAss[v_Association] := Which[
   KeyExistsQ[v, color],
   colorierT[v[color] // valueFunc, 
    KeyDrop[v, color] // createTransformerAss],
   KeyExistsQ[v, border],
   bordersT[v[border] // valueFunc, 
    KeyDrop[v, border] // createTransformerAss],
   KeyExistsQ[v, texture],
   textureT[v[texture] // valueFunc, 
    KeyDrop[v, texture] // createTransformerAss],
   KeyExistsQ[v, opacity],
   opacityT[v[opacity] // valueFunc, 
    KeyDrop[v, opacity] // createTransformerAss],
   KeyExistsQ[v, evolver],
   evolverT[v[evolver], KeyDrop[v, evolver] // createTransformerAss],
   KeyExistsQ[v, addvar],
   addVarT[v[addvar], KeyDrop[v, addvar] // createTransformerAss],
   KeyExistsQ[v, poly],
   polyT[
    v[poly] // valueFunc,
     Lookup[v, Key[coef], 0.5] // valueFunc,
    Lookup[v, Key[offset],  {0, 0}] // valueFunc,
     Lookup[v, Key[angle], 0] // valueFunc,
    Lookup[v, Key[nbEdges], (emp |-> valueFunc[v[poly]][emp] - 1)] // 
     valueFunc
    ],
   True,
   emptyT
   ];
r = createtransformer[{color -> Red, poly -> 8}][BASEEMP];
r[[1]] // Graphics[#, Axes -> True] &;

(*Case where the user give rules with only one result*)
associationlist[
  left_ -> right_] := {(left /. MATCHERRENAMINGS) -> right}
(*Case where the user give rules with multiple results*)
associationlist[left_ -> {right__List}] := Table[
  Join[left, {PsideIndex -> a}] -> {right}[[a]],
  {a, 1, {right} // Length}
  ]

(* convert a rule left->right *)
convertrule[left_ -> right_] := {creatematcher[left], 
   createtransformer[right]};


(* main nest loop *)
ClearAll[nextFrame, advanceBy]

(*Boucle*)
nextFrame[{emps_, graphics_, rules_}] := With[
   {r = emps (*liste des precedants emplacements*)
        // 
        Map[emp |-> {emp, 
           SelectFirst[rules, (#[[1]][emp]) &]}]  (*{emp,
       1ere_rule_qui_match_ou_Missing}*)
       // Select[(! MissingQ[#[[2]]]) &]   (*{emp,
      1ere_rule_qui_match}*)
      // Map[(#[[2, 2]][#[[1]]]) &]   (*resultats des transformers*)
    },
   {Flatten[r[[All, 2]], 1], Join[graphics, Flatten[r[[All, 1]]], 1], 
    rules}  (*on met ca en forme pour le prochain nest*)
   ];

(*donne la situation a l\[CloseCurlyQuote]index niter*)
advanceBy[emps_, graphics_, rules_, niter_] := 
  Nest[nextFrame, {emps, graphics, rules}, niter];
advanceByList[emps_, graphics_, rules_, niter_] := 
  NestList[nextFrame, {emps, graphics, rules}, niter];

(* user public interface *)
ClearAll[system, animsystem, systemList, systemManipulate];
system[rawRules_, base_, niter_] := With [
    {
     baseres = createtransformer[base][BASEEMP],
     rules = 
      rawRules // Map[associationlist] // Flatten[#, 1] & // 
       Map[convertrule]
     },
    advanceBy[baseres[[2]], baseres[[1]],  rules, niter]
     ][[2]];
Options[animsystem] := {AnimationRepetitions -> \[Infinity], 
  AnimationRunning -> True, DefaultDuration -> Automatic, 
  FrameRate -> Automatic, ImageSize -> Automatic, 
  RasterSize -> Automatic, RefreshRate -> Automatic}
animsystem[rawRules_, base_, niter_, options : OptionsPattern[]] := 
 AnimatedImage[(Image[Graphics[#]] &) /@ (With[
      {
       baseres = createtransformer[base][BASEEMP],
       rules = 
        rawRules // Map[associationlist] // Flatten[#, 1] & // 
         Map[convertrule]
       },
      advanceByList[baseres[[2]], baseres[[1]],  rules, niter]
      ][[All, 2]]), options, Sequence @@ Options[animsystem]]

systemList[rawRules_, base_, niter_] := With [
    {
     baseres = createtransformer[base][BASEEMP],
     rules = 
      rawRules // Map[associationlist] // Flatten[#, 1] & // 
       Map[convertrule]
     },
    advanceByList[baseres[[2]], baseres[[1]],  rules, niter]
     ][[All, 2]];

systemManipulate[rawRules_, base_, {n, i1_, i2_}, 
   graphfn_ : Graphics] := With [
   {
    baseres = createtransformer[base][BASEEMP],
    rules = 
     rawRules // Map[associationlist] // Flatten[#, 1] & // 
      Map[convertrule]
    },
   Module[
    {
     state = {baseres[[2]], baseres[[1]],  rules},
     lst = {baseres[[1]] // graphfn}
     },
    Manipulate[
     If[
      Length[lst] <= n,
      state = nextFrame[state];
      lst = Append[lst, state[[2]] // graphfn];
      0
      ]; lst[[Min[n + 1, Length[lst]]]],
     {n, i1, i2, 1}
     ]
    ]
   ];
