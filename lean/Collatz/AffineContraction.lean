/-
Copyright (c) 2026 Wayne Brassem. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Wayne Brassem
-/

import Mathlib.Data.Nat.Log
import Mathlib.Data.Rat.Floor
import Mathlib.Data.Set.Finite.List
import Collatz.Cylinders

/-!

# Affine Contraction and Descent Cylinders

This module develops the affine contraction criterion for finite division
words and proves that every linearly contractive realization cylinder
contributes its full dyadic mass asymptotically to genuine descent.

The preceding module, `Collatz.Cylinders`, identifies exact realization
classes with dyadic cylinders and proves that the realization cylinder
associated with a division word `ω` has ordinary natural density

    1 / 2 ^ (total_division_count ω + 1).

The affine representation itself was developed earlier in `Collatz.Affine`.
For a division word `ω`, its linear coefficient is

    3 ^ ω.length / 2 ^ total_division_count ω.

The present module compares this coefficient with `1`, relates that comparison
to the canonical dyadic threshold, derives an exact pointwise descent
criterion for the affine map, and finally shows that only finitely many points
of a contractive realization cylinder can fail to descend.

Thus the module provides the bridge from symbolic cylinder mass to genuine
descent mass.

The development separates naturally into six stages.

## 1. Affine Linear Coefficient and Contractivity

The quantity

    affine_linear_coefficient ω

isolates the multiplicative coefficient of the affine branch associated with
`ω`:

    affine_linear_coefficient ω
      =
    3 ^ ω.length / 2 ^ total_division_count ω.

A division word has a linearly contractive affine branch when this coefficient
is strictly less than one:

    linearly_contractive_affine_branch ω
      :=
    affine_linear_coefficient ω < 1.

This slope condition is equivalent to the strict power inequality

    3 ^ ω.length
      <
    2 ^ total_division_count ω.

No admissibility hypothesis is required for this equivalence.

Linear contractivity concerns only the slope of the affine map. Because the
affine map also contains a positive additive constant for every nonempty word,
a slope below one does not by itself imply pointwise descent for every input.

The principal results are:

* `affine_linear_coefficient`;
* `linearly_contractive_affine_branch`;
* `linearly_contractive_affine_branch_iff`.

## 2. Dyadic Threshold as the Contraction Boundary

The canonical dyadic threshold

    dyadic_threshold m

is defined in `Collatz.Affine` as the least natural exponent `k` satisfying

    3 ^ m < 2 ^ k.

The present module uses that single upstream threshold to identify the exact
division-count boundary for linear contraction:

    linearly_contractive_affine_branch ω
      ↔
    dyadic_threshold ω.length
      ≤ total_division_count ω.

Thus reaching the threshold is exactly equivalent to entering the
linearly contractive regime.

The module also derives elementary bounds on the threshold itself. It is
always positive, the preceding power of two satisfies

    2 ^ (dyadic_threshold m - 1)
      ≤
    3 ^ m,

and therefore

    2 ^ dyadic_threshold m
      ≤
    2 * 3 ^ m.

Combined with the defining strict inequality, this gives

    3 ^ m
      <
    2 ^ dyadic_threshold m
      ≤
    2 * 3 ^ m.

Hence the threshold power of two lies within a factor of two of the
corresponding ternary power.

The principal results are:

* `linearly_contractive_affine_branch_iff_threshold`;
* `dyadic_threshold_pos`;
* `dyadic_threshold_pred_le`;
* `dyadic_threshold_upper_bound`.

## 3. Affine Positivity and the Expansive Slope Criterion

The affine constant is strictly positive for every nonempty division word:

    0 < affine_constant ω.

In particular, every admissible division word has positive affine constant.

The expansive side of the affine slope is characterized directly by the
reverse power inequality:

    1 < affine_linear_coefficient ω
      ↔
    2 ^ total_division_count ω
      <
    3 ^ ω.length.

Thus the contractive and expansive slope conditions correspond respectively
to the two strict orderings of the ternary numerator and dyadic denominator.

These elementary positivity and slope facts are used in the subsequent
strict-separation and pointwise-descent arguments.

The principal results are:

* `affine_constant_pos_of_nonempty`;
* `affine_constant_pos_of_admissible`;
* `affine_linear_coefficient_gt_one_iff`.

## 4. Alternative Threshold Characterizations and Strict Slope Separation

The dyadic threshold also admits an equivalent ceiling characterization.

Define

    dyadic_ceiling_condition n k

by

    ceil (2 ^ k / 3 ^ n) = 2.

For rational `q`,

    ceil q = 2
      ↔
    1 < q ∧ q ≤ 2.

Consequently,

    dyadic_ceiling_condition n k

is equivalent to the arithmetic window

    3 ^ n
      <
    2 ^ k
      ≤
    2 * 3 ^ n.

The canonical dyadic threshold satisfies this condition and is its least
natural solution. Hence the original least-power definition and the
ceiling-two characterization describe exactly the same threshold.

The module next establishes strict separation between powers of two and
three. A positive power of two cannot equal a power of three, and for an
admissible division word this gives

    2 ^ total_division_count ω
      ≠
    3 ^ ω.length.

Therefore an admissible word lying below the dyadic threshold is not merely
non-contractive: it is strictly expansive. More precisely,

    total_division_count ω
      <
    dyadic_threshold ω.length

if and only if

    2 ^ total_division_count ω
      <
    3 ^ ω.length,

and equivalently,

    1 < affine_linear_coefficient ω
      ↔
    total_division_count ω
      <
    dyadic_threshold ω.length.

