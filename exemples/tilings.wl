(*4-uniform tilings*)
animsystem[
  {
    {poly-> 3, color -> Yellow, edge -> {1,2,3}} -> {poly -> 4, color -> Red, coef -> 1/0.811},
    {poly -> 4, color -> Red, edge -> {1,3}}-> {poly -> 3, color -> Blue, coef -> 0.811},
    {poly -> 4, color -> Red, edge -> {2}}-> {poly -> 4, color -> Green, coef -> 1},
    {poly -> 4, color -> Green, edge -> {1,3}} -> {poly -> 6, color -> Orange, coef -> 1.4},
    {poly -> 4, color -> Green, edge -> {2}} -> {poly -> 4, color -> Gray, coef -> 1},
    {poly -> 4, color -> Gray, edge -> {2}}-> {poly -> 3, color -> Yellow , coef -> 0.811},
    {poly -> 4, color -> Gray, edge -> {1,3}} -> {poly -> 3, color -> Blue, coef -> 0.811},
    {poly -> 6, color -> Orange, edge -> {3}} -> {poly -> 6, color -> Hue[0.9], coef -> 1}
  },
  {poly -> 3, nbEdges -> 3, color -> Yellow , border -> Black},
  15,
  FrameRate -> 3
]

animsystem[{{poly->3,color->Yellow,edge->1}->{poly->4,color->Red,coef->1.225`},{poly->3,color->Yellow,edge->2}->{poly->4,color->Orange,coef->1.225`},{poly->4,color->Red,edge->2}->{poly->3,color->Green,coef->0.816`},{poly->3,color->Green,edge->2}->{poly->4,color->Blue,coef->1.225`},{poly->3,color->Green,edge->1}->{poly->4,color->Orange,coef->1.225`},{poly->4,color->Blue,edge->2}->{poly->3,color->Yellow,coef->0.816`},{poly->4,color->Orange,edge->2}->{poly->4,color->Yellow,coef->1},{poly->4,color->Yellow,edge->2}->{poly->4,color->Hue[0.8`],coef->1},{poly->4,color->Hue[0.8`],edge->2}->{poly->4,color->Hue[0.5`],coef->1},{poly->4,color->Hue[0.5`],edge->2}->{poly->4,color->Hue[0.23`],coef->1},{poly->4,color->Orange,edge->3}->{poly->6,color->Green,coef->1.41`},{poly->4,color->Yellow,edge->{1,3}}->{poly->3,color->Blue,coef->0.816`},{poly->4,color->Hue[0.8`],edge->3}->{poly->6,color->Green,coef->1.41`},{poly->4,color->Hue[0.5`],edge->{1,3}}->{poly->3,color->Blue,coef->0.816`},{poly->4,color->Hue[0.23`],edge->3}->{poly->6,color->Green,coef->1.41`},{poly->4,color->Hue[0.23`],edge->2}->{poly->3,color->Green,coef->0.816`,angle->(4 \[Pi])/3}},{poly->3,nbEdges->3,angle->\[Pi]/6,color->Yellow,border->Black},30,FrameRate->4]

animsystem[{
{poly -> 4, color -> Hue[0.6]}-> {poly -> 3, color ->Hue[0.15], coef -> 0.811},
{poly -> 3, color -> Hue[0.15], edge -> 1} -> {poly -> 3, color -> Hue[0.1], coef ->1},
{poly -> 3, color -> Hue[0.15], edge -> 2} -> {poly -> 4, color -> Red, coef -> 1.225},
{poly -> 3, color ->Hue[0.1], edge -> 2} -> {poly -> 3, color -> Hue[0.16], coef -> 1},
{poly -> 3, color -> Hue[0.16], edge -> 1} -> {poly -> 4, color -> Hue[0.59], coef -> 1.225},
{poly -> 4, color -> Hue[0.59]} -> {poly -> 3, color -> Hue[0.145], coef -> 0.811},
{poly -> 3, color -> Hue[0.145], edge -> 2} -> {poly -> 3, color -> Hue[0.11], coef -> 1},
{poly -> 3, color -> Hue[0.11],edge -> 1} -> {poly -> 3, color -> Hue[.147], coef ->1},
{poly -> 3, color -> Hue[.147],edge -> 2} -> {poly -> 4, color -> Hue[0.6], coef ->1.225}
},
{poly -> 4, nbEdges -> 4, angle -> Pi/6, color -> Hue[0.6], border -> Black},20, FrameRate -> 4]

