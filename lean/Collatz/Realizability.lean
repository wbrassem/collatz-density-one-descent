/-
Copyright (c) 2026 Wayne Brassem. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Wayne Brassem
-/

import Collatz.Affine

/-!

# Realizability of the Affine Representation

This module develops the exact realizability theory for finite division words
of the fully accelerated Collatz map.

The preceding module, `Collatz.Affine`, associates to every formal division
word `ω` the rational affine map

    affine_map ω x
      =
    (3 ^ ω.length * x + affine_constant ω) /
      2 ^ total_division_count ω.

That affine representation is defined independently of whether `ω` actually
occurs along a Collatz trajectory. The purpose of the present module is to
characterize exactly when the formal affine data represents a realized
division word and to describe the resulting dyadic residue-class structure.

Write informally

    D(ω) = total_division_count ω

and

    c(ω) = affine_constant ω.

The central arithmetic distinction is between formal affine integrality,

    3 ^ ω.length * x + c(ω)
      ≡
    0
      mod 2 ^ D(ω),

and exact realization,

    3 ^ ω.length * x + c(ω)
      ≡
    2 ^ D(ω)
      mod 2 ^ (D(ω) + 1).

The first congruence says only that the prescribed dyadic denominator divides
the affine numerator. The second contains one additional parity bit: after
removing `2 ^ D(ω)`, the remaining quotient is odd. That extra bit records
exact `2`-adic valuation rather than mere divisibility.

The development separates naturally into eight stages.

## 1. Exact Congruence from Realized Trajectories

The first stage derives the exact affine congruence from an actual realized
trajectory.

Every positive iterate of the fully accelerated map is odd. In particular,
if `ω` is nonempty, then the accelerated endpoint after `ω.length` steps is
odd.

If `x` realizes `ω`, the affine numerator satisfies the exact identity

    3 ^ ω.length * x + affine_constant ω
      =
    2 ^ total_division_count ω *
      ((fully_accelerated^[ω.length]) x).

For a nonempty realized word, the final factor on the right is odd.
Consequently,

    3 ^ ω.length * x + affine_constant ω
      ≡
    2 ^ total_division_count ω
      mod 2 ^ (total_division_count ω + 1).

Thus actual realization implies the exact affine congruence, with the
additional modulus bit encoding oddness of the accelerated endpoint.

The principal results are:

* `fully_accelerated_iterate_succ_odd`;
* `fully_accelerated_iterate_length_odd`;
* `affine_numerator_eq_of_realizes`;
* `realizes_modEq_succ`.

## 2. Arithmetic Meaning of the Exact Congruence

The exact congruence modulo one additional power of `2` has a simple
arithmetic interpretation.

For natural numbers `N` and `D`,

    N ≡ 2 ^ D mod 2 ^ (D + 1)

if and only if

    N = 2 ^ D * q

for some odd natural number `q`.

Thus divisibility by `2 ^ D` alone records only formal integrality, whereas
the additional modulus bit asserts that the quotient after removing exactly
that dyadic factor is odd.

This distinction is the arithmetic mechanism that later permits exact
valuation data to be recovered from one global congruence.

The principal result is:

* `modEq_pow_succ_iff_eq_pow_mul_odd`.

## 3. Prefix Integrality from Global Affine Constraints

The third stage shows that global affine integrality propagates backward to
every symbolic prefix.

If the affine numerator associated with a concatenated word `ω ++ η` is
divisible by

    2 ^ total_division_count (ω ++ η),

then the affine numerator associated with the left prefix `ω` is divisible by

    2 ^ total_division_count ω.

The proof uses the affine concatenation identity. Modulo the prefix dyadic
factor, the suffix contribution vanishes, while the remaining ternary factor
is coprime to every power of `2` and can therefore be cancelled.

Consequently, if

    3 ^ ω.length * x + affine_constant ω
      ≡
    0
      mod 2 ^ total_division_count ω,

then every prefix `ω.take j` satisfies its corresponding affine integrality
condition.

The exact congruence can also be reduced to ordinary integrality by forgetting
the additional parity bit:

    N ≡ 2 ^ D mod 2 ^ (D + 1)
      →
    N ≡ 0 mod 2 ^ D.

Together these results show that a single global affine condition controls
the formal integrality of every prefix.

The principal results are:

* `affine_integrality_append_left`;
* `affine_congruence_prefix`;
* `modEq_pow_succ_implies_integrality`.

## 4. Reconstructing Realization from Exact Congruence

The reverse direction is the dynamical core of the module.

Suppose the prescribed division counts are positive and the global exact
congruence holds:

    3 ^ ω.length * x + affine_constant ω
      ≡
    2 ^ total_division_count ω
      mod 2 ^ (total_division_count ω + 1).

For a nonempty word `d :: ω`, prefix integrality first gives

    2 ^ d ∣ 3 * x + 1.

Writing

    3 * x + 1 = 2 ^ d * y,

the exact affine congruence transports to the tail word `ω` beginning at `y`.
Induction shows that `y` is odd and realizes the tail.

Because the quotient `y` is odd, the legal dyadic factor `2 ^ d` is in fact
the exact power of `2` dividing `3 * x + 1`. Hence

    division_count x = d,

so the prescribed head symbol is the actual fully accelerated Collatz
division count. The realized head step and realized tail then reassemble into
realization of the complete word.

Thus a single exact global congruence, together with positivity of the
prescribed division counts, contains enough information to reconstruct every
exact valuation in the finite trajectory.

The principal results are:

* `affine_exact_congruence_head_dvd`;
* `affine_exact_congruence_tail`;
* `odd_of_division_count_pos`;
* `exact_congruence_implies_odd_and_realizes`.

## 5. Exact Realization Criterion

The forward and reverse directions combine into the central realizability
theorem.

For every admissible division word `ω`,

    realizes x ω

if and only if

    3 ^ ω.length * x + affine_constant ω
      ≡
    2 ^ total_division_count ω
      mod 2 ^ (total_division_count ω + 1).

Thus the full sequence of exact `2`-adic valuation constraints defining
realization is equivalent to one global affine congruence.

The same exactness principle has a local one-step form. For natural numbers
`x` and `d`,

    division_count x = d

if and only if

    3 * x + 1
      ≡
    2 ^ d
      mod 2 ^ (d + 1).

This local criterion again distinguishes exact valuation from mere
divisibility.

The principal results are:

* `realizes_iff_exact_congruence`;
* `division_count_eq_iff_exact_modEq`.

## 6. Canonical Residue Classes from Exact Realization

The exact affine realization congruence is linear in the starting value.

Its coefficient

    3 ^ ω.length

is coprime to the exact dyadic modulus

    2 ^ (total_division_count ω + 1).

Therefore the affine congruence can be solved uniquely as a residue class in
the starting value.

A generic linear-congruence lemma first shows that, whenever `A` is coprime to
a positive modulus `M`, an equation of the form

    A * x + C ≡ B mod M

is equivalent to membership in one canonical residue class

    x ≡ r mod M,

with `r < M`.

Specializing this result to the affine data yields, for every formal division
word `ω`, a canonical residue class satisfying the exact affine congruence.

For admissible `ω`, the exact realization criterion identifies that arithmetic
class with the actual realization set. Consequently there exists a unique

    r < 2 ^ (total_division_count ω + 1)

such that

    realizes x ω

if and only if

    x ≡ r mod 2 ^ (total_division_count ω + 1).

Thus every admissible division word determines one exact dyadic residue class
of starting values.

The principal results are:

* `ternary_coprime_exact_modulus`;
* `realizations_modEq`;
* `coprime_linear_modEq_residue`;
* `affine_exact_residue_exists`;
* `realization_residue_exists_unique`.

## 7. Residue Refinement, Prefix Lifting, and Realizability

Canonical realization residues are compatible with symbolic prefixes.

If `rωη` is the canonical realization residue of an extended word `ω ++ η`
and `rω` is the corresponding residue of its left prefix `ω`, then

    rωη ≡ rω
      mod 2 ^ (total_division_count ω + 1).

Realization itself is likewise prefix-closed: if `x` realizes `ω`, then `x`
realizes every prefix `ω.take j`.

The same compatibility holds for canonical residues of arbitrary prefixes.
Positive-length prefixes of admissible words are themselves admissible, so
every such prefix has a unique realization residue.

The predicate

    realization_residue ω r

packages the two defining properties of a canonical realization residue:

    r < 2 ^ (total_division_count ω + 1),

and

    realizes x ω
      ↔
    x ≡ r mod 2 ^ (total_division_count ω + 1).