Thus every admissible affine branch lies strictly on one side or the other
of slope one; equality cannot occur.

The principal results are:

* `dyadic_ceiling_condition`;
* `rational_ceil_eq_two_iff`;
* `dyadic_ceiling_condition_iff`;
* `dyadic_threshold_ceiling_condition`;
* `dyadic_threshold_isLeast_ceiling_condition`;
* `two_pow_ne_three_pow_of_pos`;
* `two_pow_total_division_count_ne_three_pow_length`;
* `total_division_count_lt_threshold_iff_power_lt`;
* `affine_linear_coefficient_gt_one_iff_threshold`;
* `affine_linear_coefficient_ne_one_of_admissible`.

## 5. Exact Pointwise Descent from Affine Contraction

Pointwise descent of the affine map admits an exact algebraic
characterization.

For every formal division word `ω` and rational input `x`,

    affine_map ω x < x

if and only if

    affine_constant ω
      <
    (2 ^ total_division_count ω - 3 ^ ω.length) * x,

where the powers are interpreted in `ℚ`.

This equivalence requires neither admissibility nor contractivity. It is
obtained simply by clearing the positive dyadic denominator and rearranging
the affine inequality.

When `ω` is linearly contractive,

    3 ^ ω.length
      <
    2 ^ total_division_count ω,

so the coefficient gap

    2 ^ total_division_count ω - 3 ^ ω.length

is strictly positive. Division by that gap gives the exact rational descent
threshold:

    affine_map ω x < x
      ↔
    affine_constant ω /
        (2 ^ total_division_count ω - 3 ^ ω.length)
      < x.

Thus a contractive affine branch descends precisely above an explicit
rational cutoff.

For natural-number inputs, the simpler condition

    affine_constant ω < x

is sufficient for descent. Because the integer coefficient gap is then at
least one, every natural number above the affine constant also lies above
the exact rational threshold.

Consequently, every possible failure of pointwise descent along a linearly
contractive branch is confined to the finite initial interval

    x ≤ affine_constant ω.

The principal results are:

* `affine_map_lt_self_iff_gap_mul_gt_affine_constant`;
* `affine_map_lt_self_iff_gt_descent_threshold`;
* `affine_map_lt_self_of_gt_affine_constant`.

## 6. Descending Realization Cylinders and Density

For a division word `ω`, define the descending realizations by

    descending_realizations ω
      =
    {x | realizes x ω ∧ affine_map ω x < x},

and the non-descending realizations by

    non_descending_realizations ω
      =
    {x | realizes x ω ∧ ¬ affine_map ω x < x}.

Their corresponding counting functions partition the full realization count:

    realization_count ω N
      =
    descending_realization_count ω N
      +
    non_descending_realization_count ω N.

If the affine branch is linearly contractive, every non-descending
realization satisfies

    x ≤ affine_constant ω.

Hence

    non_descending_realizations ω
      ⊆
    Set.Iic (affine_constant ω),

so the non-descending exceptional set is finite.

Its counting function is therefore uniformly bounded, and after normalization
its natural density is zero:

    non_descending_realization_count ω N / N
      →
    0.

On the other hand, `Collatz.Cylinders` already gives the full realization
cylinder the natural density

    1 / 2 ^ (total_division_count ω + 1).

Since every realization is either descending or non-descending, subtracting
the zero-density exceptional contribution leaves

    descending_realization_count ω N / N
      →
    1 / 2 ^ (total_division_count ω + 1).

Thus every linearly contractive realization cylinder contributes its entire
dyadic cylinder mass asymptotically to genuine descent.

The principal definitions and results are:

* `descending_realizations`;
* `descending_realization_count`;
* `non_descending_realizations`;
* `non_descending_realization_count`;
* `non_descending_realizations_subset_Iic`;
* `non_descending_realizations_finite`;
* `realization_count_eq_descending_add_non_descending`;
* `non_descending_realization_count_has_density_zero`;
* `descending_realization_cylinder_has_natural_density`.

## Dependency flow

The main logical dependencies are:

    Collatz.Affine
          │
          │  affine_map
          │  affine_constant
          │  dyadic_threshold
          ▼
    ┌──────────────────────────────────────────────┐
    │ Affine coefficient and contractivity         │
    │                                              │
    │ affine_linear_coefficient                    │
    │      ↓                                       │
    │ linearly_contractive_affine_branch           │
    │      ↓                                       │
    │ linearly_contractive_affine_branch_iff       │
    └──────────────────────────────────────────────┘
                          │
                          ▼
    ┌──────────────────────────────────────────────┐
    │ Dyadic threshold as contraction boundary     │
    │                                              │
    │ linearly_contractive_..._iff_threshold       │
    │      ↓                                       │
    │ dyadic_threshold_pos                         │
    │      ↓                                       │
    │ dyadic_threshold_pred_le                     │
    │      ↓                                       │
    │ dyadic_threshold_upper_bound                 │
    └──────────────────────────────────────────────┘
                          │
              ┌───────────┴────────────┐
              │                        │
              ▼                        ▼
    ┌───────────────────────┐  ┌──────────────────────────────┐
    │ Affine positivity and │  │ Alternative threshold and    │
    │ expansive slope       │  │ strict slope separation      │
    │                       │  │                              │
    │ affine_constant_pos...│  │ dyadic_ceiling_condition     │
    │       ↓               │  │       ↓                      │
    │ coefficient_gt_one_iff│  │ ceiling characterization     │
    └───────────────────────┘  │       ↓                      │
                               │ threshold is least solution  │
                               │       ↓                      │
                               │ dyadic / ternary inequality  │
                               │       ↓                      │
                               │ below threshold ⇔ expansive │
                               │       ↓                      │
                               │ coefficient ≠ 1              │
                               └──────────────────────────────┘
              │                        │
              └───────────┬────────────┘
                          ▼
    ┌──────────────────────────────────────────────┐
    │ Exact pointwise affine descent               │
    │                                              │
    │ affine_map_lt_self_iff_gap_mul_...           │
    │      ↓                                       │
    │ affine_map_lt_self_iff_gt_descent_threshold  │
    │      ↓                                       │
    │ affine_map_lt_self_of_gt_affine_constant     │
    └──────────────────────────────────────────────┘
                          │
                          │
    Collatz.Cylinders     │
          │               │
          │ realization_count
          │ realization_cylinder_has_natural_density
          └───────────────┼───────────────────────┐
                          ▼                       │
    ┌──────────────────────────────────────────────┐
    │ Descending realization cylinders             │
    │                                              │
    │ descending / non-descending partition        │
    │      ↓                                       │
    │ non-descending realizations are bounded      │
    │      ↓                                       │
    │ non-descending set is finite                 │
    │      ↓                                       │
    │ exceptional density = 0                      │
    │      ↓                                       │
    │ descending cylinder retains full density     │
    └──────────────────────────────────────────────┘

