/-
Copyright (c) 2026 Wayne Brassem. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Wayne Brassem
-/

import Collatz.DivisionWords

/-!

# Affine Representation of Division Words

This module develops the exact affine representation associated with finite
division words for the fully accelerated Collatz map.

The preceding module, `Collatz.DivisionWords`, defines the ordinary and fully
accelerated Collatz maps, finite division words, their total division counts,
and the realization relation between a natural number and a division word.

The purpose of the present module is to convert that symbolic data into an
exact affine representation. The construction is first carried out formally
over `ℚ`, independently of whether a division word is realized by an actual
Collatz trajectory, and is then connected back to the natural-number
dynamics.

For a division word `ω`, the associated affine map has the form

    F_ω(x)
      =
    (3 ^ ω.length * x + affine_constant ω) /
      2 ^ total_division_count ω.

The development separates naturally into six stages.

## 1. Symbolic Action and the Closed Affine Representation

A prescribed division count `d` determines the formal rational step

    symbolic_step d x
      =
    (3 * x + 1) / 2 ^ d.

Composing these prescribed steps along a division word gives

    word_action ω x.

Independently, the module defines the recursively generated natural-number
constant

    affine_constant ω

and the closed-form rational map

    affine_map ω x
      =
    (3 ^ ω.length * x + affine_constant ω) /
      2 ^ total_division_count ω.

The central algebraic identity is

    word_action ω x = affine_map ω x.

This equality holds for every formal division word and every rational input;
no realizability hypothesis is required.

Thus a finite symbolic division word already determines a single exact affine
transformation before any connection to an actual Collatz trajectory is made.

## 2. Concatenation and Prefix Structure

Concatenation of division words corresponds exactly to composition of their
symbolic and affine actions.

If `ω ++ η` denotes the word obtained by appending `η` to `ω`, then

    word_action (ω ++ η) x
      =
    word_action η (word_action ω x),

and therefore

    affine_map (ω ++ η) x
      =
    affine_map η (affine_map ω x).

The affine constants satisfy the corresponding semigroup law

    affine_constant (ω ++ η)
      =
    3 ^ η.length * affine_constant ω
      +
    2 ^ total_division_count ω * affine_constant η.

The generated division-count sequence also respects finite prefixes.
In particular, taking the first part of a generated division-count word agrees
with generating only that many division counts, and realization of a
concatenated word implies realization of its left-hand prefix.

These results provide the prefix and concatenation structure used throughout
the later realizability and cylinder theory.

## 3. Realized Words and Accelerated Trajectories

The formal affine construction is independent of realizability. This section
establishes the bridge to the actual fully accelerated Collatz dynamics.

At one symbolic step, prescribing the actual division count of a natural
number reproduces one fully accelerated Collatz step after coercion to `ℚ`:

    symbolic_step (division_count x) x
      =
    fully_accelerated x.

Iteration then gives the principal dynamical correspondence. If `x` realizes
a division word `ω`, then

    word_action ω x
      =
    (fully_accelerated^[ω.length]) x,

after coercion to `ℚ`.

Combining this identity with the closed affine representation yields

    affine_map ω x
      =
    (fully_accelerated^[ω.length]) x.

Thus the formal affine map agrees exactly with the finite accelerated Collatz
trajectory whenever the division word is realized.

## 4. Explicit Form of the Affine Constant

The affine constant is initially defined recursively because that form is
natural for symbolic composition. This section derives the explicit
prefix-sum representation used in the mathematical development.

For

    prefix_division_count ω j
      =
    total_division_count (ω.take j),

define

    explicit_affine_constant ω
      =
    ∑ j < ω.length,
      3 ^ (ω.length - 1 - j) *
        2 ^ prefix_division_count ω j.

Supporting lemmas describe how prefix division counts change when a new head
is added and how the finite sum separates into its initial term and shifted
tail.

The explicit expression is shown to satisfy the same head-tail recurrence as
the recursively defined affine constant. Consequently,

    affine_constant ω
      =
    explicit_affine_constant ω.

This identifies the recursive symbolic constant with the closed finite sum
appearing in the affine formula.

