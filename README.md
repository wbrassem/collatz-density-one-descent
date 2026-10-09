# Collatz Density-One Descent

A Lean-verified symbolic–affine framework proving density-one descent for the
Collatz map via exact realization cylinders and residual-mass decay.

## Result

This repository contains the manuscript and Lean 4 formalization for

> **A Symbolic–Affine Framework for Density-One Collatz Descent**

The main result is that the set of positive integers whose ordinary Collatz
orbit eventually falls below its starting value has natural density one.

Equivalently, if

```math
T(x)=
\begin{cases}
x/2, & x \text{ even},\\
3x+1, & x \text{ odd},
\end{cases}
```

then

```math
\mathrm{dens}\lbrace
x\in\mathbb{N}_{>0} :
\exists n,\quad T^n(x)\lt x
\rbrace
=1.
```

This is a density-one finite-stopping result. It does **not** prove that every
positive integer descends, nor does it prove the Collatz conjecture.

The density-one finite-stopping theorem itself is classical. The purpose of
the manuscript is to give a deterministic symbolic–affine formulation in
fully accelerated coordinates, organized through exact realization classes,
dyadic cylinders, a residual forest, and residual-mass decay, together with
a formal verification in Lean 4.

## Manuscript

The current manuscript is available directly as a PDF:

[`manuscript/Symbolic_Affine_Collatz.pdf`](manuscript/Symbolic_Affine_Collatz.pdf)

LaTeX source and bibliography:

- `manuscript/Symbolic_Affine_Collatz.tex`
- `manuscript/references.bib`

The tracked PDF is an author-vetted publication artifact. It is regenerated
deliberately rather than automatically by CI.

To rebuild the manuscript locally:

```bash
cd manuscript
latexmk -pdf -interaction=nonstopmode -halt-on-error Symbolic_Affine_Collatz.tex
```

## Lean formalization

The Lean 4 formalization is contained in `lean/`. To build the complete
formal development and run the verification harness:

```bash
cd lean
lake build
lake env lean Collatz/Scratch.lean
```

The culminating theorem is

```text
Collatz.ordinary_collatz_descent_has_natural_density_one
```

Continuous integration builds the Lean project, runs the verification
harness, and audits the `Collatz` namespace for axiomatic dependencies.
The permitted foundational axioms are

```text
propext
Classical.choice
Quot.sound
```

No project-specific mathematical axioms are permitted by the CI audit.

## Licensing

The Lean source and project files under `lean/` are licensed under the
Apache License 2.0; see `lean/LICENSE`.

The manuscript files under `manuscript/` are not covered by that software
license. No separate license is currently granted for the manuscript.