The resulting contraction criterion and full-density descent theorem are the
formal handoff to `Collatz.ResidualForest`, where division words are organized
according to the first symbolic depth at which the contraction threshold is
reached, and to `Collatz.ResidualMass`, where the surviving residual mass is
shown to decay to zero.

-/

namespace Collatz

/-! ## Affine Linear Coefficient and Contractivity -/

/--
The linear coefficient of the affine branch associated with a division word.

For a division word `ω`, the affine map over `ℚ` has the form

    affine_map ω x
      =
    (3 ^ ω.length / 2 ^ total_division_count ω) * x
      + affine_constant ω.

This definition isolates the linear coefficient of the affine map. Its
comparison with `1` distinguishes the linearly contractive and expansive
regimes and connects directly to the dyadic threshold developed in
`Collatz.Affine`.

Linear contraction concerns only this coefficient; because the affine map
also has an additive constant, a coefficient below `1` does not by itself
imply pointwise descent for every input.
-/
def affine_linear_coefficient
    (ω : division_word) : ℚ :=
  (3 : ℚ) ^ ω.length /
    (2 : ℚ) ^ total_division_count ω

/--
A division word has a linearly contractive affine branch when the linear
coefficient of its associated affine map is strictly less than one.

This condition concerns only the linear coefficient. It does not assert
pointwise descent of `affine_map ω x`, which also depends on the positive
affine constant.
-/
def linearly_contractive_affine_branch
    (ω : division_word) : Prop :=
  affine_linear_coefficient ω < 1

/--
Linear contractivity is equivalent to the power inequality

    3 ^ ω.length < 2 ^ total_division_count ω.

Thus the rational condition

    affine_linear_coefficient ω < 1

reduces exactly to comparison of the numerator and denominator powers
appearing in the affine slope.
-/
theorem linearly_contractive_affine_branch_iff
    (ω : division_word) :
    linearly_contractive_affine_branch ω ↔
      3 ^ ω.length <
        2 ^ total_division_count ω := by
  unfold linearly_contractive_affine_branch
  unfold affine_linear_coefficient
  rw [div_lt_one (by positivity)]
  norm_cast

/-! ## Dyadic Threshold as the Contraction Boundary

The canonical threshold `dyadic_threshold` is defined and characterized in
`Collatz.Affine`. This module uses that single upstream notion to connect
total division count with affine contraction and to derive the additional
bounds needed below.

-/

/--
A division word has a linearly contractive affine branch exactly when its
total division count reaches or exceeds the dyadic threshold for its
symbolic length.

Equivalently,

    linearly_contractive_affine_branch ω

holds exactly when

    dyadic_threshold ω.length ≤
      total_division_count ω.

No admissibility hypothesis is required for this arithmetic equivalence.
-/
theorem linearly_contractive_affine_branch_iff_threshold
    (ω : division_word) :
    linearly_contractive_affine_branch ω ↔
      dyadic_threshold ω.length ≤
        total_division_count ω := by
  rw [linearly_contractive_affine_branch_iff]
  exact
    (dyadic_threshold_le_iff
      ω.length
      (total_division_count ω)).symm

/--
The dyadic threshold is always positive.

Since

    dyadic_threshold m
      = (3 ^ m).log2 + 1,

it is at least `1` for every natural symbolic length `m`.
-/
lemma dyadic_threshold_pos
    (m : ℕ) :
    0 < dyadic_threshold m := by
  unfold dyadic_threshold
  omega

/--
The power of two immediately below the dyadic threshold does not
exceed `3 ^ m`.

Equivalently,

    2 ^ (dyadic_threshold m - 1) ≤ 3 ^ m.

Together with the defining threshold characterization, this brackets `3 ^ m`
between two consecutive powers of two.
-/
theorem dyadic_threshold_pred_le
    (m : ℕ) :
    2 ^ (dyadic_threshold m - 1) ≤
      3 ^ m := by
  have hpos :
      0 < dyadic_threshold m :=
    dyadic_threshold_pos m
  by_contra h
  have hlt :
      3 ^ m <
        2 ^ (dyadic_threshold m - 1) := by
    omega
  have hmin :
      dyadic_threshold m ≤
        dyadic_threshold m - 1 := by
    exact
      (dyadic_threshold_le_iff
        m
        (dyadic_threshold m - 1)).mpr hlt
  omega

