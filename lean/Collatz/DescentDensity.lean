/-
Copyright (c) 2026 Wayne Brassem. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Wayne Brassem
-/

import Collatz.ResidualMass

/-!

# Eventual Descent and the Density-One Theorem

This module completes the density-one eventual-descent argument developed
through the preceding symbolic, affine, realization, cylinder, residual-forest,
and residual-mass modules.

The preceding module, `Collatz.ResidualMass`, proves the asymptotic collapse

    residual_mass m → 0.

For each fixed symbolic depth `m`, `residual_mass m` is the ordinary natural
density of `residual_realizations m`. Thus the density of the population that
survives residually to depth `m` tends to zero as the required survival depth
increases.

The residual-forest structure needed here has already been established in
`Collatz.ResidualForest`. In particular, that module proves the finite
first-passage alternative: an initially residual starting value either survives
to any prescribed finite residual depth or has already exited through an
earlier first-contraction layer.

The present module supplies the remaining dynamical and density arguments:

* first-contraction exits produce actual accelerated descent apart from a
  finite exceptional set at each fixed layer;
* fixed-depth first-passage structure gives finite-error covers of the
  initially residual non-descending population;
* residual-mass collapse makes those covers asymptotically negligible;
* the initial residual population is identified with the congruence class
  `3 mod 4`, while the complementary elementary classes descend directly;
* fully accelerated descent is transferred to ordinary Collatz descent;
* ordinary non-descent is therefore shown to have density zero.

The final theorem proves

    #{x < N | ∃ m : ℕ, (collatz_step^[m]) x < x} / N
      →
    1.

This is a density-one eventual-descent theorem: almost every starting value
has some ordinary Collatz iterate strictly below itself. It does not assert
that every trajectory reaches `1`, nor does it prove global Collatz
convergence.

The development separates naturally into five stages.

## 1. First-Contraction Descent and Finite Exceptions

A first-contraction word reaches the dyadic contraction threshold for the
first time at its terminal symbolic position. Hence its affine branch has
strictly contractive slope:

    3 ^ ω.length
      <
    2 ^ total_division_count ω.

For a realized division word `η`, the exact affine identity gives

    2 ^ total_division_count η *
      ((fully_accelerated^[η.length]) x)
      =
    3 ^ η.length * x + affine_constant η.

Consequently, if the affine branch is contractive and

    affine_constant η < x,

then the realized endpoint lies strictly below the starting value.

At a fixed first-contraction layer, every first-contraction child of symbolic
length `m + 1` has a residual parent `ω` of length `m`. Writing

    η = ω ++ [d],

the affine constant satisfies

    affine_constant η
      =
    3 * affine_constant ω +
      2 ^ total_division_count ω.

The appended division count `d` does not appear in this expression.

Because the residual parent level at fixed depth `m` is finite, the finitely
many parent-based affine constants have a common upper bound. Hence there is
a uniform cutoff `K` such that every starting value in the first-contraction
layer with

    K ≤ x

descends below itself after `m + 1` fully accelerated steps.

Therefore the starting values in any fixed first-contraction layer that never
descend form a finite exceptional set.

The principal results are:

* `affine_constant_append_singleton`;
* `realized_contracting_word_descends_above_constant`;
* `first_contraction_layer_eventual_descent`;
* `first_contraction_layer_non_descent_finite`.

## 2. Finite-Depth Covers and Density-Zero Residual Non-Descent

The finite first-passage structure used in this section is supplied upstream
by `Collatz.ResidualForest`: an initially residual starting value either
survives to a prescribed finite residual depth or exits through one of the
preceding first-contraction layers.

The present module combines that finite-depth structure with the finiteness
of non-descending exceptions on each fixed first-contraction layer.

For every `k`, the initially residual starting values that never descend and
have already exited the residual forest by depth `1 + k` form a finite set.

Equivalently, there exists a finite set `F` such that every initially residual
non-descender satisfies

    x ∈ residual_realizations (1 + k)

or

    x ∈ F.

At the counting level this yields, for some constant `C` independent of the
interval cutoff `N`,

    A(N)
      ≤
    R_k(N) + C,

where `A(N)` counts initially residual non-descending integers below `N` and
`R_k(N)` counts residual realizations surviving through depth `1 + k`.

The finite error disappears after normalization:

    C / N → 0.

Meanwhile, for fixed `k`,

    R_k(N) / N
      →
    residual_mass (1 + k).

Residual-mass collapse allows the symbolic depth to be chosen first so that

    residual_mass (1 + k)

is arbitrarily small. With that depth fixed, the interval cutoff `N` is then
sent to infinity.

This gives

    A(N) / N → 0.

Thus the initially residual starting values that never descend under the
fully accelerated map have ordinary natural density zero.

The quantifier order is essential: symbolic depth is fixed before the
counting limit is taken. No countable additivity of natural density,
continuity from above, or interchange of symbolic-depth and interval-size
limits is used.

The principal results are:

* `non_descent_initial_exits_finite`;
* `non_descent_initial_finite_error_cover`;
* `non_descent_initial_count_bound`;
* `finite_error_ratio_tendsto_zero`;
* `count_ratio_eventually_le_of_bound`;
* `residual_mass_shift_eventually_small`;
* `non_descent_initial_has_natural_density_zero`.

## 3. Initial Residual Congruence Class and Immediate Descent

The initial residual population can be identified explicitly.

At symbolic depth one, the unique residual word is `[1]`. Hence

    x ∈ residual_realizations 1

is equivalent to

    division_count x = 1,

which in turn is equivalent to

    x % 4 = 3.

Therefore

    x ∈ residual_realizations 1
      ↔
    x % 4 = 3.

The complementary elementary classes are handled directly.

If

    1 < x
    and
    x % 4 = 1,

then `3 * x + 1` is divisible by at least `4`, so

    division_count x ≥ 2.

Consequently one fully accelerated step satisfies

    fully_accelerated x < x.

Positive even integers require no accelerated analysis at all. For such `x`,

    collatz_step x = x / 2 < x.

Thus, apart from the isolated values `0` and `1`, the only congruence class
that can contribute to ordinary non-descent is the odd class

    x ≡ 3 mod 4,

which is exactly the initial residual population.

The principal results are:

* `residual_realizations_one_iff_mod_four`;
* `one_mod_four_descends`;
* `positive_half_lt`;
* `even_collatz_descends`.

## 4. Transfer from Accelerated to Ordinary Collatz Descent

Every finite fully accelerated trajectory beginning at an odd integer occurs
as a finite subsequence of the ordinary Collatz trajectory.

One fully accelerated step from an odd integer consists of the ordinary odd
step

    x ↦ 3 * x + 1

followed by exactly `division_count x` divisions by two. Thus

    (collatz_step^[division_count x + 1]) x
      =
    fully_accelerated x.

Iterating this correspondence gives: for every accelerated iterate count `n`
and every odd starting value `x`, there exists `m : ℕ` such that

    (collatz_step^[m]) x
      =
    (fully_accelerated^[n]) x.

Therefore, if some fully accelerated iterate lies below the starting value,

    ∃ n : ℕ,
      (fully_accelerated^[n]) x < x,

