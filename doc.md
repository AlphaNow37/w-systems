# The w systems documentation

## Vocabulary
axiom: the situation at the begin, at iteration 0

rules: a list of pair condition-effect

niter: the number of iterations, of application of the rules

place: an association containing all the informations on the parent

matcher: The function f(place)->bool associated to a condition

transformer: The function f(place)->{graphics, new places} associated to a effect

radius of a polygon: the external radius, from the center to all the vertices

## The entry points
There is 4 functions you can use as a user:

- `system[ rules, axiom, niter ]`
  
  Calculate the graphics list at iteration niter.
  Note that you need to pass it into `Graphics` yourself

  Exemple: `system[{{}->{poly->3}}, {poly->4}, 4] // Graphics`
  
- `systemList[ rules, axiom, niter ]`
  
  Same as system, but return all frames beetween 0 and niter
  
- `animesystem[ rules, axiom, niter, ..Options ]`
  
  Return an animation of all the frames
  
- `systemManipulate[ rules, axiom, {n, start, stop} ]`
  
  `systemManipulate[ rules, axiom, {n, start, stop} graphfn: Graphics ]`
  
  Return a manipulator showing the state at iterarion n, with n in range {i1, i2, 1}
  The graphfn is optionnal, and allow change the graphics options

## The rule syntax
A rule consist of two parts: the condition and the effect. 

### Exemples
`condition->effect` is a rule
`{ cond1->eff1, cond2->eff2 }` is a list of two rules

### Tags
The folowing tags are built-in:
| Name(s) | Description |
|---|---|
| Pnsides / poly | The number of sides (>=3) |
| PsideIndex / edge | The placement on the parent, counting counterclockwise, where 1 is the first edge after the base |
| color | The filling color |
| border | The border color |
| opacity | The opacity, in the range [0-1] |
| texture | The texture (image, ...) |
| Pangle | the absolute angle |
| Pxy | the absolute position |
| Pradius | the external radius |

### The condition syntax
A condition can be multiple things
| name | syntax |  description | usage |
|---|---|---|---|
| Condition list | `{A, B, ...}` | All conditions {A, B, ...} must be verified | `{color->Red, poly->3}` match a red triangle |
| Probabilities | `proba->P` | This condition has a probability of P to be verified | `proba->0.75` match 75% of the time |
| Custom function | `custom->F` | This condition is verified when F[place] return True | `custom->(#Pnsides>4&)` match any shape with 5 or more sides. |
| Tag list | `tag->values` | The parent's field tag must be contained in values | `poly->{4, 5}` match a square or a pentagon |
| Tag equality | `tag->value` | The parent's field tag must be equal to value | `poly->4` match a square |


### The effect system
An effect can have one of the following form:
| name | syntax |  description | usage |
|---|---|---|---|
| list | `{T1, T2, ...}` | Just apply all the transformer T1, T2, ... | `{color->Red, poly->4}` |
| list of list | `{L1, L2, ...}` | Apply L1 on the first edge, L2 on the second, ... | `cond->{{poly->4}, {poly->5}}` <=> `{cond, edge->1}->{poly->4}, {cond, edge->2}->{poly->5}` |
| custom | `custom[F]` | return the result of the transformer F | `custom[{{RegularPolygon[3]}, {}}&]` just place a triangle |
| and | `L1 && L2` | Apply L1 and L2 on the same place | `{poly->3} && {poly->4}` place a triangle and a square |

An effect list have the following options:
| name | syntax |  description | usage |
|---|---|---|---|
| polygon | `poly->N` | Place a polygon with N sides | `{poly->4}` place a square |
| coef | `coef->C` | The child's radius will be C times the parent's radius (default: 0.5) | `coef->1` don't change the size |
| angle | `angle->A` | The child will be rotated by A radians (default: 0) | `angle->Pi` flip the polygon |
| offset | `offset->{X, Y}` | Move the child relatively to the parent, by `{X, Y}*child's radius` (default: {0, 0}) | `offset->{1, 1}` move the child to the outside right |
| nbEdges | `nbEdges->N` | The number of childs the child could have (default: poly-1 because we don't place child on the base) | `poly->4, ..., nbEdges->4` allow the square to have 4 childs |
| color |  `color->C` | Fill the polygon with the color C; note: if nexts shapes don't specify color, this color will be applied | `color->Red` create a red polygon |
| border | `border->B` | Set the border to B, which can be any EdgeForm valid parameter. None reset it. Same as color, it apply on next shapes | `border->{Red, Thick}` create a thick red border and `border->Green` just a green border |
| texture | `texture->T` | Set the texture to T, which can be an image of anything else | `texture->img` will put img on the polygon |
| addvar | `addvar-><\|"name"->value, ...\|>` | set the tag name to value for each new place | `addvar-><\|"i"->0\|>` add the tag i with value 0 |
| evolver | `evolver->F` | Join the data of F[place] and newplace for each new place | `evolver->(<\|"i"->#i+1\|>&)` set all new place tag i to the current value of i plus 1 |

  note that, for most of them, you can pass a function which is called every time the effect is applied.

  usage: `color->(RandomColor[]&)`or `color->(#i&)`