## 5. Dyadic-Ternary Balance and Threshold Structure

The affine representation naturally compares cumulative multiplication by
`3` with cumulative division by powers of `2`.

The dyadic threshold is defined by

    dyadic_threshold m
      =
    (3 ^ m).log2 + 1.

It is characterized exactly as the least natural exponent `k` satisfying

    3 ^ m < 2 ^ k.

Equivalently,

    dyadic_threshold m ≤ k
      ↔
    3 ^ m < 2 ^ k.

Applied to a division word, this gives

    dyadic_threshold ω.length ≤ total_division_count ω
      ↔
    3 ^ ω.length < 2 ^ total_division_count ω.

The module also packages the threshold as a least-element statement and
connects it with the real-logarithmic expression

    dyadic_threshold m
      =
    ⌊m * log₂ 3⌋ + 1.

A supporting positivity result shows that the affine constant is strictly
positive for every nonempty division word.

These results isolate the exact discrete boundary between ternary growth and
dyadic division.

## 6. Affine Slope and Strict Separation from One

The linear coefficient of the affine map is recorded separately as

    affine_slope ω
      =
    3 ^ ω.length /
      2 ^ total_division_count ω.

The dyadic-threshold characterization gives the exact criterion

    affine_slope ω < 1
      ↔
    dyadic_threshold ω.length ≤ total_division_count ω.

For every nonempty division word, the dyadic and ternary powers cannot be
equal:

    2 ^ total_division_count ω
      ≠
    3 ^ ω.length.

Hence the affine slope is strictly separated from `1`:

    affine_slope ω < 1
      ∨
    1 < affine_slope ω.

This is a dichotomy for the linear coefficient only. A slope below one does
not by itself imply pointwise descent of the affine map, because the positive
affine constant must also be taken into account. The subsequent contraction
analysis uses both pieces of affine data.

## Dependency flow

The main logical dependencies are:

    Collatz.DivisionWords
          │
          │  division_word
          │  total_division_count
          │  division_count
          │  fully_accelerated
          │  division_counts
          │  realizes
          ▼
    ┌──────────────────────────────────────────────┐
    │ Symbolic action and closed affine form       │
    │                                              │
    │ symbolic_step                                │
    │      ↓                                       │
    │ word_action                                  │
    │      ↓                                       │
    │ word_action_eq_affine_map                    │
    │      ↑                                       │
    │ affine_constant ─────────► affine_map        │
    └──────────────────────────────────────────────┘
          │
          ├─────────────────────────────┐
          │                             │
          ▼                             ▼
    ┌──────────────────────────┐  ┌──────────────────────────┐
    │ Concatenation and prefix │  │ Explicit affine constant │
    │ structure                │  │                          │
    │                          │  │ prefix_division_count    │
    │ word_action_append       │  │      ↓                   │
    │      ↓                   │  │ explicit_affine_constant │
    │ affine_map_append        │  │      ↓                   │
    │      ↓                   │  │ explicit_..._cons        │
    │ affine_constant_append   │  │      ↓                   │
    │                          │  │ affine_constant_eq_...   │
    │ division_counts_take     │  └──────────────────────────┘
    │      ↓                   │
    │ realizes_append_left     │
    └──────────────────────────┘
          │
          ▼
    ┌──────────────────────────────────────────────┐
    │ Realized words and accelerated trajectories  │
    │                                              │
    │ symbolic_step_division_count                 │
    │      ↓                                       │
    │ word_action_realized                         │
    │      ↓                                       │
    │ affine_map_realized                          │
    └──────────────────────────────────────────────┘


    Collatz.DivisionWords
          │
          │  word length and total division count
          ▼
    ┌──────────────────────────────────────────────┐
    │ Dyadic-ternary balance and threshold         │
    │                                              │
    │ dyadic_threshold                             │
    │      ↓                                       │
    │ dyadic_threshold_le_iff                      │
    │      ├── dyadic_threshold_le_total_iff       │
    │      ├── dyadic_threshold_isLeast            │
    │      └── dyadic_threshold_eq_floor_log       │
    └──────────────────────────────────────────────┘
          │
          ▼
    ┌──────────────────────────────────────────────┐
    │ Affine slope and strict separation from one  │
    │                                              │
    │ affine_slope                                 │
    │      ↓                                       │
    │ affine_slope_lt_one_iff                      │
    │                                              │
    │ dyadic_ternary_ne                            │
    │      ↓                                       │
    │ affine_slope_lt_or_gt_one                    │
    └──────────────────────────────────────────────┘