The residue-lifting theorem then records the compatible nested system of
canonical residues along consecutive positive prefixes.

This residue theory also yields an important existence result: every
admissible finite division word is realized by some natural number. Indeed,
its canonical residue representative belongs to its own residue class and
therefore realizes the word.

Thus admissibility is not merely a formal positivity condition: every
admissible finite division word occurs along some fully accelerated Collatz
trajectory.

The principal results are:

* `realization_residue_append_left`;
* `realizes_take`;
* `realization_residue_take`;
* `admissible_division_word_take`;
* `realization_residue`;
* `realization_residue_exists_unique'`;
* `residue_lifting_theorem`;
* `admissible_division_word_realizable`.

## 8. Prefix Comparability and Nested Realization Classes

The final stage converts deterministic trajectory structure into geometry of
realization classes.

A starting value realizes at most one division word of any fixed length. If
the same starting value realizes two words of different lengths, the shorter
word must be exactly the corresponding prefix of the longer one.

Hence any two division words possessing a common realization are
prefix-comparable.

It follows that realization classes cannot partially overlap. For any two
division words, one of three alternatives holds:

* every realization of the second word also realizes the first;
* every realization of the first word also realizes the second;
* the two realization classes are disjoint.

Through `realization_residue`, this trichotomy transfers directly to the exact
dyadic residue classes.

Thus exact realization classes are nested according to symbolic prefix order
or else are disjoint. This is the arithmetic structure transferred in the
next module to dyadic cylinders.

The principal results are:

* `realizes_eq_of_length_eq`;
* `realizes_prefix_of_length_le`;
* `common_realization_implies_prefix`;
* `realization_classes_nested_or_disjoint`;
* `exact_residue_classes_nested_or_disjoint`.

## Dependency flow

The main logical dependencies are:

    Collatz.Affine
          │
          │  affine_map_realized
          │  affine_constant_append
          │  realizes_append_left
          ▼
    ┌───────────────────────────────────────────────┐
    │ Exact congruence from realized trajectories   │
    │                                               │
    │ fully_accelerated_iterate_succ_odd            │
    │       ↓                                       │
    │ affine_numerator_eq_of_realizes               │
    │       ↓                                       │
    │ realizes_modEq_succ                           │
    └───────────────────────────────────────────────┘
                          │
                          ▼
    ┌───────────────────────────────────────────────┐
    │ Arithmetic meaning of exact congruence        │
    │                                               │
    │ modEq_pow_succ_iff_eq_pow_mul_odd             │
    └───────────────────────────────────────────────┘
                          │
                          ▼
    ┌───────────────────────────────────────────────┐
    │ Prefix integrality from global constraints    │
    │                                               │
    │ affine_integrality_append_left                │
    │       ↓                                       │
    │ affine_congruence_prefix                      │
    │                                               │
    │ modEq_pow_succ_implies_integrality            │
    └───────────────────────────────────────────────┘
                          │
                          ▼
    ┌───────────────────────────────────────────────┐
    │ Reconstructing realization                    │
    │                                               │
    │ affine_exact_congruence_head_dvd              │
    │       ↓                                       │
    │ affine_exact_congruence_tail                  │
    │       ↓                                       │
    │ exact_congruence_implies_odd_and_realizes    │
    └───────────────────────────────────────────────┘
                          │
              ┌───────────┴───────────┐
              │                       │
              │                       │
              ▼                       ▼
    ┌───────────────────────┐  ┌───────────────────────┐
    │ Forward exactness     │  │ Reverse reconstruction│
    │                       │  │                       │
    │ realizes_modEq_succ   │  │ exact_congruence_... │
    └───────────────────────┘  └───────────────────────┘
              │                       │
              └───────────┬───────────┘
                          ▼
    ┌───────────────────────────────────────────────┐
    │ Exact realization criterion                   │
    │                                               │
    │ realizes_iff_exact_congruence                 │
    │                                               │
    │ division_count_eq_iff_exact_modEq             │
    └───────────────────────────────────────────────┘
                          │
                          ▼
    ┌───────────────────────────────────────────────┐
    │ Canonical residue classes                     │
    │                                               │
    │ ternary_coprime_exact_modulus                 │
    │       ↓                                       │
    │ coprime_linear_modEq_residue                  │
    │       ↓                                       │
    │ affine_exact_residue_exists                   │
    │       ↓                                       │
    │ realization_residue_exists_unique             │
    └───────────────────────────────────────────────┘
                          │
                          ▼
    ┌───────────────────────────────────────────────┐
    │ Residue refinement and prefix lifting         │
    │                                               │
    │ realizes_take                                 │
    │       ├── realization_residue_take            │
    │       ├── realization_residue                 │
    │       ├── residue_lifting_theorem             │
    │       └── admissible_division_word_realizable │
    └───────────────────────────────────────────────┘
                          │
                          ▼
    ┌───────────────────────────────────────────────┐
    │ Prefix comparability and class geometry       │
    │                                               │
    │ realizes_eq_of_length_eq                      │
    │       ↓                                       │
    │ realizes_prefix_of_length_le                  │
    │       ↓                                       │
    │ common_realization_implies_prefix             │
    │       ↓                                       │
    │ realization_classes_nested_or_disjoint        │
    │       ↓                                       │
    │ exact_residue_classes_nested_or_disjoint      │
    └───────────────────────────────────────────────┘

The final nested-or-disjoint residue-class theorem is the arithmetic handoff
to `Collatz.Cylinders`, where these exact dyadic residue classes are treated
as cylinders, their natural densities are established, and symbolic prefix
order is identified with cylinder containment.

-/

namespace Collatz

/-! ## Exact Congruence from Realized Trajectories -/

/--
Every strictly positive iterate of the fully accelerated Collatz map is odd.

The proof is by induction on the number of iterates. The starting value
`x` is generalized so that the induction hypothesis can be applied after
replacing `x` by `fully_accelerated x`.
-/
lemma fully_accelerated_iterate_succ_odd
    (x n : ℕ) :
    Odd ((fully_accelerated^[n.succ]) x) := by
  induction n generalizing x with
  | zero =>
      simpa [Function.iterate_succ_apply] using
        fully_accelerated_odd x
  | succ n ih =>
      rw [Function.iterate_succ_apply]
      exact ih (fully_accelerated x)

/--
An accelerated iterate indexed by the length of a nonempty division word
is odd.

Since `0 < ω.length`, the length is a successor, so the result follows
from `fully_accelerated_iterate_succ_odd`.

This packages the positive-length condition needed later to show that the
endpoint associated with a nonempty realized word is odd.
-/
lemma fully_accelerated_iterate_length_odd
    (x : ℕ) {ω : division_word}
    (hω : 0 < ω.length) :
    Odd ((fully_accelerated^[ω.length]) x) := by
  cases ω with
  | nil =>
      simp at hω
  | cons d ω =>
      simp only [List.length_cons]
      exact fully_accelerated_iterate_succ_odd x ω.length

/--
If `x` realizes `ω`, then the affine numerator factors exactly as the
prescribed dyadic denominator times the actual accelerated endpoint:

`3 ^ ω.length * x + affine_constant ω =
  2 ^ total_division_count ω *
    ((fully_accelerated^[ω.length]) x)`.

This is obtained from `affine_map_realized` by clearing the rational
denominator in the affine representation. The resulting identity is the
arithmetic bridge used to derive the exact realization congruence modulo
`2 ^ (total_division_count ω + 1)`.
-/
lemma affine_numerator_eq_of_realizes
    {x : ℕ} {ω : division_word}
    (h : realizes x ω) :
    3 ^ ω.length * x + affine_constant ω =
      2 ^ total_division_count ω *
        ((fully_accelerated^[ω.length]) x) := by
  have hq := affine_map_realized h
  unfold affine_map at hq
  field_simp at hq
  /- Transfer the cleared affine identity from `ℚ` back to `ℕ`. -/
  exact_mod_cast hq

/--
A realized nonempty division word satisfies the exact affine congruence
modulo one power of `2` beyond the formal denominator.

If `x` realizes `ω`, then

`3 ^ ω.length * x + affine_constant ω ≡
  2 ^ total_division_count ω
    mod 2 ^ (total_division_count ω + 1)`.

By `affine_numerator_eq_of_realizes`, the affine numerator is

`2 ^ total_division_count ω * y`,

where

`y = (fully_accelerated^[ω.length]) x`

is the endpoint of the realized trajectory segment. Since `ω` is nonempty,
this endpoint is odd and therefore congruent to `1` modulo `2`. Scaling
that congruence by `2 ^ total_division_count ω` gives the desired exact
affine congruence.

