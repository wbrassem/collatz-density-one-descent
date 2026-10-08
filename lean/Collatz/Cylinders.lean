/-
Copyright (c) 2026 Wayne Brassem. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Wayne Brassem
-/

import Collatz.Realizability

/-!

# Dyadic Cylinders and the Geometry of Realization Classes

This module develops the dyadic-cylinder structure associated with finite
division words for the fully accelerated Collatz map.

The preceding module, `Collatz.Realizability`, proves that every admissible
division word `ω` has a unique canonical realization residue modulo

    2 ^ (total_division_count ω + 1),

and that realization of `ω` is exactly membership in that residue class.

The purpose of the present module is first to develop the arithmetic geometry
and natural density of generic residue classes modulo powers of two, and then
to specialize that theory to division-word realization classes.

The resulting realization cylinders inherit two complementary structures:

* an arithmetic dyadic-refinement structure coming from powers-of-two
  congruence classes;
* a symbolic forest structure in which division-word prefix order is exactly
  reversed cylinder containment.

The development separates naturally into five stages.

## 1. Generic Dyadic Cylinders

A dyadic cylinder is the congruence class

    dyadic_cylinder r k
      =
    {x : ℕ | x ≡ r mod 2 ^ k}.

This first stage is purely arithmetic and is independent of Collatz dynamics.

Every dyadic cylinder contains its defining residue and is therefore
nonempty. Two cylinders at the same dyadic depth are equal exactly when their
defining residues are congruent modulo that depth. When the residues are
canonical,

    r, s < 2 ^ k,

equality of the corresponding cylinders is equivalent to literal equality of
the residues, and distinct canonical residues determine disjoint cylinders.

Containment across different dyadic depths is also characterized exactly. If

    k ≤ l,

then

    dyadic_cylinder s l ⊆ dyadic_cylinder r k

if and only if

    s ≡ r mod 2 ^ k.

Consequently, if two cylinders at comparable depths intersect, the deeper
one is contained in the shallower one.

More generally, any two dyadic cylinders are either nested or disjoint.
Thus the family of all dyadic cylinders is laminar even before any symbolic
Collatz structure is imposed.

The principal results are:

* `dyadic_cylinder`;
* `dyadic_cylinder_mem_self`;
* `dyadic_cylinder_nonempty`;
* `dyadic_cylinder_eq_iff_modEq`;
* `dyadic_cylinder_eq_iff_eq_of_lt`;
* `dyadic_cylinder_disjoint_of_ne`;
* `dyadic_cylinder_subset_iff_modEq`;
* `dyadic_cylinder_intersection_implies_subset`;
* `dyadic_cylinders_nested_or_disjoint`.

## 2. Binary Refinement and Parent–Child Structure

Dyadic cylinders refine canonically when the modulus is increased by one
power of two.

The cylinder

    dyadic_cylinder r k

has two children at depth `k + 1`:

    dyadic_cylinder r (k + 1)

and

    dyadic_cylinder (r + 2 ^ k) (k + 1).

Both children lie inside the parent. They are disjoint, since their residues
differ by exactly `2 ^ k` and therefore cannot be congruent modulo
`2 ^ (k + 1)`.

For a canonical parent residue

    r < 2 ^ k,

the two children exhaust the parent:

    dyadic_cylinder r k
      =
    dyadic_cylinder r (k + 1) ∪
      dyadic_cylinder (r + 2 ^ k) (k + 1).

Together with their disjointness, this gives an exact binary decomposition of
every canonical dyadic cylinder.

Arithmetically, passing from modulus `2 ^ k` to modulus `2 ^ (k + 1)` fixes
one additional binary digit. The two possible values of that digit give
precisely the lower and upper child residues.

The principal results are:

* `dyadic_cylinder_lower_child_subset`;
* `dyadic_cylinder_upper_child_subset`;
* `dyadic_cylinder_children_disjoint`;
* `dyadic_cylinder_eq_union_children`.

## 3. Counting and Natural Density

The finite counting function

    dyadic_cylinder_count r k N

counts the natural numbers below `N` belonging to

    dyadic_cylinder r k.

Cylinder membership is periodic with period `2 ^ k`. For a canonical residue

    r < 2 ^ k,

each complete period contains exactly one member of the cylinder.

Hence, over any integer number of complete periods,

    dyadic_cylinder_count r k (q * 2 ^ k) = q.

Decomposing a general cutoff `N` into complete periods and a remainder yields
the uniform count bounds

    N / 2 ^ k
      ≤
    dyadic_cylinder_count r k N
      ≤
    N / 2 ^ k + 1.

After normalization, the discrepancy from the expected dyadic mass is bounded
by

    1 / N.

Therefore

    (dyadic_cylinder_count r k N : ℝ) / N

converges to

    (1 : ℝ) / (2 ^ k : ℝ).

Thus every canonical dyadic cylinder has ordinary natural density exactly
`2⁻ᵏ`.

The principal results are:

* `mem_dyadic_cylinder_iff`;
* `dyadic_cylinder_decidable_mem`;
* `dyadic_cylinder_count`;
* `dyadic_cylinder_periodic`;
* `dyadic_cylinder_count_one_period`;
* `dyadic_cylinder_count_mul_period`;
* `dyadic_cylinder_count_bounds`;
* `dyadic_cylinder_density_error_bound`;
* `dyadic_cylinder_has_natural_density`.

## 4. Realization Cylinders

The generic dyadic theory is next specialized to exact division-word
realization classes.

If `r` is a realization residue for a division word `ω`, then

    {x : ℕ | realizes x ω}
      =
    dyadic_cylinder
      r
      (total_division_count ω + 1).

Thus the exact arithmetic realization class obtained in
`Collatz.Realizability` is literally a dyadic cylinder.

The counting function

    realization_count ω N

counts the natural numbers below `N` that realize `ω`. It agrees exactly with
the generic dyadic-cylinder count for the canonical realization residue.

Consequently the realization class of `ω` has ordinary natural density

    (1 : ℝ) /
      (2 ^ (total_division_count ω + 1) : ℝ).

Thus the symbolic quantity `total_division_count ω` determines the exact
asymptotic mass of the corresponding realization class.

The principal results are:

* `realizes_decidable`;
* `realization_set_eq_dyadic_cylinder`;
* `realization_count`;
* `realization_count_eq_dyadic_cylinder_count`;
* `realization_cylinder_has_natural_density`.

## 5. Prefix Order and Cylinder-Forest Geometry

The final stage identifies symbolic prefix order with arithmetic containment
of realization cylinders.

For an admissible division word, passing to a proper prefix strictly decreases
the total division count. Hence a proper symbolic extension strictly increases
the dyadic depth of its realization cylinder.

The central structural theorem states that, for canonical realization
residues of words `ω` and `η`, with `ω` admissible,

    dyadic_cylinder
        rη
        (total_division_count η + 1)
      ⊆
    dyadic_cylinder
        rω
        (total_division_count ω + 1)

if and only if

    ω = η.take ω.length.

In symbolic notation,

    ω ≼ η
      ↔
    C_η ⊆ C_ω.

Thus symbolic ancestry is exactly arithmetic cylinder containment with the
order reversed.

The forward implication uses the fact that cylinder inclusion provides a
common realization and therefore forces the words to be prefix-comparable.
The possibility of a proper prefix in the wrong direction is excluded by
strict growth of total division count and the corresponding incompatibility
of the dyadic moduli.

The reverse implication follows directly from prefix-closure of realization:
every starting value realizing an extension also realizes its prefix.

It follows immediately that prefix-incomparable words have disjoint
realization cylinders. In particular, distinct division words of equal
symbolic length determine disjoint realization cylinders, even though their
dyadic depths need not be equal.

This establishes the realization-cylinder forest used by the subsequent
affine-contraction and residual-forest developments.

The principal results are:

* `total_division_count_lt_of_proper_prefix`;
* `realization_cylinder_subset_iff_prefix`;
* `realization_cylinders_disjoint_of_prefix_incomparable`;
* `realization_cylinders_disjoint_of_ne_of_length_eq`.