The exact affine representation, concatenation structure, realization bridge,
explicit constant formula, and dyadic-threshold analysis developed here
supply the algebraic foundation for the exact realizability and cylinder
theory in subsequent modules and for the later analysis of affine contraction
and descent.

-/

/- BigOperators required for summation in the explicit formula for the affine constant -/
open scoped BigOperators

namespace Collatz

/-! ## Symbolic Action and the Closed Affine Representation -/

/--
One formal Collatz step using the prescribed division count `d`.

The exponent `d` is symbolic and need not equal the actual `2`-adic
valuation of `3 * x + 1`.
-/
def symbolic_step (d : ℕ) (x : ℚ) : ℚ :=
  (3 * x + 1) / 2 ^ d

/--
Apply the formal Collatz steps encoded by a division word, from left to right.
-/
def word_action : division_word → ℚ → ℚ
  | [], x => x
  | d :: ω, x => word_action ω (symbolic_step d x)

/--
The natural-number constant term associated with a division word in its
affine representation.

For a nonempty word `d :: ω`, the constant satisfies the recursion

`c(d :: ω) = 3 ^ ω.length + 2 ^ d * c(ω)`.
-/
def affine_constant : division_word → ℕ
  | [] => 0
  | d :: ω =>
      3 ^ ω.length + 2 ^ d * affine_constant ω

/--
The formal affine map associated with a division word `ω`.

It is the rational map

`F_ω(x) = (3 ^ ω.length * x + affine_constant ω) /
  2 ^ total_division_count ω`.

The map is defined for every formal division word, independently of
whether `ω` is realized by an actual Collatz trajectory.
-/
def affine_map (ω : division_word) (x : ℚ) : ℚ :=
  ((3 : ℚ) ^ ω.length * x + (affine_constant ω : ℚ)) /
    (2 : ℚ) ^ total_division_count ω

/--
The recursively composed symbolic action of a division word agrees
with its closed-form affine representation.

This is a purely algebraic identity and holds for every division word,
independently of realizability. The proof proceeds by induction, composing
the head symbolic step with the affine representation of the tail.
-/
theorem word_action_eq_affine_map
    (ω : division_word) (x : ℚ) :
    word_action ω x = affine_map ω x := by
  /-
  Generalize `x` because the induction hypothesis is applied to the tail
  at the new starting value `symbolic_step d x`.
  -/
  induction ω generalizing x with
  | nil =>
      simp [word_action, affine_map, affine_constant, total_division_count]
  | cons d ω ih =>
      rw [word_action]
      rw [ih]
      unfold affine_map
      unfold symbolic_step
      simp only [affine_constant, total_division_count,
        List.length_cons, List.sum_cons]
      push_cast
      rw [pow_succ, pow_add]
      /-
      After expanding the recursive affine data, clear the powers-of-two
      denominators; the remaining statement is a polynomial identity.
      -/
      field_simp
      ring

/-! ## Concatenation and Prefix Structure -/

/--
Acting by a concatenated division word is the same as first acting by
the prefix word and then by the appended word.
-/
lemma word_action_append
    (ω η : division_word) (x : ℚ) :
    word_action (ω ++ η) x =
      word_action η (word_action ω x) := by
  induction ω generalizing x with
  | nil =>
      simp [word_action]
  | cons d ω ih =>
      simp [word_action, ih]

/--
The affine representation respects concatenation of division words.

For `ω ++ η`, the affine map of `ω` acts first and the affine map of `η`
acts on the result.
-/
theorem affine_map_append
    (ω η : division_word) (x : ℚ) :
    affine_map (ω ++ η) x =
      affine_map η (affine_map ω x) := by
  rw [← word_action_eq_affine_map]
  rw [word_action_append]
  rw [word_action_eq_affine_map]
  rw [word_action_eq_affine_map]