Thus the extra modulus bit records the oddness of the realized endpoint:
divisibility by `2 ^ total_division_count ω` gives only formal integrality,
while congruence modulo `2 ^ (total_division_count ω + 1)` records exact
dyadic division.
-/
theorem realizes_modEq_succ
    {x : ℕ} {ω : division_word}
    (h : realizes x ω)
    (hω : 0 < ω.length) :
    Nat.ModEq
      (2 ^ (total_division_count ω + 1))
      (3 ^ ω.length * x + affine_constant ω)
      (2 ^ total_division_count ω) := by
  rw [affine_numerator_eq_of_realizes h]
  have hodd :
      Odd ((fully_accelerated^[ω.length]) x) := by
    exact fully_accelerated_iterate_length_odd x hω
  have hmod2 :
      Nat.ModEq 2
        ((fully_accelerated^[ω.length]) x)
        1 := by
    rcases hodd with ⟨q, hq⟩
    rw [hq]
    exact Nat.ModEq.modulus_mul_add
  /-
  `mul_left'` scales both sides and the modulus, turning congruence
  modulo `2` into congruence modulo `2 ^ D * 2`.
  -/
  have hscaled :=
    hmod2.mul_left'
      (2 ^ total_division_count ω)
  simpa [pow_succ] using hscaled

/-! ## Arithmetic Meaning of the Exact Congruence -/

/--
Characterizes the exact dyadic congruence modulo one additional power of `2`.

For natural numbers `N` and `D`,

`N ≡ 2 ^ D mod 2 ^ (D + 1)`

if and only if

`N = 2 ^ D * q`

for some odd natural number `q`.

Thus congruence modulo `2 ^ (D + 1)` does more than assert divisibility
by `2 ^ D`: it asserts that the quotient remaining after removal of that
dyadic factor is odd. This is the arithmetic meaning of the additional
modulus bit used throughout the realizability theory.
-/
lemma modEq_pow_succ_iff_eq_pow_mul_odd
    (N D : ℕ) :
    Nat.ModEq
        (2 ^ (D + 1))
        N
        (2 ^ D)
      ↔
    ∃ q : ℕ,
      Odd q ∧
      N = 2 ^ D * q := by
  constructor
  · intro h
    have hpow_dvd :
        2 ^ D ∣ 2 ^ (D + 1) := by
      rw [pow_succ]
      exact dvd_mul_right (2 ^ D) 2
    have hdiv :
        2 ^ D ∣ N := by
      exact
        (h.dvd_iff hpow_dvd).mpr
          (dvd_refl (2 ^ D))
    rcases hdiv with ⟨q, hq⟩
    /-
    Cancel the common factor `2 ^ D` from both values and from the
    modulus, leaving `q ≡ 1 mod 2`.
    -/
    have hmod2 :
        Nat.ModEq 2 q 1 := by
      apply Nat.ModEq.mul_left_cancel'
        (by positivity : 2 ^ D ≠ 0)
      simpa [pow_succ, hq] using h
    have hodd : Odd q := by
      simpa [Nat.ModEq, Nat.odd_iff] using hmod2
    exact ⟨q, hodd, hq⟩
  · rintro ⟨q, hodd, hq⟩
    have hmod2 :
        Nat.ModEq 2 q 1 := by
      simpa [Nat.ModEq, Nat.odd_iff] using hodd
    /-
    Scale `q ≡ 1 mod 2` by `2 ^ D`, including the modulus, to recover
    the exact congruence modulo `2 ^ (D + 1)`.
    -/
    have hscaled :=
      hmod2.mul_left' (2 ^ D)
    simpa [hq, pow_succ] using hscaled

/-! ## Prefix Integrality from Global Affine Constraints -/

/--
Global affine integrality for a concatenated word descends to its left
prefix.

If the affine numerator for `ω ++ η` is divisible by

`2 ^ total_division_count (ω ++ η)`,

then the affine numerator for `ω` is divisible by

`2 ^ total_division_count ω`.

The full numerator decomposes as

`3 ^ η.length *
    (3 ^ ω.length * x + affine_constant ω) +
  2 ^ total_division_count ω * affine_constant η`.

Modulo the prefix dyadic factor, the second term vanishes. The remaining
factor `3 ^ η.length` is coprime to every power of `2`, so it can be
cancelled from the resulting divisibility statement.

Thus global affine integrality is not merely an endpoint condition: it
forces the corresponding integrality condition on every left prefix.
-/
lemma affine_integrality_append_left
    (x : ℕ) (ω η : division_word)
    (h :
      Nat.ModEq
        (2 ^ total_division_count (ω ++ η))
        (3 ^ (ω ++ η).length * x +
          affine_constant (ω ++ η))
        0) :
    Nat.ModEq
      (2 ^ total_division_count ω)
      (3 ^ ω.length * x + affine_constant ω)
      0 := by
  have hpow_dvd :
      2 ^ total_division_count ω ∣
        2 ^ total_division_count (ω ++ η) := by
    unfold total_division_count
    rw [List.sum_append, pow_add]
    exact dvd_mul_right _ _
  have hsmall :
      Nat.ModEq
        (2 ^ total_division_count ω)
        (3 ^ (ω ++ η).length * x +
          affine_constant (ω ++ η))
        0 := by
    exact h.of_dvd hpow_dvd
  /-
  Rewrite the concatenated affine numerator into a ternary multiple
  of the prefix numerator plus a term divisible by the prefix modulus.
  -/
  have hnum :
      3 ^ (ω ++ η).length * x +
          affine_constant (ω ++ η)
        =
      3 ^ η.length *
          (3 ^ ω.length * x + affine_constant ω)
        +
      2 ^ total_division_count ω *
          affine_constant η := by
    rw [List.length_append]
    rw [affine_constant_append]
    rw [pow_add]
    ring
  rw [hnum] at hsmall
  have hremove :
      Nat.ModEq
        (2 ^ total_division_count ω)
        (3 ^ η.length *
            (3 ^ ω.length * x + affine_constant ω) +
          2 ^ total_division_count ω *
            affine_constant η)
        (3 ^ η.length *
            (3 ^ ω.length * x + affine_constant ω)) := by
    simp [add_comm]
  have hprod :
      Nat.ModEq
        (2 ^ total_division_count ω)
        (3 ^ η.length *
          (3 ^ ω.length * x + affine_constant ω))
        0 := by
    exact hremove.symm.trans hsmall
  have hdvdprod :
      2 ^ total_division_count ω ∣
        3 ^ η.length *
          (3 ^ ω.length * x + affine_constant ω) := by
    exact
      (hprod.dvd_iff (dvd_refl _)).mpr
        (dvd_zero _)
  /-
  Powers of `2` and `3` are coprime, so the ternary factor can be
  cancelled from the divisibility statement.
  -/
  have hcop :
      Nat.Coprime
        (2 ^ total_division_count ω)
        (3 ^ η.length) := by
    exact
      (by norm_num : Nat.Coprime 2 3).pow
        (total_division_count ω)
        η.length
  have hdvdprefix :
      2 ^ total_division_count ω ∣
        3 ^ ω.length * x + affine_constant ω := by
    exact hcop.dvd_of_dvd_mul_left hdvdprod
  change
    (3 ^ ω.length * x + affine_constant ω) %
        (2 ^ total_division_count ω)
      =
    0 % (2 ^ total_division_count ω)
  simp only [Nat.zero_mod]
  exact Nat.dvd_iff_mod_eq_zero.mp hdvdprefix

/--
Global affine integrality propagates to every prefix of a division word.

If the affine numerator for `ω` is congruent to `0` modulo

`2 ^ total_division_count ω`,

then for every `j ≤ ω.length`, the affine numerator of the prefix
`ω.take j` is congruent to `0` modulo

`2 ^ total_division_count (ω.take j)`.

The proof decomposes

`ω = ω.take j ++ ω.drop j`

and applies `affine_integrality_append_left`. The bound `j ≤ ω.length`
then identifies the prefix length with `j`.

Thus a single global integrality condition determines the corresponding
formal integrality condition at every prefix stage.
-/
lemma affine_congruence_prefix
    {x : ℕ} {ω : division_word}
    (h :
      Nat.ModEq
        (2 ^ total_division_count ω)
        (3 ^ ω.length * x + affine_constant ω)
        0) :
    ∀ j ≤ ω.length,
      Nat.ModEq
        (2 ^ total_division_count (ω.take j))
        (3 ^ j * x + affine_constant (ω.take j))
        0 := by
  intro j hj
  have hsplit := h
  rw [← List.take_append_drop j ω] at hsplit
  have hp :=
    affine_integrality_append_left
      x
      (ω.take j)
      (ω.drop j)
      hsplit
  simpa [List.length_take, Nat.min_eq_left hj] using hp