## Dependency flow

The main logical dependencies are:

    ┌──────────────────────────────────────────────┐
    │          Generic dyadic cylinders            │
    │                                              │
    │  dyadic_cylinder                             │
    │       ↓                                      │
    │  equality / canonical uniqueness             │
    │       ↓                                      │
    │  subset criterion                            │
    │       ↓                                      │
    │  nested-or-disjoint geometry                 │
    └──────────────────────────────────────────────┘
              │                         │
              │                         │
              ▼                         ▼
    ┌──────────────────────────┐  ┌──────────────────────────┐
    │ Binary refinement        │  │ Counting and density     │
    │                          │  │                          │
    │ lower child              │  │ periodicity              │
    │ upper child              │  │      ↓                   │
    │      ↓                   │  │ one-period count         │
    │ children disjoint        │  │      ↓                   │
    │      ↓                   │  │ multiple-period count    │
    │ parent = child ∪ child   │  │      ↓                   │
    │                          │  │ count bounds             │
    └──────────────────────────┘  │      ↓                   │
                                  │ error bound              │
                                  │      ↓                   │
                                  │ natural density          │
                                  └──────────────────────────┘
                                             │
                                             │
    Collatz.Realizability                    │
          │                                  │
          │  realization_residue             │
          │  realizes_take                   │
          │  common_realization_implies_prefix
          │  realizes_eq_of_length_eq        │
          └──────────────────┬───────────────┘
                             ▼
    ┌──────────────────────────────────────────────┐
    │            Realization cylinders             │
    │                                              │
    │ realization_set_eq_dyadic_cylinder           │
    │       ↓                                      │
    │ realization_count                            │
    │       ↓                                      │
    │ realization_count_eq_dyadic_cylinder_count   │
    │       ↓                                      │
    │ realization_cylinder_has_natural_density     │
    └──────────────────────────────────────────────┘
                             │
                             ▼
    ┌──────────────────────────────────────────────┐
    │       Prefix order and forest geometry       │
    │                                              │
    │ total_division_count_lt_of_proper_prefix     │
    │       ↓                                      │
    │ realization_cylinder_subset_iff_prefix       │
    │       ├── prefix-incomparable → disjoint     │
    │       └── distinct equal-length → disjoint   │
    └──────────────────────────────────────────────┘

The generic cylinder theory supplies the arithmetic geometry and natural
density of dyadic residue classes. The exact-realization theory identifies
division-word realization classes with those cylinders. Their combination
produces the nested, disjoint, quantitatively measured cylinder forest used
in `Collatz.AffineContraction` and the subsequent residual analysis.

-/

namespace Collatz

/-! ## Generic Dyadic Cylinders -/

/--
A dyadic cylinder is a residue class modulo a power of two.

For `r k : ℕ`,

`dyadic_cylinder r k`

is the set

`{x : ℕ | x ≡ r [MOD 2 ^ k]}`.

The parameter `r` need not be the canonical representative satisfying
`r < 2 ^ k`; later results impose that bound when uniqueness of the
representative is required.

This definition is purely arithmetic and independent of the Collatz map.
It provides the generic dyadic residue-class structure later specialized
to exact realization classes of division words.
-/
def dyadic_cylinder (r k : ℕ) : Set ℕ :=
  {x | Nat.ModEq (2 ^ k) x r}

/--
The defining residue of a dyadic cylinder belongs to that cylinder.

This is reflexivity of congruence modulo `2 ^ k`. It is used to witness
nonemptiness and to test cylinder inclusions at canonical representatives.
-/
lemma dyadic_cylinder_mem_self
    (r k : ℕ) :
    r ∈ dyadic_cylinder r k := by
  exact Nat.ModEq.refl r

/--
Every dyadic cylinder is nonempty.

Its defining residue `r` is itself a member of `dyadic_cylinder r k`, so
`r` provides an immediate witness of nonemptiness.
-/
lemma dyadic_cylinder_nonempty
    (r k : ℕ) :
    (dyadic_cylinder r k).Nonempty := by
  exact ⟨r, dyadic_cylinder_mem_self r k⟩

/--
Two dyadic cylinders at the same dyadic depth are equal exactly when their
defining residues are congruent modulo that common modulus.

More precisely,

`dyadic_cylinder r k = dyadic_cylinder s k`

if and only if

`r ≡ s [MOD 2 ^ k]`.

The forward direction tests cylinder equality at the defining residue `r`.
The reverse direction transports membership across the residue congruence.

No canonical bounds on `r` or `s` are required: different natural-number
representatives of the same residue class define the same dyadic cylinder.
-/
theorem dyadic_cylinder_eq_iff_modEq
    (r s k : ℕ) :
    dyadic_cylinder r k = dyadic_cylinder s k ↔
      Nat.ModEq (2 ^ k) r s := by
  constructor
  · intro h
    have hr :
        r ∈ dyadic_cylinder s k := by
      rw [← h]
      exact dyadic_cylinder_mem_self r k
    exact hr
  · intro hrs
    ext x
    constructor
    · intro hx
      exact hx.trans hrs
    · intro hx
      exact hx.trans hrs.symm

/--
Canonical representatives determine dyadic cylinders uniquely.

If `r` and `s` both lie in the canonical range

`r, s < 2 ^ k`,

then

`dyadic_cylinder r k = dyadic_cylinder s k`

if and only if

`r = s`.

This strengthens `dyadic_cylinder_eq_iff_modEq`: congruent residues need
not be literally equal in general, but within the canonical range modulo
`2 ^ k`, congruence reduces to equality.
-/
theorem dyadic_cylinder_eq_iff_eq_of_lt
    {r s k : ℕ}
    (hr : r < 2 ^ k)
    (hs : s < 2 ^ k) :
    dyadic_cylinder r k = dyadic_cylinder s k ↔
      r = s := by
  constructor
  · intro h
    have hrs :
        Nat.ModEq (2 ^ k) r s := by
      exact
        (dyadic_cylinder_eq_iff_modEq r s k).mp h
    change r % (2 ^ k) = s % (2 ^ k) at hrs
    rw [
      Nat.mod_eq_of_lt hr,
      Nat.mod_eq_of_lt hs
    ] at hrs
    exact hrs
  · intro h
    rw [h]

/--
Distinct canonical residue classes at the same dyadic depth are disjoint.

If `r` and `s` both lie in the canonical range modulo `2 ^ k` and
`r ≠ s`, then no natural number can belong to both
`dyadic_cylinder r k` and `dyadic_cylinder s k`.

Indeed, a common element would make `r` and `s` congruent modulo `2 ^ k`;
canonicality would then force `r = s`, contradicting the hypothesis.
-/
theorem dyadic_cylinder_disjoint_of_ne
    {r s k : ℕ}
    (hr : r < 2 ^ k)
    (hs : s < 2 ^ k)
    (hne : r ≠ s) :
    Disjoint
      (dyadic_cylinder r k)
      (dyadic_cylinder s k) := by
  rw [Set.disjoint_left]
  intro x hxr hxs
  have hrs :
      Nat.ModEq (2 ^ k) r s := by
    exact hxr.symm.trans hxs
  change r % (2 ^ k) = s % (2 ^ k) at hrs
  rw [
    Nat.mod_eq_of_lt hr,
    Nat.mod_eq_of_lt hs
  ] at hrs
  exact hne hrs

/--
A deeper dyadic cylinder is contained in a shallower one exactly when
their defining residues agree modulo the shallower modulus.

Assume `k ≤ l`. Then

`dyadic_cylinder s l ⊆ dyadic_cylinder r k`

if and only if

`s ≡ r [MOD 2 ^ k]`.

The forward direction tests the inclusion at the defining residue `s`.
For the reverse direction, congruence modulo `2 ^ l` is reduced to
congruence modulo `2 ^ k` using

`2 ^ k ∣ 2 ^ l`,