/--
The affine constant of a concatenated division word satisfies the
composition law

`c(ω ++ η) = 3 ^ η.length * c(ω) +
  2 ^ total_division_count ω * c(η)`.

This is the constant-term identity corresponding to composition of the
affine maps associated with `ω` and `η`.
-/
lemma affine_constant_append
    (ω η : division_word) :
    affine_constant (ω ++ η) =
      3 ^ η.length * affine_constant ω +
      2 ^ total_division_count ω * affine_constant η := by
  induction ω with
  | nil =>
      simp [affine_constant, total_division_count]
  | cons d ω ih =>
      rw [List.cons_append]
      rw [affine_constant]
      unfold total_division_count
      rw [ih]
      unfold total_division_count
      /-
      Expand the list invariants and recursive affine constant,
      then normalize the resulting algebraic identity.
      -/
      simp only [List.length_append, List.sum_cons, affine_constant, pow_add]
      ring

/--
The first `m` generated division counts are the first `m` entries
of any longer generated division-count word.
-/
lemma division_counts_take
    (x m n : ℕ) :
    (division_counts x (m + n)).take m =
      division_counts x m := by
  induction m generalizing x with
  | zero =>
      simp [division_counts]
  | succ m ih =>
      /-
      Reassociate the requested length so that `List.iterate`
      exposes the initial trajectory state.
      -/
      have hlen : m + 1 + n = (m + n) + 1 := by
        omega
      rw [hlen]
      simp only [division_counts, List.iterate,
        List.map_cons, List.take_succ_cons, List.cons.injEq, true_and]
      /-
      The remaining tail begins at `fully_accelerated x`, so restate
      the goal in the form of the induction hypothesis.
      -/
      change
        List.take m
            (division_counts (fully_accelerated x) (m + n)) =
          division_counts (fully_accelerated x) m
      exact ih (fully_accelerated x)

/--
Any realization of a concatenated division word also realizes
its left-hand prefix.
-/
theorem realizes_append_left
    {x : ℕ} {ω η : division_word}
    (h : realizes x (ω ++ η)) :
    realizes x ω := by
  unfold realizes at h ⊢
  /-
  Take the first `ω.length` entries of the realization equality for
  `ω ++ η`; both sides then reduce to the realization equality for `ω`.
  -/
  have ht := congrArg (List.take ω.length) h
  simpa [List.length_append, division_counts_take] using ht

/-! ## Realized Words and Accelerated Trajectories -/

/--
A symbolic step using the actual division count of `x` agrees with
one fully accelerated Collatz step after coercion to `ℚ`.

The symbolic step is defined using division in `ℚ`, whereas
`fully_accelerated` uses natural-number division. The definition of
`division_count` guarantees that the required power of two divides
`3 * x + 1` exactly, so these two forms of division agree after coercion.
-/
lemma symbolic_step_division_count
    (x : ℕ) :
    symbolic_step (division_count x) (x : ℚ) =
      (fully_accelerated x : ℚ) := by
  unfold symbolic_step
  unfold fully_accelerated
  /- The full power of `2` specified by the division count divides the numerator. -/
  have hdiv :
      2 ^ division_count x ∣ 3 * x + 1 := by
    unfold division_count
    exact (padicValNat_dvd_iff_le
      (p := 2)
      (a := 3 * x + 1)
      (n := padicValNat 2 (3 * x + 1))
      (by omega)).mpr le_rfl
  /- Exact divisibility allows the natural quotient to be coerced to rational division. -/
  rw [Nat.cast_div hdiv]
  · norm_num
  · positivity

/--
If `x` realizes the division word `ω`, then the symbolic action encoded
by `ω` agrees, after coercion to `ℚ`, with `ω.length` iterations of the
fully accelerated Collatz map.

