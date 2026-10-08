/-
Copyright (c) 2026 Wayne Brassem. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Wayne Brassem
-/

import Collatz.ResidualForest

/-!

# Exponential Decay and Collapse of Residual Mass

This module proves that the finite-depth residual mass constructed in
`Collatz.ResidualForest` tends to zero as symbolic depth tends to infinity.

The preceding module constructs the residual forest, identifies its
first-contraction exit layers, proves that each fixed residual level has
ordinary natural density equal to its symbolic cylinder mass, and establishes
the finite-stage conservation law

    residual_mass m - residual_mass (m + 1)

for the mass leaving the forest at each positive symbolic refinement.

The present module supplies the asymptotic estimate needed to show that the
density of the residual population surviving to depth `m` tends to zero as
`m → ∞`.

The argument proceeds indirectly. Rather than attempting to contract the
dyadic residual mass itself in one symbolic step, the module introduces an
auxiliary weighted mass with a uniform extension estimate. This weighted
decay is transferred to an explicit upper envelope for the true residual
mass. A five-step threshold estimate then makes that envelope uniformly
contractive, forcing both the envelope and the residual mass to tend to zero.

The development separates naturally into five stages.

## 1. Weighted Residual Mass and One-Step Contraction

For a residual division word `ω`, assign the auxiliary weight

    (3 / 8) ^ total_division_count ω.

The weighted residual mass at symbolic depth `m` is the finite sum

    residual_weighted_mass m

of these weights over `residual_words_at_depth m`.

Every residual word of length `m + 1` is obtained from its residual
length-`m` prefix by appending one positive division count. Enlarging the
actual residual children of each parent to all possible positive extensions
gives the geometric estimate

    ∑ d ≥ 1, (3 / 8) ^ d = 3 / 5.

Consequently, for every positive symbolic depth,

    residual_weighted_mass (m + 1)
      ≤
    (3 / 5) * residual_weighted_mass m.

The first residual level consists only of `[1]`, whose auxiliary weight is
`3 / 8`. Iterating the one-step estimate therefore yields the convenient
uniform bound

    residual_weighted_mass m
      ≤
    (3 / 5) ^ m

for every `m ≥ 1`.

The principal results are:

* `residual_weighted_mass`;
* `residual_word_snoc`;
* `total_division_count_append_singleton`;
* `residual_weighted_mass_step`;
* `residual_weighted_mass_one_le`;
* `residual_weighted_mass_le`.

## 2. From Weighted Mass to Dyadic Residual Mass

The exact dyadic cylinder weight can be factored into a threshold-growth
factor and the auxiliary weight:

    1 / 2 ^ (D + 1)
      =
    (1 / 2) *
      (4 / 3) ^ D *
      (3 / 8) ^ D.

For a residual word `ω` of symbolic length `m`,

    total_division_count ω
      <
    dyadic_threshold m,

and hence

    total_division_count ω
      ≤
    dyadic_threshold m - 1.

Since `4 / 3 > 1`, this gives the uniform levelwise bound

    (4 / 3) ^ total_division_count ω
      ≤
    (4 / 3) ^ (dyadic_threshold m - 1).

Summing over the finite residual level therefore gives

    residual_mass m
      ≤
    (1 / 2) *
      (4 / 3) ^ (dyadic_threshold m - 1) *
      residual_weighted_mass m.

Combining this transfer estimate with

    residual_weighted_mass m ≤ (3 / 5) ^ m

produces, for every positive depth,

    0 ≤ residual_mass m

and

    residual_mass m
      ≤
    (1 / 2) *
      (4 / 3) ^ (dyadic_threshold m - 1) *
      (3 / 5) ^ m.

This explicit upper bound is the quantity subsequently packaged as the
residual-mass envelope.

The principal results are:

* `dyadic_weight_eq_weighted`;
* `residual_mass_le_weighted_envelope`;
* `residual_mass_squeeze_bound`.

## 3. Five-Step Threshold Growth and Envelope Contraction

The growth of the dyadic threshold is controlled over blocks of five symbolic
steps.

Since

    3 ^ 5 < 2 ^ 8,

the least-threshold characterization implies

    dyadic_threshold (m + 5)
      ≤
    dyadic_threshold m + 8.

Define the residual-mass envelope by

    residual_mass_envelope m
      =
    (1 / 2) *
      (4 / 3) ^ (dyadic_threshold m - 1) *
      (3 / 5) ^ m.

At every positive depth, the preceding squeeze estimate gives

    0 ≤ residual_mass m
      ≤
    residual_mass_envelope m.

Over five symbolic steps, possible growth of the threshold factor contributes
at most

    (4 / 3) ^ 8,

while the weighted-mass decay contributes

    (3 / 5) ^ 5.

Their product is

    q
      =
    (4 / 3) ^ 8 * (3 / 5) ^ 5
      =
    65536 / 84375
      <
    1.

Therefore

    residual_mass_envelope (m + 5)
      ≤
    q * residual_mass_envelope m.

In particular, the envelope strictly decreases every five symbolic steps.
Iterating the same estimate gives, for every starting residue `r` and
`k : ℕ`,

    residual_mass_envelope (r + 5 * k)
      ≤
    q ^ k * residual_mass_envelope r.

Thus each residue class modulo five is controlled by a geometric sequence
with common ratio strictly below one.

The principal results are:

* `dyadic_threshold_add_five_le`;
* `residual_mass_envelope`;
* `residual_mass_envelope_ratio_lt_one`;
* `residual_mass_envelope_add_five_le`;
* `residual_mass_envelope_add_five_lt`;
* `residual_mass_envelope_iterate_five_le`.

## 4. Envelope Decay and Residual-Mass Collapse

For each fixed residue class modulo five, the geometric iteration estimate
implies

    residual_mass_envelope (r + 5 * k)
      →
    0

as `k → ∞`.

The five residue classes

    0, 1, 2, 3, 4

exhaust all natural symbolic depths. Combining the five subsequential limits
therefore gives

    residual_mass_envelope m
      →
    0

as `m → ∞`.

The true residual mass is nonnegative and, from every positive depth onward,
is bounded above by this vanishing envelope:

    0
      ≤
    residual_mass m
      ≤
    residual_mass_envelope m.