and the residue congruence `s ≡ r [MOD 2 ^ k]` then places the point in
the shallower cylinder.

This is the basic arithmetic criterion governing containment in the dyadic
cylinder hierarchy.
-/
theorem dyadic_cylinder_subset_iff_modEq
    {r s k l : ℕ}
    (hkl : k ≤ l) :
    dyadic_cylinder s l ⊆ dyadic_cylinder r k ↔
      Nat.ModEq (2 ^ k) s r := by
  constructor
  · intro hsubset
    apply hsubset
    exact dyadic_cylinder_mem_self s l
  · intro hsr x hx
    have hpow : 2 ^ k ∣ 2 ^ l := by
      exact pow_dvd_pow 2 hkl
    have hxs :
        Nat.ModEq (2 ^ k) x s := by
      exact hx.of_dvd hpow
    exact hxs.trans hsr

/--
If two dyadic cylinders intersect and one is at least as deep as the other,
then the deeper cylinder is contained in the shallower one.

Assume `k ≤ l`, so `dyadic_cylinder s l` is at least as deep as
`dyadic_cylinder r k`. If some `x` belongs to both cylinders, then reducing
the deeper congruence modulo `2 ^ k` shows that `s` and `r` are congruent
modulo `2 ^ k`.

The containment criterion `dyadic_cylinder_subset_iff_modEq` then gives

`dyadic_cylinder s l ⊆ dyadic_cylinder r k`.

Thus dyadic cylinders cannot partially overlap across comparable depths:
any nonempty intersection forces containment of the deeper cylinder in the
shallower one.
-/
theorem dyadic_cylinder_intersection_implies_subset
    {r s k l : ℕ}
    (hkl : k ≤ l)
    {x : ℕ}
    (hxr : x ∈ dyadic_cylinder r k)
    (hxs : x ∈ dyadic_cylinder s l) :
    dyadic_cylinder s l ⊆ dyadic_cylinder r k := by
  have hpow : 2 ^ k ∣ 2 ^ l := by
    exact pow_dvd_pow 2 hkl
  have hxs' :
      Nat.ModEq (2 ^ k) x s := by
    exact hxs.of_dvd hpow
  have hsr :
      Nat.ModEq (2 ^ k) s r := by
    exact hxs'.symm.trans hxr
  exact
    (dyadic_cylinder_subset_iff_modEq hkl).2 hsr

/--
Any two dyadic cylinders are nested or disjoint.

For arbitrary residues `r`, `s` and dyadic depths `k`, `l`, at least one
of the following holds:

* `dyadic_cylinder s l ⊆ dyadic_cylinder r k`;
* `dyadic_cylinder r k ⊆ dyadic_cylinder s l`;
* the two cylinders are disjoint.

The proof first compares the dyadic depths. Once the shallower and deeper
cylinders are identified, either they have a common element, in which case
`dyadic_cylinder_intersection_implies_subset` forces the deeper cylinder
into the shallower one, or they have no common element and are disjoint.

Thus dyadic cylinders never partially overlap: the family of all dyadic
cylinders is laminar.

This generic arithmetic structure is the model for the later forest
geometry of division-word realization cylinders.
-/
theorem dyadic_cylinders_nested_or_disjoint
    {r s k l : ℕ} :
    dyadic_cylinder s l ⊆ dyadic_cylinder r k ∨
    dyadic_cylinder r k ⊆ dyadic_cylinder s l ∨
    Disjoint
      (dyadic_cylinder r k)
      (dyadic_cylinder s l) := by
  /-
  Compare the dyadic depths to determine which cylinder would have to
  contain the other if they intersect.
  -/
  rcases le_total k l with hkl | hlk
  · by_cases hcommon :
        ∃ x : ℕ,
          x ∈ dyadic_cylinder r k ∧
          x ∈ dyadic_cylinder s l
    /-
    A common point forces containment of the deeper cylinder; otherwise
    the two cylinders are disjoint.
    -/
    · rcases hcommon with ⟨x, hxr, hxs⟩
      left
      exact
        dyadic_cylinder_intersection_implies_subset
          hkl hxr hxs
    · right
      right
      rw [Set.disjoint_left]
      intro x hxr hxs
      exact hcommon ⟨x, hxr, hxs⟩
  · by_cases hcommon :
        ∃ x : ℕ,
          x ∈ dyadic_cylinder r k ∧
          x ∈ dyadic_cylinder s l
    · rcases hcommon with ⟨x, hxr, hxs⟩
      right
      left
      exact
        dyadic_cylinder_intersection_implies_subset
          hlk hxs hxr
    · right
      right
      rw [Set.disjoint_left]
      intro x hxr hxs
      exact hcommon ⟨x, hxr, hxs⟩

/-! ## Binary Refinement and Parent–Child Structure -/

/--
The lower dyadic child of `dyadic_cylinder r k` is contained in its parent.

Passing from modulus `2 ^ k` to `2 ^ (k + 1)` refines the residue class
while preserving the same representative `r`. Hence

`dyadic_cylinder r (k + 1) ⊆ dyadic_cylinder r k`.

This is one half of the binary refinement of a dyadic cylinder into its two
children at the next dyadic depth.
-/
lemma dyadic_cylinder_lower_child_subset
    (r k : ℕ) :
    dyadic_cylinder r (k + 1) ⊆
      dyadic_cylinder r k := by
  apply
    (dyadic_cylinder_subset_iff_modEq
      (r := r) (s := r)
      (k := k) (l := k + 1)
      (by omega)).2
  exact Nat.ModEq.refl r

/--
The upper dyadic child of `dyadic_cylinder r k` is also contained in its
parent.

At depth `k + 1`, the residue

`r + 2 ^ k`

is congruent to `r` modulo `2 ^ k`. Therefore

`dyadic_cylinder (r + 2 ^ k) (k + 1) ⊆ dyadic_cylinder r k`.

Together with `dyadic_cylinder_lower_child_subset`, this identifies the
lower and upper binary refinements of a dyadic cylinder at the next depth.
-/
lemma dyadic_cylinder_upper_child_subset
    (r k : ℕ) :
    dyadic_cylinder (r + 2 ^ k) (k + 1) ⊆
      dyadic_cylinder r k := by
  apply
    (dyadic_cylinder_subset_iff_modEq
      (r := r) (s := r + 2 ^ k)
      (k := k) (l := k + 1)
      (by omega)).2
  simp [Nat.ModEq]

/--
The lower and upper dyadic children of a cylinder are disjoint.

The two children of `dyadic_cylinder r k` at depth `k + 1` are

`dyadic_cylinder r (k + 1)`

and

`dyadic_cylinder (r + 2 ^ k) (k + 1)`.

If a natural number belonged to both, their defining residues would be
congruent modulo `2 ^ (k + 1)`. Cancelling the common term `r` would give

`0 ≡ 2 ^ k [MOD 2 ^ (k + 1)]`,

equivalently,

`2 ^ (k + 1) ∣ 2 ^ k`.

But `2 ^ (k + 1)` is strictly larger than the positive number `2 ^ k`,
so this divisibility is impossible.

Thus the two binary refinements of a dyadic cylinder have no common points.
-/
theorem dyadic_cylinder_children_disjoint
    (r k : ℕ) :
    Disjoint
      (dyadic_cylinder r (k + 1))
      (dyadic_cylinder (r + 2 ^ k) (k + 1)) := by
  rw [Set.disjoint_left]
  intro x hxr hxs
  /-
  A common point makes the two child residues congruent; cancelling
  their common term `r` leaves `2 ^ k ≡ 0` modulo `2 ^ (k + 1)`.
  -/
  have hrs :
      Nat.ModEq (2 ^ (k + 1)) r (r + 2 ^ k) := by
    exact hxr.symm.trans hxs
  have hzero :
      Nat.ModEq (2 ^ (k + 1)) 0 (2 ^ k) := by
    apply Nat.ModEq.add_left_cancel' r
    simpa using hrs
  have hdvd :
      2 ^ (k + 1) ∣ 2 ^ k := by
    exact (Nat.modEq_zero_iff_dvd).mp hzero.symm
  /-
  Divisibility would force the larger positive power `2 ^ (k + 1)`
  to be at most `2 ^ k`, giving the contradiction.
  -/
  have hpos : 0 < 2 ^ k := by
    positivity
  have hle :
      2 ^ (k + 1) ≤ 2 ^ k := by
    exact Nat.le_of_dvd hpos hdvd
  rw [pow_succ] at hle
  omega

