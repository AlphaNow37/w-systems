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
  
- `systemList[ rules, axiom, niter ]`
  
  Same as system, but return all frames beetween 0 and niter
  
- `animesystem[...]`
  
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

### The condition syntax
A condition can be multiple things
| name | syntax |  description | usage |
|---|---|---|---|
| Condition list | `{A, B, ...}` | All conditions {A, B, ...} must be verified | `{color->Red, poly->3}` match a red triangle |
| Probabilities | `proba->P` | This condition has a probability of P to be verified | `proba->0.75` match 75% of the time |
| Custom function | `custom->F` | This condition is verified when F[place] return True | `custom->(#Pnsides>4&)` match any shape with 5 or more sides. |
| Tag list | `tag->values` | The parent's field tag must be contained in values | `poly->{4, 5}` match a square or a pentagon |
| Tag equality | `tag->value` | The parent's field tag must be equal to value | `poly->4` match a square |

#### Tags
The folowing tags are built-in:
| Name(s) | Description |
|---|---|
| Pnsides / poly | The number of sides (>=3) |
| PsideIndex / edge | The placement on the parent |
| color | The filling color |
| border | The border color |
| opacity | The opacity, in the range [0-1] |
| texture | The texture (image, ...) |
| Pangle | the absolute angle |
| Pxy | the absolute position |
| Pradius | the external radius |

### The effect system
An effect can be multiple things
| name | syntax |  description | usage |
|---|---|---|---|
| polygon | `poly->N` | Place a polygon with N sides | `{poly->4}` place a square |
| coef | `coef->C` | The external radius of the children will be C times the 
