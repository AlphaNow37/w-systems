Manipulate[
 system[
   {
    {} -> {poly -> 3, offset -> {0,  0.5}, coef -> 1/2, nbEdges -> 3, 
      angle -> Pi, texture -> CurrentImage[]}
    },
   {poly -> 3, color -> Black, nbEdges -> 0, angle -> Pi} && {poly -> 3, 
     nbEdges -> 3, border -> White, coef -> 1/4, 
     offset -> {0, 1/2}, texture -> CurrentImage[]},
   n
   ] // Graphics,
   {n, 0, 6, 1}
 ]
 