The squeeze theorem consequently yields the central asymptotic result

    residual_mass m
      →
    0.

Since `residual_mass m` is the ordinary natural density of
`residual_realizations m`, this says that the densities of the finite-depth
residual populations tend to zero as the required residual survival depth
increases.

No continuity-from-above assertion for the infinite residual intersection is
used in this argument.

The principal results are:

* `residual_mass_envelope_subsequence_tendsto_zero`;
* `residual_mass_envelope_tendsto_zero`;
* `residual_mass_tendsto_zero`.

## 5. Exhaustion by First-Contraction Mass

The finite-stage conservation theory from `Collatz.ResidualForest` gives the
telescoping identity

    ∑ j ∈ Finset.range k,
      (residual_mass (1 + j) -
        residual_mass (1 + j + 1))
      =
    residual_mass 1 - residual_mass (1 + k).

Each difference

    residual_mass m - residual_mass (m + 1)

is the natural density of the first-contraction layer exiting the residual
forest at that refinement step.

Since

    residual_mass (1 + k) → 0,

the finite partial sums of first-contraction mass converge to the entire
initial residual mass:

    ∑ j ∈ Finset.range k,
      (residual_mass (1 + j) -
        residual_mass (1 + j + 1))
      →
    residual_mass 1.

Thus the initial residual mass is asymptotically exhausted by successive
finite-depth first-contraction exits.

This is a statement about the limit of the finite-stage mass identities; it
does not require countable additivity of natural density.

The principal result is:

* `first_contraction_partial_mass_tendsto`.

## Dependency flow

The main logical dependencies are:

    Collatz.ResidualForest
              │
              │  residual_words_at_depth
              │  residual_mass
              │  residual_mass_nonneg
              │  finite-stage mass conservation
              ▼
    ┌──────────────────────────────────────────────┐
    │ Weighted residual mass                       │
    │                                              │
    │ residual_weighted_mass                       │
    │      ↓                                       │
    │ residual child = parent ++ [d]               │
    │      ↓                                       │
    │ positive-extension geometric sum = 3/5       │
    │      ↓                                       │
    │ W_(m+1) ≤ (3/5) W_m                          │
    │      ↓                                       │
    │ W_m ≤ (3/5)^m                                │
    └──────────────────────────────────────────────┘
              │
              ▼
    ┌──────────────────────────────────────────────┐
    │ Transfer to dyadic residual mass             │
    │                                              │
    │ 2^(-(D+1))                                   │
    │   = (1/2)(4/3)^D(3/8)^D                      │
    │      ↓                                       │
    │ D ≤ B(m) - 1                                 │
    │      ↓                                       │
    │ M_m ≤                                        │
    │   (1/2)(4/3)^(B(m)-1) W_m                    │
    │      ↓                                       │
    │ M_m ≤                                        │
    │   (1/2)(4/3)^(B(m)-1)(3/5)^m                 │
    └──────────────────────────────────────────────┘
              │
              ▼
    ┌──────────────────────────────────────────────┐
    │ Five-step threshold and envelope contraction │
    │                                              │
    │ B(m+5) ≤ B(m)+8                              │
    │      ↓                                       │
    │ E_m :=                                       │
    │   (1/2)(4/3)^(B(m)-1)(3/5)^m                 │
    │      ↓                                       │
    │ q = (4/3)^8(3/5)^5 < 1                       │
    │      ↓                                       │
    │ E_(m+5) ≤ q E_m                              │
    │      ↓                                       │
    │ E_(r+5k) ≤ q^k E_r                           │
    └──────────────────────────────────────────────┘
              │
              ▼
    ┌──────────────────────────────────────────────┐
    │ Envelope decay and residual-mass collapse    │
    │                                              │
    │ E_(r+5k) → 0                                 │
    │      ↓                                       │
    │ E_m → 0                                      │
    │      ↓                                       │
    │ 0 ≤ M_m ≤ E_m                                │
    │      ↓                                       │
    │ M_m → 0                                      │
    └──────────────────────────────────────────────┘
              │
              ▼
    ┌──────────────────────────────────────────────┐
    │ First-contraction mass exhaustion            │
    │                                              │
    │ finite telescoping                           │
    │      +                                       │
    │ M_(1+k) → 0                                  │
    │      ↓                                       │
    │ accumulated exit mass → M_1                  │
    └──────────────────────────────────────────────┘

The residual-mass collapse and first-contraction exhaustion established here
are the asymptotic inputs for `Collatz.DescentDensity`, where the finite
first-contraction layers are converted into genuine descent and the remaining
finite-depth residual error is driven to zero.

-/

namespace Collatz

/-! ## Weighted Residual Mass and One-Step Contraction -/

/--
The total weight of any finite initial segment of positive division counts
is at most `3 / 5`.

For every cutoff `K`,

    ∑ d ∈ Finset.Ico 1 K, (3 / 8 : ℝ) ^ d
      ≤ 3 / 5.

This is the corresponding finite partial-sum bound for the geometric series

    ∑ d ≥ 1, (3 / 8) ^ d = 3 / 5,

and provides the uniform contraction factor used when summing over all
possible positive one-symbol extensions of a residual word.
-/
private lemma weighted_positive_extensions_le
    (K : ℕ) :
    (∑ d ∈ Finset.Ico 1 K,
      (3 / 8 : ℝ) ^ d) ≤
        (3 / 5 : ℝ) := by
  calc
    (∑ d ∈ Finset.Ico 1 K,
        (3 / 8 : ℝ) ^ d)
        ≤
        (3 / 8 : ℝ) ^ 1 /
          (1 - (3 / 8 : ℝ)) := by
          exact
            geom_sum_Ico_le_of_lt_one
              (x := (3 / 8 : ℝ))
              (m := 1)
              (n := K)
              (by norm_num)
              (by norm_num)
    _ = (3 / 5 : ℝ) := by
      norm_num

/--
The auxiliary weighted mass of the residual words at symbolic depth `m`.

Each residual word `ω` contributes the weight

    (3 / 8) ^ total_division_count ω,

and `residual_weighted_mass m` is the finite sum of these contributions over
`residual_words_at_depth m`.