/--
A canonical dyadic cylinder is exactly the union of its lower and upper
children.

If `r < 2 ^ k`, then

`dyadic_cylinder r k`

splits at the next dyadic depth into

`dyadic_cylinder r (k + 1)`

and

`dyadic_cylinder (r + 2 ^ k) (k + 1)`.

Thus

`dyadic_cylinder r k =
  dyadic_cylinder r (k + 1) ∪
  dyadic_cylinder (r + 2 ^ k) (k + 1)`.

Arithmetically, fixing a residue modulo `2 ^ k` fixes the lower `k`
binary digits. Passing to modulus `2 ^ (k + 1)` introduces one additional
binary digit, which is either `0` or `1`; these two possibilities give
exactly the lower and upper child residues `r` and `r + 2 ^ k`.

Together with `dyadic_cylinder_children_disjoint`, this gives a disjoint
binary decomposition of every canonical dyadic cylinder at the next depth.
-/
theorem dyadic_cylinder_eq_union_children
    {r k : ℕ}
    (hr : r < 2 ^ k) :
    dyadic_cylinder r k =
      dyadic_cylinder r (k + 1) ∪
      dyadic_cylinder (r + 2 ^ k) (k + 1) := by
  ext x
  constructor
  · intro hx
    /-
    Membership in the parent fixes the canonical remainder of `x`
    modulo `2 ^ k` to be `r`.
    -/
    have hxmod :
        x % (2 ^ k) = r := by
      change x % (2 ^ k) = r % (2 ^ k) at hx
      simpa [Nat.mod_eq_of_lt hr] using hx
    have hrdeep :
        r < 2 ^ (k + 1) := by
      rw [pow_succ]
      omega
    have hotherdeep :
        r + 2 ^ k < 2 ^ (k + 1) := by
      rw [pow_succ]
      omega
    /-
    The next binary digit is `(x / 2 ^ k) % 2`; according as it is
    `0` or `1`, `x` belongs to the lower or upper child.
    -/
    rcases Nat.mod_two_eq_zero_or_one (x / (2 ^ k)) with hzero | hone
    · left
      change Nat.ModEq (2 ^ (k + 1)) x r
      change x % (2 ^ (k + 1)) = r % (2 ^ (k + 1))
      calc
        x % (2 ^ (k + 1))
            = x % (2 ^ k) +
                2 ^ k * (x / (2 ^ k) % 2) := by
                  exact Nat.mod_pow_succ
        _ = r := by
              rw [hxmod, hzero]
              simp
        _ = r % (2 ^ (k + 1)) := by
              symm
              exact Nat.mod_eq_of_lt hrdeep
    · right
      change Nat.ModEq
        (2 ^ (k + 1))
        x
        (r + 2 ^ k)
      change
        x % (2 ^ (k + 1)) =
          (r + 2 ^ k) % (2 ^ (k + 1))
      calc
        x % (2 ^ (k + 1))
            = x % (2 ^ k) +
                2 ^ k * (x / (2 ^ k) % 2) := by
                  exact Nat.mod_pow_succ
        _ = r + 2 ^ k := by
              rw [hxmod, hone]
              simp
        _ = (r + 2 ^ k) % (2 ^ (k + 1)) := by
              symm
              exact Nat.mod_eq_of_lt hotherdeep
  /- Both children were already shown to lie inside the parent. -/
  · intro hx
    rcases hx with hx | hx
    · exact dyadic_cylinder_lower_child_subset r k hx
    · exact dyadic_cylinder_upper_child_subset r k hx

/-! ## Counting and Natural Density -/

/--
Membership in a dyadic cylinder is exactly congruence modulo its defining
power of two.

This lemma is marked `[simp]`, so simplification can replace

`x ∈ dyadic_cylinder r k`

with

`Nat.ModEq (2 ^ k) x r`.

The equivalence is definitional, but registering it with the simplifier
makes the arithmetic content of cylinder membership directly available in
the counting and density arguments that follow.
-/
@[simp]
lemma mem_dyadic_cylinder_iff
    {x r k : ℕ} :
    x ∈ dyadic_cylinder r k ↔
      Nat.ModEq (2 ^ k) x r := by
  rfl

/--
Membership in a dyadic cylinder is decidable.

Since membership is the congruence condition

`Nat.ModEq (2 ^ k) x r`,

Lean can decide whether any natural number `x` belongs to
`dyadic_cylinder r k`.

This instance supports the finite counting development below, where
`Nat.count` evaluates the cylinder-membership predicate over initial
segments of the natural numbers.
-/
instance dyadic_cylinder_decidable_mem
    (r k : ℕ) :
    DecidablePred (fun x : ℕ => x ∈ dyadic_cylinder r k) := by
  intro x
  unfold dyadic_cylinder
  infer_instance

/--
`dyadic_cylinder_count r k N` counts the natural numbers `x < N`
belonging to `dyadic_cylinder r k`.

Equivalently, it counts

`#{x ∈ ℕ : x < N and x ≡ r mod 2 ^ k}`.

Cylinder membership is the congruence condition recorded by
`mem_dyadic_cylinder_iff`.

This finite counting function is the arithmetic quantity whose normalized
limit gives the natural density, and hence the asymptotic mass, of a
dyadic cylinder.
-/
def dyadic_cylinder_count
    (r k N : ℕ) : ℕ :=
  Nat.count
    (fun x : ℕ => x ∈ dyadic_cylinder r k)
    N

/--
Membership in a dyadic cylinder is periodic with period `2 ^ k`.

For fixed `r` and `k`, the predicate

`x ∈ dyadic_cylinder r k`

is unchanged when `x` is increased by one full modulus `2 ^ k`.

This periodicity is the key input for the exact counting results that
follow: every complete block of length `2 ^ k` contains the same number
of cylinder elements.
-/
lemma dyadic_cylinder_periodic
    (r k : ℕ) :
    Function.Periodic
      (fun x : ℕ => x ∈ dyadic_cylinder r k)
      (2 ^ k) := by
  intro x
  apply propext
  simp [dyadic_cylinder, Nat.ModEq]

/--
A canonical dyadic cylinder contains exactly one element in a complete
period of length `2 ^ k`.

If `r < 2 ^ k`, then among the natural numbers

`0, 1, ..., 2 ^ k - 1`

the only member of `dyadic_cylinder r k` is `r` itself. Hence

`dyadic_cylinder_count r k (2 ^ k) = 1`.

This is the basic counting fact behind the natural-density computation:
every full period contributes exactly one point to the cylinder.
-/
lemma dyadic_cylinder_count_one_period
    {r k : ℕ}
    (hr : r < 2 ^ k) :
    dyadic_cylinder_count r k (2 ^ k) = 1 := by
  unfold dyadic_cylinder_count
  rw [Nat.count_eq_card_filter_range]
  /-
  Within one canonical period, congruence modulo `2 ^ k` to `r`
  is equivalent to literal equality with `r`.
  -/
  have hfilter :
      {x ∈ Finset.range (2 ^ k) |
        x ∈ dyadic_cylinder r k} = {r} := by
    ext x
    simp only [
      Finset.mem_filter,
      Finset.mem_range,
      Finset.mem_singleton
    ]
    constructor
    · intro hx
      rcases hx with ⟨hxlt, hxcyl⟩
      have hmod :
          Nat.ModEq (2 ^ k) x r := by
        exact hxcyl
      change x % (2 ^ k) = r % (2 ^ k) at hmod
      rw [
        Nat.mod_eq_of_lt hxlt,
        Nat.mod_eq_of_lt hr
      ] at hmod
      exact hmod
    · intro hxr
      subst x
      constructor
      · exact hr
      · exact dyadic_cylinder_mem_self r k
  rw [hfilter]
  simp