then some ordinary Collatz iterate reaches that same endpoint and hence also
lies below `x`:

    ∃ m : ℕ,
      (collatz_step^[m]) x < x.

Thus accelerated descent is a genuine witness of ordinary Collatz descent for
odd starting values.

The principal results are:

* `accelerated_iterate_eq_collatz_iterate`;
* `accelerated_descent_implies_collatz_descent`.

## 5. Density-One Descent for the Ordinary Collatz Map

The final stage combines the preceding results.

Let `A(N)` count the ordinary-Collatz non-descending starting values below
`N`.

Apart from `0` and `1`, every ordinary non-descender must be odd, since every
positive even integer descends immediately.

Such an integer cannot satisfy

    x % 4 = 1,

because `one_mod_four_descends` gives fully accelerated descent and
`accelerated_descent_implies_collatz_descent` transfers that descent to the
ordinary Collatz map.

Hence every remaining ordinary non-descender satisfies

    x % 4 = 3

and therefore lies in

    residual_realizations 1.

Moreover, it cannot descend under the fully accelerated map, since any such
accelerated descent would imply ordinary Collatz descent.

Thus, apart from the two isolated values `0` and `1`, ordinary non-descent is
contained in the initially residual accelerated non-descending population.

At the counting level,

    ordinary_non_descent_count N
      ≤
    residual_accelerated_non_descent_count N + 2.

The residual accelerated non-descending population has density zero by
`non_descent_initial_has_natural_density_zero`, and the two isolated
exceptions also have zero density. Therefore ordinary non-descent has natural
density zero.

Finally, ordinary eventual descent and perpetual non-descent partition the
first `N` natural numbers. Hence the ordinary descent proportion is one minus
a quantity tending to zero:

    #{x < N |
        ∃ m : ℕ,
          (collatz_step^[m]) x < x} / N
      →
    1.

This is the theorem

    ordinary_collatz_descent_has_natural_density_one.

It asserts density-one eventual descent below the starting value, not global
convergence of every Collatz trajectory.

## Dependency flow

The principal logical dependencies are:

    Collatz.ResidualForest
            │
            │  first-contraction layers
            │  finite residual parent levels
            │  residual_first_passage_or_survives
            │  fixed-depth residual densities
            │
            │
    Collatz.ResidualMass
            │
            │  residual_mass m → 0
            │
            ▼
    ┌──────────────────────────────────────────────┐
    │ First-contraction dynamical descent          │
    │                                              │
    │ strict affine contraction                    │
    │      +                                       │
    │ finite residual parent level                 │
    │      ↓                                       │
    │ uniform affine cutoff on each exit layer     │
    │      ↓                                       │
    │ finite non-descent exceptions per layer      │
    └──────────────────────────────────────────────┘
            │
            ▼
    ┌──────────────────────────────────────────────┐
    │ Finite-depth non-descent cover               │
    │                                              │
    │ upstream finite first-passage structure      │
    │      +                                       │
    │ finite exceptions on each earlier layer      │
    │      ↓                                       │
    │ non-descent ⊆ R_(1+k) ∪ finite error         │
    │      ↓                                       │
    │ A(N) ≤ R_k(N) + C_k                          │
    │      ↓                                       │
    │ choose k with M_(1+k) small                  │
    │      ↓                                       │
    │ residual accelerated non-descent density 0   │
    └──────────────────────────────────────────────┘
            │
            ▼
    ┌──────────────────────────────────────────────┐
    │ Initial congruence classes                   │
    │                                              │
    │ R_1 = {x : x ≡ 3 mod 4}                      │
    │                                              │
    │ positive even x      → ordinary descent      │
    │ x > 1, x ≡ 1 mod 4   → accelerated descent   │
    └──────────────────────────────────────────────┘
            │
            ▼
    ┌──────────────────────────────────────────────┐
    │ Accelerated-to-ordinary transfer             │
    │                                              │
    │ finite accelerated iterate                   │
    │      ↓                                       │
    │ matching finite ordinary Collatz iterate     │
    │      ↓                                       │
    │ accelerated descent → ordinary descent       │
    └──────────────────────────────────────────────┘
            │
            ▼
    ┌──────────────────────────────────────────────┐
    │ Density-one ordinary Collatz descent         │
    │                                              │
    │ ordinary non-descent                         │
    │   ⊆ residual accelerated non-descent         │
    │      ∪ {0, 1}                                │
    │      ↓                                       │
    │ ordinary non-descent density = 0             │
    │      ↓                                       │
    │ ordinary eventual descent density = 1        │
    └──────────────────────────────────────────────┘

The final theorem is

    ordinary_collatz_descent_has_natural_density_one.

It proves that ordinary Collatz eventual descent below the starting value has
natural density one. The theorem makes no claim that every trajectory
eventually reaches `1`.

-/

namespace Collatz

/-! ## First-Contraction Descent and Finite Exceptions -/

/--
Appending one division count updates the affine constant by

    affine_constant (ω ++ [d])
      =
    3 * affine_constant ω +
      2 ^ total_division_count ω.

In particular, the affine constant of a one-symbol extension depends only on
the parent word and its total division count; the value of the appended
division count `d` does not enter this recurrence.

This identity is used below to obtain uniform affine-constant bounds for
first-contraction children from the finite collection of residual parents.
-/
private lemma affine_constant_append_singleton
    (ω : division_word) (d : ℕ) :
    affine_constant (ω ++ [d]) =
      3 * affine_constant ω +
        2 ^ total_division_count ω := by
  simpa [affine_constant] using
    affine_constant_append ω [d]

/--
A realized word with strictly contractive affine slope sends every starting
value above its affine constant below itself.

Suppose `x` realizes `η`, and

    3 ^ η.length <
      2 ^ total_division_count η.

If moreover

    affine_constant η < x,

then

    (fully_accelerated^[η.length]) x < x.

The proof uses the exact affine identity

    2 ^ D(η) * f^[|η|](x)
      =
    3 ^ |η| * x + affine_constant η.

Since the affine constant is smaller than `x`, the numerator is strictly
less than `(3 ^ |η| + 1) * x`; strict slope contraction gives

    3 ^ |η| + 1 ≤ 2 ^ D(η),

so the entire affine numerator is strictly below `2 ^ D(η) * x`.