/--
The threshold power of two is at most twice `3 ^ m`.

Equivalently,

    2 ^ dyadic_threshold m ≤ 2 * 3 ^ m.

Together with the defining threshold characterization, this yields the uniform
two-sided bound

    3 ^ m < 2 ^ dyadic_threshold m ≤ 2 * 3 ^ m.

Thus the threshold power lies within a factor of two of `3 ^ m`.
-/
theorem dyadic_threshold_upper_bound
    (m : ℕ) :
    2 ^ dyadic_threshold m ≤
      2 * 3 ^ m := by
  have hpred :=
    dyadic_threshold_pred_le m
  have hpos :
      0 < dyadic_threshold m :=
    dyadic_threshold_pos m
  have hsplit :
      dyadic_threshold m =
        (dyadic_threshold m - 1) + 1 := by
    omega
  rw [hsplit, pow_succ]
  simpa [Nat.mul_comm] using
    (Nat.mul_le_mul_left 2 hpred)

/-! ## Affine Positivity and the Expansive Slope Criterion -/

/--
The affine constant of every nonempty division word is strictly positive.

The nonempty hypothesis excludes the empty word, whose affine constant
vanishes.
-/
lemma affine_constant_pos_of_nonempty
    {ω : division_word}
    (hω : 0 < ω.length) :
    0 < affine_constant ω := by
  cases ω with
  | nil =>
      simp at hω
  | cons d ω =>
      simp [affine_constant]

/--
Every admissible division word has strictly positive affine constant.

This follows from `affine_constant_pos_of_nonempty`, since admissibility
includes nonemptiness.
-/
lemma affine_constant_pos_of_admissible
    {ω : division_word}
    (hω : admissible_division_word ω) :
    0 < affine_constant ω := by
  exact affine_constant_pos_of_nonempty hω.1

/--
The affine linear coefficient is strictly greater than one exactly when

    2 ^ total_division_count ω < 3 ^ ω.length.

Thus the expansive slope condition is the strict reverse of the power
inequality characterizing linear contractivity.
-/
theorem affine_linear_coefficient_gt_one_iff
    (ω : division_word) :
    1 < affine_linear_coefficient ω ↔
      2 ^ total_division_count ω <
        3 ^ ω.length := by
  unfold affine_linear_coefficient
  rw [one_lt_div (by positivity)]
  norm_cast

/-! ## Alternative Threshold Characterizations and Strict Slope Separation -/

/--
An alternative ceiling-two characterization of the dyadic threshold.

For symbolic length `n` and exponent `k`, the condition is

    ceil (2^k / 3^n) = 2.

The dyadic threshold will later be shown to be the least exponent
`k` satisfying this condition; that connection is proved rather than assumed.
-/
def dyadic_ceiling_condition
    (n k : ℕ) : Prop :=
  Int.ceil
    (((2 : ℚ) ^ k) / ((3 : ℚ) ^ n)) = 2

/--
A rational number has ceiling two exactly when it lies in the interval

    1 < q ≤ 2.

Equivalently,

    Int.ceil q = 2 ↔ (1 : ℚ) < q ∧ q ≤ 2.
-/
lemma rational_ceil_eq_two_iff
    (q : ℚ) :
    Int.ceil q = 2 ↔
      (1 : ℚ) < q ∧ q ≤ 2 := by
  constructor
  · intro hceil
    have hlow_int :
        (1 : ℤ) < Int.ceil q := by
      omega
    have hupp_int :
        Int.ceil q ≤ (2 : ℤ) := by
      omega
    have hlow :
        (1 : ℚ) < q := by
      exact (Int.lt_ceil).mp hlow_int
    have hupp :
        q ≤ (2 : ℚ) := by
      exact (Int.ceil_le).mp hupp_int
    exact ⟨hlow, hupp⟩
  · rintro ⟨hlow, hupp⟩
    have hlow_int :
        (1 : ℤ) < Int.ceil q := by
      exact (Int.lt_ceil).mpr hlow
    have hupp_int :
        Int.ceil q ≤ (2 : ℤ) := by
      exact (Int.ceil_le).mpr hupp
    omega

/--
The ceiling-two condition is equivalent to placing `2 ^ k` in the interval

    3 ^ n < 2 ^ k ≤ 2 * 3 ^ n.

Thus the ceiling formulation is exactly the same arithmetic window determined
by the dyadic threshold bounds.
-/
theorem dyadic_ceiling_condition_iff
    (n k : ℕ) :
    dyadic_ceiling_condition n k ↔
      3 ^ n < 2 ^ k ∧
      2 ^ k ≤ 2 * 3 ^ n := by
  unfold dyadic_ceiling_condition
  rw [rational_ceil_eq_two_iff]
  have hden :
      (0 : ℚ) < (3 : ℚ) ^ n := by
    positivity
  constructor
  · rintro ⟨hlow, hupp⟩
    have hlow' :
        (3 : ℚ) ^ n < (2 : ℚ) ^ k := by
      apply (lt_div_iff₀ hden).mp at hlow
      simpa using hlow
    have hupp' :
        (2 : ℚ) ^ k ≤
          (2 : ℚ) * (3 : ℚ) ^ n := by
      exact (div_le_iff₀ hden).mp hupp
    constructor
    · exact_mod_cast hlow'
    · exact_mod_cast hupp'
  · rintro ⟨hlow, hupp⟩
    have hlow' :
        (3 : ℚ) ^ n < (2 : ℚ) ^ k := by
      exact_mod_cast hlow
    have hupp' :
        (2 : ℚ) ^ k ≤
          (2 : ℚ) * (3 : ℚ) ^ n := by
      exact_mod_cast hupp
    constructor
    · apply (lt_div_iff₀ hden).mpr
      simpa using hlow'
    · apply (div_le_iff₀ hden).mpr
      simpa using hupp'