/--
A canonical dyadic cylinder contains exactly one element in each complete
period of length `2 ^ k`.

Therefore, among the first

`q * 2 ^ k`

natural numbers, the cylinder contains exactly `q` elements:

`dyadic_cylinder_count r k (q * 2 ^ k) = q`.

The proof is by induction on the number of complete periods. Periodicity
shows that each additional block of length `2 ^ k` has the same membership
pattern as the first, while `dyadic_cylinder_count_one_period` shows that
each such block contributes exactly one element.
-/
theorem dyadic_cylinder_count_mul_period
    {r k : ℕ}
    (hr : r < 2 ^ k)
    (q : ℕ) :
    dyadic_cylinder_count r k
      (q * 2 ^ k) = q := by
  induction q with
  | zero =>
      simp [dyadic_cylinder_count]
  | succ q ih =>
      /-
      Shifting by `q` complete periods preserves cylinder membership,
      since `q * 2 ^ k` is itself a period.
      -/
      have hperiod :
          Function.Periodic
            (fun x : ℕ => x ∈ dyadic_cylinder r k)
            (q * 2 ^ k) := by
        exact
          (dyadic_cylinder_periodic r k).nat_mul q
      have hshift :
          (fun x : ℕ =>
            (q * 2 ^ k + x) ∈ dyadic_cylinder r k)
          =
          (fun x : ℕ =>
            x ∈ dyadic_cylinder r k) := by
        funext x
        rw [Nat.add_comm]
        exact hperiod x
      /-
      Split the first `q + 1` complete periods into the first `q`
      periods and one final block of length `2 ^ k`.
      -/
      change
        Nat.count
          (fun x : ℕ => x ∈ dyadic_cylinder r k)
          ((q + 1) * 2 ^ k) = q + 1
      rw [Nat.succ_mul]
      rw [Nat.count_add]
      simp only [hshift]
      change
        dyadic_cylinder_count r k (q * 2 ^ k) +
        dyadic_cylinder_count r k (2 ^ k) =
        q + 1
      rw [ih]
      rw [dyadic_cylinder_count_one_period hr]

/--
The number of points of a canonical dyadic cylinder below `N` differs from
the complete-period quotient `N / 2 ^ k` by at most one.

If `r < 2 ^ k`, then

`N / 2 ^ k ≤ dyadic_cylinder_count r k N`

and

`dyadic_cylinder_count r k N ≤ N / 2 ^ k + 1`.

The proof compares `[0, N)` with complete blocks of length `2 ^ k`.
The endpoint

`(N / 2 ^ k) * 2 ^ k`

lies below `N`, while `N` lies below

`(N / 2 ^ k + 1) * 2 ^ k`.

Monotonicity of `Nat.count`, together with
`dyadic_cylinder_count_mul_period`, therefore gives the lower and upper
bounds respectively.

Thus an arbitrary initial segment differs from its complete-period count
by at most one point. This is the key estimate underlying the subsequent
density error bound.
-/
theorem dyadic_cylinder_count_bounds
    {r k N : ℕ}
    (hr : r < 2 ^ k) :
    N / (2 ^ k) ≤
      dyadic_cylinder_count r k N ∧
    dyadic_cylinder_count r k N ≤
      N / (2 ^ k) + 1 := by
  /-
  Euclidean division places `N` between the endpoint of its last
  complete period and the endpoint of the next complete period.
  -/
  have hp : 0 < 2 ^ k := by
    positivity
  have hlower :
      (N / (2 ^ k)) * (2 ^ k) ≤ N := by
    exact Nat.div_mul_le_self N (2 ^ k)
  have hdecomp :
      (N / (2 ^ k)) * (2 ^ k) +
        N % (2 ^ k) = N := by
    simpa [Nat.mul_comm] using
      Nat.div_add_mod N (2 ^ k)
  have hrem :
      N % (2 ^ k) < 2 ^ k := by
    exact Nat.mod_lt N hp
  have hupper :
      N ≤ (N / (2 ^ k) + 1) * (2 ^ k) := by
    rw [Nat.add_mul]
    omega
  constructor
  /-
  Monotonicity against the last complete-period endpoint gives the
  lower bound, whose count is known exactly.
  -/
  · have hcount :
        dyadic_cylinder_count r k
            ((N / (2 ^ k)) * (2 ^ k)) ≤
          dyadic_cylinder_count r k N := by
      unfold dyadic_cylinder_count
      exact
        Nat.count_monotone
          (fun x : ℕ => x ∈ dyadic_cylinder r k)
          hlower
    rw [
      dyadic_cylinder_count_mul_period
        hr (N / (2 ^ k))
    ] at hcount
    exact hcount
  /-
  Enlarging to the next complete-period endpoint gives the corresponding
  upper bound.
  -/
  · have hcount :
        dyadic_cylinder_count r k N ≤
          dyadic_cylinder_count r k
            ((N / (2 ^ k) + 1) * (2 ^ k)) := by
      unfold dyadic_cylinder_count
      exact
        Nat.count_monotone
          (fun x : ℕ => x ∈ dyadic_cylinder r k)
          hupper
    rw [
      dyadic_cylinder_count_mul_period
        hr (N / (2 ^ k) + 1)
    ] at hcount
    exact hcount

/--
The normalized counting density of a canonical dyadic cylinder differs from
its limiting density `1 / 2 ^ k` by at most `1 / N`.

For `N > 0` and `r < 2 ^ k`,

`|dyadic_cylinder_count r k N / N - 1 / 2 ^ k| ≤ 1 / N`.

This is the quantitative estimate underlying
`dyadic_cylinder_has_natural_density`.

The counting bounds give

`N / 2 ^ k ≤ count ≤ N / 2 ^ k + 1`.

Rather than casting natural-number division directly into `ℝ`, the proof
first converts these inequalities into the cross-multiplied natural-number
bounds

`N ≤ (count + 1) * 2 ^ k`

and

`count * 2 ^ k ≤ N + 2 ^ k`.

These cast cleanly to `ℝ`. Dividing by the positive quantities `N` and
`2 ^ k` then yields

`1 / 2 ^ k - 1 / N ≤ count / N`

and

`count / N ≤ 1 / 2 ^ k + 1 / N`.

Together these are exactly the required absolute-value estimate.