Thus contractive slope gives actual pointwise descent once the starting value
dominates the affine translation term.
-/
private lemma realized_contracting_word_descends_above_constant
    {x : ℕ}
    {η : division_word}
    (hreal : realizes x η)
    (hcontract :
      3 ^ η.length <
        2 ^ total_division_count η)
    (hx : affine_constant η < x) :
    (fully_accelerated^[η.length]) x < x := by
  /- Strict slope contraction leaves at least one unit of integer gap. -/
  have hgap :
      3 ^ η.length + 1 ≤
        2 ^ total_division_count η := by
    omega
  /-
  Since the affine constant is smaller than x, the affine numerator is
  strictly below (3^|η| + 1) * x.
  -/
  have hconstant :
      3 ^ η.length * x + affine_constant η <
        (3 ^ η.length + 1) * x := by
    have h :=
      Nat.add_lt_add_left hx (3 ^ η.length * x)
    simpa [add_mul] using h
  have hidentity :=
    affine_numerator_eq_of_realizes hreal
  /- Insert the exact affine identity, then compare with 2^D(η) * x. -/
  have hproduct :
      2 ^ total_division_count η *
          ((fully_accelerated^[η.length]) x) <
        2 ^ total_division_count η * x := by
    calc
      2 ^ total_division_count η *
          ((fully_accelerated^[η.length]) x)
          =
          3 ^ η.length * x +
            affine_constant η :=
              hidentity.symm
      _ < (3 ^ η.length + 1) * x :=
        hconstant
      _ ≤ 2 ^ total_division_count η * x :=
        Nat.mul_le_mul_right x hgap
  exact
    (Nat.mul_lt_mul_left
      (by positivity :
        0 < 2 ^ total_division_count η)).mp
      hproduct

/--
At each fixed first-contraction layer, every sufficiently large starting
value descends below itself.

For every positive symbolic depth `m`, there exists a cutoff `K` such that

    x ∈ first_contraction_layer m
      ∧ K ≤ x

implies

    (fully_accelerated^[m + 1]) x < x.

The cutoff is obtained from the finitely many residual parent words at depth
`m`. If `ω` is such a parent and `η = ω ++ [d]` is its first-contraction
child, then

    affine_constant η
      =
    3 * affine_constant ω +
      2 ^ total_division_count ω.

In particular, the affine constant of the child depends only on its parent,
not on the appended division count. Taking the maximum of these parent-based
constants therefore gives a uniform cutoff for the entire layer.

The first-contraction condition also gives

    3 ^ (m + 1) <
      2 ^ total_division_count η,

so every realized child has strictly contractive affine slope. Once the
starting value exceeds the uniform affine constant, the preceding descent
lemma applies and forces descent below the starting value.