/--
The dyadic threshold satisfies the ceiling-two condition.

Equivalently, the threshold exponent lies in the interval

    3 ^ n <
      2 ^ dyadic_threshold n
    ≤ 2 * 3 ^ n,

so its associated quotient has ceiling two.
-/
theorem dyadic_threshold_ceiling_condition
    (n : ℕ) :
    dyadic_ceiling_condition
      n
      (dyadic_threshold n) := by
  rw [dyadic_ceiling_condition_iff]
  exact ⟨
    (dyadic_threshold_le_iff
      n
      (dyadic_threshold n)).mp le_rfl,
    dyadic_threshold_upper_bound n
  ⟩

/--
The dyadic threshold is the least exponent satisfying the
ceiling-two characterization.

Thus the threshold defined by

    dyadic_threshold n

agrees exactly with the alternative ceiling-two characterization.
-/
theorem dyadic_threshold_isLeast_ceiling_condition
    (n : ℕ) :
    IsLeast
      {k : ℕ |
        dyadic_ceiling_condition n k}
      (dyadic_threshold n) := by
  constructor
  · exact
      dyadic_threshold_ceiling_condition n
  · intro k hk
    have hwindow :=
      (dyadic_ceiling_condition_iff n k).mp hk
    exact
      (dyadic_threshold_le_iff n k).mpr hwindow.1

/--
A positive power of two cannot equal any power of three.

If `0 < a`, then

    2 ^ a ≠ 3 ^ b

for every natural exponent `b`.
-/
lemma two_pow_ne_three_pow_of_pos
    {a b : ℕ}
    (ha : 0 < a) :
    2 ^ a ≠ 3 ^ b := by
  intro h
  have htwo_dvd :
      2 ∣ 2 ^ a := by
    exact Nat.div_pow_of_pos 2 a ha
  have htwo_dvd_three :
      2 ∣ 3 ^ b := by
    rw [← h]
    exact htwo_dvd
  have h23 :
      2 = 3 := by
    exact
      Nat.prime_eq_prime_of_dvd_pow
        (by norm_num)
        (by norm_num)
        htwo_dvd_three
  norm_num at h23

/--
For an admissible division word, the denominator and numerator powers of
the affine linear coefficient cannot be equal.

Admissibility implies that the word is nonempty and that every division
exponent is positive, hence

    0 < total_division_count ω.

Therefore

    2 ^ total_division_count ω ≠ 3 ^ ω.length.
-/
lemma two_pow_total_division_count_ne_three_pow_length
    {ω : division_word}
    (hω : admissible_division_word ω) :
    2 ^ total_division_count ω ≠
      3 ^ ω.length := by
  have hlen_le :
      ω.length ≤ total_division_count ω := by
    unfold total_division_count
    exact
      division_word_length_le_sum_of_pos
        ω
        hω.2
  have hDpos :
      0 < total_division_count ω := by
    exact lt_of_lt_of_le hω.1 hlen_le
  exact two_pow_ne_three_pow_of_pos hDpos

/--
For an admissible division word, lying below the dyadic threshold
is equivalent to strict expansion of the affine slope.

Equivalently,

    total_division_count ω <
      dyadic_threshold ω.length

if and only if

    2 ^ total_division_count ω <
      3 ^ ω.length.

The admissibility hypothesis is used to exclude equality between the two
powers.
-/
theorem total_division_count_lt_threshold_iff_power_lt
    {ω : division_word}
    (hω : admissible_division_word ω) :
    total_division_count ω <
        dyadic_threshold ω.length ↔
      2 ^ total_division_count ω <
        3 ^ ω.length := by
  constructor
  · intro hbelow
    have hnot :
        ¬ 3 ^ ω.length <
            2 ^ total_division_count ω := by
      intro hcontract
      have hthreshold :
          dyadic_threshold ω.length ≤
            total_division_count ω := by
        exact
          (dyadic_threshold_le_iff
            ω.length
            (total_division_count ω)).mpr
            hcontract
      omega
    have hle :
        2 ^ total_division_count ω ≤
          3 ^ ω.length := by
      exact Nat.le_of_not_gt hnot
    /-
    Admissibility excludes the equality case,
    so non-contractivity is strict expansion.
    -/
    have hne :
        2 ^ total_division_count ω ≠
          3 ^ ω.length := by
      exact
        two_pow_total_division_count_ne_three_pow_length hω
    exact lt_of_le_of_ne hle hne
  · intro hpower
    by_contra hnot
    have hthreshold :
        dyadic_threshold ω.length ≤
          total_division_count ω := by
      omega
    have hcontract :
        3 ^ ω.length <
          2 ^ total_division_count ω := by
      exact
        (dyadic_threshold_le_iff
          ω.length
          (total_division_count ω)).mp
          hthreshold
    omega

/--
For an admissible division word, the affine linear coefficient is strictly
greater than one exactly when its total division count lies below the dyadic
threshold for its symbolic length.

Equivalently,

    1 < affine_linear_coefficient ω

if and only if

    total_division_count ω <
      dyadic_threshold ω.length.