The error bound is uniform in the residue `r` and tends to zero at the
explicit rate `1 / N`.
-/
lemma dyadic_cylinder_density_error_bound
    {r k N : ℕ}
    (hr : r < 2 ^ k)
    (hN : 0 < N) :
    abs (
      (dyadic_cylinder_count r k N : ℝ) / N
        - (1 : ℝ) / (2 ^ k : ℝ)
    )
      ≤ (1 : ℝ) / N := by
  /-
  Begin with the integer counting bounds and the quotient-remainder
  geometry of `N` relative to the period `2 ^ k`.
  -/
  have hbounds :=
    dyadic_cylinder_count_bounds
      (r := r) (k := k) (N := N) hr
  have hp : 0 < 2 ^ k := by
    positivity
  have hlower :
      (N / (2 ^ k)) * (2 ^ k) ≤ N := by
    exact Nat.div_mul_le_self N (2 ^ k)
  have hdecomp :
      (N / (2 ^ k)) * (2 ^ k) +
        N % (2 ^ k) = N := by
    simpa [Nat.mul_comm] using
      Nat.div_add_mod N (2 ^ k)
  have hrem :
      N % (2 ^ k) < 2 ^ k := by
    exact Nat.mod_lt N hp
  have hupper :
      N ≤ (N / (2 ^ k) + 1) * (2 ^ k) := by
    rw [Nat.add_mul]
    omega
  /-
  Eliminate natural-number division by converting the counting bounds
  into cross-multiplied inequalities over `ℕ`.
  -/
  have hleft_nat :
      N ≤
        (dyadic_cylinder_count r k N + 1) *
          (2 ^ k) := by
    have hq :
        N / (2 ^ k) + 1 ≤
          dyadic_cylinder_count r k N + 1 := by
      exact Nat.add_le_add_right hbounds.1 1
    exact
      le_trans hupper
        (Nat.mul_le_mul_right (2 ^ k) hq)
  have hright_nat :
      dyadic_cylinder_count r k N * (2 ^ k) ≤
        N + 2 ^ k := by
    have h₁ :
        dyadic_cylinder_count r k N * (2 ^ k) ≤
          (N / (2 ^ k) + 1) * (2 ^ k) := by
      exact
        Nat.mul_le_mul_right
          (2 ^ k) hbounds.2
    have h₂ :
        (N / (2 ^ k) + 1) * (2 ^ k) ≤
          N + 2 ^ k := by
      simpa [Nat.add_mul] using
        Nat.add_le_add_right hlower (2 ^ k)
    exact le_trans h₁ h₂
  /-
  Cast only the cross-multiplied inequalities to `ℝ`; this avoids
  reasoning about casts of natural-number division.
  -/
  have hleft_real :
      (N : ℝ) ≤
        ((dyadic_cylinder_count r k N : ℝ) + 1) *
          (2 ^ k : ℝ) := by
    exact_mod_cast hleft_nat
  have hright_real :
      (dyadic_cylinder_count r k N : ℝ) *
          (2 ^ k : ℝ) ≤
        (N : ℝ) + (2 ^ k : ℝ) := by
    exact_mod_cast hright_nat
  have hNreal : (0 : ℝ) < (N : ℝ) := by
    exact_mod_cast hN
  have hpreal : (0 : ℝ) < (2 ^ k : ℝ) := by
    positivity
  /-
  Divide the real inequalities by the positive denominators to obtain
  the two one-sided density estimates.
  -/
  have hfrac_lower :
      (1 : ℝ) / (2 ^ k : ℝ) ≤
        ((dyadic_cylinder_count r k N : ℝ) + 1) /
          (N : ℝ) := by
    rw [div_le_div_iff₀ hpreal hNreal]
    simpa using hleft_real
  have hcount_upper :
      (dyadic_cylinder_count r k N : ℝ) ≤
        ((N : ℝ) + (2 ^ k : ℝ)) /
          (2 ^ k : ℝ) := by
    apply (le_div_iff₀ hpreal).2
    exact hright_real
  have hfrac_upper :
      (dyadic_cylinder_count r k N : ℝ) / (N : ℝ) ≤
        (1 : ℝ) / (2 ^ k : ℝ) +
          (1 : ℝ) / (N : ℝ) := by
    calc
      (dyadic_cylinder_count r k N : ℝ) / (N : ℝ)
          ≤
        (((N : ℝ) + (2 ^ k : ℝ)) /
            (2 ^ k : ℝ)) / (N : ℝ) := by
              exact
                div_le_div_of_nonneg_right
                  hcount_upper
                  (le_of_lt hNreal)
      _ =
        (1 : ℝ) / (2 ^ k : ℝ) +
          (1 : ℝ) / (N : ℝ) := by
            field_simp [
              ne_of_gt hNreal,
              ne_of_gt hpreal
            ]
  /-
  The one-sided estimates are exactly the lower and upper inequalities
  obtained by expanding the absolute-value bound.
  -/
  rw [abs_le]
  constructor
  · have hsplit :
        ((dyadic_cylinder_count r k N : ℝ) + 1) /
            (N : ℝ)
          =
        (dyadic_cylinder_count r k N : ℝ) / (N : ℝ) +
          (1 : ℝ) / (N : ℝ) := by
      ring
    rw [hsplit] at hfrac_lower
    linarith
  · linarith

/--
A canonical dyadic cylinder has ordinary natural density `1 / 2 ^ k`.

More precisely, if `r < 2 ^ k`, then

`dyadic_cylinder_count r k N / N`

converges as `N → ∞` to

`1 / 2 ^ k`.

The proof uses `dyadic_cylinder_density_error_bound`, which gives the
explicit estimate

`|count / N - 1 / 2 ^ k| ≤ 1 / N`

for every positive `N`. Since `1 / N → 0`, the difference between the
normalized cylinder count and `1 / 2 ^ k` tends to zero. Adding back the
constant limiting value gives the desired convergence.

Thus every canonical residue class modulo `2 ^ k` has ordinary natural
density exactly `1 / 2 ^ k`.
-/
theorem dyadic_cylinder_has_natural_density
    {r k : ℕ}
    (hr : r < 2 ^ k) :
    Filter.Tendsto
      (fun N : ℕ =>
        (dyadic_cylinder_count r k N : ℝ) / N)
      Filter.atTop
      (nhds ((1 : ℝ) / (2 ^ k : ℝ))) := by
  /-
  The quantitative error estimate squeezes the difference from the
  proposed density to zero.
  -/
  have herr :
      Filter.Tendsto
        (fun N : ℕ =>
          (dyadic_cylinder_count r k N : ℝ) / N
            - (1 : ℝ) / (2 ^ k : ℝ))
        Filter.atTop
        (nhds 0) := by
    apply squeeze_zero_norm'
    · filter_upwards [Filter.eventually_gt_atTop (0 : ℕ)] with N hN
      simpa [Real.norm_eq_abs] using
        dyadic_cylinder_density_error_bound
          (r := r) (k := k) hr hN
    · simpa using
        (tendsto_const_div_atTop_nhds_zero_nat (1 : ℝ))
  /- The proposed limiting density is a constant sequence. -/
  have hconst :
      Filter.Tendsto
        (fun _ : ℕ => (1 : ℝ) / (2 ^ k : ℝ))
        Filter.atTop
        (nhds ((1 : ℝ) / (2 ^ k : ℝ))) :=
    tendsto_const_nhds
  /- Add the limiting density back to the vanishing error term. -/
  have hadd := herr.add hconst
  simpa [sub_add_cancel] using hadd

/-! ## Realization Cylinders -/

/--
Realization of a fixed division word is decidable.

For a division word `ω` and natural number `x`, Lean can decide whether

`realizes x ω`.

This instance provides the finite computational infrastructure needed to
count realizations of `ω` over initial segments of the natural numbers.
-/
instance realizes_decidable
    (ω : division_word) :
    DecidablePred (fun x : ℕ => realizes x ω) := by
  intro x
  unfold realizes
  infer_instance

/--
The realization set of a division word is exactly its dyadic residue
cylinder.

If `r` is a realization residue for `ω`, then the natural numbers realizing
`ω` are precisely those congruent to `r` modulo

`2 ^ (total_division_count ω + 1)`.

Equivalently,

`{x : ℕ | realizes x ω}`

is exactly

`dyadic_cylinder r (total_division_count ω + 1)`.

This theorem is the bridge from the exact realizability theory developed in
`Collatz.Realizability` to the generic dyadic-cylinder geometry and density
theory developed above. It allows the corresponding arithmetic and density
results for dyadic cylinders to be transferred directly to realization
classes.
-/
theorem realization_set_eq_dyadic_cylinder
    {ω : division_word}
    {r : ℕ}
    (hr : realization_residue ω r) :
    {x : ℕ | realizes x ω} =
      dyadic_cylinder r (total_division_count ω + 1) := by
  ext x
  rcases hr with ⟨_, hrclass⟩
  exact hrclass x

/--
`realization_count ω N` counts the natural numbers `x < N` that realize
the division word `ω`.

Equivalently, it counts

`#{x ∈ ℕ : x < N and realizes x ω}`.

Via `realization_set_eq_dyadic_cylinder`, this is exactly the finite count
of the dyadic realization cylinder associated with `ω`.