Thus each fixed first-contraction layer has only boundedly many possible
non-descending starting values.
-/
theorem first_contraction_layer_eventual_descent
    (m : ℕ)
    (hm : 1 ≤ m) :
    ∃ K : ℕ, ∀ x : ℕ,
      x ∈ first_contraction_layer m →
      K ≤ x →
      (fully_accelerated^[m + 1]) x < x := by
  classical
  let s : Finset division_word :=
    (residual_words_at_depth_finite m).toFinset
  let C : division_word → ℕ :=
    fun ω =>
      3 * affine_constant ω +
        2 ^ total_division_count ω
  /- Use the finite residual parent level to choose a uniform affine cutoff. -/
  refine ⟨s.sup C + 1, ?_⟩
  intro x hx hxlarge
  /- Recover the residual parent word of depth m realized by x. -/
  have hxres :
      x ∈ residual_realizations m := hx.1
  obtain ⟨ω, hωmem, hωreal⟩ := hxres
  change residual_word ω ∧ ω.length = m at hωmem
  obtain ⟨hωres, hωlen⟩ := hωmem
  have hωs : ω ∈ s := by
    change
      ω ∈ (residual_words_at_depth_finite m).toFinset
    simp only [Set.Finite.mem_toFinset]
    exact ⟨hωres, hωlen⟩
  /- Identify the realized first-contraction child of symbolic length m + 1. -/
  have hxfirst :
      x ∈ first_contraction_realizations_at_depth (m + 1) := by
    rw [← first_contraction_layer_eq_realizations m hm]
    exact hx
  obtain ⟨η, hη, hηlen, hηreal⟩ := hxfirst
  /- Split the child at depth m and identify its prefix with the residual parent. -/
  have hmlt : m < η.length := by
    omega
  have hsplit :
      η = η.take m ++ [η[m]] := by
    calc
      η = η.take (m + 1) := by
        rw [← hηlen, List.take_length]
      _ = η.take m ++ [η[m]] :=
        (List.take_concat_get' η m hmlt).symm
  have hwhole :
      realizes x (η.take m ++ [η[m]]) := by
    rw [← hsplit]
    exact hηreal
  have hprefix :
      realizes x (η.take m) :=
    realizes_append_left hwhole
  have hωeq :
      ω = η.take m := by
    have hωcounts :
        ω = division_counts x m := by
      simpa [realizes, hωlen] using hωreal
    have hprefixlen :
        (η.take m).length = m := by
      simp [hηlen]
    have hprefixcounts :
        η.take m = division_counts x m := by
      simpa [realizes, hprefixlen] using hprefix
    exact hωcounts.trans hprefixcounts.symm
  have hchild :
      η = ω ++ [η[m]] := by
    calc
      η = η.take m ++ [η[m]] := hsplit
      _ = ω ++ [η[m]] := by
        rw [← hωeq]
  /- The finite parent maximum bounds the child's affine constant uniformly. -/
  have hparent_bound :
      C ω ≤ s.sup C :=
    Finset.le_sup hωs
  have hconstant :
      affine_constant η < x := by
    rw [hchild, affine_constant_append_singleton]
    change C ω < x
    omega
  /- First contraction forces strict dyadic dominance over the ternary slope. -/
  have hthreshold :
      dyadic_threshold (m + 1) ≤
        total_division_count η := by
    simpa only [hηlen] using hη.2.1
  have hbase :
      (3 : ℕ) ^ (m + 1) <
        2 ^ dyadic_threshold (m + 1) := by
    exact
      (dyadic_threshold_le_iff
        (m + 1)
        (dyadic_threshold (m + 1))).mp le_rfl
  have hpower :
      2 ^ dyadic_threshold (m + 1) ≤
        2 ^ total_division_count η := by
    exact
      pow_le_pow_right₀
        (by norm_num : (1 : ℕ) ≤ 2)
        hthreshold
  have hcontract :
      3 ^ η.length <
        2 ^ total_division_count η := by
    rw [hηlen]
    exact lt_of_lt_of_le hbase hpower
  /- Apply the pointwise descent criterion to the realized contractive child. -/
  have hdescent :=
    realized_contracting_word_descends_above_constant
      hηreal hcontract hconstant
  simpa only [hηlen] using hdescent

/--
At every fixed first-contraction layer, the starting values that never descend
below themselves form a finite set.

For `1 ≤ m`, the preceding theorem gives a cutoff `K` such that every
`x ∈ first_contraction_layer m` with `K ≤ x` satisfies

    (fully_accelerated^[m + 1]) x < x.

Hence any layer member satisfying

    ∀ n : ℕ, ¬ (fully_accelerated^[n]) x < x

must lie below `K`. The non-descending subset of the layer is therefore
contained in the finite set `Finset.range K`.
-/
theorem first_contraction_layer_non_descent_finite
    (m : ℕ)
    (hm : 1 ≤ m) :
    Set.Finite
      {x : ℕ |
        x ∈ first_contraction_layer m ∧
        ∀ n : ℕ,
          ¬ (fully_accelerated^[n]) x < x} := by
  obtain ⟨K, hK⟩ :=
    first_contraction_layer_eventual_descent m hm
  have hsubset :
      {x : ℕ |
        x ∈ first_contraction_layer m ∧
        ∀ n : ℕ,
          ¬ (fully_accelerated^[n]) x < x}
        ⊆ (Finset.range K : Set ℕ) := by
    intro x hx
    change x ∈ Finset.range K
    apply Finset.mem_range.mpr
    by_contra hlt
    have hxlarge : K ≤ x :=
      Nat.le_of_not_gt hlt
    exact hx.2 (m + 1)
      (hK x hx.1 hxlarge)
  exact (Finset.range K).finite_toSet.subset hsubset

/-! ## Finite-Depth Covers and Density-Zero Residual Non-Descent -/

/--
Among the initial residual population, the starting values that never descend
and have exited the residual forest by a fixed symbolic depth form a finite
set.

More precisely, for every `k`, the set of `x` satisfying

    x ∈ residual_realizations 1,

    ∀ n : ℕ, ¬ (fully_accelerated^[n]) x < x,

and

    x ∉ residual_realizations (1 + k)

is finite.

The proof proceeds inductively in the terminal depth. At the successor step,
a non-descending integer that has left by depth `1 + (k + 1)` either had
already left by depth `1 + k`, or survives through depth `1 + k` and exits
through `first_contraction_layer (1 + k)`.

The former set is finite by induction, while the latter is finite by
`first_contraction_layer_non_descent_finite`. Thus only finitely many
non-descending exceptions have exited by any fixed depth.
-/
theorem non_descent_initial_exits_finite
    (k : ℕ) :
    Set.Finite
      {x : ℕ |
        x ∈ residual_realizations 1 ∧
        (∀ n : ℕ,
          ¬ (fully_accelerated^[n]) x < x) ∧
        x ∉ residual_realizations (1 + k)} := by
  induction k with
  | zero =>
      /- At depth one, an initially residual integer cannot already have exited. -/
      have hsubset :
          {x : ℕ |
            x ∈ residual_realizations 1 ∧
            (∀ n : ℕ,
              ¬ (fully_accelerated^[n]) x < x) ∧
            x ∉ residual_realizations (1 + 0)}
            ⊆ (∅ : Set ℕ) := by
        intro x hx
        exact False.elim (hx.2.2 hx.1)
      exact Set.finite_empty.subset hsubset
  | succ k ih =>
      have hindex :
          1 + (k + 1) = (1 + k) + 1 := by
        omega
      /-
      By the next depth, a non-descender has either exited earlier or
      leaves through the current first-contraction layer.
      -/
      have hsubset :
          {x : ℕ |
            x ∈ residual_realizations 1 ∧
            (∀ n : ℕ,
              ¬ (fully_accelerated^[n]) x < x) ∧
            x ∉ residual_realizations (1 + (k + 1))}
          ⊆
          {x : ℕ |
            x ∈ residual_realizations 1 ∧
            (∀ n : ℕ,
              ¬ (fully_accelerated^[n]) x < x) ∧
            x ∉ residual_realizations (1 + k)}
          ∪
          {x : ℕ |
            x ∈ first_contraction_layer (1 + k) ∧
            ∀ n : ℕ,
              ¬ (fully_accelerated^[n]) x < x} := by
        intro x hx
        by_cases hprevious :
            x ∈ residual_realizations (1 + k)
        · right
          constructor
          · change
              x ∈ residual_realizations (1 + k) ∧
              x ∉ residual_realizations ((1 + k) + 1)
            exact ⟨hprevious,
              by simpa only [hindex] using hx.2.2⟩
          · exact hx.2.1
        · left
          exact ⟨hx.1, hx.2.1, hprevious⟩
      /- Both parts of this finite-depth decomposition are finite. -/
      exact
        (ih.union
          (first_contraction_layer_non_descent_finite
            (1 + k) (by omega))).subset hsubset

/--
At every finite symbolic depth, the non-descending integers in the initial
residual population are covered by the surviving residual population together
with a finite exceptional set.

For every `k`, there exists a finite set `F` such that any `x` satisfying

    x ∈ residual_realizations 1

and

    ∀ n : ℕ, ¬ (fully_accelerated^[n]) x < x

must satisfy

    x ∈ residual_realizations (1 + k)

or

    x ∈ F.

The exceptional set consists exactly of the initially residual non-descenders
that have already exited the residual forest by depth `1 + k`. Its finiteness
was established in `non_descent_initial_exits_finite`.

This finite-depth cover is the form needed below to derive a uniform counting
bound for the non-descending population.
-/
theorem non_descent_initial_finite_error_cover
    (k : ℕ) :
    ∃ F : Finset ℕ,
      ∀ x : ℕ,
        x ∈ residual_realizations 1 →
        (∀ n : ℕ,
          ¬ (fully_accelerated^[n]) x < x) →
        x ∈ residual_realizations (1 + k) ∨
          x ∈ F := by
  classical
  let E : Set ℕ :=
    {x |
      x ∈ residual_realizations 1 ∧
      (∀ n : ℕ,
        ¬ (fully_accelerated^[n]) x < x) ∧
      x ∉ residual_realizations (1 + k)}
  have hfinite : E.Finite :=
    non_descent_initial_exits_finite k
  /-  Use the finite set of non-descenders that have already exited by depth 1 + k. -/
  refine ⟨hfinite.toFinset, ?_⟩
  intro x hx hnever
  by_cases hstay :
      x ∈ residual_realizations (1 + k)
  · exact Or.inl hstay
  · right
    simp only [Set.Finite.mem_toFinset]
    exact ⟨hx, hnever, hstay⟩

open Classical in
/--
At every fixed symbolic depth, the number of initially residual
non-descending integers below `N` is bounded by the surviving residual count
plus a constant independent of `N`.

More precisely, for every `k` there exists `C : ℕ` such that for every
cutoff `N`,

    #{x < N |
        x ∈ residual_realizations 1
          ∧ ∀ n, ¬ (fully_accelerated^[n]) x < x}
      ≤
    #{x < N |
        x ∈ residual_realizations (1 + k)}
      + C.

The preceding finite-error cover supplies a finite exceptional set `F`,
independent of `N`. Every initially residual non-descender below `N` either
survives to depth `1 + k` or belongs to `F`, so one may take

    C = F.card.