This is the dynamical bridge between the formal symbolic action and the
actual accelerated trajectory.
-/
theorem word_action_realized
    {x : ℕ} {ω : division_word}
    (h : realizes x ω) :
    word_action ω (x : ℚ) =
      (((fully_accelerated^[ω.length]) x : ℕ) : ℚ) := by
  /-
  Generalize `x` because after consuming the head of the word, the tail
  is realized from `fully_accelerated x`.
  -/
  induction ω generalizing x with
  | nil =>
      simp [word_action]
  | cons d ω ih =>
      /-
      Realization of `d :: ω` identifies the head with the actual
      division count at `x` and the tail with the counts generated
      from the next accelerated state.
      -/
      unfold realizes at h
      simp only [division_counts, List.length_cons, List.iterate,
        List.map_cons, List.cons.injEq] at h
      rcases h with ⟨hd, htail⟩
      /- Repackage the tail equality as realization from the next state. -/
      have hrealizes_tail :
          realizes (fully_accelerated x) ω := by
        unfold realizes
        unfold division_counts
        exact htail
      rw [word_action]
      rw [hd]
      rw [symbolic_step_division_count]
      rw [ih hrealizes_tail]
      simp only [List.length_cons, Function.iterate_succ_apply]

/--
If `x` realizes the division word `ω`, then the formal affine map
associated with `ω` agrees, after coercion to `ℚ`, with the actual
`ω.length`-step fully accelerated Collatz trajectory starting at `x`.

This follows by combining the algebraic identity
`word_action_eq_affine_map` with the dynamical bridge
`word_action_realized`.
-/
theorem affine_map_realized
    {x : ℕ} {ω : division_word}
    (h : realizes x ω) :
    affine_map ω (x : ℚ) =
      ((fully_accelerated^[ω.length]) x : ℚ) := by
  rw [← word_action_eq_affine_map]
  exact word_action_realized h

/-! ## Explicit Form of the Affine Constant -/

/--
The total division count of the length-`j` prefix of `ω`.
-/
def prefix_division_count
    (ω : division_word) (j : ℕ) : ℕ :=
  total_division_count (ω.take j)

/--
The explicit summation formula for the affine constant of `ω`.

The term indexed by `j` contributes the factor
`3 ^ (ω.length - 1 - j)` together with the power of `2` accumulated
from the first `j` division counts of `ω`.
-/
def explicit_affine_constant
    (ω : division_word) : ℕ :=
  ∑ j ∈ Finset.range ω.length,
    3 ^ (ω.length - 1 - j) *
      2 ^ prefix_division_count ω j

/--
Prepending a division count `d` shifts every positive prefix count by one.

The first `j + 1` entries of `d :: ω` consist of the head `d`
followed by the first `j` entries of `ω`. Therefore their total
division count is `d` plus the corresponding prefix division count
of the tail.
-/
lemma prefix_division_count_cons_succ
    (d : ℕ) (ω : division_word) (j : ℕ) :
    prefix_division_count (d :: ω) (j + 1) =
      d + prefix_division_count ω j := by
  unfold prefix_division_count
  unfold total_division_count
  simp

/--
Split a finite sum over `0, ..., n` into its initial term and a
reindexed sum over the remaining terms:

`∑ j ∈ Finset.range (n + 1), f j =
  f 0 + ∑ j ∈ Finset.range n, f (j + 1)`.

This is the initial-term counterpart of `Finset.sum_range_succ`, which
peels off the final term. The shifted form is useful when a recursive
construction separates the contribution at index `0` from those
associated with the tail of a sequence.
-/
lemma sum_range_succ_shift
    {M : Type*} [AddCommMonoid M]
    (f : ℕ → M) (n : ℕ) :
    (∑ j ∈ Finset.range (n + 1), f j) =
      f 0 + ∑ j ∈ Finset.range n, f (j + 1) := by
  induction n with
  | zero =>
      simp
  | succ n ih =>
      rw [Finset.sum_range_succ]
      rw [ih]
      rw [Finset.sum_range_succ]
      simp [add_assoc]

/--
The explicit affine constant satisfies the same head-tail recurrence as
the recursively defined affine constant.

For `d :: ω`, the index-zero term contributes `3 ^ ω.length`. The
remaining terms correspond to the indices of `ω`, and
`prefix_division_count_cons_succ` contributes an additional initial
division count `d`. Hence every remaining dyadic factor contains the
common factor `2 ^ d`, giving

