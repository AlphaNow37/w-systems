# The w systems documentation

## Vocabulary
axiom: the situation at the begin, at iteration 0
rules: a list of pair condition-consequence
niter: the number of iterations, of application of the rules

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
