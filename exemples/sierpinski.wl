Row[{
  systemManipulate[
    {
      {} -> {poly -> 3, offset -> {0, 0.5`}, coef -> 1/2, nbEdges -> 3, angle -> \[Pi]}
    },
    {poly -> 3, color -> Black, nbEdges -> 0} && {poly -> 3, nbEdges -> 3,  border -> White, angle -> \[Pi], coef -> 1/4,  offset -> {0, 1/2}},
    {n, 0, 6}
  ], 
  systemManipulate[
    {
      {color -> Black} -> {angle -> Pi, poly -> 3, offset -> {0, Sqrt[3]/4}, nbEdges -> 3, color -> Black}
    },
    {poly -> 3, color -> White, coef -> 1, offset -> {0, -(1/4)}} && {poly -> 3, color -> Black, nbEdges -> 3, angle -> Pi}, 
    {n, 0, 6}
  ], 
  systemManipulate[
    {
      {edge -> {1, 3, 5}} -> {poly -> 6, offset -> {0, -(Sqrt[3]/2)}}
    }, 
    {poly -> 6, color -> Black,  nbEdges -> 6, border -> White},
    {n, 0, 7}
  ]
}]