This is the finite-count estimate used to prove that initial residual
non-descent has natural density zero.
-/
theorem non_descent_initial_count_bound
    (k : ℕ) :
    ∃ C : ℕ, ∀ N : ℕ,
      ((Finset.range N).filter
        (fun x : ℕ =>
          x ∈ residual_realizations 1 ∧
          ∀ n : ℕ,
            ¬ (fully_accelerated^[n]) x < x)).card
      ≤
      ((Finset.range N).filter
        (fun x : ℕ =>
          x ∈ residual_realizations (1 + k))).card
        + C := by
  classical
  obtain ⟨F, hF⟩ :=
    non_descent_initial_finite_error_cover k
  refine ⟨F.card, ?_⟩
  intro N
  let A : Finset ℕ :=
    (Finset.range N).filter
      (fun x : ℕ =>
        x ∈ residual_realizations 1 ∧
        ∀ n : ℕ,
          ¬ (fully_accelerated^[n]) x < x)
  let B : Finset ℕ :=
    (Finset.range N).filter
      (fun x : ℕ =>
        x ∈ residual_realizations (1 + k))
  /- The finite-error cover gives A ⊆ B ∪ F. -/
  have hsubset : A ⊆ B ∪ F := by
    intro x hx
    have hxA :
        x ∈ Finset.range N ∧
        (x ∈ residual_realizations 1 ∧
          ∀ n : ℕ,
            ¬ (fully_accelerated^[n]) x < x) := by
      exact Finset.mem_filter.mp hx
    rcases hF x hxA.2.1 hxA.2.2 with hstay | hfinite
    · apply Finset.mem_union.mpr
      left
      apply Finset.mem_filter.mpr
      exact ⟨hxA.1, hstay⟩
    · exact Finset.mem_union.mpr (Or.inr hfinite)
  /- Pass from set inclusion to a cardinality bound. -/
  have hcard : A.card ≤ (B ∪ F).card :=
    Finset.card_le_card hsubset
  /- Bound the union by the residual count plus the fixed exceptional size. -/
  have hunion :
      (B ∪ F).card ≤ B.card + F.card :=
    Finset.card_union_le B F
  change A.card ≤ B.card + F.card
  exact hcard.trans hunion

/--
A fixed finite counting error becomes negligible after normalization by the
size of the initial interval.

For every constant `C : ℕ`,

    (C : ℝ) / N → 0

as `N → ∞`.

This is the asymptotic input used to eliminate the `N`-independent finite
error term in `non_descent_initial_count_bound`.
-/
private lemma finite_error_ratio_tendsto_zero
    (C : ℕ) :
    Filter.Tendsto
      (fun N : ℕ => (C : ℝ) / (N : ℝ))
      Filter.atTop
      (nhds (0 : ℝ)) := by
  have hN :
      Filter.Tendsto
        (fun N : ℕ => (N : ℝ))
        Filter.atTop
        Filter.atTop :=
    tendsto_natCast_atTop_atTop
  simpa using
    (tendsto_const_nhds.div_atTop hN :
      Filter.Tendsto
        (fun N : ℕ => (C : ℝ) / (N : ℝ))
        Filter.atTop
        (nhds (0 : ℝ)))

/--
A counting function bounded by another counting function plus a fixed finite
error inherits the latter's asymptotic density as an eventual upper bound.

Suppose

    A N ≤ R N + C

for every `N`, where `C` is independent of `N`, and suppose

    R N / N → δ.

Then for every `ε > 0`,

    A N / N ≤ δ + ε

for all sufficiently large `N`.

Indeed,

    A N / N
      ≤
    R N / N + C / N,

the first term converges to `δ`, and the fixed finite-error term `C / N`
converges to zero.

This lemma packages the analytic step used below to convert a finite-depth
counting cover into an eventual density bound.
-/
private lemma count_ratio_eventually_le_of_bound
    (A R : ℕ → ℕ)
    (C : ℕ)
    (δ ε : ℝ)
    (hcount : ∀ N, A N ≤ R N + C)
    (hR :
      Filter.Tendsto
        (fun N : ℕ => (R N : ℝ) / (N : ℝ))
        Filter.atTop
        (nhds δ))
    (hε : 0 < ε) :
    ∀ᶠ N : ℕ in Filter.atTop,
      (A N : ℝ) / (N : ℝ) ≤ δ + ε := by
  /- The residual ratio plus the normalized finite error still converges to δ. -/
  have hsum :
      Filter.Tendsto
        (fun N : ℕ =>
          (R N : ℝ) / (N : ℝ) +
            (C : ℝ) / (N : ℝ))
        Filter.atTop
        (nhds δ) := by
    simpa only [add_zero] using
      hR.add (finite_error_ratio_tendsto_zero C)
  /- Hence that upper-bound ratio is eventually strictly below δ + ε. -/
  have hsmall :
      ∀ᶠ N : ℕ in Filter.atTop,
        (R N : ℝ) / (N : ℝ) +
          (C : ℝ) / (N : ℝ) < δ + ε := by
    exact hsum.eventually
      (eventually_lt_nhds (by linarith : δ < δ + ε))
  /- Normalize the finite counting inequality and compare with the limiting bound. -/
  filter_upwards [hsmall] with N hsmallN
  have hcast :
      (A N : ℝ) ≤ (R N : ℝ) + (C : ℝ) := by
    exact_mod_cast hcount N
  have hdiv :
      (A N : ℝ) / (N : ℝ) ≤
        ((R N : ℝ) + (C : ℝ)) / (N : ℝ) := by
    exact div_le_div_of_nonneg_right hcast (by positivity)
  rw [add_div] at hdiv
  exact hdiv.trans hsmallN.le

/--
For every positive tolerance, some shifted residual depth has mass below that
tolerance.

If `ε > 0`, then there exists `k : ℕ` such that

    residual_mass (1 + k) < ε.

This is an immediate consequence of `residual_mass_tendsto_zero`, after
restricting to the cofinal sequence of positive depths `1 + k`.

The lemma provides the finite depth chosen first in the later density-zero
argument.
-/
private lemma residual_mass_shift_eventually_small
    (ε : ℝ)
    (hε : 0 < ε) :
    ∃ k : ℕ,
      residual_mass (1 + k) < ε := by
  /- The shifted depth sequence 1 + k is cofinal in the natural numbers. -/
  have hshift :
      Filter.Tendsto
        (fun k : ℕ => 1 + k)
        Filter.atTop
        Filter.atTop := by
    apply Filter.tendsto_atTop.2
    intro b
    apply Filter.eventually_atTop.mpr
    refine ⟨b, ?_⟩
    intro k hk
    omega
  /-
  Residual-mass collapse therefore makes the shifted mass eventually
  smaller than any prescribed positive tolerance.
  -/
  have hzero :
      Filter.Tendsto
        (fun k : ℕ => residual_mass (1 + k))
        Filter.atTop
        (nhds (0 : ℝ)) :=
    residual_mass_tendsto_zero.comp hshift
  have hsmall :
      ∀ᶠ k : ℕ in Filter.atTop,
        residual_mass (1 + k) < ε :=
    hzero.eventually (eventually_lt_nhds hε)
  obtain ⟨K, hK⟩ :=
    Filter.eventually_atTop.1 hsmall
  exact ⟨K, hK K le_rfl⟩

open Classical in
/--
The initially residual integers that never descend below their starting
values have ordinary natural density zero.

More precisely, the normalized count

    #{x < N |
        x ∈ residual_realizations 1
          ∧ ∀ n, ¬ (fully_accelerated^[n]) x < x} / N

tends to zero as `N → ∞`.

The proof uses the finite-depth cover established above. Given `ε > 0`,
first choose a fixed depth `1 + k` such that

    residual_mass (1 + k) < ε / 2.

With this depth held fixed, the non-descending count is bounded by the
surviving residual count plus a constant `C` independent of `N`:

    A(N) ≤ R_k(N) + C.

The residual counting ratio satisfies

    R_k(N) / N → residual_mass (1 + k),

while the normalized finite error `C / N` tends to zero. Hence for all
sufficiently large `N`,

    A(N) / N < ε.