This weighted mass is introduced as an analytic surrogate for the true
dyadic residual mass. Its advantage is that positive one-symbol extensions
admit the uniform geometric contraction factor `3 / 5`.
-/
noncomputable def residual_weighted_mass (m : ℕ) : ℝ :=
  ((residual_words_at_depth_finite m).toFinset).sum
    (fun ω =>
      (3 / 8 : ℝ) ^ total_division_count ω)

/--
Every residual word of length `m + 1`, with `1 ≤ m`, is obtained by
appending one positive division count to a residual word of length `m`.

Thus if `η` is residual of length `m + 1`, there exist a residual parent
`ω` and a positive division count `d` such that

    η = ω ++ [d],
    ω.length = m,
    1 ≤ d.

This gives the parent–child decomposition used to estimate weighted mass
across one residual refinement step.
-/
lemma residual_word_snoc
    (m : ℕ)
    {η : division_word}
    (hm : 1 ≤ m)
    (hη : residual_word η)
    (hlen : η.length = m + 1) :
    ∃ ω d,
      η = ω ++ [d] ∧
      residual_word ω ∧
      ω.length = m ∧
      1 ≤ d := by
  have hmlt : m < η.length := by
    omega
  refine ⟨η.take m, η[m], ?_, ?_, ?_, ?_⟩
  /- Recover η from its length-m prefix and final entry. -/
  · calc
      η = η.take (m + 1) := by
        rw [← hlen, List.take_length]
      _ = η.take m ++ [η[m]] :=
        (List.take_concat_get' η m hmlt).symm
  /- The parent remains residual. -/
  · exact residual_word_prefix hη hm (by omega)
  /- The parent has symbolic length m. -/
  · simp [List.length_take, hlen]
  /- The appended division count is positive. -/
  · exact hη.1.2 η[m] (List.getElem_mem hmlt)

/--
Appending a single division count adds that value to the total division
count.

For any division word `ω` and natural number `d`,

    total_division_count (ω ++ [d])
      =
    total_division_count ω + d.

Consequently, the weighted contribution of an extension factors into the
weight of its parent times `(3 / 8) ^ d`.
-/
lemma total_division_count_append_singleton
    (ω : division_word) (d : ℕ) :
    total_division_count (ω ++ [d]) =
      total_division_count ω + d := by
  simp [total_division_count, List.sum_append]

/--
The weighted residual mass contracts by a factor of at most `3 / 5` at every
positive symbolic depth.

For `1 ≤ m`,

    residual_weighted_mass (m + 1)
      ≤
    (3 / 5) * residual_weighted_mass m.

Every residual child at depth `m + 1` is obtained from a residual parent at
depth `m` by appending a positive division count `d`. To obtain an upper
bound, the actual residual children are enlarged to all parent–increment
pairs with

    1 ≤ d < dyadic_threshold (m + 1).

The weight of such an extension factors as

    (3 / 8) ^ D(ω ++ [d])
      =
    (3 / 8) ^ D(ω) * (3 / 8) ^ d,

and the total weight of all permitted positive increments is bounded by the
geometric sum `3 / 5`.

Thus the residual extension process is uniformly subcritical for this
auxiliary weighted mass.
-/
theorem residual_weighted_mass_step
    (m : ℕ)
    (hm : 1 ≤ m) :
    residual_weighted_mass (m + 1) ≤
      (3 / 5 : ℝ) * residual_weighted_mass m := by
  classical
  let s : Finset division_word :=
    (residual_words_at_depth_finite m).toFinset
  let u : Finset division_word :=
    (residual_words_at_depth_finite (m + 1)).toFinset
  let t : Finset ℕ :=
    Finset.Ico 1 (dyadic_threshold (m + 1))
  let extend : division_word × ℕ → division_word :=
    fun p => p.1 ++ [p.2]
  let w : division_word → ℝ :=
    fun ω => (3 / 8 : ℝ) ^ total_division_count ω
  /-
  Every actual residual child lies in the image of the larger finite
  family of residual-parent / positive-increment pairs.
  -/
  have hsubset :
      u ⊆ (s.product t).image extend := by
    intro η hη
    have hηset :
        η ∈ residual_words_at_depth (m + 1) := by
      simpa only [u, Set.Finite.mem_toFinset] using hη
    change
      residual_word η ∧ η.length = m + 1 at hηset
    obtain ⟨hres, hlen⟩ := hηset
    obtain ⟨ω, d, happend, hωres, hωlen, hdpos⟩ :=
      residual_word_snoc m hm hres hlen
    have hbelow :
        total_division_count η <
          dyadic_threshold (m + 1) := by
      have h :=
        hres.2 (m + 1) (by omega) (by omega)
      have ht : η.take (m + 1) = η := by
        rw [← hlen, List.take_length]
      simpa only [ht] using h
    have hdlt :
        d < dyadic_threshold (m + 1) := by
      rw [
        happend,
        total_division_count_append_singleton
      ] at hbelow
      omega
    have hωs : ω ∈ s := by
      change ω ∈ (residual_words_at_depth_finite m).toFinset
      simp only [Set.Finite.mem_toFinset]
      exact ⟨hωres, hωlen⟩
    have hdt : d ∈ t := by
      change
        d ∈ Finset.Ico 1
          (dyadic_threshold (m + 1))
      exact Finset.mem_Ico.mpr ⟨hdpos, hdlt⟩
    apply Finset.mem_image.mpr
    refine ⟨(ω, d), ?_, ?_⟩
    · exact Finset.mem_product.mpr ⟨hωs, hdt⟩
    · exact happend.symm
  /-
  Enlarge the actual children first to their image, then to all
  generating parent–increment pairs; nonnegativity makes both safe.
  -/
  have hsum1 :
      (∑ η ∈ u, w η) ≤
        ∑ η ∈ (s.product t).image extend, w η := by
    apply Finset.sum_le_sum_of_subset_of_nonneg hsubset
    intro η hη hnot
    dsimp [w]
    positivity
  have hsum2 :
      (∑ η ∈ (s.product t).image extend, w η) ≤
        ∑ p ∈ s.product t, w (extend p) := by
    apply Finset.sum_image_le_of_nonneg
    intro η hη
    dsimp [w]
    positivity
  /- Extension weights factor into parent weight times increment weight. -/
  have hfactor :
      (∑ p ∈ s.product t, w (extend p)) =
        (∑ ω ∈ s, w ω) *
          (∑ d ∈ t, (3 / 8 : ℝ) ^ d) := by
    change
      (∑ p ∈ s.product t,
        (3 / 8 : ℝ) ^
          total_division_count (p.1 ++ [p.2])) =
      (∑ ω ∈ s,
        (3 / 8 : ℝ) ^ total_division_count ω) *
      (∑ d ∈ t, (3 / 8 : ℝ) ^ d)
    rw [Finset.product_eq_sprod, Finset.sum_product]
    simp_rw [
      total_division_count_append_singleton,
      pow_add
    ]
    simp_rw [← Finset.mul_sum]
    rw [← Finset.sum_mul]
  /- The total increment weight is uniformly bounded by 3/5. -/
  have hgeom :
      (∑ d ∈ t, (3 / 8 : ℝ) ^ d) ≤
        (3 / 5 : ℝ) := by
    exact
      weighted_positive_extensions_le
        (dyadic_threshold (m + 1))
  /- Multiply the geometric bound by the nonnegative total parent weight. -/
  have hparent_nonneg :
      0 ≤ ∑ ω ∈ s, w ω := by
    apply Finset.sum_nonneg
    intro ω hω
    dsimp [w]
    positivity
  have hbound :
      (∑ ω ∈ s, w ω) *
          (∑ d ∈ t, (3 / 8 : ℝ) ^ d) ≤
        (3 / 5 : ℝ) * (∑ ω ∈ s, w ω) := by
    calc
      _ ≤
          (∑ ω ∈ s, w ω) * (3 / 5 : ℝ) :=
        mul_le_mul_of_nonneg_left hgeom hparent_nonneg
      _ = _ := mul_comm _ _
  /- Chain the enlargement, factorization, and geometric estimates. -/
  calc
    residual_weighted_mass (m + 1)
        = ∑ η ∈ u, w η := rfl
    _ ≤ ∑ η ∈ (s.product t).image extend, w η :=
      hsum1
    _ ≤ ∑ p ∈ s.product t, w (extend p) :=
      hsum2
    _ =
        (∑ ω ∈ s, w ω) *
          (∑ d ∈ t, (3 / 8 : ℝ) ^ d) :=
      hfactor
    _ ≤ (3 / 5 : ℝ) * (∑ ω ∈ s, w ω) :=
      hbound
    _ = (3 / 5 : ℝ) * residual_weighted_mass m :=
      rfl

/--
At symbolic depth one, the residual forest consists exactly of the single
word `[1]`.

Its weighted mass is therefore

    residual_weighted_mass 1 = 3 / 8,

and in particular

    residual_weighted_mass 1 ≤ 3 / 5.

This supplies the base estimate for the geometric decay of the weighted
residual mass.
-/
theorem residual_weighted_mass_one_le :
    residual_weighted_mass 1 ≤ (3 / 5 : ℝ) := by
  have hB :
      dyadic_threshold 1 = 2 := by
    decide
  /- Verify directly that [1] is residual at symbolic depth one. -/
  have hsingle :
      residual_word ([1] : division_word) := by
    constructor
    · constructor
      · simp [valid_division_word]
      · intro d hd
        simp at hd
        omega
    · intro j hjpos hjle
      have hj : j = 1 := by
        simp at hjle
        omega
      subst j
      norm_num [total_division_count, hB]
  /-
  Residuality and the depth-one threshold force every length-one
  residual word to be exactly [1].
  -/
  have hwords :
      (residual_words_at_depth_finite 1).toFinset =
        ({[1]} : Finset division_word) := by
    ext ω
    simp only [
      Set.Finite.mem_toFinset,
      Finset.mem_singleton
    ]
    constructor
    · intro hω
      change residual_word ω ∧ ω.length = 1 at hω
      obtain ⟨hr, hl⟩ := hω
      cases ω with
      | nil =>
          simp at hl
      | cons d tail =>
          cases tail with
          | nil =>
              have hdpos : 1 ≤ d :=
                hr.1.2 d (by simp)
              have hdlt : d < 2 := by
                have htotal :=
                  residual_word_total_lt_threshold hr
                simpa [total_division_count, hB]
                  using htotal
              have hd : d = 1 := by
                omega
              simp [hd]
          | cons e rest =>
              simp at hl
    · intro hω
      subst ω
      exact ⟨hsingle, by simp⟩
  /-  The weighted residual mass is therefore a singleton sum. -/
  unfold residual_weighted_mass
  rw [hwords]
  norm_num [total_division_count]

/--
The auxiliary weighted residual mass is exponentially bounded at every
positive symbolic depth.

For `1 ≤ m`,

    residual_weighted_mass m
      ≤
    (3 / 5) ^ m.

The proof iterates the one-step contraction

    residual_weighted_mass (m + 1)
      ≤
    (3 / 5) * residual_weighted_mass m

from the depth-one bound. Thus the weighted residual forest is bounded above
by a geometric sequence with ratio `3 / 5`.

This estimate is the input used below to bound the true dyadic residual mass.
-/
theorem residual_weighted_mass_le
    (m : ℕ)
    (hm : 1 ≤ m) :
    residual_weighted_mass m ≤ (3 / 5 : ℝ) ^ m := by
  induction m, hm using Nat.le_induction with
  | base =>
      simpa using residual_weighted_mass_one_le
  | succ m hm ih =>
      calc
        residual_weighted_mass (m + 1)
            ≤ (3 / 5 : ℝ) * residual_weighted_mass m :=
              residual_weighted_mass_step m hm
        _ ≤ (3 / 5 : ℝ) * (3 / 5 : ℝ) ^ m :=
              mul_le_mul_of_nonneg_left ih (by norm_num)
        _ = (3 / 5 : ℝ) ^ (m + 1) := by
              rw [pow_succ]
              ring

/-! ## From Weighted Mass to Dyadic Residual Mass -/

/--
Rewrite the exact dyadic cylinder weight in terms of the auxiliary weighted
factor.

For every total division count `D`,

    1 / 2 ^ (D + 1)
      =
    (1 / 2) *
      (4 / 3) ^ D *
      (3 / 8) ^ D.

The final factor

    (3 / 8) ^ D

is exactly the weight used in `residual_weighted_mass`. The remaining factor

    (4 / 3) ^ D

will be bounded uniformly across a residual level using the critical division
threshold.

This identity is the algebraic bridge from the auxiliary weighted mass back
to the true dyadic realization-cylinder mass.
-/
private lemma dyadic_weight_eq_weighted
    (D : ℕ) :
    (1 : ℝ) / (2 : ℝ) ^ (D + 1) =
      (1 / 2 : ℝ) *
        (4 / 3 : ℝ) ^ D *
        (3 / 8 : ℝ) ^ D := by
  calc
    (1 : ℝ) / (2 : ℝ) ^ (D + 1)
        = (1 / 2 : ℝ) * (1 / 2 : ℝ) ^ D := by
            rw [← one_div_pow, pow_succ]
            ring
    _ =
        (1 / 2 : ℝ) *
          (4 / 3 : ℝ) ^ D *
          (3 / 8 : ℝ) ^ D := by
            rw [mul_assoc, ← mul_pow]
            norm_num

/--
The true residual mass at symbolic depth `m` is bounded by a uniform
threshold factor times the auxiliary weighted residual mass.

For every residual word `ω` of length `m`,

    total_division_count ω
      <
    dyadic_threshold m,

hence

    total_division_count ω
      ≤
    dyadic_threshold m - 1.

Using

    1 / 2 ^ (D + 1)
      =
    (1 / 2) * (4 / 3) ^ D * (3 / 8) ^ D

and the monotonicity of `(4 / 3) ^ D`, each exact dyadic cylinder weight is
therefore bounded by

    (1 / 2) *
      (4 / 3) ^ (dyadic_threshold m - 1) *
      (3 / 8) ^ D.

Summing this bound over the residual words at depth `m` gives

    residual_mass m
      ≤
    (1 / 2) *
      (4 / 3) ^ (dyadic_threshold m - 1) *
      residual_weighted_mass m.

Thus the true dyadic residual mass differs from the auxiliary weighted mass
only by a common depth-dependent envelope factor.
-/
theorem residual_mass_le_weighted_envelope
    (m : ℕ) :
    residual_mass m ≤
      (1 / 2 : ℝ) *
        (4 / 3 : ℝ) ^
          (dyadic_threshold m - 1) *
        residual_weighted_mass m := by
  classical
  let s : Finset division_word :=
    (residual_words_at_depth_finite m).toFinset
  let C : ℝ :=
    (1 / 2 : ℝ) *
      (4 / 3 : ℝ) ^
        (dyadic_threshold m - 1)
  /-
  Bound each exact dyadic cylinder weight by the common threshold
  factor C times its auxiliary weighted contribution.
  -/
  have hterm
      (ω : division_word)
      (hω : ω ∈ s) :
      (1 : ℝ) /
          (2 : ℝ) ^ (total_division_count ω + 1)
        ≤
          C *
            (3 / 8 : ℝ) ^ total_division_count ω := by
    /- Recover residuality and the length condition. -/
    have hmem :
        ω ∈ residual_words_at_depth m := by
      simpa only [s, Set.Finite.mem_toFinset] using hω
    change residual_word ω ∧ ω.length = m at hmem
    obtain ⟨hres, hlen⟩ := hmem
    /- Residuality supplies a uniform upper bound on the division count. -/
    have hlt :
        total_division_count ω <
          dyadic_threshold m := by
      simpa only [hlen] using
        residual_word_total_lt_threshold hres
    have hD :
        total_division_count ω ≤
          dyadic_threshold m - 1 := by
      omega
    /- Since 4/3 ≥ 1, the threshold bound transfers to its exponential factor. -/
    have hpow :
        (4 / 3 : ℝ) ^ total_division_count ω ≤
          (4 / 3 : ℝ) ^
            (dyadic_threshold m - 1) := by
      exact
        pow_le_pow_right₀
          (by norm_num)
          hD
    /- Rewrite the dyadic weight and apply the common exponent bound. -/
    calc
      (1 : ℝ) /
          (2 : ℝ) ^ (total_division_count ω + 1)
          =
          (1 / 2 : ℝ) *
            (4 / 3 : ℝ) ^ total_division_count ω *
            (3 / 8 : ℝ) ^ total_division_count ω :=
            dyadic_weight_eq_weighted _
      _ ≤
          C *
            (3 / 8 : ℝ) ^ total_division_count ω := by
            dsimp [C]
            exact
              mul_le_mul_of_nonneg_right
                (mul_le_mul_of_nonneg_left
                  hpow
                  (by norm_num))
                (by positivity)
  /- Sum the uniform per-word estimate over the finite residual level. -/
  change
    (∑ ω ∈ s,
      (1 : ℝ) /
        (2 : ℝ) ^ (total_division_count ω + 1))
      ≤
        C *
          (∑ ω ∈ s,
            (3 / 8 : ℝ) ^ total_division_count ω)
  rw [Finset.mul_sum]
  apply Finset.sum_le_sum
  intro ω hω
  exact hterm ω hω

/--
The true residual mass is trapped between zero and an explicit
depth-dependent exponential envelope.

For every positive symbolic depth `m`,

    0 ≤ residual_mass m

and

    residual_mass m
      ≤
    (1 / 2) *
      (4 / 3) ^ (dyadic_threshold m - 1) *
      (3 / 5) ^ m.

The upper bound combines the transfer estimate from the true dyadic mass to
the auxiliary weighted mass with the geometric estimate

    residual_weighted_mass m ≤ (3 / 5) ^ m.

This gives the explicit majorant that will be studied in the next section
and eventually shown to tend to zero.
-/
theorem residual_mass_squeeze_bound
    (m : ℕ)
    (hm : 1 ≤ m) :
    0 ≤ residual_mass m ∧
      residual_mass m ≤
        (1 / 2 : ℝ) *
          (4 / 3 : ℝ) ^
            (dyadic_threshold m - 1) *
          (3 / 5 : ℝ) ^ m := by
  constructor
  · exact residual_mass_nonneg m
  · calc
      residual_mass m
          ≤
          (1 / 2 : ℝ) *
            (4 / 3 : ℝ) ^
              (dyadic_threshold m - 1) *
            residual_weighted_mass m :=
            residual_mass_le_weighted_envelope m
      _ ≤
          (1 / 2 : ℝ) *
            (4 / 3 : ℝ) ^
              (dyadic_threshold m - 1) *
            (3 / 5 : ℝ) ^ m := by
            exact
              mul_le_mul_of_nonneg_left
                (residual_weighted_mass_le m hm)
                (by positivity)

/-! ## Five-Step Threshold Growth and Envelope Contraction -/

/--
The dyadic threshold grows by at most eight when the symbolic depth
is increased by five.

For every `m`,

    dyadic_threshold (m + 5)
      ≤
    dyadic_threshold m + 8.

The proof uses the canonical threshold characterization

    dyadic_threshold m ≤ k ↔ 3 ^ m < 2 ^ k.

Since

    3 ^ m < 2 ^ dyadic_threshold m

and

    3 ^ 5 < 2 ^ 8,

multiplication gives

    3 ^ (m + 5)
      <
    2 ^ (dyadic_threshold m + 8).

The least-threshold characterization then yields the desired bound.

This five-step threshold control is the arithmetic input for the uniform
contraction of the residual-mass envelope.
-/
theorem dyadic_threshold_add_five_le
    (m : ℕ) :
    dyadic_threshold (m + 5) ≤
      dyadic_threshold m + 8 := by
  /-
  Use the canonical least-threshold characterization from `Collatz.Affine`.
  It suffices to show that the exponent `dyadic_threshold m + 8`
  already dominates `3 ^ (m + 5)`.
  -/
  apply
    (dyadic_threshold_le_iff
      (m + 5)
      (dyadic_threshold m + 8)).mpr
  have hm :
      3 ^ m < 2 ^ dyadic_threshold m := by
    exact
      (dyadic_threshold_le_iff
        m
        (dyadic_threshold m)).mp le_rfl
  have hfive :
      (3 : ℕ) ^ 5 < 2 ^ 8 := by
    norm_num
  calc
    3 ^ (m + 5)
        =
      3 ^ m * 3 ^ 5 := by
        rw [pow_add]
    _ <
      2 ^ dyadic_threshold m * 2 ^ 8 := by
        gcongr
    _ =
      2 ^ (dyadic_threshold m + 8) := by
        rw [pow_add]


/--
The explicit depth-dependent upper envelope for the true residual mass.

For symbolic depth `m`,

    residual_mass_envelope m
      =
    (1 / 2) *
      (4 / 3) ^ (dyadic_threshold m - 1) *
      (3 / 5) ^ m.

At every positive depth, `residual_mass_squeeze_bound` gives

    residual_mass m ≤ residual_mass_envelope m.

The envelope combines two competing effects: growth of the threshold factor

    (4 / 3) ^ (dyadic_threshold m - 1)

and geometric decay of the weighted-mass factor

    (3 / 5) ^ m.

The remainder of this section shows that, despite the threshold growth, the
combined envelope contracts uniformly over blocks of five symbolic steps.
-/
noncomputable def residual_mass_envelope (m : ℕ) : ℝ :=
  (1 / 2 : ℝ) *
    (4 / 3 : ℝ) ^
      (dyadic_threshold m - 1) *
    (3 / 5 : ℝ) ^ m

/--
The combined five-step envelope multiplier is strictly less than one.

The threshold-growth estimate contributes at most the factor

    (4 / 3) ^ 8,

while five iterations of the weighted-mass decay contribute

    (3 / 5) ^ 5.

Their product satisfies

    (4 / 3) ^ 8 * (3 / 5) ^ 5 < 1.

Thus the geometric decay dominates the possible threshold growth over every
block of five symbolic steps.
-/
private lemma residual_mass_envelope_ratio_lt_one :
    (4 / 3 : ℝ) ^ 8 * (3 / 5 : ℝ) ^ 5 < 1 := by
  norm_num

/--
The residual-mass envelope contracts by a uniform multiplicative factor over
every block of five symbolic steps.

For every `m`,

    residual_mass_envelope (m + 5)
      ≤
    ((4 / 3) ^ 8 * (3 / 5) ^ 5) *
      residual_mass_envelope m.

The threshold estimate

    dyadic_threshold (m + 5)
      ≤
    dyadic_threshold m + 8

shows that the growing factor `(4 / 3) ^ (...)` increases by at most
`(4 / 3) ^ 8`, while five further symbolic steps contribute the decay factor
`(3 / 5) ^ 5`.

Thus the combined five-step multiplier is uniform in `m`; the preceding lemma
shows that it is strictly less than one.
-/
theorem residual_mass_envelope_add_five_le
    (m : ℕ) :
    residual_mass_envelope (m + 5) ≤
      ((4 / 3 : ℝ) ^ 8 * (3 / 5 : ℝ) ^ 5) *
        residual_mass_envelope m := by
  /-
  The five-step threshold bound increases the envelope exponent by at
  most eight.
  -/
  have hB :=
    dyadic_threshold_add_five_le m
  have hE :
      dyadic_threshold (m + 5) - 1 ≤
        (dyadic_threshold m - 1) + 8 := by
    omega
  /- Since 4/3 ≥ 1, the exponent bound transfers to the growing envelope factor. -/
  have hpow :
      (4 / 3 : ℝ) ^
          (dyadic_threshold (m + 5) - 1) ≤
        (4 / 3 : ℝ) ^
          ((dyadic_threshold m - 1) + 8) := by
    exact pow_le_pow_right₀ (by norm_num) hE
  /- Expand the five-step powers and collect the uniform multiplier. -/
  unfold residual_mass_envelope
  calc
    (1 / 2 : ℝ) *
        (4 / 3 : ℝ) ^
          (dyadic_threshold (m + 5) - 1) *
        (3 / 5 : ℝ) ^ (m + 5)
        ≤
        (1 / 2 : ℝ) *
          (4 / 3 : ℝ) ^
            ((dyadic_threshold m - 1) + 8) *
          (3 / 5 : ℝ) ^ (m + 5) := by
          exact
            mul_le_mul_of_nonneg_right
              (mul_le_mul_of_nonneg_left
                hpow
                (by norm_num))
              (by positivity)
    _ =
        ((4 / 3 : ℝ) ^ 8 * (3 / 5 : ℝ) ^ 5) *
          ((1 / 2 : ℝ) *
            (4 / 3 : ℝ) ^
              (dyadic_threshold m - 1) *
            (3 / 5 : ℝ) ^ m) := by
          simp only [pow_add]
          ring

/--
The residual-mass envelope strictly decreases over every block of five
symbolic steps.

For every `m`,

    residual_mass_envelope (m + 5)
      <
    residual_mass_envelope m.

Indeed, the previous theorem bounds the five-step ratio by the uniform factor

    (4 / 3) ^ 8 * (3 / 5) ^ 5,

which is strictly less than one, while `residual_mass_envelope m` is strictly
positive.

Thus each residue class modulo five forms a strictly decreasing subsequence
of the envelope.
-/
theorem residual_mass_envelope_add_five_lt
    (m : ℕ) :
    residual_mass_envelope (m + 5) <
      residual_mass_envelope m := by
  have hpos : 0 < residual_mass_envelope m := by
    unfold residual_mass_envelope
    positivity
  calc
    residual_mass_envelope (m + 5)
        ≤
        ((4 / 3 : ℝ) ^ 8 * (3 / 5 : ℝ) ^ 5) *
          residual_mass_envelope m :=
            residual_mass_envelope_add_five_le m
    _ < 1 * residual_mass_envelope m :=
      mul_lt_mul_of_pos_right
        residual_mass_envelope_ratio_lt_one
        hpos
    _ = residual_mass_envelope m := by
      ring

/--
Iterating the five-step contraction gives a geometric upper bound along each
residue class modulo five.

For every starting residue `r` and every `k`,

    residual_mass_envelope (r + 5 * k)
      ≤
    (((4 / 3) ^ 8 * (3 / 5) ^ 5) ^ k) *
      residual_mass_envelope r.

Thus, along the subsequence

    r, r + 5, r + 10, ...,

the envelope is bounded by a geometric sequence with common ratio

    (4 / 3) ^ 8 * (3 / 5) ^ 5,

which is strictly less than one.

This is the quantitative estimate used below to prove that each residue-class
subsequence of the envelope tends to zero.
-/
theorem residual_mass_envelope_iterate_five_le
    (r k : ℕ) :
    residual_mass_envelope (r + 5 * k) ≤
      (((4 / 3 : ℝ) ^ 8 * (3 / 5 : ℝ) ^ 5) ^ k) *
        residual_mass_envelope r := by
  induction k with
  | zero =>
      simp
  | succ k ih =>
      have hnonneg :
          0 ≤ (4 / 3 : ℝ) ^ 8 *
            (3 / 5 : ℝ) ^ 5 := by
        positivity
      /- Apply one further five-step contraction, then insert the inductive bound. -/
      calc
        residual_mass_envelope (r + 5 * (k + 1))
            =
            residual_mass_envelope ((r + 5 * k) + 5) := by
              congr 1
        _ ≤
            ((4 / 3 : ℝ) ^ 8 * (3 / 5 : ℝ) ^ 5) *
              residual_mass_envelope (r + 5 * k) :=
                residual_mass_envelope_add_five_le _
        _ ≤
            ((4 / 3 : ℝ) ^ 8 * (3 / 5 : ℝ) ^ 5) *
              ((((4 / 3 : ℝ) ^ 8 *
                  (3 / 5 : ℝ) ^ 5) ^ k) *
                residual_mass_envelope r) := by
                  exact mul_le_mul_of_nonneg_left ih hnonneg
        _ =
            (((4 / 3 : ℝ) ^ 8 *
                (3 / 5 : ℝ) ^ 5) ^ (k + 1)) *
              residual_mass_envelope r := by
                rw [pow_succ]
                ring

/-! ## Envelope Decay and Residual-Mass Collapse -/

/--
For any fixed starting depth `r`, the residual-mass envelope tends to zero
along the corresponding five-step subsequence.

More precisely,

    residual_mass_envelope (r + 5 * k) → 0

as `k → ∞`.

Writing

    q = (4 / 3) ^ 8 * (3 / 5) ^ 5,

the preceding five-step iteration theorem gives

    0 ≤ residual_mass_envelope (r + 5 * k)
      ≤ q ^ k * residual_mass_envelope r,

with `0 ≤ q < 1`. The geometric factor `q ^ k` therefore tends to zero,
and the squeeze theorem forces the envelope subsequence to do the same.

This establishes decay separately along each residue class modulo five.
-/
theorem residual_mass_envelope_subsequence_tendsto_zero
    (r : ℕ) :
    Filter.Tendsto
      (fun k : ℕ =>
        residual_mass_envelope (r + 5 * k))
      Filter.atTop
      (nhds (0 : ℝ)) := by
  let q : ℝ :=
    (4 / 3 : ℝ) ^ 8 * (3 / 5 : ℝ) ^ 5
  have hq_nonneg : 0 ≤ q := by
    dsimp [q]
    positivity
  have hq_lt : q < 1 := by
    exact residual_mass_envelope_ratio_lt_one
  /- Since 0 ≤ q < 1, the geometric factor q^k tends to zero. -/
  have hpow :
      Filter.Tendsto
        (fun k : ℕ => q ^ k)
        Filter.atTop
        (nhds (0 : ℝ)) :=
    tendsto_pow_atTop_nhds_zero_of_lt_one
      hq_nonneg hq_lt
  /- Multiplying by the fixed initial envelope preserves convergence to zero. -/
  have hupper :
      Filter.Tendsto
        (fun k : ℕ =>
          q ^ k * residual_mass_envelope r)
        Filter.atTop
        (nhds (0 : ℝ)) := by
    simpa using
      hpow.mul_const (residual_mass_envelope r)
  /- Squeeze the envelope subsequence between zero and its geometric bound. -/
  apply Filter.Tendsto.squeeze
    tendsto_const_nhds hupper
  · intro k
    unfold residual_mass_envelope
    positivity
  · intro k
    exact residual_mass_envelope_iterate_five_le r k

/--
The residual-mass envelope tends to zero over all natural symbolic depths.

More precisely,

    residual_mass_envelope m → 0

as `m → ∞`.

The preceding theorem gives convergence to zero separately along each of the
five subsequences

    r, r + 5, r + 10, ...

for `r = 0, 1, 2, 3, 4`.

Because every natural number has a unique quotient and remainder modulo five,
these five subsequences exhaust all symbolic depths. Taking a common eventual
cutoff for the five residue classes therefore upgrades the subsequential
limits to convergence of the full envelope sequence.
-/
theorem residual_mass_envelope_tendsto_zero :
    Filter.Tendsto
      residual_mass_envelope
      Filter.atTop
      (nhds (0 : ℝ)) := by
  rw [Filter.tendsto_def]
  intro s hs
  /-
  Each of the five residue-class subsequences is eventually contained
  in the chosen neighborhood of zero.
  -/
  have hsub (r : ℕ) :
      ∀ᶠ k : ℕ in Filter.atTop,
        residual_mass_envelope (r + 5 * k) ∈ s :=
    (residual_mass_envelope_subsequence_tendsto_zero r).eventually_mem hs
  /-
  Since there are only five residue classes, choose one eventual stage
  at which all five subsequences lie in the neighborhood simultaneously.
  -/
  have hall :
      ∀ᶠ k : ℕ in Filter.atTop,
        ∀ r : ℕ, r < 5 →
          residual_mass_envelope (r + 5 * k) ∈ s := by
    filter_upwards
      [hsub 0, hsub 1, hsub 2, hsub 3, hsub 4]
      with k h0 h1 h2 h3 h4
    intro r hr
    interval_cases r
    · simpa using h0
    · simpa using h1
    · simpa using h2
    · simpa using h3
    · simpa using h4
  /- Extract a common quotient cutoff for the five residue classes. -/
  obtain ⟨K, hK⟩ :=
    Filter.eventually_atTop.mp hall
  change
    ∀ᶠ n : ℕ in Filter.atTop,
      residual_mass_envelope n ∈ s
  apply Filter.eventually_atTop.mpr
  refine ⟨5 * K, ?_⟩
  intro n hn
  have hquot : K ≤ n / 5 := by
    omega
  have hrem : n % 5 < 5 := by
    omega
  /-
  Write n as its remainder plus five times its quotient and apply the
  corresponding residue-class estimate.
  -/
  have hmem :=
    hK (n / 5) hquot (n % 5) hrem
  have hrepr :
      n % 5 + 5 * (n / 5) = n := by
    omega
  simpa only [hrepr] using hmem

/--
The natural density of the residual realization set tends to zero as
symbolic depth tends to infinity.

More precisely,

    residual_mass m → 0

as `m → ∞`.

For each fixed depth `m`, `residual_mass m` is the ordinary natural density
of the starting integers whose realized division word remains residual
through depth `m`. Thus this theorem says that the density of trajectories
surviving in the residual forest to increasingly large symbolic depths
vanishes.

The proof uses the explicit envelope established above:

    0 ≤ residual_mass m ≤ residual_mass_envelope m

for every positive depth. Since `residual_mass_envelope m → 0`, the squeeze
theorem gives the result.
-/
theorem residual_mass_tendsto_zero :
    Filter.Tendsto
      residual_mass
      Filter.atTop
      (nhds (0 : ℝ)) := by
  /- Residual mass is nonnegative at every depth. -/
  have hlower :
      ∀ᶠ m : ℕ in Filter.atTop,
        (0 : ℝ) ≤ residual_mass m := by
    filter_upwards [] with m
    exact residual_mass_nonneg m
  /-  From depth one onward, residual mass lies below the envelope tending to zero. -/
  have hupper :
      ∀ᶠ m : ℕ in Filter.atTop,
        residual_mass m ≤ residual_mass_envelope m := by
    apply Filter.eventually_atTop.mpr
    refine ⟨1, ?_⟩
    intro m hm
    exact (residual_mass_squeeze_bound m hm).2
  exact Filter.Tendsto.squeeze'
    tendsto_const_nhds
    residual_mass_envelope_tendsto_zero
    hlower
    hupper

/-! ## Exhaustion by First-Contraction Mass -/

/--
The accumulated first-contraction mass converges to the entire residual mass
present at symbolic depth one.

More precisely,

    ∑ j ∈ Finset.range k,
      (residual_mass (1 + j) -
        residual_mass (1 + j + 1))
      →
    residual_mass 1

as `k → ∞`.

By the one-step density theorem from `Collatz.ResidualForest`, each difference

    residual_mass m - residual_mass (m + 1)

is the natural density of the first-contraction layer leaving the residual
forest at that refinement step. The finite telescoping identity gives

    ∑ j ∈ Finset.range k,
      (residual_mass (1 + j) -
        residual_mass (1 + j + 1))
      =
    residual_mass 1 - residual_mass (1 + k).

Since `residual_mass (1 + k) → 0`, the accumulated mass of the successive
first-contraction layers therefore converges to `residual_mass 1`.

Thus, asymptotically, all of the initial residual mass is exhausted by
first-contraction exits.
-/
theorem first_contraction_partial_mass_tendsto :
    Filter.Tendsto
      (fun k : ℕ =>
        ∑ j ∈ Finset.range k,
          (residual_mass (1 + j) -
            residual_mass (1 + j + 1)))
      Filter.atTop
      (nhds (residual_mass 1)) := by
  /- Shift residual-mass collapse from k to the depth sequence 1 + k. -/
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
  have hzero :
      Filter.Tendsto
        (fun k : ℕ => residual_mass (1 + k))
        Filter.atTop
        (nhds (0 : ℝ)) := by
    exact residual_mass_tendsto_zero.comp hshift
  /- Subtract the vanishing terminal residual mass from the fixed initial mass. -/
  have hconst :
      Filter.Tendsto
        (fun _ : ℕ => residual_mass 1)
        Filter.atTop
        (nhds (residual_mass 1)) :=
    tendsto_const_nhds
  have hdiff := hconst.sub hzero
  /-
  The finite telescoping identity identifies this difference with the
  accumulated first-contraction mass.
  -/
  simpa only [residual_mass_telescoping, sub_zero] using hdiff

end Collatz