/--
Forgets the extra parity bit in an exact dyadic congruence.

If

`N ≡ 2 ^ D mod 2 ^ (D + 1)`,

then reducing modulo the smaller power `2 ^ D` gives

`N ≡ 0 mod 2 ^ D`.

This is the bridge from exact congruence to the ordinary affine
integrality condition required by the prefix-integrality machinery.
-/
lemma modEq_pow_succ_implies_integrality
    (N D : ℕ)
    (h :
      Nat.ModEq
        (2 ^ (D + 1))
        N
        (2 ^ D)) :
    Nat.ModEq
      (2 ^ D)
      N
      0 := by
  have hpow_dvd :
      2 ^ D ∣ 2 ^ (D + 1) := by
    rw [pow_succ]
    exact dvd_mul_right _ _
  have hsmall :
      Nat.ModEq
        (2 ^ D)
        N
        (2 ^ D) := by
    exact h.of_dvd hpow_dvd
  have hzero :
      Nat.ModEq
        (2 ^ D)
        (2 ^ D)
        0 := by
    simp
  exact hsmall.trans hzero

/-! ## Reconstructing Realization from Exact Congruence -/

/--
The global exact congruence for a nonempty word forces the first prescribed
dyadic division to be legal.

For a word `d :: ω`, the exact congruence

`3 ^ (d :: ω).length * x + affine_constant (d :: ω) ≡
  2 ^ total_division_count (d :: ω)
    mod 2 ^ (total_division_count (d :: ω) + 1)`

implies

`2 ^ d ∣ 3 * x + 1`.

The proof first forgets the final parity bit, obtaining ordinary affine
integrality. Prefix integrality is then applied to the one-element prefix
`[d]`, whose affine numerator is `3 * x + 1` and whose total division
count is `d`.

This establishes only legality of the first prescribed division. Exactness
of the valuation is recovered later from oddness of the quotient remaining
after removal of `2 ^ d`.
-/
lemma affine_exact_congruence_head_dvd
    {x d : ℕ} {ω : division_word}
    (h :
      Nat.ModEq
        (2 ^ (total_division_count (d :: ω) + 1))
        (3 ^ (d :: ω).length * x +
          affine_constant (d :: ω))
        (2 ^ total_division_count (d :: ω))) :
    2 ^ d ∣ 3 * x + 1 := by
  have hint :
      Nat.ModEq
        (2 ^ total_division_count (d :: ω))
        (3 ^ (d :: ω).length * x +
          affine_constant (d :: ω))
        0 := by
    exact
      modEq_pow_succ_implies_integrality
        (3 ^ (d :: ω).length * x +
          affine_constant (d :: ω))
        (total_division_count (d :: ω))
        h
  /- Apply prefix integrality to the one-element prefix `[d]`. -/
  have hp :=
    affine_congruence_prefix
      (x := x)
      (ω := d :: ω)
      hint
      1
      (by simp)
  have hdvd :
      2 ^ total_division_count ((d :: ω).take 1) ∣
        3 ^ 1 * x +
          affine_constant ((d :: ω).take 1) := by
    exact
      (hp.dvd_iff (dvd_refl _)).mpr
        (dvd_zero _)
  simpa [total_division_count, affine_constant] using hdvd

/--
Transports the exact affine congruence from a nonempty word to its tail
after the first prescribed dyadic division has been factored off.

Suppose

`3 * x + 1 = 2 ^ d * y`

and `d :: ω` satisfies its exact affine congruence. Then the tail word `ω`,
starting from `y`, satisfies

`3 ^ ω.length * y + affine_constant ω ≡
  2 ^ total_division_count ω
    mod 2 ^ (total_division_count ω + 1)`.

The full affine numerator factors as

`2 ^ d *
  (3 ^ ω.length * y + affine_constant ω)`,

while

`total_division_count (d :: ω) =
  d + total_division_count ω`.

Thus both sides and the modulus contain the common factor `2 ^ d`;
cancelling it yields exactly the tail congruence.

This is the recursive transport step in the reverse realizability argument:
once the first prescribed division is legal, the same exact congruence
structure reappears for the remaining word.
-/
lemma affine_exact_congruence_tail
    {x y d : ℕ} {ω : division_word}
    (hy : 3 * x + 1 = 2 ^ d * y)
    (h :
      Nat.ModEq
        (2 ^ (total_division_count (d :: ω) + 1))
        (3 ^ (d :: ω).length * x +
          affine_constant (d :: ω))
        (2 ^ total_division_count (d :: ω))) :
    Nat.ModEq
      (2 ^ (total_division_count ω + 1))
      (3 ^ ω.length * y + affine_constant ω)
      (2 ^ total_division_count ω) := by
  /-
  Substitute the legal first division and factor the full affine
  numerator as `2 ^ d` times the tail numerator.
  -/
  have hnum :
      3 ^ (d :: ω).length * x +
          affine_constant (d :: ω)
        =
      2 ^ d *
        (3 ^ ω.length * y + affine_constant ω) := by
    simp only [List.length_cons, affine_constant]
    rw [pow_succ]
    calc
      3 ^ ω.length * 3 * x +
            (3 ^ ω.length + 2 ^ d * affine_constant ω)
          =
        3 ^ ω.length * (3 * x + 1) +
            2 ^ d * affine_constant ω := by
          ring
      _ =
        3 ^ ω.length * (2 ^ d * y) +
            2 ^ d * affine_constant ω := by
          rw [hy]
      _ =
        2 ^ d *
          (3 ^ ω.length * y + affine_constant ω) := by
          ring
  rw [hnum] at h
  have hD :
      total_division_count (d :: ω) =
        d + total_division_count ω := by
    simp [total_division_count]
  /-
  Cancel the common nonzero factor `2 ^ d` from both values and from
  the modulus, leaving precisely the exact congruence for the tail.
  -/
  apply Nat.ModEq.mul_left_cancel'
    (by positivity : 2 ^ d ≠ 0)
  simpa [hD, pow_add, add_assoc] using h

/--
A positive division count forces the starting value to be odd.

If

`1 ≤ division_count x`,

then `2` divides `3 * x + 1`, so that quantity is even. Since `1` is odd,
`3 * x` must be odd, and hence `x` is odd.