The admissibility hypothesis excludes the equality case at slope one.
-/
theorem affine_linear_coefficient_gt_one_iff_threshold
    {ω : division_word}
    (hω : admissible_division_word ω) :
    1 < affine_linear_coefficient ω ↔
      total_division_count ω <
        dyadic_threshold ω.length := by
  rw [affine_linear_coefficient_gt_one_iff]
  exact
    (total_division_count_lt_threshold_iff_power_lt hω).symm

/--
For an admissible division word, the affine linear coefficient cannot equal
one.

Indeed,

    affine_linear_coefficient ω = 1

would force

    2 ^ total_division_count ω = 3 ^ ω.length,

contradicting the previously established separation of the two powers.
-/
theorem affine_linear_coefficient_ne_one_of_admissible
    {ω : division_word}
    (hω : admissible_division_word ω) :
    affine_linear_coefficient ω ≠ 1 := by
  intro h
  have hpow :
      2 ^ total_division_count ω =
        3 ^ ω.length := by
    unfold affine_linear_coefficient at h
    have hden :
        (0 : ℚ) <
          (2 : ℚ) ^ total_division_count ω := by
      positivity
    field_simp at h
    exact_mod_cast h.symm
  exact
    two_pow_total_division_count_ne_three_pow_length hω
    hpow

/-! ## Exact Pointwise Descent from Affine Contraction -/

/--
Exact algebraic criterion for pointwise descent of an affine branch.

For every formal division word `ω` and every rational input `x`,

    affine_map ω x < x

if and only if

    affine_constant ω <
      (2 ^ total_division_count ω - 3 ^ ω.length) * x,

with the powers interpreted in `ℚ`.

No admissibility or contractivity hypothesis is required. The denominator
power in `affine_map` is always positive, so the inequality can be cleared
and rearranged exactly. In the non-contractive regime the coefficient
difference on the right may be nonpositive; positivity of that difference
is supplied by linear contraction in the threshold theorem below.

This is the exact algebraic form underlying the pointwise descent threshold.
-/
theorem affine_map_lt_self_iff_gap_mul_gt_affine_constant
    (ω : division_word)
    (x : ℚ) :
    affine_map ω x < x ↔
      (affine_constant ω : ℚ) <
        (((2 : ℚ) ^ total_division_count ω -
          (3 : ℚ) ^ ω.length) * x) := by
  unfold affine_map
  have hden :
      (0 : ℚ) <
        (2 : ℚ) ^ total_division_count ω := by
    positivity
  rw [div_lt_iff₀ hden]
  constructor <;> intro h <;> nlinarith

/--
A linearly contractive affine branch has an exact rational descent threshold.

If `ω` is linearly contractive, then

    3 ^ ω.length < 2 ^ total_division_count ω,

so the coefficient gap

    2 ^ total_division_count ω - 3 ^ ω.length

is strictly positive. Therefore, for every rational input `x`,

    affine_map ω x < x

if and only if

    affine_constant ω /
      (2 ^ total_division_count ω - 3 ^ ω.length) < x.

Thus the affine branch descends precisely above its rational threshold; this
is stronger than merely giving a sufficient large-input bound.

No separate admissibility or nonemptiness hypothesis is required for the
formal statement.
-/
theorem affine_map_lt_self_iff_gt_descent_threshold
    {ω : division_word}
    (hcontract : linearly_contractive_affine_branch ω)
    (x : ℚ) :
    affine_map ω x < x ↔
      (affine_constant ω : ℚ) /
          ((2 : ℚ) ^ total_division_count ω -
            (3 : ℚ) ^ ω.length) < x := by
  have hpow :
      3 ^ ω.length <
        2 ^ total_division_count ω := by
    exact
      (linearly_contractive_affine_branch_iff ω).mp
        hcontract
  have hpow_q :
      (3 : ℚ) ^ ω.length <
        (2 : ℚ) ^ total_division_count ω := by
    exact_mod_cast hpow
  have hgap :
      (0 : ℚ) <
        (2 : ℚ) ^ total_division_count ω -
          (3 : ℚ) ^ ω.length := by
    exact sub_pos.mpr hpow_q
  rw [affine_map_lt_self_iff_gap_mul_gt_affine_constant]
  rw [div_lt_iff₀ hgap]
  simp only [mul_comm]

/--
A simple natural-number sufficient condition for descent along a linearly
contractive affine branch.

If

    affine_linear_coefficient ω < 1

and

    affine_constant ω < x,

then

    affine_map ω x < x.

The preceding exact threshold theorem gives the sharper rational cutoff

    affine_constant ω /
      (2 ^ total_division_count ω - 3 ^ ω.length).

For natural-number inputs, the present coarser bound is especially convenient:
linear contraction makes the integer coefficient gap at least one, so every
input larger than `affine_constant ω` necessarily lies above the exact
threshold.

Consequently, any failure of descent along a linearly contractive branch is
confined to the finite initial interval

    x ≤ affine_constant ω.