`explicit_affine_constant (d :: ω) =
  3 ^ ω.length + 2 ^ d * explicit_affine_constant ω`.

This recurrence is the key step in proving that the recursive and explicit
definitions of the affine constant agree.
-/
lemma explicit_affine_constant_cons
    (d : ℕ) (ω : division_word) :
    explicit_affine_constant (d :: ω) =
      3 ^ ω.length +
        2 ^ d * explicit_affine_constant ω := by
  unfold explicit_affine_constant
  simp only [List.length_cons]
  /- Separate the index-zero contribution from the reindexed tail sum. -/
  rw [sum_range_succ_shift]
  have hp0 :
      prefix_division_count (d :: ω) 0 = 0 := by
    simp [prefix_division_count, total_division_count]
  rw [hp0]
  simp only [
    Nat.add_sub_cancel,
    Nat.sub_zero,
    pow_zero,
    mul_one
  ]
  /-
  After the leading terms agree, distribute the common factor `2 ^ d`
  and compare the remaining summands pointwise.
  -/
  congr 1
  rw [Finset.mul_sum]
  apply Finset.sum_congr rfl
  intro j _
  /-
  The shifted ternary exponent must be normalized explicitly because
  subtraction on `ℕ` is truncated.
  -/
  have hexp :
      ω.length - (j + 1) =
        ω.length - 1 - j := by
    omega
  rw [prefix_division_count_cons_succ]
  rw [hexp]
  rw [pow_add]
  ring

/--
The recursively defined affine constant agrees with its explicit
prefix-sum formula.

The proof uses the fact that both constructions satisfy the same
head-tail recurrence. For the empty word both constants are zero.
For a nonempty word `d :: ω`, the recursive definition gives
`c(d :: ω) = 3 ^ ω.length + 2 ^ d * c(ω)`, while
`explicit_affine_constant_cons` establishes the identical recurrence
for the explicit prefix-sum formula. The induction hypothesis then
identifies the constants associated with the tail.

Consequently, the recursive definition used to construct the affine
map and the explicit summation formula are two representations of the
same affine constant.
-/
theorem affine_constant_eq_explicit
    (ω : division_word) :
    affine_constant ω = explicit_affine_constant ω := by
  induction ω with
  | nil =>
      simp [affine_constant, explicit_affine_constant]
  | cons d ω ih =>
      rw [affine_constant]
      rw [explicit_affine_constant_cons]
      rw [ih]

/-! ## Dyadic-Ternary Balance and Threshold Structure -/

/--
The least exponent `k` such that `2 ^ k > 3 ^ m`.
-/
def dyadic_threshold (m : ℕ) : ℕ :=
  (3 ^ m).log2 + 1

/--
The dyadic threshold `dyadic_threshold m` characterizes exactly those
exponents `k` for which the dyadic factor `2 ^ k` exceeds the ternary
factor `3 ^ m`.

Equivalently,

`dyadic_threshold m ≤ k ↔ 3 ^ m < 2 ^ k`.

Thus every exponent at or above the threshold gives strict dyadic
dominance, while every exponent below it fails to do so.
-/
theorem dyadic_threshold_le_iff
    (m k : ℕ) :
    dyadic_threshold m ≤ k ↔
      3 ^ m < 2 ^ k := by
  unfold dyadic_threshold
  have hnonzero : 3 ^ m ≠ 0 := by
    positivity
  /-
  `Nat.log2_lt` converts strict comparison with a power of two into
  the corresponding strict inequality for the base-two logarithm.
  -/
  constructor
  · intro h
    have hlog : (3 ^ m).log2 < k := by
      omega
    exact (Nat.log2_lt hnonzero).mp hlog
  · intro h
    have hlog : (3 ^ m).log2 < k := by
      exact (Nat.log2_lt hnonzero).mpr h
    omega

/--
For a division word `ω`, its total division count reaches the dyadic
threshold exactly when its cumulative dyadic factor exceeds its
cumulative ternary factor:

`dyadic_threshold ω.length ≤ total_division_count ω ↔
  3 ^ ω.length < 2 ^ total_division_count ω`.