Thus initial residual non-descent has natural density zero.

The argument deliberately uses a fixed finite depth before passing to the
limit in `N`; no countable additivity and no interchange of the depth and
interval-size limits is required.
-/
theorem non_descent_initial_has_natural_density_zero :
    Filter.Tendsto
      (fun N : ℕ =>
        (((Finset.range N).filter
          (fun x : ℕ =>
            x ∈ residual_realizations 1 ∧
            ∀ n : ℕ,
              ¬ (fully_accelerated^[n]) x < x)).card : ℝ)
          / (N : ℝ))
      Filter.atTop
      (nhds (0 : ℝ)) := by
  classical
  let A : ℕ → ℕ :=
    fun N =>
      ((Finset.range N).filter
        (fun x : ℕ =>
          x ∈ residual_realizations 1 ∧
          ∀ n : ℕ,
            ¬ (fully_accelerated^[n]) x < x)).card
  /- Prove convergence to zero through eventual lower and upper bounds. -/
  apply tendsto_order.2
  constructor
  /- The normalized counting function is everywhere nonnegative. -/
  · intro a ha
    exact Filter.Eventually.of_forall (fun N => by
      have hnonneg :
          (0 : ℝ) ≤ (A N : ℝ) / (N : ℝ) := by
        positivity
      exact lt_of_lt_of_le ha hnonneg)
  /- Given ε > 0, first choose a fixed residual depth with mass below ε / 2. -/
  · intro ε hε
    obtain ⟨k, hk⟩ :=
      residual_mass_shift_eventually_small
        (ε / 2) (by linarith)
    /-
    At this fixed depth, bound non-descent by the residual count plus
    an N-independent finite error.
    -/
    obtain ⟨C, hC⟩ :=
      non_descent_initial_count_bound k
    let R : ℕ → ℕ :=
      fun N =>
        residual_realization_count (1 + k) N
    have hcount :
        ∀ N : ℕ, A N ≤ R N + C := by
      intro N
      simpa only
        [A, R, residual_realization_count,
         Nat.count_eq_card_filter_range]
        using hC N
    /- The surviving residual count has natural density residual_mass (1 + k). -/
    have hR :
        Filter.Tendsto
          (fun N : ℕ =>
            (R N : ℝ) / (N : ℝ))
          Filter.atTop
          (nhds (residual_mass (1 + k))) := by
      simpa only [R] using
        residual_realization_count_has_natural_density
          (1 + k)
    /- Combine the residual-density limit with the vanishing finite error. -/
    have hlarge :=
      count_ratio_eventually_le_of_bound
        A R C
        (residual_mass (1 + k))
        (ε / 2)
        hcount hR
        (by linarith)
    filter_upwards [hlarge] with N hN
    change (A N : ℝ) / (N : ℝ) < ε
    linarith

/-! ## Initial Residual Congruence Class and Immediate Descent -/

/--
The initial residual population consists exactly of the integers congruent to
`3` modulo `4`.

For every `x`,

    x ∈ residual_realizations 1
      ↔
    x % 4 = 3.

At symbolic depth one, the unique residual word is `[1]`. Thus membership in
`residual_realizations 1` is equivalent to realizing the one-symbol division
word `[1]`, which in turn is equivalent to

    division_count x = 1.

The exact valuation characterization of `division_count` then gives

    (3 * x + 1) % 4 = 2,

which is equivalent to

    x % 4 = 3.

Hence the entire initial residual population is precisely the congruence
class `3 mod 4`.
-/
theorem residual_realizations_one_iff_mod_four
    (x : ℕ) :
    x ∈ residual_realizations 1 ↔ x % 4 = 3 :=
  calc
    x ∈ residual_realizations 1
        ↔ realizes x ([1] : division_word) := by
          simp [residual_realizations,
                residual_words_at_depth_one]
    _ ↔ division_count x = 1 := by
      change ([1] : List ℕ) = [division_count x] ↔
        division_count x = 1
      simp only [List.cons.injEq, and_true]
      exact eq_comm
    _ ↔ x % 4 = 3 := by
          rw [division_count_eq_iff_exact_modEq x 1]
          change (3 * x + 1) % 4 = 2 ↔ x % 4 = 3
          omega

/--
Every natural number greater than one and congruent to `1` modulo `4`
descends after one fully accelerated Collatz step.

If

    x % 4 = 1,

then `4 ∣ 3 * x + 1`, so

    2 ≤ division_count x

and therefore

    4 ≤ 2 ^ division_count x.

Hence

    4 * fully_accelerated x ≤ 3 * x + 1.

Since `1 < x` implies

    3 * x + 1 < 4 * x,

it follows that

    fully_accelerated x < x.

The hypothesis `1 < x` excludes the fixed point `x = 1`.
-/
theorem one_mod_four_descends
    (x : ℕ)
    (hx : 1 < x)
    (hmod : x % 4 = 1) :
    fully_accelerated x < x := by
  /-
  The congruence x ≡ 1 mod 4 forces at least two factors of two
  in the accelerated numerator.
  -/
  have hfour : 4 ∣ 3 * x + 1 := by
    omega
  have hval : 2 ≤ division_count x := by
    unfold division_count
    apply
      (padicValNat_dvd_iff_le
        (p := 2)
        (a := 3 * x + 1)
        (n := 2)
        (by omega)).mp
    simpa using hfour
  /- Consequently the denominator of the accelerated step is at least four. -/
  have hden : 4 ≤ 2 ^ division_count x := by
    have hdvd :
        2 ^ 2 ∣ 2 ^ division_count x :=
      pow_dvd_pow 2 hval
    exact Nat.le_of_dvd (by positivity) (by simpa using hdvd)
  /-
  Natural-number division therefore gives
  4 * fully_accelerated x ≤ 3 * x + 1.
  -/
  have hquotient :
      fully_accelerated x * 2 ^ division_count x ≤
        3 * x + 1 := by
    unfold fully_accelerated
    exact Nat.div_mul_le_self _ _
  have hbound :
      fully_accelerated x * 4 ≤ 3 * x + 1 := by
    calc
      fully_accelerated x * 4
          ≤ fully_accelerated x * 2 ^ division_count x :=
              Nat.mul_le_mul_left _ hden
      _ ≤ 3 * x + 1 := hquotient
  /- Since x > 1, the numerator is strictly smaller than 4 * x. -/
  omega

/--
Every positive natural number strictly decreases when divided by two.

If `0 < x`, then

    x / 2 < x.

This elementary inequality supplies the descent step for positive even
integers under the ordinary Collatz map.
-/
lemma positive_half_lt
    (x : ℕ)
    (hx : 0 < x) :
    x / 2 < x := by
  exact Nat.div_lt_self hx (by norm_num)

/--
Every positive even integer descends after one ordinary Collatz step.

If `x` is positive and even, then

    collatz_step x = x / 2,

and therefore

    collatz_step x < x

by `positive_half_lt`.

Thus the even starting values require no further residual or accelerated
analysis in the final density-one argument.
-/
theorem even_collatz_descends
    (x : ℕ)
    (hx : 0 < x)
    (heven : Even x) :
    collatz_step x < x := by
  have hmod : x % 2 = 0 :=
    Nat.mod_eq_zero_of_dvd (Even.two_dvd heven)
  simp only [collatz_step, hmod, ↓reduceIte]
  exact positive_half_lt x hx