This convenient integer bound is the form used in the later finiteness and
density arguments.
-/
theorem affine_map_lt_self_of_gt_affine_constant
    {ω : division_word}
    (hcontract : linearly_contractive_affine_branch ω)
    {x : ℕ}
    (hx : affine_constant ω < x) :
    affine_map ω x < x := by
  /- Linear contraction gives a one-unit gap between the integer powers. -/
  have hpow :
      3 ^ ω.length <
        2 ^ total_division_count ω := by
    exact
      (linearly_contractive_affine_branch_iff ω).mp
        hcontract
  have hstep :
      3 ^ ω.length + 1 ≤
        2 ^ total_division_count ω := by
    omega
  have hmul :
      (3 ^ ω.length + 1) * x ≤
        2 ^ total_division_count ω * x := by
    exact Nat.mul_le_mul_right x hstep
  /-
  Since the affine constant is smaller than x, the full numerator is
  strictly smaller than the denominator power times x.
  -/
  have hnum :
      3 ^ ω.length * x + affine_constant ω <
        2 ^ total_division_count ω * x := by
    calc
      3 ^ ω.length * x + affine_constant ω
          <
        3 ^ ω.length * x + x := by
            exact
              Nat.add_lt_add_left
                hx
                (3 ^ ω.length * x)
      _ =
        (3 ^ ω.length + 1) * x := by
          simp [Nat.add_mul]
      _ ≤
        2 ^ total_division_count ω * x := hmul
  /-
  Cast the numerator inequality to ℚ and divide by the positive
  denominator to recover the affine-map inequality.
  -/
  have hnum_q :
      (3 : ℚ) ^ ω.length * (x : ℚ) +
          (affine_constant ω : ℚ) <
        (2 : ℚ) ^ total_division_count ω * (x : ℚ) := by
    exact_mod_cast hnum
  unfold affine_map
  have hden :
      (0 : ℚ) <
        (2 : ℚ) ^ total_division_count ω := by
    positivity
  apply (div_lt_iff₀ hden).mpr
  simpa [mul_comm] using hnum_q

/-! ## Descending Realization Cylinders and Density -/

/--
The realizations of a division word that descend under its associated affine
branch.

An integer `x` belongs to `descending_realizations ω` exactly when it realizes
`ω` and the endpoint of the corresponding affine branch lies strictly below
`x`:

    realizes x ω ∧ affine_map ω x < x.

Thus `descending_realizations ω` is the descending subset of the realization
cylinder associated with `ω`.
-/
def descending_realizations
    (ω : division_word) : Set ℕ :=
  {x | realizes x ω ∧ affine_map ω x < x}

/--
Membership in `descending_realizations ω` is decidable.
-/
instance descending_realizations_decidable_mem
    (ω : division_word) :
    DecidablePred
      (fun x : ℕ => x ∈ descending_realizations ω) := by
  intro x
  unfold descending_realizations
  infer_instance

/--
The number of descending realizations of `ω` below `N`.

Equivalently, `descending_realization_count ω N` counts the integers
`x < N` such that

    realizes x ω ∧ affine_map ω x < x.
-/
def descending_realization_count
    (ω : division_word)
    (N : ℕ) : ℕ :=
  Nat.count
    (fun x : ℕ => x ∈ descending_realizations ω)
    N

/--
The realizations of a division word that do not descend under its associated
affine branch.

An integer `x` belongs to `non_descending_realizations ω` exactly when it
realizes `ω` and the corresponding affine endpoint is not strictly below `x`:

    realizes x ω ∧ ¬ affine_map ω x < x.

Thus `non_descending_realizations ω` is the non-descending subset of the
realization cylinder associated with `ω`.
-/
def non_descending_realizations
    (ω : division_word) : Set ℕ :=
  {x | realizes x ω ∧ ¬ affine_map ω x < x}

/--
Membership in `non_descending_realizations ω` is decidable.
-/
instance non_descending_realizations_decidable_mem
    (ω : division_word) :
    DecidablePred
      (fun x : ℕ => x ∈ non_descending_realizations ω) := by
  intro x
  unfold non_descending_realizations
  infer_instance

/--
The number of non-descending realizations of `ω` below `N`.

Equivalently, `non_descending_realization_count ω N` counts the integers
`x < N` such that

    realizes x ω ∧ ¬ affine_map ω x < x.
-/
def non_descending_realization_count
    (ω : division_word)
    (N : ℕ) : ℕ :=
  Nat.count
    (fun x : ℕ => x ∈ non_descending_realizations ω)
    N

/--
For a linearly contractive affine branch, every non-descending realization
lies at or below the affine constant.

Equivalently,

    non_descending_realizations ω ⊆
      Set.Iic (affine_constant ω).

Thus the non-descending part of a contractive realization cylinder is
confined to a finite initial interval.
-/
theorem non_descending_realizations_subset_Iic
    {ω : division_word}
    (hcontract : linearly_contractive_affine_branch ω) :
    non_descending_realizations ω ⊆
      Set.Iic (affine_constant ω) := by
  intro x hx
  change x ≤ affine_constant ω
  by_contra hle
  have hxgt :
      affine_constant ω < x := by
    omega
  exact hx.2
    (affine_map_lt_self_of_gt_affine_constant
      hcontract hxgt)

/--
For a linearly contractive affine branch, the set of non-descending
realizations is finite.

This follows because every non-descending realization lies in the finite
initial interval

    Set.Iic (affine_constant ω).

Thus a contractive realization cylinder can contain only finitely many
non-descending exceptions.
-/
theorem non_descending_realizations_finite
    {ω : division_word}
    (hcontract : linearly_contractive_affine_branch ω) :
    (non_descending_realizations ω).Finite := by
  exact
    (Set.finite_Iic (affine_constant ω)).subset
      (non_descending_realizations_subset_Iic hcontract)

/--
The realization count splits exactly into descending and non-descending
realizations.

For every cutoff `N`,

    realization_count ω N
      =
    descending_realization_count ω N
      + non_descending_realization_count ω N.

