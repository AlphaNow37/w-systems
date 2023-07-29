f = And @@ ({poly->4, offset->#, coef->1/3, nbEdges->4}& /@ {{0, Sqrt[2]}, {3*Sqrt[2], Sqrt[2]}});
system[
  {
    {}->f
  },
  {poly->4, color->White, nbEdges->4, border->Black},
  {n 0, 4}
]