Equivalently, this is precisely the condition under which the linear
coefficient

`3 ^ ω.length / 2 ^ total_division_count ω`

of the associated affine map is strictly less than `1`.

This concerns only the linear coefficient; it does not by itself imply
that the affine map sends a realization below its starting value.
-/
theorem dyadic_threshold_le_total_iff
    (ω : division_word) :
    dyadic_threshold ω.length ≤ total_division_count ω ↔
      3 ^ ω.length <
        2 ^ total_division_count ω := by
  exact dyadic_threshold_le_iff
    ω.length
    (total_division_count ω)

/--
The affine constant of every nonempty division word is strictly positive.

The empty word is the unique degenerate case, with `affine_constant [] = 0`.
For a nonempty word `d :: ω`,

`affine_constant (d :: ω) =
  3 ^ ω.length + 2 ^ d * affine_constant ω`,

whose first term is strictly positive. Hence the entire affine constant
is positive.
-/
lemma affine_constant_pos
    {ω : division_word}
    (hω : 0 < ω.length) :
    0 < affine_constant ω := by
  cases ω with
  | nil =>
      simp at hω
  | cons d ω =>
      simp [affine_constant]

/--
The dyadic threshold is the least natural exponent whose power of two
strictly exceeds `3 ^ m`.

Equivalently, `dyadic_threshold m` is the least element of

`{k : ℕ | 3 ^ m < 2 ^ k}`.

This packages the minimality implicit in `dyadic_threshold_le_iff` into
the order-theoretic form used by the paper: `B(m)` is the smallest
exponent at which strict dyadic dominance begins.
-/
theorem dyadic_threshold_isLeast
    (m : ℕ) :
    IsLeast
      {k : ℕ | 3 ^ m < 2 ^ k}
      (dyadic_threshold m) := by
  constructor
  · change 3 ^ m < 2 ^ dyadic_threshold m
    exact
      (dyadic_threshold_le_iff
        m
        (dyadic_threshold m)).mp le_rfl
  · intro k hk
    exact
      (dyadic_threshold_le_iff m k).mpr hk

/--
The integer dyadic threshold agrees with the real-logarithmic floor
formula used in the paper.

The threshold is defined intrinsically by `Nat.log2 (3 ^ m) + 1`,
avoiding real arithmetic in the basic threshold theory. This theorem
connects that discrete definition to

`B(m) = ⌊m * log₂ 3⌋₊ + 1`.

Thus the integer threshold characterized by `dyadic_threshold_le_iff`
is the same sequence described by the familiar logarithmic formula.
-/
theorem dyadic_threshold_eq_floor_log
    (m : ℕ) :
    dyadic_threshold m =
      ⌊(m : ℝ) * Real.logb 2 3⌋₊ + 1 := by
  unfold dyadic_threshold
  congr 1
  rw [Nat.log2_eq_log_two]
  /-
  Convert the natural logarithm into the natural floor of the
  corresponding real logarithm, then apply the real power law.
  -/
  rw [← Real.natFloor_logb_natCast 2 (3 ^ m)]
  push_cast
  rw [Real.logb_pow]

/-! ## Affine Slope and Strict Separation from One -/

/--
The linear coefficient of the affine map associated with a division word `ω`.

It is

`affine_slope ω =
  3 ^ ω.length / 2 ^ total_division_count ω`.

The numerator records cumulative ternary growth, while the denominator
records cumulative dyadic division. Like `affine_map`, the slope is defined
for every formal division word, independently of realizability.
-/
def affine_slope (ω : division_word) : ℚ :=
  (3 : ℚ) ^ ω.length /
    (2 : ℚ) ^ total_division_count ω

/--
The affine slope is strictly less than one exactly when the total
division count reaches the dyadic threshold for the word length.

Since

`affine_slope ω =
  3 ^ ω.length / 2 ^ total_division_count ω`,

the inequality `affine_slope ω < 1` is equivalent to strict dyadic
dominance,

`3 ^ ω.length < 2 ^ total_division_count ω`.

By `dyadic_threshold_le_total_iff`, this is equivalent to

`dyadic_threshold ω.length ≤ total_division_count ω`.