Thus the realizations of `ω` below `N` are partitioned according to whether
their affine endpoint lies strictly below the starting value.
-/
lemma realization_count_eq_descending_add_non_descending
    (ω : division_word)
    (N : ℕ) :
    realization_count ω N =
      descending_realization_count ω N +
        non_descending_realization_count ω N := by
  unfold realization_count
  unfold descending_realization_count
  unfold non_descending_realization_count
  /- Prove the counting identity by adding one candidate integer at a time. -/
  induction N with
  | zero =>
      simp
  | succ N ih =>
      rw [Nat.count_succ, Nat.count_succ, Nat.count_succ, ih]
      /-
      If N realizes ω, it contributes to exactly one of the two parts
      according to whether the affine endpoint is below N.
      -/
      by_cases hr : realizes N ω
      · by_cases hd : affine_map ω N < N
        · have hnotle :
              ¬ (N : ℚ) ≤ affine_map ω N := by
            exact not_le_of_gt hd
          simp [
            descending_realizations,
            non_descending_realizations,
            hr,
            hd,
            hnotle
          ]
          omega
        · have hle :
              (N : ℚ) ≤ affine_map ω N := by
            exact le_of_not_gt hd
          simp [
            descending_realizations,
            non_descending_realizations,
            hr,
            hd,
            hle
          ]
          omega
      /- A non-realization contributes to neither counting function. -/
      · have hnot_desc :
            N ∉ descending_realizations ω := by
          intro h
          exact hr h.1
        have hnot_non_desc :
            N ∉ non_descending_realizations ω := by
          intro h
          exact hr h.1
        simp [hr, hnot_desc, hnot_non_desc]

/--
For a linearly contractive affine branch, the non-descending realizations
have natural density zero.

More precisely,

    non_descending_realization_count ω N / N → 0

as `N → ∞`.

The key point is that `non_descending_realizations ω` is finite: every
non-descending realization lies at or below `affine_constant ω`. Hence its
counting function is uniformly bounded by a constant independent of `N`,
and dividing that bound by `N` forces the normalized count to vanish.

Thus the finitely many possible failures of pointwise descent contribute no
asymptotic mass to a linearly contractive realization cylinder.
-/
theorem non_descending_realization_count_has_density_zero
    {ω : division_word}
    (hcontract :
      linearly_contractive_affine_branch ω) :
    Filter.Tendsto
      (fun N : ℕ =>
        (non_descending_realization_count ω N : ℝ) / N)
      Filter.atTop
      (nhds 0) := by
  /- Finiteness gives a uniform bound on the exceptional counting function. -/
  have hfinite :
      (non_descending_realizations ω).Finite :=
    non_descending_realizations_finite hcontract
  let K : ℕ := hfinite.toFinset.card
  have hbound :
      ∀ N : ℕ,
        non_descending_realization_count ω N ≤ K := by
    intro N
    unfold non_descending_realization_count
    exact Nat.count_le_card hfinite N
  /- After normalization, the uniform bound K / N tends to zero. -/
  have hupper :
      Filter.Tendsto
        (fun N : ℕ => (K : ℝ) / N)
        Filter.atTop
        (nhds 0) := by
    exact tendsto_const_div_atTop_nhds_zero_nat (K : ℝ)
  have hlower :
      Filter.Tendsto
        (fun _ : ℕ => (0 : ℝ))
        Filter.atTop
        (nhds 0) :=
    tendsto_const_nhds
  /- Squeeze the normalized exceptional count between 0 and K / N. -/
  exact
    Filter.Tendsto.squeeze
      hlower
      hupper
      (fun N => by
        positivity)
      (fun N => by
        have hN := hbound N
        gcongr)

/--
A linearly contractive realization cylinder has the same natural density
when restricted to genuinely descending realizations.

If `r` is a realization residue for `ω` and the affine branch associated
with `ω` is linearly contractive, then

    descending_realization_count ω N / N

converges to

    1 / 2 ^ (total_division_count ω + 1).

The full realization cylinder has this density by
`realization_cylinder_has_natural_density`. Its non-descending subset has
density zero by `non_descending_realization_count_has_density_zero`.
Since every realization is either descending or non-descending, subtracting
the exceptional contribution leaves the full cylinder density unchanged.

Thus a linearly contractive realization cylinder contributes its entire
dyadic mass asymptotically to descent.
-/
theorem descending_realization_cylinder_has_natural_density
    {ω : division_word}
    {r : ℕ}
    (hr : realization_residue ω r)
    (hcontract :
      linearly_contractive_affine_branch ω) :
    Filter.Tendsto
      (fun N : ℕ =>
        (descending_realization_count ω N : ℝ) / N)
      Filter.atTop
      (nhds
        ((1 : ℝ) /
          (2 ^ (total_division_count ω + 1) : ℝ))) := by
  /-
  The full realization cylinder has its dyadic density, while the
  non-descending exceptional subset has density zero.
  -/
  have hfull :=
    realization_cylinder_has_natural_density hr
  have hexception :=
    non_descending_realization_count_has_density_zero
      hcontract
  have hdiff := hfull.sub hexception
  /-
  Rewrite the descending count as the full realization count minus
  the non-descending count.
  -/
  have heq :
      (fun N : ℕ =>
        (descending_realization_count ω N : ℝ) / N)
        =
      (fun N : ℕ =>
        (realization_count ω N : ℝ) / N -
          (non_descending_realization_count ω N : ℝ) / N) := by
    funext N
    have hsplit :=
      realization_count_eq_descending_add_non_descending
        ω N
    have hsplit_real :
        (realization_count ω N : ℝ) =
          (descending_realization_count ω N : ℝ) +
            (non_descending_realization_count ω N : ℝ) := by
      exact_mod_cast hsplit
    rw [hsplit_real]
    ring
  /- The zero-density exceptional term disappears from the limiting mass. -/
  rw [heq]
  simpa using hdiff

end Collatz