Its normalized limit is therefore the ordinary natural density of the
realization class.
-/
def realization_count
    (ω : division_word)
    (N : ℕ) : ℕ :=
  Nat.count (fun x : ℕ => realizes x ω) N

/--
The realization count of a division word is exactly the count of its
associated dyadic cylinder.

If `r` is a realization residue for `ω`, then for every cutoff `N`,

`realization_count ω N`

equals

`dyadic_cylinder_count r (total_division_count ω + 1) N`.

The proof identifies the realization predicate with membership in the
associated dyadic cylinder and transports that equality through `Nat.count`.

This is the counting-level bridge from realization theory to the generic
dyadic-cylinder density machinery.
-/
theorem realization_count_eq_dyadic_cylinder_count
    {ω : division_word}
    {r N : ℕ}
    (hr : realization_residue ω r) :
    realization_count ω N =
      dyadic_cylinder_count
        r
        (total_division_count ω + 1)
        N := by
  have hpred :
      (fun x : ℕ => realizes x ω) =
      (fun x : ℕ =>
        x ∈ dyadic_cylinder
          r
          (total_division_count ω + 1)) := by
    funext x
    apply propext
    change
      x ∈ {x : ℕ | realizes x ω} ↔
      x ∈ dyadic_cylinder
        r
        (total_division_count ω + 1)
    rw [
      realization_set_eq_dyadic_cylinder
        (ω := ω) (r := r) hr
    ]
  unfold realization_count
  unfold dyadic_cylinder_count
  simp only [hpred]

/--
The realization cylinder of a division word has ordinary natural density

`1 / 2 ^ (total_division_count ω + 1)`.

If `r` is a realization residue of `ω`, then the realization set of `ω`
is the dyadic cylinder

`dyadic_cylinder r (total_division_count ω + 1)`.

Therefore its normalized counting function

`realization_count ω N / N`

converges to

`1 / 2 ^ (total_division_count ω + 1)`.

The proof transports `realization_count` to the corresponding
`dyadic_cylinder_count` using
`realization_count_eq_dyadic_cylinder_count`, then applies the generic
natural-density theorem. The canonical bound contained in
`realization_residue` supplies exactly the hypothesis required there.

Thus every exact finite division-word realization class has ordinary
natural density determined explicitly by its total division count.
-/
theorem realization_cylinder_has_natural_density
    {ω : division_word}
    {r : ℕ}
    (hr : realization_residue ω r) :
    Filter.Tendsto
      (fun N : ℕ =>
        (realization_count ω N : ℝ) / N)
      Filter.atTop
      (nhds
        ((1 : ℝ) /
          (2 ^ (total_division_count ω + 1) : ℝ))) := by
  /-
  Identify the realization count with the count of its exact dyadic
  cylinder, then apply the generic cylinder-density theorem.
  -/
  rw [show
    (fun N : ℕ => (realization_count ω N : ℝ) / N) =
    (fun N : ℕ =>
      (dyadic_cylinder_count
        r
        (total_division_count ω + 1)
        N : ℝ) / N) by
      funext N
      rw [realization_count_eq_dyadic_cylinder_count hr]]
  exact
    dyadic_cylinder_has_natural_density
      hr.1

/-! ## Prefix Order and Cylinder-Forest Geometry -/

/--
A proper prefix of an admissible division word has strictly smaller total
division count.

Assume `η` is a prefix of `ω`, expressed by

`η = ω.take η.length`,

and that the prefix is proper, so `η ≠ ω`. Since `ω` is admissible, every
division count occurring in `ω` is positive. The omitted suffix

`ω.drop η.length`

is therefore nonempty and has strictly positive sum.

Using

`ω = ω.take η.length ++ ω.drop η.length`

and the prefix identity gives

`total_division_count ω =
  total_division_count η + (ω.drop η.length).sum`.

Hence

`total_division_count η < total_division_count ω`.

This strict increase in total division count is used later to distinguish
the dyadic depths of realization cylinders associated with proper symbolic
extensions.

Only the longer word `ω` must be admissible: admissibility is used to ensure
positivity of the division counts in the omitted suffix.
-/
lemma total_division_count_lt_of_proper_prefix
    {ω η : division_word}
    (hω : admissible_division_word ω)
    (hprefix : η = ω.take η.length)
    (hne : η ≠ ω) :
    total_division_count η <
      total_division_count ω := by
  /-
  Properness makes `η` strictly shorter than `ω`, so the omitted suffix
  is nonempty.
  -/
  have htake_ne :
      ω.take η.length ≠ ω := by
    intro h
    apply hne
    calc
      η = ω.take η.length := hprefix
      _ = ω := h
  have hlen_lt :
      η.length < ω.length := by
    exact List.lt_length_of_take_ne_self htake_ne
  have hdrop_len_pos :
      0 < (ω.drop η.length).length := by
    rw [List.length_drop]
    omega
  /-
  Admissibility makes every entry of the omitted suffix positive, hence
  its total division count is strictly positive.
  -/
  have hdrop_pos :
      ∀ d ∈ ω.drop η.length, 1 ≤ d := by
    intro d hd
    apply hω.2 d
    exact List.mem_of_mem_drop hd
  have hdrop_len_le_sum :
      (ω.drop η.length).length ≤
        (ω.drop η.length).sum := by
    exact
      division_word_length_le_sum_of_pos
        (ω.drop η.length)
        hdrop_pos
  have hdrop_sum_pos :
      0 < (ω.drop η.length).sum := by
    exact lt_of_lt_of_le
      hdrop_len_pos
      hdrop_len_le_sum
  unfold total_division_count
  /-
  Decompose the full sum into the prefix sum and the strictly positive
  suffix sum.
  -/
  have hsum_eta :
      η.sum = (ω.take η.length).sum := by
    exact congrArg List.sum hprefix
  have hsum :
      η.sum + (ω.drop η.length).sum =
        ω.sum := by
    calc
      η.sum + (ω.drop η.length).sum
          =
        (ω.take η.length).sum +
          (ω.drop η.length).sum := by
            rw [hsum_eta]
      _ =
        (ω.take η.length ++
          ω.drop η.length).sum := by
            rw [List.sum_append]
      _ = ω.sum := by
        rw [List.take_append_drop]
  omega

/--
Realization-cylinder containment is equivalent to symbolic prefix order.

Let `rω` and `rη` be realization residues for division words `ω` and `η`.
Assuming `ω` is admissible, the realization cylinder of `η` is contained
in that of `ω` exactly when `ω` is the prefix of `η` of length `ω.length`:

`dyadic_cylinder rη (total_division_count η + 1) ⊆
    dyadic_cylinder rω (total_division_count ω + 1)`

if and only if

`ω = η.take ω.length`.

Thus symbolic extension reverses the inclusion order of realization
cylinders:

`ω ≼ η  ↔  C_η ⊆ C_ω`.

For the forward implication, cylinder inclusion makes the canonical residue
`rη` a common realization of `η` and `ω`.
`common_realization_implies_prefix` therefore gives two possibilities:
either `ω` is a prefix of `η`, which is the desired conclusion, or `η` is
a prefix of `ω`.

In the reverse-prefix case, equality is harmless. If the prefix is proper,
`total_division_count_lt_of_proper_prefix` gives

`total_division_count η < total_division_count ω`.

The assumed cylinder inclusion then yields a contradiction. Shifting `rη`
by one complete `η`-cylinder period,

`2 ^ (total_division_count η + 1)`,

produces another point of the `η` cylinder and therefore, by inclusion,
another point of the `ω` cylinder. Hence the `ω` modulus would divide one
complete `η` period:

`2 ^ (total_division_count ω + 1) ∣
    2 ^ (total_division_count η + 1)`.

But the strict division-count inequality makes the `ω` modulus at least
twice as large as the `η` modulus, which is impossible.

For the reverse implication, if `ω` is a prefix of `η`, every realization
of `η` realizes that prefix by `realizes_take`, and therefore belongs to
the realization cylinder of `ω`.