/-! ## Transfer from Accelerated to Ordinary Collatz Descent -/

/--
Every finite fully accelerated trajectory beginning at an odd integer can be
reproduced exactly by finitely many ordinary Collatz steps.

For every accelerated iterate count `n` and every odd starting value `x`,
there exists `m : ℕ` such that

    (collatz_step^[m]) x
      =
    (fully_accelerated^[n]) x.

One fully accelerated step from an odd integer consists of one ordinary odd
Collatz step followed by `division_count x` successive divisions by two.
Thus

    (collatz_step^[division_count x + 1]) x
      =
    fully_accelerated x.

Inductively expanding each accelerated step therefore produces a finite
ordinary Collatz trajectory with the same endpoint.
-/
lemma accelerated_iterate_eq_collatz_iterate
    (n : ℕ) :
    ∀ x : ℕ, Odd x →
      ∃ m : ℕ,
        (collatz_step^[m]) x =
          (fully_accelerated^[n]) x := by
  induction n with
  | zero =>
      intro x _
      exact ⟨0, rfl⟩
  | succ n ih =>
      intro x hx
      /- Reproduce the remaining accelerated trajectory from fully_accelerated x. -/
      obtain ⟨m, hm⟩ :=
        ih (fully_accelerated x) (fully_accelerated_odd x)
      /-
      Expand the first accelerated step into ordinary Collatz steps and
      concatenate it with the ordinary realization of the remaining steps.
      -/
      refine ⟨m + (division_count x + 1), ?_⟩
      calc
        (collatz_step^[m + (division_count x + 1)]) x
            = (collatz_step^[m])
                ((collatz_step^[division_count x + 1]) x) := by
                  rw [Function.iterate_add_apply]
        _ = (collatz_step^[m]) (fully_accelerated x) := by
              rw [collatz_step_iterate_eq_fully_accelerated x hx]
        _ = (fully_accelerated^[n]) (fully_accelerated x) :=
              hm
        _ = (fully_accelerated^[n.succ]) x := by
              rw [Function.iterate_succ_apply]

/--
Eventual descent under the fully accelerated map implies eventual descent
under the ordinary Collatz map for odd starting values.

Suppose `x` is odd and there exists `n` such that

    (fully_accelerated^[n]) x < x.

By `accelerated_iterate_eq_collatz_iterate`, the same accelerated endpoint is
reached by some finite number `m` of ordinary Collatz steps:

    (collatz_step^[m]) x
      =
    (fully_accelerated^[n]) x.

Hence

    (collatz_step^[m]) x < x.

Thus any descent witnessed in the fully accelerated dynamics is also a
genuine descent in the ordinary Collatz dynamics.
-/
theorem accelerated_descent_implies_collatz_descent
    (x : ℕ)
    (hx : Odd x)
    (hdesc : ∃ n : ℕ,
      (fully_accelerated^[n]) x < x) :
    ∃ m : ℕ,
      (collatz_step^[m]) x < x := by
  obtain ⟨n, hn⟩ := hdesc
  obtain ⟨m, hm⟩ :=
    accelerated_iterate_eq_collatz_iterate n x hx
  refine ⟨m, ?_⟩
  rw [hm]
  exact hn

/-! ## Density-One Descent for the Ordinary Collatz Map -/

open Classical in
/--
The set of natural numbers admitting eventual descent under the ordinary
Collatz map has natural density one.

More precisely,

    #{x < N | ∃ m : ℕ, (collatz_step^[m]) x < x} / N
      →
    1

as `N → ∞`.

The proof first shows that ordinary-Collatz non-descent has natural density
zero. Apart from the exceptional values `0` and `1`, an ordinary
non-descending integer must be odd. It cannot be congruent to `1` modulo `4`,
since `one_mod_four_descends` gives accelerated descent and
`accelerated_descent_implies_collatz_descent` transfers that descent to the
ordinary Collatz map. Hence every remaining ordinary non-descender is
congruent to `3` modulo `4`, and therefore belongs to
`residual_realizations 1`.

Moreover, such an integer cannot descend under the fully accelerated map:
any accelerated descent would again imply ordinary Collatz descent. Thus,
apart from `0` and `1`, ordinary non-descent is contained in the initially
residual accelerated non-descent population.

Consequently,

    ordinary_non_descent_count N
      ≤
    residual_accelerated_non_descent_count N + 2.

The latter population has natural density zero by
`non_descent_initial_has_natural_density_zero`, and the two exceptional
values contribute zero density. Hence ordinary non-descent has natural
density zero.

Finally, eventual descent and non-descent partition the first `N` natural
numbers. Therefore the ordinary descent proportion is one minus a quantity
tending to zero, and so tends to one.