The proof passes between the rational inequality defining the slope and
the corresponding natural-number power inequality.
-/
theorem affine_slope_lt_one_iff
    (ω : division_word) :
    affine_slope ω < 1 ↔
      dyadic_threshold ω.length ≤
        total_division_count ω := by
  unfold affine_slope
  rw [div_lt_one (by positivity)]
  constructor
  · intro h
    /- Transfer strict dyadic dominance from `ℚ` to `ℕ`. -/
    apply (dyadic_threshold_le_total_iff ω).mpr
    exact_mod_cast h
  · intro h
    have hnat :
        3 ^ ω.length <
          2 ^ total_division_count ω := by
      exact (dyadic_threshold_le_total_iff ω).mp h
    /- Transfer strict dyadic dominance from `ℕ` back to `ℚ`. -/
    exact_mod_cast hnat

/--
For every nonempty division word, the cumulative dyadic and ternary
factors are unequal.

The only common value of a power of `2` and a power of `3` in `ℕ`
is `1 = 2 ^ 0 = 3 ^ 0`. The hypothesis `0 < ω.length` excludes the
zero ternary exponent.

If `total_division_count ω = 0`, then the dyadic factor is `1` while
`3 ^ ω.length > 1`. Otherwise the dyadic factor is divisible by `2`,
whereas the ternary factor is odd. In either case equality is impossible.
-/
lemma dyadic_ternary_ne
    {ω : division_word}
    (hω : 0 < ω.length) :
    2 ^ total_division_count ω ≠ 3 ^ ω.length := by
  intro h
  by_cases hD : total_division_count ω = 0
  · rw [hD] at h
    simp only [pow_zero] at h
    have hlen0 : ω.length ≠ 0 := by
      omega
    have hgt : 1 < 3 ^ ω.length := by
      exact one_lt_pow₀ (by norm_num) hlen0
    omega
  · obtain ⟨n, hn⟩ :
        ∃ n, total_division_count ω = n + 1 := by
      use total_division_count ω - 1
      omega
    have hdiv :
        (2 : ℕ) ∣ 2 ^ total_division_count ω := by
      rw [hn, pow_succ]
      simp
    have hodd :
        Odd (3 ^ ω.length) := by
      exact Odd.pow (by norm_num)
    have hnotdiv :
        ¬ (2 : ℕ) ∣ 3 ^ ω.length := by
      rintro ⟨q, hq⟩
      rcases hodd with ⟨r, hr⟩
      omega
    have hdiv' :
        (2 : ℕ) ∣ 3 ^ ω.length := by
      rw [← h]
      exact hdiv
    exact hnotdiv hdiv'

/--
The affine slope of every nonempty division word is strictly separated
from one.

Since

`affine_slope ω =
  3 ^ ω.length / 2 ^ total_division_count ω`,

equality with `1` would force

`3 ^ ω.length = 2 ^ total_division_count ω`.

The theorem `dyadic_ternary_ne` excludes this equality for every
nonempty division word. Since `ℚ` is linearly ordered, the remaining
possibilities are exhaustive:

`affine_slope ω < 1 ∨ 1 < affine_slope ω`.

This establishes only a strict slope dichotomy; it does not by itself
assert a corresponding dichotomy between descending and ascending
realized trajectories.
-/
theorem affine_slope_lt_or_gt_one
    {ω : division_word}
    (hω : 0 < ω.length) :
    affine_slope ω < 1 ∨ 1 < affine_slope ω := by
  have hslope_ne : affine_slope ω ≠ 1 := by
    intro h
    unfold affine_slope at h
    /-
    Clear the dyadic denominator and transfer the resulting equality
    of rational powers back to `ℕ`.
    -/
    have hpow :
        (3 : ℚ) ^ ω.length =
          (2 : ℚ) ^ total_division_count ω := by
      field_simp at h
      exact h
    have hpow_nat :
        3 ^ ω.length =
          2 ^ total_division_count ω := by
      exact_mod_cast hpow
    exact
      (dyadic_ternary_ne hω)
        hpow_nat.symm
  exact lt_or_gt_of_ne hslope_ne

end Collatz