This theorem formally identifies symbolic ancestry with arithmetic cylinder
containment and is the central structural result underlying the
realization-cylinder forest.

Only `ω` must be admissible. Admissibility is used through
`total_division_count_lt_of_proper_prefix` to ensure strict growth of total
division count along a proper symbolic extension.
-/
theorem realization_cylinder_subset_iff_prefix
    {ω η : division_word}
    {rω rη : ℕ}
    (hrω : realization_residue ω rω)
    (hrη : realization_residue η rη)
    (hω : admissible_division_word ω) :
    dyadic_cylinder rη (total_division_count η + 1) ⊆
      dyadic_cylinder rω (total_division_count ω + 1) ↔
      ω = η.take ω.length := by
  constructor
  · intro hsubset
    /-
    Test the inclusion at `rη`. This gives a concrete point in both
    realization cylinders and hence a common realization of the two words.
    -/
    have hrη_mem_eta :
        rη ∈
          dyadic_cylinder
            rη
            (total_division_count η + 1) := by
      exact
        dyadic_cylinder_mem_self
          rη
          (total_division_count η + 1)
    have hrη_mem_omega :
        rη ∈
          dyadic_cylinder
            rω
            (total_division_count ω + 1) := by
      exact hsubset hrη_mem_eta
    have hrη_realizes_eta :
        realizes rη η := by
      apply (hrη.2 rη).mpr
      exact hrη_mem_eta
    have hrη_realizes_omega :
        realizes rη ω := by
      apply (hrω.2 rη).mpr
      exact hrη_mem_omega
    /-
    A common realization makes the two words prefix-comparable. The
    desired orientation is immediate; a proper reverse prefix must be
    ruled out arithmetically.
    -/
    rcases
        common_realization_implies_prefix
          hrη_realizes_omega
          hrη_realizes_eta
      with hprefix | hreverse
    · exact hprefix
    · by_cases heq : η = ω
      · subst η
        simp
      · have hcount_lt :
            total_division_count η <
              total_division_count ω := by
          exact
            total_division_count_lt_of_proper_prefix
              hω
              hreverse
              heq
        /-
        Shift `rη` by one complete `η`-cylinder period. Inclusion places
        both the original point and its shift in the `ω` cylinder, forcing
        the `ω` modulus to divide one `η` period.
        -/
        have hshift_mem_eta :
            rη + 2 ^ (total_division_count η + 1) ∈
              dyadic_cylinder
                rη
                (total_division_count η + 1) := by
          change
            Nat.ModEq
              (2 ^ (total_division_count η + 1))
              (rη + 2 ^ (total_division_count η + 1))
              rη
          simp [Nat.ModEq]
        have hshift_mem_omega :
            rη + 2 ^ (total_division_count η + 1) ∈
              dyadic_cylinder
                rω
                (total_division_count ω + 1) := by
          exact hsubset hshift_mem_eta
        have hcong :
            Nat.ModEq
              (2 ^ (total_division_count ω + 1))
              rη
              (rη + 2 ^ (total_division_count η + 1)) := by
          exact
            hrη_mem_omega.trans
              hshift_mem_omega.symm
        have hzero :
            Nat.ModEq
              (2 ^ (total_division_count ω + 1))
              0
              (2 ^ (total_division_count η + 1)) := by
          apply Nat.ModEq.add_left_cancel' rη
          simpa using hcong
        have hdvd_reverse :
            2 ^ (total_division_count ω + 1) ∣
              2 ^ (total_division_count η + 1) := by
          exact
            (Nat.modEq_zero_iff_dvd).mp
              hzero.symm
        have hle_reverse :
            2 ^ (total_division_count ω + 1) ≤
              2 ^ (total_division_count η + 1) := by
          exact
            Nat.le_of_dvd
              (by positivity)
              hdvd_reverse
        /-
        Strict growth of total division count gives the opposite scale:
        the `ω` modulus is at least twice the `η` modulus.
        -/
        have hexp_le :
            (total_division_count η + 1) + 1 ≤
              total_division_count ω + 1 := by
          omega
        have hdvd_forward :
            2 ^ ((total_division_count η + 1) + 1) ∣
              2 ^ (total_division_count ω + 1) := by
          exact pow_dvd_pow 2 hexp_le
        have hle_forward :
            2 ^ ((total_division_count η + 1) + 1) ≤
              2 ^ (total_division_count ω + 1) := by
          exact
            Nat.le_of_dvd
              (by positivity)
              hdvd_forward
        rw [pow_succ] at hle_forward
        have hpos :
            0 < 2 ^ (total_division_count η + 1) := by
          positivity
        omega
  /-
  Conversely, a realization of `η` realizes every finite prefix, so a
  symbolic prefix relation immediately gives the cylinder inclusion.
  -/
  · intro hprefix x hx
    have hx_eta :
        realizes x η := by
      apply (hrη.2 x).mpr
      exact hx
    have hx_take :
        realizes x (η.take ω.length) := by
      exact realizes_take hx_eta ω.length
    have hx_omega :
        realizes x ω := by
      rw [hprefix]
      exact hx_take
    apply (hrω.2 x).mp
    exact hx_omega

/--
Prefix-incomparable division words have disjoint realization cylinders.

Suppose neither word is a prefix of the other:

`ω ≠ η.take ω.length`

and

`η ≠ ω.take η.length`.

Then their realization cylinders are disjoint.

If some natural number belonged to both cylinders, the corresponding
residue characterizations would show that it realizes both `ω` and `η`.
But `common_realization_implies_prefix` forces any two words with a common
realization to be prefix-comparable, contradicting one of the two
incomparability hypotheses.

Thus symbolic prefix incomparability forces arithmetic disjointness of the
corresponding realization cylinders.
-/
theorem realization_cylinders_disjoint_of_prefix_incomparable
    {ω η : division_word}
    {rω rη : ℕ}
    (hrω : realization_residue ω rω)
    (hrη : realization_residue η rη)
    (hωη : ω ≠ η.take ω.length)
    (hηω : η ≠ ω.take η.length) :
    Disjoint
      (dyadic_cylinder
        rω
        (total_division_count ω + 1))
      (dyadic_cylinder
        rη
        (total_division_count η + 1)) := by
  rw [Set.disjoint_left]
  intro x hxω hxη
  have hxω' :
      realizes x ω := by
    exact (hrω.2 x).mpr hxω
  have hxη' :
      realizes x η := by
    exact (hrη.2 x).mpr hxη
  /-
  A common realization forces prefix comparability, contradicting one
  of the two assumed incomparability relations.
  -/
  rcases
      common_realization_implies_prefix hxω' hxη'
    with hprefix | hprefix
  · exact hωη hprefix
  · exact hηω hprefix

/--
Distinct division words of the same symbolic length have disjoint
realization cylinders.

If `ω` and `η` have equal length but are not equal, then no natural number
can realize both words. Indeed, a common realization of two equal-length
division words would force

`ω = η`

by `realizes_eq_of_length_eq`.

Therefore their realization cylinders are disjoint.

This gives the equal-symbolic-depth antichain property of the realization
forest: distinct words of the same length determine pairwise disjoint
cylinders, even though their dyadic depths

`total_division_count ω + 1`

and

`total_division_count η + 1`

need not be equal.
-/
theorem realization_cylinders_disjoint_of_ne_of_length_eq
    {ω η : division_word}
    {rω rη : ℕ}
    (hrω : realization_residue ω rω)
    (hrη : realization_residue η rη)
    (hne : ω ≠ η)
    (hlen : ω.length = η.length) :
    Disjoint
      (dyadic_cylinder
        rω
        (total_division_count ω + 1))
      (dyadic_cylinder
        rη
        (total_division_count η + 1)) := by
  rw [Set.disjoint_left]
  intro x hxω hxη
  apply hne
  exact
    realizes_eq_of_length_eq
      ((hrω.2 x).mpr hxω)
      ((hrη.2 x).mpr hxη)
      hlen

end Collatz