Here "eventual descent" means only that some iterate is strictly smaller than
the starting value. This theorem does not assert that every Collatz trajectory
reaches `1`, nor does it prove global convergence of the Collatz map.
-/
theorem ordinary_collatz_descent_has_natural_density_one :
    Filter.Tendsto
      (fun N : ℕ =>
        (((Finset.range N).filter
          (fun x : ℕ =>
            ∃ m : ℕ, (collatz_step^[m]) x < x)).card : ℝ)
          / (N : ℝ))
      Filter.atTop (nhds (1 : ℝ)) := by
  classical
  /-
  Count ordinary non-descent, residual accelerated non-descent,
  and ordinary eventual descent below each cutoff N.
  -/
  let A : ℕ → ℕ := fun N =>
    ((Finset.range N).filter
      (fun x : ℕ =>
        ∀ m : ℕ, ¬ (collatz_step^[m]) x < x)).card
  let R : ℕ → ℕ := fun N =>
    ((Finset.range N).filter
      (fun x : ℕ =>
        x ∈ residual_realizations 1 ∧
        ∀ n : ℕ, ¬ (fully_accelerated^[n]) x < x)).card
  let G : ℕ → ℕ := fun N =>
    ((Finset.range N).filter
      (fun x : ℕ =>
        ∃ m : ℕ, (collatz_step^[m]) x < x)).card
  /-
  Apart from 0 and 1, every ordinary non-descender is an initially
  residual integer that also never descends under the accelerated map.
  -/
  have hcount : ∀ N : ℕ, A N ≤ R N + 2 := by
    intro N
    let bad : Finset ℕ :=
      (Finset.range N).filter
        (fun x : ℕ =>
          ∀ m : ℕ, ¬ (collatz_step^[m]) x < x)
    let residual : Finset ℕ :=
      (Finset.range N).filter
        (fun x : ℕ =>
          x ∈ residual_realizations 1 ∧
          ∀ n : ℕ, ¬ (fully_accelerated^[n]) x < x)
    have hsubset :
        bad ⊆ residual ∪ ({0, 1} : Finset ℕ) := by
      intro x hx
      change
        x ∈ (Finset.range N).filter
          (fun x : ℕ =>
            ∀ m : ℕ, ¬ (collatz_step^[m]) x < x)
        at hx
      obtain ⟨hrange, hbad⟩ := Finset.mem_filter.mp hx
      by_cases hx0 : x = 0
      · exact Finset.mem_union.mpr
          (Or.inr (by simp [hx0]))
      by_cases hx1 : x = 1
      · exact Finset.mem_union.mpr
          (Or.inr (by simp [hx1]))
      have hxgt : 1 < x := by omega
      /-
      Any remaining non-descender must be odd, since a positive even
      starting value descends after one ordinary Collatz step.
      -/
      have hodd : Odd x := by
        by_cases hevenmod : x % 2 = 0
        · have heven : Even x := by
            refine ⟨x / 2, ?_⟩
            omega
          have hstep :=
            even_collatz_descends x (by omega) heven
          have hstep' :
              (collatz_step^[1]) x < x := by
            simpa using hstep
          exact False.elim (hbad 1 hstep')
        · refine ⟨x / 2, ?_⟩
          omega
      have hoddmod : x % 2 = 1 := by
        obtain ⟨k, hk⟩ := hodd
        omega
      /-
      An odd value congruent to 1 mod 4 would descend under the
      accelerated map, hence also under the ordinary Collatz map.
      -/
      by_cases hmod1 : x % 4 = 1
      · have hacc :
            ∃ n : ℕ,
              (fully_accelerated^[n]) x < x := by
          refine ⟨1, ?_⟩
          simpa using one_mod_four_descends x hxgt hmod1
        obtain ⟨m, hm⟩ :=
          accelerated_descent_implies_collatz_descent
            x hodd hacc
        exact False.elim (hbad m hm)
      /-
      The only remaining odd congruence class is 3 mod 4, which is
      exactly the initial residual class; accelerated descent is also
      impossible because it would transfer to ordinary descent.
      -/
      have hmod3 : x % 4 = 3 := by
        omega
      apply Finset.mem_union.mpr
      left
      change
        x ∈ (Finset.range N).filter
          (fun x : ℕ =>
            x ∈ residual_realizations 1 ∧
            ∀ n : ℕ,
              ¬ (fully_accelerated^[n]) x < x)
      apply Finset.mem_filter.mpr
      refine ⟨hrange, ?_⟩
      constructor
      · exact (residual_realizations_one_iff_mod_four x).mpr hmod3
      · intro n hn
        obtain ⟨m, hm⟩ :=
          accelerated_descent_implies_collatz_descent
            x hodd ⟨n, hn⟩
        exact hbad m hm
    /-
    Passing to cardinalities introduces only the two exceptional
    starting values 0 and 1.
    -/
    change bad.card ≤ residual.card + 2
    calc
      bad.card
          ≤ (residual ∪ ({0, 1} : Finset ℕ)).card :=
            Finset.card_le_card hsubset
      _ ≤ residual.card + ({0, 1} : Finset ℕ).card :=
            Finset.card_union_le _ _
      _ = residual.card + 2 := by norm_num
  /- Residual accelerated non-descent already has natural density zero. -/
  have hR :
      Filter.Tendsto
        (fun N : ℕ => (R N : ℝ) / (N : ℝ))
        Filter.atTop (nhds (0 : ℝ)) := by
    simpa only [R] using
      non_descent_initial_has_natural_density_zero
  /-
  The comparison A(N) ≤ R(N) + 2 therefore forces ordinary
  non-descent itself to have natural density zero.
  -/
  have hA :
      Filter.Tendsto
        (fun N : ℕ => (A N : ℝ) / (N : ℝ))
        Filter.atTop (nhds (0 : ℝ)) := by
    apply tendsto_order.2
    constructor
    · intro a ha
      exact Filter.Eventually.of_forall (fun N => by
        have hnonneg :
            (0 : ℝ) ≤ (A N : ℝ) / (N : ℝ) := by
          positivity
        exact lt_of_lt_of_le ha hnonneg)
    · intro ε hε
      have hlarge :=
        count_ratio_eventually_le_of_bound
          A R 2 (0 : ℝ) (ε / 2)
          hcount hR (by linarith)
      filter_upwards [hlarge] with N hN
      change (A N : ℝ) / (N : ℝ) < ε
      linarith
  /-
  Eventual descent and perpetual non-descent partition the first N
  natural numbers, so A(N) + G(N) = N.
  -/
  have hpartition (N : ℕ) :
      A N + G N = N := by
    classical
    let p : ℕ → Prop := fun x =>
      ∀ m : ℕ, ¬ (collatz_step^[m]) x < x
    have hsubset :
        (Finset.range N).filter p ⊆ Finset.range N :=
      Finset.filter_subset _ _
    have hcard :=
      Finset.card_sdiff_add_card_eq_card hsubset
    /-
    The complement of perpetual non-descent is exactly the existence
    of some ordinary Collatz iterate below the starting value.
    -/
    have hfilter :
        (Finset.range N) \ (Finset.range N).filter p =
          (Finset.range N).filter
            (fun x : ℕ =>
              ∃ m : ℕ, (collatz_step^[m]) x < x) := by
      ext x
      simp only [Finset.mem_sdiff, Finset.mem_filter, p]
      constructor
      · rintro ⟨hx, hnot⟩
        have hn :
            ¬ ∀ m : ℕ, ¬ (collatz_step^[m]) x < x := by
          intro hall
          exact hnot ⟨hx, hall⟩
        push Not at hn
        exact ⟨hx, hn⟩
      · rintro ⟨hx, ⟨m, hm⟩⟩
        refine ⟨hx, ?_⟩
        rintro ⟨_, hall⟩
        exact hall m hm
    rw [hfilter] at hcard
    have hsum : G N + A N = N := by
      simpa only [A, G, p, Finset.card_range] using hcard
    omega
  /-
  Since non-descent has density zero and G(N) = N - A(N), the ordinary
  descent proportion converges to one.
  -/
  have hlim :
      Filter.Tendsto
        (fun N : ℕ =>
          (1 : ℝ) - (A N : ℝ) / (N : ℝ))
        Filter.atTop (nhds (1 : ℝ)) := by
    simpa only [sub_zero] using
      ((tendsto_const_nhds :
        Filter.Tendsto
          (fun _ : ℕ => (1 : ℝ))
          Filter.atTop (nhds (1 : ℝ))).sub hA)
  have hG :
      Filter.Tendsto
        (fun N : ℕ => (G N : ℝ) / (N : ℝ))
        Filter.atTop (nhds (1 : ℝ)) := by
    apply hlim.congr'
    filter_upwards [Filter.eventually_gt_atTop (0 : ℕ)]
      with N hN
    have hne : (N : ℝ) ≠ 0 := by
      exact_mod_cast (Nat.ne_of_gt hN)
    have hpart :
        (A N : ℝ) + (G N : ℝ) = (N : ℝ) := by
      exact_mod_cast hpartition N
    change
      (1 : ℝ) - (A N : ℝ) / (N : ℝ) =
        (G N : ℝ) / (N : ℝ)
    field_simp [hne]
    linarith
  simpa only [G] using hG

end Collatz

#print axioms Collatz.ordinary_collatz_descent_has_natural_density_one