This is used in the reverse realizability argument after the exact head
valuation has been recovered: admissibility supplies positivity of that
valuation, which then forces oddness of the current starting value.
-/
lemma odd_of_division_count_pos
    (x : ℕ)
    (hpos : 1 ≤ division_count x) :
    Odd x := by
  unfold division_count at hpos
  have hdiv :
      (2 : ℕ) ∣ 3 * x + 1 := by
    exact
      (padicValNat_dvd_iff_le
        (p := 2)
        (a := 3 * x + 1)
        (n := 1)
        (by omega)).mpr hpos
  have heven :
      Even (3 * x + 1) := by
    exact even_iff_two_dvd.mpr hdiv
  have h3x :
      Odd (3 * x) := by
    exact (Nat.even_add'.mp heven).mpr odd_one
  exact (Nat.odd_mul.mp h3x).2

/--
The global exact affine congruence, together with positivity of the
prescribed division counts, forces oddness of the starting value and exact
realization of the entire division word.

Assume every entry of `ω` is positive and

`3 ^ ω.length * x + affine_constant ω ≡
  2 ^ total_division_count ω
    mod 2 ^ (total_division_count ω + 1)`.

The proof proceeds by induction on `ω`. For a nonempty word `d :: ω`,
the exact congruence first implies

`2 ^ d ∣ 3 * x + 1`.

Writing

`3 * x + 1 = 2 ^ d * y`,

the same exact congruence transports to the tail `ω` starting from `y`.
The induction hypothesis shows that `y` is odd and realizes the tail.
Oddness of `y` then upgrades the legal factor `2 ^ d` to the exact
`2`-adic valuation of `3 * x + 1`, so the prescribed head division is
the actual fully accelerated Collatz step.

The exact head valuation and realized tail then reassemble into realization
of the full word. Positivity of the recovered head division count also
forces the starting value `x` to be odd.

Thus the single global congruence modulo
`2 ^ (total_division_count ω + 1)` contains enough information to recover
every prescribed valuation in the word.
-/
theorem exact_congruence_implies_odd_and_realizes
    {x : ℕ} {ω : division_word}
    (hpos : ∀ d ∈ ω, 1 ≤ d)
    (h :
      Nat.ModEq
        (2 ^ (total_division_count ω + 1))
        (3 ^ ω.length * x + affine_constant ω)
        (2 ^ total_division_count ω)) :
    Odd x ∧ realizes x ω := by
  induction ω generalizing x with
  | nil =>
      /-
      For the empty word the exact congruence reduces to
      `x ≡ 1 mod 2`, while realization is structural.
      -/
      have hxmod :
          Nat.ModEq
            (2 ^ (0 + 1))
            x
            (2 ^ 0) := by
        simpa [total_division_count, affine_constant] using h
      rcases
          (modEq_pow_succ_iff_eq_pow_mul_odd x 0).mp hxmod
        with ⟨q, hqodd, hxq⟩
      have hxq' : x = q := by
        simpa using hxq
      constructor
      · rw [hxq']
        exact hqodd
      · simp [realizes, division_counts]
  | cons d ω ih =>
      have hdpos : 1 ≤ d := by
        exact hpos d (by simp)
      have htailpos :
          ∀ e ∈ ω, 1 ≤ e := by
        intro e he
        exact hpos e (by simp [he])
      /-
      Peel off one legal prescribed division and transport the exact
      congruence to the tail.
      -/
      have hdiv :
          2 ^ d ∣ 3 * x + 1 := by
        exact affine_exact_congruence_head_dvd h
      rcases hdiv with ⟨y, hy⟩
      have htail :
          Nat.ModEq
            (2 ^ (total_division_count ω + 1))
            (3 ^ ω.length * y + affine_constant ω)
            (2 ^ total_division_count ω) := by
        exact affine_exact_congruence_tail hy h
      have ihtail :
          Odd y ∧ realizes y ω := by
        exact ih htailpos htail
      rcases ihtail with ⟨hyodd, hyrealizes⟩
      /-
      Because the quotient `y` is odd, the legal exponent `d` is the
      exact `2`-adic valuation of `3 * x + 1`.
      -/
      have hval :
          padicValNat 2 (3 * x + 1) = d := by
        exact
          valuation_exponent_of_odd_factor
            hy
            hyodd
            (by omega)
      have hdcount :
          d = division_count x := by
        unfold division_count
        exact hval.symm
      have hyfa :
          fully_accelerated x = y := by
        unfold fully_accelerated
        rw [← hdcount]
        rw [hy]
        simp
      have hxodd : Odd x := by
        apply odd_of_division_count_pos x
        rw [← hdcount]
        exact hdpos
      constructor
      · exact hxodd
      /-
      Reassemble the exact head division count and the realized tail
      into realization of the full word.
      -/
      · unfold realizes
        simp only [
          division_counts,
          List.length_cons,
          List.iterate,
          List.map_cons,
          List.cons.injEq
        ]
        constructor
        · exact hdcount
        · rw [hyfa]
          unfold realizes at hyrealizes
          unfold division_counts at hyrealizes
          exact hyrealizes

/-! ## Exact Realization Criterion -/

/--
Exact realization criterion for admissible division words.

For an admissible word `ω`, a natural number `x` realizes `ω` if and only if

`3 ^ ω.length * x + affine_constant ω ≡
  2 ^ total_division_count ω
    mod 2 ^ (total_division_count ω + 1)`.

The forward implication is `realizes_modEq_succ`: realization of a
nonempty word forces the affine numerator to be the prescribed dyadic
factor times an odd endpoint.

The reverse implication is `exact_congruence_implies_odd_and_realizes`:
positivity of every prescribed division count, together with the exact
global congruence, recursively recovers every exact valuation and hence
the realized trajectory.

Thus, for admissible words, the single congruence modulo
`2 ^ (total_division_count ω + 1)` is equivalent to the full sequence of
exact valuation constraints defining realization.
-/
theorem realizes_iff_exact_congruence
    {x : ℕ} {ω : division_word}
    (hω : admissible_division_word ω) :
    realizes x ω ↔
      Nat.ModEq
        (2 ^ (total_division_count ω + 1))
        (3 ^ ω.length * x + affine_constant ω)
        (2 ^ total_division_count ω) := by
  constructor
  · intro hrealizes
    rcases hω with ⟨hvalid, _⟩
    exact realizes_modEq_succ hrealizes hvalid
  · intro hcong
    rcases hω with ⟨_, hpos⟩
    exact
      (exact_congruence_implies_odd_and_realizes
        hpos
        hcong).2

/--
Characterizes an exact local division count by a dyadic congruence.

For natural numbers `x` and `d`,

`division_count x = d`

if and only if

`3 * x + 1 ≡ 2 ^ d mod 2 ^ (d + 1)`.

Equivalently,

`3 * x + 1 = 2 ^ d * q`

for some odd natural number `q`.

Thus divisibility by `2 ^ d` alone is insufficient: the additional
modulus bit records that no further factor of `2` remains. This is the
local one-step analogue of the global exact realization criterion.
-/
lemma division_count_eq_iff_exact_modEq
    (x d : ℕ) :
    division_count x = d ↔
      Nat.ModEq
        (2 ^ (d + 1))
        (3 * x + 1)
        (2 ^ d) := by
  constructor
  · intro hcount
    /-
    Decompose `3 * x + 1` into its exact power-of-two factor and
    odd remainder, then identify that exponent with `d`.
    -/
    have hn0 : 3 * x + 1 ≠ 0 := by
      omega
    obtain ⟨k, q, hqodd, hn⟩ :=
      Nat.exists_eq_two_pow_mul_odd hn0
    have hval :
        padicValNat 2 (3 * x + 1) = k := by
      exact
        valuation_exponent_of_odd_factor
          hn
          hqodd
          hn0
    have hk : k = d := by
      unfold division_count at hcount
      omega
    apply
      (modEq_pow_succ_iff_eq_pow_mul_odd
        (3 * x + 1)
        d).mpr
    refine ⟨q, hqodd, ?_⟩
    simpa [hk] using hn
  · intro hmod
    /-
    The exact congruence gives a factorization by `2 ^ d` with odd
    quotient, so the `2`-adic valuation is exactly `d`.
    -/
    rcases
        (modEq_pow_succ_iff_eq_pow_mul_odd
          (3 * x + 1)
          d).mp hmod
      with ⟨q, hqodd, hn⟩
    unfold division_count
    exact
      valuation_exponent_of_odd_factor
        hn
        hqodd
        (by omega)

/-! ## Canonical Residue Classes from Exact Realization -/

/--
The ternary coefficient in the affine numerator is coprime to the exact
dyadic realization modulus.

Since `3` and `2` are coprime, their powers are coprime. Hence

`3 ^ ω.length`

is coprime to

`2 ^ (total_division_count ω + 1)`.

This makes the exact affine realization congruence a linear congruence
with invertible coefficient in the starting value `x`, which is the
arithmetic basis for its canonical residue class.
-/
lemma ternary_coprime_exact_modulus
    (ω : division_word) :
    Nat.Coprime
      (3 ^ ω.length)
      (2 ^ (total_division_count ω + 1)) := by
  exact
    (by norm_num : Nat.Coprime 3 2).pow
      ω.length
      (total_division_count ω + 1)

/--
Any two realizations of the same admissible division word are congruent
modulo the exact realization modulus.

If `x` and `y` both realize `ω`, then

`x ≡ y mod 2 ^ (total_division_count ω + 1)`.

Both realizations satisfy the same exact affine congruence, so their affine
numerators are congruent. Cancelling the common affine constant leaves a
congruence between

`3 ^ ω.length * x`

and

`3 ^ ω.length * y`.

Since the ternary coefficient is coprime to the dyadic modulus, it can also
be cancelled.

Thus all realizations of an admissible word lie in a single residue class
modulo its exact realization modulus.
-/
theorem realizations_modEq
    {ω : division_word}
    (hω : admissible_division_word ω)
    {x y : ℕ}
    (hx : realizes x ω)
    (hy : realizes y ω) :
    Nat.ModEq
      (2 ^ (total_division_count ω + 1))
      x y := by
  have hxc :=
    (realizes_iff_exact_congruence hω).mp hx
  have hyc :=
    (realizes_iff_exact_congruence hω).mp hy
  have haff :
      Nat.ModEq
        (2 ^ (total_division_count ω + 1))
        (3 ^ ω.length * x + affine_constant ω)
        (3 ^ ω.length * y + affine_constant ω) := by
    exact hxc.trans hyc.symm
  /-
  Cancel first the common affine constant, then the coprime ternary
  coefficient.
  -/
  have hmul :
      Nat.ModEq
        (2 ^ (total_division_count ω + 1))
        (3 ^ ω.length * x)
        (3 ^ ω.length * y) := by
    exact
      Nat.ModEq.add_right_cancel'
        (affine_constant ω)
        haff
  have hcop :
      Nat.Coprime
        (2 ^ (total_division_count ω + 1))
        (3 ^ ω.length) := by
    exact (ternary_coprime_exact_modulus ω).symm
  exact
    Nat.ModEq.cancel_left_of_coprime
      hcop
      hmul

/--
Solves a linear congruence with coprime coefficient as a canonical residue
class.

Let `A`, `B`, `C`, and `M` be natural numbers with `M > 0` and
`Nat.Coprime A M`. Then there exists a representative `r < M` such that,
for every natural number `x`,

`A * x + C ≡ B mod M`

if and only if

`x ≡ r mod M`.

The proof works in `ZMod M`. Coprimality makes `A` a unit, so the equation

`A * x + C = B`

has the formal solution

`x = A⁻¹ * (B - C)`.

Taking the canonical natural representative of this element produces `r`.

In the realizability development this is applied with

`A = 3 ^ ω.length`,
`B = 2 ^ total_division_count ω`,
`C = affine_constant ω`, and
`M = 2 ^ (total_division_count ω + 1)`,

thereby converting the exact affine realization congruence into a single
canonical residue class of starting values.
-/
lemma coprime_linear_modEq_residue
    (A B C M : ℕ)
    (hM : 0 < M)
    (hcop : Nat.Coprime A M) :
    ∃ r : ℕ,
      r < M ∧
      ∀ x : ℕ,
        Nat.ModEq M (A * x + C) B ↔
          Nat.ModEq M x r := by
  /-
  Work in `ZMod M`, where coprimality turns the coefficient `A` into
  an invertible element.
  -/
  let : NeZero M := ⟨Nat.ne_of_gt hM⟩
  /-
  The formal solution of `A * x + C = B` is
  `A⁻¹ * (B - C)`.
  -/
  let z : ZMod M :=
    (A : ZMod M)⁻¹ *
      ((B : ZMod M) - (C : ZMod M))
  let r : ℕ := z.val
  refine ⟨r, ?_, ?_⟩
  · exact ZMod.val_lt z
  · intro x
    /-
    Translate both natural-number congruences into equalities in
    `ZMod M`; the canonical representative `r` denotes exactly `z`.
    -/
    rw [← ZMod.natCast_eq_natCast_iff]
    rw [← ZMod.natCast_eq_natCast_iff]
    push_cast
    have hrz : (r : ZMod M) = z := by
      dsimp [r]
      exact ZMod.natCast_zmod_val z
    rw [hrz]
    change
      (A : ZMod M) * (x : ZMod M) + (C : ZMod M) =
          (B : ZMod M)
        ↔
      (x : ZMod M) = z
    have hunit :
        IsUnit (A : ZMod M) := by
      exact (ZMod.isUnit_iff_coprime A M).2 hcop
    /-
    Use invertibility of `A` in each direction: solve the linear equation
    by multiplying by `A⁻¹`, and conversely substitute the formal solution.
    -/
    constructor
    · intro hx
      have hAx :
          (A : ZMod M) * (x : ZMod M) =
            (B : ZMod M) - (C : ZMod M) := by
        exact eq_sub_of_add_eq hx
      calc
        (x : ZMod M)
            = 1 * x := by simp
        _ =
            ((A : ZMod M)⁻¹ * (A : ZMod M)) * x := by
              rw [ZMod.inv_mul_of_unit _ hunit]
        _ =
            (A : ZMod M)⁻¹ *
              ((A : ZMod M) * x) := by
              ring
        _ =
            (A : ZMod M)⁻¹ *
              ((B : ZMod M) - (C : ZMod M)) := by
              rw [hAx]
        _ = z := by
              rfl
    · intro hx
      rw [hx]
      dsimp [z]
      calc
        (A : ZMod M) *
              ((A : ZMod M)⁻¹ *
                ((B : ZMod M) - (C : ZMod M))) +
              (C : ZMod M)
            =
          ((A : ZMod M) * (A : ZMod M)⁻¹) *
              ((B : ZMod M) - (C : ZMod M)) +
              (C : ZMod M) := by
                ring
        _ =
          1 * ((B : ZMod M) - (C : ZMod M)) +
              (C : ZMod M) := by
                rw [ZMod.mul_inv_of_unit _ hunit]
        _ = (B : ZMod M) := by
              ring

/--
The exact affine congruence associated with any division word determines
a canonical residue class of starting values.

For every division word `ω`, there exists

`r < 2 ^ (total_division_count ω + 1)`

such that, for every natural number `x`,

`3 ^ ω.length * x + affine_constant ω ≡
  2 ^ total_division_count ω
    mod 2 ^ (total_division_count ω + 1)`

if and only if

`x ≡ r mod 2 ^ (total_division_count ω + 1)`.

This is the specialization of `coprime_linear_modEq_residue` with

`A = 3 ^ ω.length`,
`B = 2 ^ total_division_count ω`,
`C = affine_constant ω`, and
`M = 2 ^ (total_division_count ω + 1)`.

The modulus is positive, and `ternary_coprime_exact_modulus` supplies the
coprimality needed to invert the ternary coefficient modulo that modulus.

This result is purely arithmetic and does not require admissibility.
Admissibility enters when the exact affine congruence is identified with
actual realization of the division word.
-/
lemma affine_exact_residue_exists
    (ω : division_word) :
    ∃ r : ℕ,
      r < 2 ^ (total_division_count ω + 1) ∧
      ∀ x : ℕ,
        Nat.ModEq
          (2 ^ (total_division_count ω + 1))
          (3 ^ ω.length * x + affine_constant ω)
          (2 ^ total_division_count ω)
        ↔
        Nat.ModEq
          (2 ^ (total_division_count ω + 1))
          x r := by
  exact
    coprime_linear_modEq_residue
      (3 ^ ω.length)
      (2 ^ total_division_count ω)
      (affine_constant ω)
      (2 ^ (total_division_count ω + 1))
      (by positivity)
      (ternary_coprime_exact_modulus ω)

/--
Every admissible division word has a unique canonical exact-realization
residue.

For an admissible word `ω`, there exists a unique natural number

`r < 2 ^ (total_division_count ω + 1)`

such that, for every natural number `x`,

`realizes x ω`

if and only if

`x ≡ r mod 2 ^ (total_division_count ω + 1)`.

Existence comes from `affine_exact_residue_exists`, which supplies a
canonical representative for the exact affine congruence, together with
`realizes_iff_exact_congruence`, which identifies that congruence with
actual realization for admissible words.

For uniqueness, if another bounded representative `s` describes the same
realization class, then the canonical representative `r` itself realizes
`ω` and therefore lies in the class represented by `s`. Hence

`r ≡ s mod 2 ^ (total_division_count ω + 1)`.

Since both representatives lie strictly below the modulus, this congruence
reduces to literal equality.

Thus every admissible division word determines a unique canonical
representative of its exact realization residue class.
-/
theorem realization_residue_exists_unique
    {ω : division_word}
    (hω : admissible_division_word ω) :
    ∃! r : ℕ,
      r < 2 ^ (total_division_count ω + 1) ∧
      ∀ x : ℕ,
        realizes x ω ↔
          Nat.ModEq
            (2 ^ (total_division_count ω + 1))
            x r := by
  rcases affine_exact_residue_exists ω with
    ⟨r, hrlt, hraff⟩
  /-
  Use admissibility to convert the canonical affine congruence class
  into the corresponding realization class.
  -/
  have hrclass :
      ∀ x : ℕ,
        realizes x ω ↔
          Nat.ModEq
            (2 ^ (total_division_count ω + 1))
            x r := by
    intro x
    exact
      (realizes_iff_exact_congruence hω).trans
        (hraff x)
  refine ⟨r, ?_, ?_⟩
  · exact ⟨hrlt, hrclass⟩
  · intro s hs
    rcases hs with ⟨hslt, hsclass⟩
    /-
    The canonical representative `r` belongs to its own class and hence
    realizes `ω`; the competing characterization therefore puts `r`
    in the class represented by `s`.
    -/
    have hrrealizes :
        realizes r ω := by
      apply (hrclass r).mpr
      exact Nat.ModEq.refl r
    have hrs :
        Nat.ModEq
          (2 ^ (total_division_count ω + 1))
          r s := by
      exact (hsclass r).mp hrrealizes
    /-
    Congruent representatives lying below the same modulus are equal
    as natural numbers.
    -/
    change
      r % (2 ^ (total_division_count ω + 1)) =
        s % (2 ^ (total_division_count ω + 1))
      at hrs
    rw [
      Nat.mod_eq_of_lt hrlt,
      Nat.mod_eq_of_lt hslt
    ] at hrs
    exact hrs.symm

/-! ## Residue Refinement, Prefix Lifting, and Realizability -/

/--
Canonical realization residues are compatible with word extension.

Suppose `rω` represents exactly the realizations of `ω`, while `rωη`
represents exactly the realizations of the extended word `ω ++ η`. Then

`rωη ≡ rω mod 2 ^ (total_division_count ω + 1)`.

The representative `rωη` belongs to its own residue class and therefore
realizes `ω ++ η`. Realization of an extended word implies realization of
its left prefix `ω`, so the residue characterization of `ω` places `rωη`
in the class represented by `rω`.

Thus extension of a division word refines its canonical realization
residue class inside that of the prefix.
-/
theorem realization_residue_append_left
    {ω η : division_word}
    {rω rωη : ℕ}
    (hrω :
      rω < 2 ^ (total_division_count ω + 1) ∧
      ∀ x : ℕ,
        realizes x ω ↔
          Nat.ModEq
            (2 ^ (total_division_count ω + 1))
            x rω)
    (hrωη :
      rωη < 2 ^ (total_division_count (ω ++ η) + 1) ∧
      ∀ x : ℕ,
        realizes x (ω ++ η) ↔
          Nat.ModEq
            (2 ^ (total_division_count (ω ++ η) + 1))
            x rωη) :
    Nat.ModEq
      (2 ^ (total_division_count ω + 1))
      rωη
      rω := by
  rcases hrω with ⟨_, hrω_class⟩
  rcases hrωη with ⟨_, hrωη_class⟩
  /-
  The longer-word representative realizes the extension, hence also its
  left prefix, and therefore lies in the prefix realization class.
  -/
  have hrωη_realizes :
      realizes rωη (ω ++ η) := by
    apply (hrωη_class rωη).mpr
    exact Nat.ModEq.refl rωη
  have hrωη_prefix :
      realizes rωη ω := by
    exact realizes_append_left hrωη_realizes
  exact (hrω_class rωη).mp hrωη_prefix

/--
Realization is inherited by every finite prefix.

If `x` realizes a division word `ω`, then for any natural number `j`,
the same starting value realizes the prefix `ω.take j`.

The proof decomposes

`ω = ω.take j ++ ω.drop j`

and applies `realizes_append_left` to discard the suffix. Thus realization
is prefix-closed.
-/
lemma realizes_take
    {x : ℕ} {ω : division_word}
    (h : realizes x ω)
    (j : ℕ) :
    realizes x (ω.take j) := by
  rw [← List.take_append_drop j ω] at h
  exact realizes_append_left h

/--
Canonical realization residues are compatible with arbitrary prefixes.

Suppose `rω` represents exactly the realizations of `ω`, while `rj`
represents exactly the realizations of the prefix `ω.take j`. Then

`rω ≡ rj mod
  2 ^ (total_division_count (ω.take j) + 1)`.

The full-word representative `rω` belongs to its own residue class and
therefore realizes `ω`. By `realizes_take`, it also realizes `ω.take j`,
so the residue characterization of that prefix places `rω` in the class
represented by `rj`.

Thus the canonical residue of a full word reduces compatibly to the
canonical residue of every finite prefix.
-/
theorem realization_residue_take
    {ω : division_word}
    {j rj rω : ℕ}
    (hrj :
      rj < 2 ^ (total_division_count (ω.take j) + 1) ∧
      ∀ x : ℕ,
        realizes x (ω.take j) ↔
          Nat.ModEq
            (2 ^ (total_division_count (ω.take j) + 1))
            x rj)
    (hrω :
      rω < 2 ^ (total_division_count ω + 1) ∧
      ∀ x : ℕ,
        realizes x ω ↔
          Nat.ModEq
            (2 ^ (total_division_count ω + 1))
            x rω) :
    Nat.ModEq
      (2 ^ (total_division_count (ω.take j) + 1))
      rω
      rj := by
  rcases hrj with ⟨_, hrj_class⟩
  rcases hrω with ⟨_, hrω_class⟩
  /-
  The full-word representative realizes `ω`, hence its prefix, and
  therefore belongs to the prefix realization class.
  -/
  have hrω_realizes :
      realizes rω ω := by
    apply (hrω_class rω).mpr
    exact Nat.ModEq.refl rω
  have hrω_prefix :
      realizes rω (ω.take j) := by
    exact realizes_take hrω_realizes j
  exact (hrj_class rω).mp hrω_prefix

/--
Positive-length prefixes of an admissible division word are admissible.

If `ω` is admissible and

`0 < j ≤ ω.length`,

then the prefix `ω.take j` is also admissible.

The prefix is nonempty because its length is exactly `j`, while positivity
of its entries is inherited from `ω`.

This allows admissibility-based realization and residue results to be
applied uniformly to nonempty prefixes.
-/
lemma admissible_division_word_take
    {ω : division_word}
    (hω : admissible_division_word ω)
    {j : ℕ}
    (hjpos : 0 < j)
    (hjle : j ≤ ω.length) :
    admissible_division_word (ω.take j) := by
  rcases hω with ⟨_, hpos⟩
  constructor
  · unfold valid_division_word
    rw [List.length_take, Nat.min_eq_left hjle]
    exact hjpos
  · intro d hd
    apply hpos d
    exact List.mem_of_mem_take hd

/--
`realization_residue ω r` means that `r` is the canonical representative
of the exact realization class of the division word `ω`.

Concretely,

`r < 2 ^ (total_division_count ω + 1)`,

and for every natural number `x`,

`realizes x ω`

if and only if

`x ≡ r mod 2 ^ (total_division_count ω + 1)`.

Thus the predicate packages both the canonical representative bound and the
exact characterization of the corresponding realization class.
-/
def realization_residue
    (ω : division_word) (r : ℕ) : Prop :=
  r < 2 ^ (total_division_count ω + 1) ∧
  ∀ x : ℕ,
    realizes x ω ↔
      Nat.ModEq
        (2 ^ (total_division_count ω + 1))
        x r

/--
Every admissible division word has a unique canonical realization residue.

This is `realization_residue_exists_unique` expressed using the packaged
predicate `realization_residue`.
-/
theorem realization_residue_exists_unique'
    {ω : division_word}
    (hω : admissible_division_word ω) :
    ∃! r : ℕ, realization_residue ω r := by
  exact realization_residue_exists_unique hω

/--
Residue lifting along the positive prefixes of an admissible division word.

Let `ω` be admissible. Then:

1. every positive prefix `ω.take j`, with `0 < j ≤ ω.length`, has a unique
   canonical realization residue;

2. if `rj` and `rj1` are the canonical realization residues of consecutive
   prefixes `ω.take j` and `ω.take (j + 1)`, then

   `rj1 ≡ rj mod
     2 ^ (total_division_count (ω.take j) + 1)`.

Thus the exact realization classes form a compatible nested system as the
prefix length increases.

The first statement follows because every positive prefix of an admissible
word is itself admissible. For the second, the representative of the longer
prefix realizes that prefix and therefore also realizes the shorter one;
the shorter residue characterization then places it in the corresponding
canonical class.

This theorem packages the prefix-by-prefix residue refinement structure
used in the subsequent nested realization-class development.
-/
theorem residue_lifting_theorem
    {ω : division_word}
    (hω : admissible_division_word ω) :
    (∀ j : ℕ,
      0 < j →
      j ≤ ω.length →
      ∃! r : ℕ,
        realization_residue (ω.take j) r)
    ∧
    (∀ j : ℕ,
      0 < j →
      j + 1 ≤ ω.length →
      ∀ rj rj1 : ℕ,
        realization_residue (ω.take j) rj →
        realization_residue (ω.take (j + 1)) rj1 →
        Nat.ModEq
          (2 ^ (total_division_count (ω.take j) + 1))
          rj1
          rj) := by
  constructor
  /-
  Every positive prefix is admissible and therefore has a unique
  canonical realization residue.
  -/
  · intro j hjpos hjle
    have hprefix :
        admissible_division_word (ω.take j) := by
      exact
        admissible_division_word_take
          hω hjpos hjle
    exact
      realization_residue_exists_unique'
        hprefix
  /-
  The longer-prefix representative realizes the longer prefix, hence
  also the shorter one, and therefore lies in the shorter residue class.
  -/
  · intro j hjpos hj1le rj rj1 hrj hrj1
    rcases hrj with
      ⟨_, hrj_class⟩
    rcases hrj1 with
      ⟨_, hrj1_class⟩
    have hrj1_realizes :
        realizes rj1 (ω.take (j + 1)) := by
      apply (hrj1_class rj1).mpr
      exact Nat.ModEq.refl rj1
    have hrj1_prefix :
        realizes rj1 (ω.take j) := by
      have htake :
          realizes rj1 ((ω.take (j + 1)).take j) := by
        exact realizes_take hrj1_realizes j
      simpa [List.take_take, Nat.min_eq_left (by omega)] using htake
    exact
      (hrj_class rj1).mp hrj1_prefix

/--
Every admissible division word is realizable by some natural number.

If `ω` is admissible, then there exists `x : ℕ` such that

`realizes x ω`.

The proof uses the unique canonical realization residue `r` associated
with `ω`. Since `r` is congruent to itself modulo the exact realization
modulus, its residue characterization immediately shows that `r` realizes
`ω`.

Thus admissibility is not merely a formal positivity condition: every
admissible finite division word occurs along some fully accelerated Collatz
trajectory.
-/
theorem admissible_division_word_realizable
    {ω : division_word}
    (hω : admissible_division_word ω) :
    ∃ x : ℕ, realizes x ω := by
  rcases realization_residue_exists_unique' hω with
    ⟨r, hr, _⟩
  rcases hr with ⟨_, hrclass⟩
  refine ⟨r, ?_⟩
  exact
    (hrclass r).mpr
      (Nat.ModEq.refl r)

/-! ## Prefix Comparability and Nested Realization Classes -/

/--
A starting value realizes at most one division word of any given length.

If `x` realizes both `ω` and `η` and

`ω.length = η.length`,

then `ω = η`.

Indeed, both words are equal to the same generated division-count prefix

`division_counts x ω.length`.

Thus a realized division word is uniquely determined by its starting value
and its length.
-/
lemma realizes_eq_of_length_eq
    {x : ℕ} {ω η : division_word}
    (hω : realizes x ω)
    (hη : realizes x η)
    (hlen : ω.length = η.length) :
    ω = η := by
  calc
    ω = division_counts x ω.length := hω
    _ = division_counts x η.length := by rw [hlen]
    _ = η := hη.symm

/--
If a starting value realizes two division words and one is no longer than
the other, then the shorter word is exactly the corresponding prefix of
the longer word.

Suppose `x` realizes both `ω` and `η`, with

`ω.length ≤ η.length`.

By prefix-closure, `x` also realizes `η.take ω.length`. This prefix has the
same length as `ω`, so `realizes_eq_of_length_eq` forces

`ω = η.take ω.length`.

Thus two division words realized by the same starting value cannot disagree
before the shorter word ends.
-/
lemma realizes_prefix_of_length_le
    {x : ℕ} {ω η : division_word}
    (hω : realizes x ω)
    (hη : realizes x η)
    (hlen : ω.length ≤ η.length) :
    ω = η.take ω.length := by
  have htake :
      realizes x (η.take ω.length) := by
    exact realizes_take hη ω.length
  have htake_length :
      (η.take ω.length).length = ω.length := by
    simp [List.length_take, Nat.min_eq_left hlen]
  exact
    realizes_eq_of_length_eq
      hω
      htake
      htake_length.symm

/--
Two division words realized by the same starting value are prefix-comparable.

If `x` realizes both `ω` and `η`, then either

`ω = η.take ω.length`

or

`η = ω.take η.length`.

Thus one realized word must be an initial segment of the other: two
distinct realized words from the same starting value cannot diverge and
then later rejoin.

The proof compares the word lengths and applies
`realizes_prefix_of_length_le` to the shorter word.
-/
theorem common_realization_implies_prefix
    {x : ℕ} {ω η : division_word}
    (hω : realizes x ω)
    (hη : realizes x η) :
    ω = η.take ω.length ∨
      η = ω.take η.length := by
  rcases le_total ω.length η.length with hle | hle
  · exact Or.inl
      (realizes_prefix_of_length_le hω hη hle)
  · exact Or.inr
      (realizes_prefix_of_length_le hη hω hle)

/--
Realization classes of division words are either nested or disjoint.

For any two division words `ω` and `η`, at least one of the following
structural situations must occur:

* every realization of `η` also realizes `ω`;
* every realization of `ω` also realizes `η`;
* no natural number realizes both words.

If the two classes intersect, a common realization forces `ω` and `η` to
be prefix-comparable by `common_realization_implies_prefix`. Realization
of the longer word then implies realization of the shorter prefix, yielding
one of the two containment relations.

If the classes do not intersect, they are disjoint.

Thus realization classes cannot partially overlap: any nonempty
intersection forces one class to be contained in the other. This is the
realization-level form of the nested-or-disjoint structure later transferred
to exact residue classes and dyadic cylinders.
-/
theorem realization_classes_nested_or_disjoint
    {ω η : division_word} :
    (∀ x : ℕ, realizes x η → realizes x ω) ∨
    (∀ x : ℕ, realizes x ω → realizes x η) ∨
    (∀ x : ℕ, ¬ (realizes x ω ∧ realizes x η)) := by
  /-
  Split according to whether the two realization classes have a common
  element.
  -/
  by_cases hcommon :
      ∃ x : ℕ, realizes x ω ∧ realizes x η
  · rcases hcommon with ⟨x, hxω, hxη⟩
    /-
    A common realization makes the two words prefix-comparable; the
    corresponding prefix relation determines which realization class
    is contained in the other.
    -/
    rcases
        common_realization_implies_prefix hxω hxη
      with hprefix | hprefix
    · left
      intro y hy
      rw [hprefix]
      exact realizes_take hy ω.length
    · right
      left
      intro y hy
      rw [hprefix]
      exact realizes_take hy η.length
  · right
    right
    intro x hx
    exact hcommon ⟨x, hx.1, hx.2⟩

/--
Exact realization residue classes are either nested or disjoint.

Suppose `rω` and `rη` are realization residues for the division words
`ω` and `η`. Then one of the following structural relations holds:

* every natural number in the exact residue class of `η` also lies in the
  exact residue class of `ω`;
* every natural number in the exact residue class of `ω` also lies in the
  exact residue class of `η`;
* the two exact residue classes have no common natural number.

The proof transfers `realization_classes_nested_or_disjoint` through the
realization-class characterizations supplied by `hrω` and `hrη`.

Thus the prefix structure of realized division words is reflected directly
in the arithmetic structure of their exact dyadic residue classes: such
classes cannot partially overlap.

This is the arithmetic endpoint of the realizability development and the
handoff to the subsequent dyadic-cylinder theory, where these residue
classes are treated as nested or disjoint cylinders.
-/
theorem exact_residue_classes_nested_or_disjoint
    {ω η : division_word}
    {rω rη : ℕ}
    (hrω : realization_residue ω rω)
    (hrη : realization_residue η rη) :
    (∀ x : ℕ,
      Nat.ModEq
        (2 ^ (total_division_count η + 1))
        x rη →
      Nat.ModEq
        (2 ^ (total_division_count ω + 1))
        x rω)
    ∨
    (∀ x : ℕ,
      Nat.ModEq
        (2 ^ (total_division_count ω + 1))
        x rω →
      Nat.ModEq
        (2 ^ (total_division_count η + 1))
        x rη)
    ∨
    (∀ x : ℕ,
      ¬ (
        Nat.ModEq
          (2 ^ (total_division_count ω + 1))
          x rω
        ∧
        Nat.ModEq
          (2 ^ (total_division_count η + 1))
          x rη)) := by
  rcases hrω with ⟨_, hrω_class⟩
  rcases hrη with ⟨_, hrη_class⟩
  /-
  Transfer each of the three realization-class relations through the
  corresponding exact residue-class characterizations.
  -/
  rcases
      realization_classes_nested_or_disjoint
        (ω := ω) (η := η)
    with hsubset | hrest
  · left
    intro x hx
    apply (hrω_class x).mp
    apply hsubset
    exact (hrη_class x).mpr hx
  · rcases hrest with hsubset | hdisjoint
    · right
      left
      intro x hx
      apply (hrη_class x).mp
      apply hsubset
      exact (hrω_class x).mpr hx
    · right
      right
      intro x hx
      apply hdisjoint x
      constructor
      · exact (hrω_class x).mpr hx.1
      · exact (hrη_class x).mpr hx.2

end Collatz
