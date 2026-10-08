/-
Copyright (c) 2026 Wayne Brassem. All rights reserved.
Released under Apache 2.0 license as described in the file LICENSE.
Authors: Wayne Brassem
-/

import Collatz.AffineContraction

/-!

# The Residual Forest, Global Decomposition, and Finite-Stage Mass Conservation

This module constructs the symbolic residual forest associated with the
dyadic affine-contraction threshold, identifies the integers that leave
that forest for the first time, establishes the global decomposition into
finite-depth exits and infinite residual survival, and proves the corresponding
finite-stage cylinder-mass conservation laws.

The preceding module, `Collatz.AffineContraction`, uses the dyadic threshold

    dyadic_threshold m

defined in `Collatz.Affine`, and proves that an admissible division word is
linearly contractive exactly when its total division count reaches that
threshold. It also shows that a linearly contractive realization cylinder
contributes its full dyadic mass asymptotically to descent.

The present module organizes division words and their realization sets
according to the first symbolic depth at which that threshold is reached.

## 1. Residual and First-Contraction Words

A `residual_word ω` is an admissible division word whose every nonempty
prefix remains strictly below the dyadic threshold:

    total_division_count (ω.take j)
      < dyadic_threshold j.

A `first_contraction_word ω` instead remains below threshold at every proper
nonempty prefix and reaches or exceeds the threshold at its terminal symbolic
position.

Distinct first-contraction words are prefix-incomparable. Using the
prefix geometry of realization cylinders developed in `Collatz.Cylinders`,
their exact realization cylinders are therefore disjoint even when the
words have different symbolic lengths or dyadic depths.

Residual words, by contrast, are closed under passage to nonempty prefixes.

## 2. Finite Residual Levels

For each symbolic depth `m`,

    residual_words_at_depth m

is the set of residual words of length `m`.

Every such level is finite. A residual word of length `m` has total division
count strictly below `dyadic_threshold m`, which bounds every division symbol
by a common finite bound. Hence only finitely many length-`m` words can occur.

The cardinality of this finite level is recorded as

    symbolic_complexity m.

The first residual level consists exactly of the word `[1]`.

## 3. Residual Realizations and One-Step Exit Layers

The set

    residual_realizations m

consists of starting integers realizing some residual word of symbolic
length `m`.

These realization sets form a nested forest. In particular,

    residual_realizations (m + 1)
      ⊆
    residual_realizations m

for every positive depth `m`, and more generally

    residual_realizations m
      ⊆
    residual_realizations j

whenever

    1 ≤ j ≤ m.

The first-contraction layer

    first_contraction_layer m

is the set difference between consecutive residual levels. Thus it contains
the integers that survive residually through depth `m` but not through depth
`m + 1`.

Every positive residual level therefore satisfies the exact one-step
decomposition

    residual_realizations m
      =
    first_contraction_layer m ∪
      residual_realizations (m + 1),

with the two sets disjoint.

The module also proves that this set-theoretic exit layer is exactly the set
of integers realizing first-contraction words of length `m + 1`.

## 4. Finite First Passage and the Infinite Residual Set

Iterating the one-step forest structure gives a finite first-passage
alternative. Every integer in the initial residual population either survives
to any prescribed finite symbolic depth or exits through one of the preceding
first-contraction layers.

The infinite residual set is defined by

    infinite_residual_set
      =
    {x | ∀ m ≥ 1, x ∈ residual_realizations m}.

This is the formal counterpart of

    R_∞ = ⋂_{m ≥ 1} R_m.

Thus an infinitely residual starting value remains below the affine-contraction
threshold at every finite symbolic depth.

The complementary finite-depth exit set is

    finite_depth_exit_set
      =
    {x | ∃ m ≥ 1, x ∈ first_contraction_layer m}.

Here "finite-depth" refers to the symbolic depth at which exit occurs; the set
of such starting values need not itself be finite.

The initial residual population has the exact global decomposition

    residual_realizations 1
      =
    finite_depth_exit_set ∪ infinite_residual_set,

and the two sets are disjoint.

Equivalently, every initially residual starting value either exits the
residual forest at some finite symbolic depth or remains residual at every
finite depth.

This decomposition is purely set-theoretic. No countable additivity of
natural density, continuity from above, or density assertion for
`infinite_residual_set` is used here.

## 5. Residual Cylinder Mass and Natural Density

Because the residual level at each fixed symbolic depth is finite and its
realization cylinders do not overlap, its total cylinder mass is defined by

    residual_mass m
      =
    ∑ ω ∈ residual_words_at_depth m,
      1 / 2 ^ (total_division_count ω + 1).

The corresponding realization counting function is proved to equal the sum
of the individual realization-cylinder counts.

Using the cylinder-density theorem from `Collatz.Cylinders`, the ordinary
natural density of `residual_realizations m` is therefore exactly

    residual_mass m.

Thus the symbolic finite-level mass and the arithmetic density of the
corresponding starting integers agree.

## 6. Exit-Layer Density and Finite-Stage Mass Conservation

Finite counting is conserved across every positive refinement:

    residual_count m
      =
    first_contraction_count m
      + residual_count (m + 1).

Passing to natural densities shows that the first-contraction layer has
density

    residual_mass m - residual_mass (m + 1).

Hence residual mass is nonincreasing with symbolic depth, and the successive
mass losses telescope:

    ∑ j < k,
      (residual_mass (m + j) - residual_mass (m + j + 1))
      =
    residual_mass m - residual_mass (m + k).

Thus this module establishes both the global set-theoretic decomposition of
the residual forest and its exact finite-stage mass accounting. The
asymptotic statement that the residual mass itself tends to zero is deferred
to the subsequent residual-mass analysis.

## Dependency flow

The main logical dependencies are:

    Collatz.AffineContraction
              │
              │  dyadic threshold
              │  contractive-cylinder density
              ▼
    ┌──────────────────────────────────────────────┐
    │   Residual and first-contraction words       │
    │                                              │
    │  residual_word                               │
    │  first_contraction_word                      │
    │       ├── prefix incomparability             │
    │       └── disjoint realization cylinders     │
    └──────────────────────────────────────────────┘
              │
              ▼
    ┌──────────────────────────────────────────────┐
    │          Finite residual levels              │
    │                                              │
    │  residual_words_at_depth                     │
    │       ├── finiteness                         │
    │       └── symbolic_complexity                │
    └──────────────────────────────────────────────┘
              │
              ▼
    ┌──────────────────────────────────────────────┐
    │       Nested residual realization forest     │
    │                                              │
    │  residual_realizations                       │
    │       ↓                                      │
    │  arbitrary-depth nesting                     │
    │       ↓                                      │
    │  first_contraction_layer                     │
    │       ↓                                      │
    │  one-step residual conservation              │
    └──────────────────────────────────────────────┘
              │
              ▼
    ┌──────────────────────────────────────────────┐
    │      Finite first passage and global split   │
    │                                              │
    │  residual_first_passage_or_survives          │
    │       ↓                                      │
    │  infinite_residual_set                       │
    │       │                                      │
    │       ├── finite_depth_exit_set              │
    │       ↓                                      │
    │  R₁ = finite-depth exits ∪ R∞                │
    │       ↓                                      │
    │  finite-depth exits ⟂ R∞                     │
    └──────────────────────────────────────────────┘
              │
              ▼
    ┌──────────────────────────────────────────────┐
    │       First-contraction realizations         │
    │                                              │
    │  first_contraction_realizations_at_depth     │
    │       ↓                                      │
    │  exit layer = first-contraction realizations │
    └──────────────────────────────────────────────┘
              │
              ▼
    ┌──────────────────────────────────────────────┐
    │       Cylinder mass and natural density      │
    │                                              │
    │  residual_mass                               │
    │       ↓                                      │
    │  exact finite count decomposition            │
    │       ↓                                      │
    │  density(residual level) = residual_mass     │
    └──────────────────────────────────────────────┘
              │
              ▼
    ┌──────────────────────────────────────────────┐
    │       Finite-stage mass conservation         │
    │                                              │
    │  residual count conservation                 │
    │       ↓                                      │
    │  exit density = M_m - M_{m+1}                │
    │       ↓                                      │
    │  residual mass is nonincreasing              │
    │       ↓                                      │
    │  finite telescoping of mass losses           │
    └──────────────────────────────────────────────┘

The resulting global forest structure and finite-stage conservation framework
are the inputs to the subsequent analysis of residual-mass decay.

-/

namespace Collatz

/-! ## Residual and First-Contraction Words -/

/--
A residual division word is an admissible word whose every nonempty prefix
remains strictly below the dyadic threshold.

Thus `residual_word ω` means that `ω` is admissible and, for every prefix
length `j` with

    1 ≤ j ≤ ω.length,

the prefix `ω.take j` satisfies

    total_division_count (ω.take j) <
      dyadic_threshold j.

Equivalently, no nonempty prefix of `ω` has yet reached the affine
contraction threshold.
-/
def residual_word (ω : division_word) : Prop :=
  admissible_division_word ω ∧
    ∀ j : ℕ,
      1 ≤ j →
      j ≤ ω.length →
      total_division_count (ω.take j) <
        dyadic_threshold j

/--
A first-contraction division word is an admissible word whose full length
reaches the dyadic threshold for the first time.

Thus `first_contraction_word ω` means that `ω` is admissible, that

    dyadic_threshold ω.length ≤
      total_division_count ω,

and that every proper nonempty prefix remains strictly below threshold:

    total_division_count (ω.take j) <
      dyadic_threshold j

for every `j` with

    1 ≤ j < ω.length.

Equivalently, `ω` exits the residual regime exactly at its terminal symbolic
position.
-/
def first_contraction_word (ω : division_word) : Prop :=
  admissible_division_word ω ∧
    dyadic_threshold ω.length ≤
      total_division_count ω ∧
    ∀ j : ℕ,
      1 ≤ j →
      j < ω.length →
      total_division_count (ω.take j) <
        dyadic_threshold j

/--
A first-contraction word cannot be a proper prefix of another
first-contraction word.

If `ω` were a proper prefix of `η`, then `ω` would already satisfy the
terminal contraction condition at symbolic length `ω.length`, while the
corresponding proper prefix of `η` would still be required to lie strictly
below the dyadic threshold. These conditions are incompatible.
-/
lemma first_contraction_word_not_proper_prefix
    {ω η : division_word}
    (hω : first_contraction_word ω)
    (hη : first_contraction_word η)
    (hprefix : ω = η.take ω.length)
    (hne : ω ≠ η) :
    False := by
  have htake_ne :
      η.take ω.length ≠ η := by
    intro heq
    exact hne (hprefix.trans heq)
  have hlen_lt :
      ω.length < η.length := by
    exact List.lt_length_of_take_ne_self htake_ne
  have hpositive :
      1 ≤ ω.length := by
    have hnonempty : 0 < ω.length := hω.1.1
    omega
  have hcontract :
      dyadic_threshold ω.length ≤
        total_division_count ω := by
    exact hω.2.1
  have hresidual :
      total_division_count (η.take ω.length) <
        dyadic_threshold ω.length := by
    exact hη.2.2 ω.length hpositive hlen_lt
  rw [← hprefix] at hresidual
  omega

/--
Distinct first-contraction words are prefix-incomparable.

Neither word can be a prefix of the other: if one were a proper prefix of
the other, its terminal contraction condition would contradict the
residual-prefix condition of the longer word.

Thus first-contraction words form an antichain under the prefix relation.
-/
theorem first_contraction_words_prefix_incomparable
    {ω η : division_word}
    (hω : first_contraction_word ω)
    (hη : first_contraction_word η)
    (hne : ω ≠ η) :
    ω ≠ η.take ω.length ∧
      η ≠ ω.take η.length := by
  constructor
  · intro hprefix
    exact
      first_contraction_word_not_proper_prefix
        hω hη hprefix hne
  · intro hprefix
    exact
      first_contraction_word_not_proper_prefix
        hη hω hprefix hne.symm

/--
Distinct first-contraction words determine disjoint realization cylinders,
regardless of their symbolic lengths or dyadic depths.

Their prefix incomparability therefore lifts, via the realization-cylinder
geometry, to disjointness of the corresponding exact dyadic cylinders.

Consequently, first-contraction cylinders can be summed without double
counting starting integers.
-/
theorem first_contraction_cylinders_disjoint
    {ω η : division_word}
    {rω rη : ℕ}
    (hrω : realization_residue ω rω)
    (hrη : realization_residue η rη)
    (hω : first_contraction_word ω)
    (hη : first_contraction_word η)
    (hne : ω ≠ η) :
    Disjoint
      (dyadic_cylinder
        rω
        (total_division_count ω + 1))
      (dyadic_cylinder
        rη
        (total_division_count η + 1)) := by
  obtain ⟨hωη, hηω⟩ :=
    first_contraction_words_prefix_incomparable
      hω hη hne
  exact
    realization_cylinders_disjoint_of_prefix_incomparable
      hrω hrη hωη hηω

/--
A residual word remains strictly below the contraction threshold at its own
symbolic length.

Equivalently,

    total_division_count ω <
      dyadic_threshold ω.length.

This is the terminal case of the prefixwise residuality condition.
-/
lemma residual_word_total_lt_threshold
    {ω : division_word}
    (hω : residual_word ω) :
    total_division_count ω <
      dyadic_threshold ω.length := by
  have h :=
    hω.2 ω.length hω.1.1 (le_refl _)
  simpa using h

/--
Every nonempty prefix of a residual word is itself residual.

If `ω` is residual and

    1 ≤ j ≤ ω.length,

then `ω.take j` is admissible and every nonempty prefix of `ω.take j`
remains strictly below its corresponding dyadic threshold.

Thus the residual forest is closed under passage to nonempty symbolic
prefixes.
-/
theorem residual_word_prefix
    {ω : division_word}
    (hω : residual_word ω)
    {j : ℕ}
    (hjpos : 1 ≤ j)
    (hj : j ≤ ω.length) :
    residual_word (ω.take j) := by
  have hlength :
      (ω.take j).length = j := by
    simp [List.length_take, Nat.min_eq_left hj]
  /- Admissibility is inherited by a nonempty prefix. -/
  constructor
  · constructor
    · change 0 < (ω.take j).length
      rw [hlength]
      omega
    · intro d hd
      exact hω.1.2 d (List.mem_of_mem_take hd)
  /- Every prefix of the prefix is already a prefix of the original word. -/
  · intro k hkpos hklen
    have hkj : k ≤ j := by
      simpa [hlength] using hklen
    have hbound :
        total_division_count (ω.take k) <
          dyadic_threshold k := by
      exact hω.2 k hkpos (le_trans hkj hj)
    simpa [List.take_take, Nat.min_eq_left hkj,
      Nat.min_eq_right hkj] using hbound

/-! ## Finite Residual Levels -/

/--
The residual division words at symbolic depth `m`.

Thus `residual_words_at_depth m` consists exactly of those residual words
whose symbolic length is `m`:

    {ω | residual_word ω ∧ ω.length = m}.

These fixed-depth levels form the horizontal slices of the residual forest.
-/
def residual_words_at_depth
    (m : ℕ) : Set division_word :=
  {ω | residual_word ω ∧ ω.length = m}

/--
At every symbolic depth, the residual forest contains only finitely many
division words.

If `ω` is residual of length `m`, then

    total_division_count ω <
      dyadic_threshold m.

Since every entry of a natural-number list is bounded by its total sum,
every symbol of `ω` lies in the finite alphabet

    Fin (dyadic_threshold m).

Thus the residual words at depth `m` embed into the finite set of
length-`m` lists over this alphabet.
-/
theorem residual_words_at_depth_finite
    (m : ℕ) :
    (residual_words_at_depth m).Finite := by
  let B := dyadic_threshold m
  /- Bound each symbol of a word by its total division count. -/
  have element_le_sum :
      ∀ (l : List ℕ) (d : ℕ),
        d ∈ l → d ≤ l.sum := by
    intro l
    induction l with
    | nil =>
        intro d hd
        simp at hd
    | cons a t ih =>
        intro d hd
        simp only [List.mem_cons] at hd
        simp only [List.sum_cons]
        rcases hd with rfl | hd
        · omega
        · have htail := ih d hd
          omega
  /- Encode lists whose entries are below B as lists over the finite type Fin B. -/
  have lift_bounded :
      ∀ l : List ℕ,
        (∀ d ∈ l, d < B) →
        ∃ l' : List (Fin B),
          l'.map (fun d : Fin B => (d : ℕ)) = l := by
    intro l
    induction l with
    | nil =>
        intro _
        exact ⟨[], rfl⟩
    | cons a t ih =>
        intro hb
        have ha : a < B :=
          hb a (by simp)
        have ht : ∀ d ∈ t, d < B := by
          intro d hd
          exact hb d (by simp [hd])
        obtain ⟨t', ht'⟩ := ih ht
        refine ⟨(⟨a, ha⟩ : Fin B) :: t', ?_⟩
        simp [ht']
  /- Fixed-length lists over Fin B form a finite ambient set. -/
  have hfinite :
      ({l : List (Fin B) | l.length = m} :
        Set (List (Fin B))).Finite := by
    exact List.finite_length_eq (Fin B) m
  have himage :
      ((fun l : List (Fin B) =>
          l.map (fun d : Fin B => (d : ℕ))) ''
        {l : List (Fin B) | l.length = m}).Finite := by
    exact hfinite.image _
  apply himage.subset
  intro ω hω
  change residual_word ω ∧ ω.length = m at hω
  rcases hω with ⟨hres, hlen⟩
  have htotal :
      total_division_count ω < B := by
    simpa [B, hlen] using
      residual_word_total_lt_threshold hres
  have hsum :
      ω.sum < B := by
    simpa [total_division_count] using htotal
  have hbound :
      ∀ d ∈ ω, d < B := by
    intro d hd
    have hle := element_le_sum ω d hd
    omega
  obtain ⟨l, hl⟩ := lift_bounded ω hbound
  refine ⟨l, ?_, hl⟩
  simpa [← hl] using hlen

/--
The number of residual division words at symbolic depth `m`.

Since `residual_words_at_depth m` is finite,
`symbolic_complexity m` is its cardinality.

Thus `symbolic_complexity m` measures the size of the residual forest at
symbolic level `m`.
-/
noncomputable def symbolic_complexity (m : ℕ) : ℕ :=
  (residual_words_at_depth_finite m).toFinset.card

/--
The first residual level consists exactly of the single word `[1]`.

At symbolic length one, admissibility forces the unique division exponent
to be positive, while residuality requires it to lie strictly below

    dyadic_threshold 1 = 2.

Hence the only possible residual word of length one is `[1]`.
-/
theorem residual_words_at_depth_one :
    residual_words_at_depth 1 =
      {([1] : division_word)} := by
  ext ω
  constructor
  /- A residual word of length one has a single positive exponent below B(1) = 2. -/
  · intro h
    change residual_word ω ∧ ω.length = 1 at h
    obtain ⟨hres, hlen⟩ := h
    cases ω with
    | nil =>
        simp at hlen
    | cons d tail =>
        cases tail with
        | nil =>
            have hdpos : 1 ≤ d :=
              hres.1.2 d (by simp)
            have hB :
                dyadic_threshold 1 = 2 := by
              decide
            have hdlt : d < 2 := by
              have hbound :=
                residual_word_total_lt_threshold hres
              simpa [total_division_count, hB] using hbound
            have hd : d = 1 := by
              omega
            subst d
            simp
        | cons e tail =>
            simp at hlen
  /- Conversely, [1] is admissible and remains below the depth-one threshold. -/
  · intro h
    have hword :
        ω = ([1] : division_word) := by
      simpa using h
    subst ω
    change residual_word ([1] : division_word) ∧
      ([1] : division_word).length = 1
    constructor
    · constructor
      · constructor
        · change 0 < ([1] : division_word).length
          decide
        · intro d hd
          simp at hd
          omega
      · intro j hjpos hjle
        have hj : j = 1 := by
          simp at hjle
          omega
        subst j
        decide
    · rfl

/-! ## Residual Realizations and One-Step Exit Layers -/

/--
The starting integers whose realized division words remain residual through
symbolic depth `m`.

Thus `x ∈ residual_realizations m` exactly when there exists a residual word
`ω` of length `m` such that

    realizes x ω.

Equivalently, `residual_realizations m` is the union of the realization
cylinders associated with the residual words at symbolic depth `m`.
-/
def residual_realizations (m : ℕ) : Set ℕ :=
  {x | ∃ ω : division_word,
    ω ∈ residual_words_at_depth m ∧
    realizes x ω}

/--
Residual realization sets are nested with symbolic depth.

If

    x ∈ residual_realizations (m + 1)

and `1 ≤ m`, then

    x ∈ residual_realizations m.

Indeed, a realization surviving residually through depth `m + 1` realizes
a residual word `ω` of length `m + 1`; its length-`m` prefix is residual by
`residual_word_prefix`, and `x` realizes that prefix by `realizes_take`.

Thus increasing symbolic depth can only shrink the residual realization set.
-/
theorem residual_realizations_nested
    (m : ℕ)
    (hm : 1 ≤ m) :
    residual_realizations (m + 1) ⊆
      residual_realizations m := by
  intro x hx
  change ∃ ω : division_word,
    ω ∈ residual_words_at_depth (m + 1) ∧
      realizes x ω at hx
  obtain ⟨ω, hω, hreal⟩ := hx
  change residual_word ω ∧
    ω.length = m + 1 at hω
  obtain ⟨hres, hlen⟩ := hω
  have hmle : m ≤ ω.length := by
    omega
  /- Truncate the residual word to its length-m prefix. -/
  have hprefix :
      residual_word (ω.take m) := by
    exact residual_word_prefix hres hm hmle
  have hprefix_length :
      (ω.take m).length = m := by
    simp [List.length_take, hlen]
  /- Realization is preserved when passing to the symbolic prefix. -/
  change ∃ η : division_word,
    η ∈ residual_words_at_depth m ∧
      realizes x η
  refine ⟨ω.take m, ?_, ?_⟩
  · exact ⟨hprefix, hprefix_length⟩
  · exact realizes_take hreal m

/--
Residual realization sets are nested across arbitrary positive symbolic depths.

If `1 ≤ j ≤ m`, then

    residual_realizations m ⊆ residual_realizations j.

A starting value surviving residually through depth `m` realizes a residual
word of length `m`. Truncating that word to length `j` preserves residuality
and realization, so the starting value also survives through depth `j`.

This is the finite-depth transitive form of `residual_realizations_nested`.
-/
theorem residual_realizations_nested_of_le
    {j m : ℕ}
    (hj : 1 ≤ j)
    (hjm : j ≤ m) :
    residual_realizations m ⊆ residual_realizations j := by
  intro x hx
  change ∃ ω : division_word,
    ω ∈ residual_words_at_depth m ∧
      realizes x ω at hx
  obtain ⟨ω, hω, hreal⟩ := hx
  change residual_word ω ∧
    ω.length = m at hω
  obtain ⟨hres, hlen⟩ := hω
  have hjle :
      j ≤ ω.length := by
    omega
  have hprefix :
      residual_word (ω.take j) := by
    exact residual_word_prefix hres hj hjle
  have hprefix_length :
      (ω.take j).length = j := by
    simp [List.length_take, hlen, hjm]
  change ∃ η : division_word,
    η ∈ residual_words_at_depth j ∧
      realizes x η
  exact
    ⟨ω.take j,
      ⟨hprefix, hprefix_length⟩,
      realizes_take hreal j⟩

/--
The integers that leave the residual forest when passing from symbolic depth
`m` to depth `m + 1`.

By definition,

    first_contraction_layer m
      =
    residual_realizations m \
      residual_realizations (m + 1).

Since the residual realization sets are nested, this is exactly the portion
of the depth-`m` residual set that fails to survive one further symbolic step.

This is the first-contraction layer `F_{m+1}` in the manuscript's finite-stage
decomposition.
-/
def first_contraction_layer (m : ℕ) : Set ℕ :=
  residual_realizations m \
    residual_realizations (m + 1)

/--
The first-contraction layer at depth `m` is disjoint from the residual
realizations that survive to depth `m + 1`.

Equivalently, an integer cannot both leave the residual forest between
depths `m` and `m + 1` and remain residual at depth `m + 1`.

This is immediate from the definition of `first_contraction_layer` as a
set difference.
-/
theorem first_contraction_layer_disjoint_next
    (m : ℕ) :
    Disjoint
      (first_contraction_layer m)
      (residual_realizations (m + 1)) := by
  rw [Set.disjoint_left]
  intro x hxF hxR
  exact hxF.2 hxR

/--
At every positive symbolic depth, the residual realization set decomposes
into the integers that leave the forest at the next step and those that
survive to the next residual level.

For `1 ≤ m`,

    residual_realizations m
      =
    first_contraction_layer m ∪
      residual_realizations (m + 1).

The union is disjoint by `first_contraction_layer_disjoint_next`.

This is the set-theoretic conservation law underlying the later counting and
mass decompositions.
-/
theorem residual_realizations_conservation
    (m : ℕ)
    (hm : 1 ≤ m) :
    residual_realizations m =
      first_contraction_layer m ∪
        residual_realizations (m + 1) := by
  apply Set.eq_of_subset_of_subset
  · intro x hx
    by_cases hnext :
        x ∈ residual_realizations (m + 1)
    · exact Or.inr hnext
    · exact Or.inl ⟨hx, hnext⟩
  · intro x hx
    rcases hx with hF | hnext
    · exact hF.1
    · exact
        residual_realizations_nested m hm hnext

/-! ## Finite First Passage and the Infinite Residual Set -/

/--
Every integer in the initial residual population either survives to symbolic
depth `1 + k` or exits through one of the preceding first-contraction layers.

More precisely, if

    x ∈ residual_realizations 1,

then either

    x ∈ residual_realizations (1 + k),

or there exists a depth `m` with

    1 ≤ m < 1 + k

such that

    x ∈ first_contraction_layer m.

Thus, at every finite symbolic depth, the initial residual population is
partitioned between the surviving residual tail and the first-contraction
layers encountered before that depth.

This finite first-passage decomposition is the bridge from one-step residual
conservation to the global residual decomposition below, and it is also the
basis for the later finite-error cover of the non-descending population.
-/
theorem residual_first_passage_or_survives
    (k : ℕ) (x : ℕ)
    (hx : x ∈ residual_realizations 1) :
    x ∈ residual_realizations (1 + k) ∨
      ∃ m : ℕ,
        1 ≤ m ∧
        m < 1 + k ∧
        x ∈ first_contraction_layer m := by
  induction k with
  | zero =>
      left
      simpa using hx
  | succ k ih =>
      rcases ih with hstay | ⟨m, hm, hmk, hmem⟩
      · by_cases hnext :
          x ∈ residual_realizations (1 + (k + 1))
        · exact Or.inl hnext
        · right
          refine ⟨1 + k, by omega, by omega, ?_⟩
          change
            x ∈ residual_realizations (1 + k) ∧
            x ∉ residual_realizations ((1 + k) + 1)
          constructor
          · exact hstay
          · have hidx :
                1 + (k + 1) = (1 + k) + 1 := by
              omega
            simpa only [hidx] using hnext
      · right
        exact ⟨m, hm, by omega, hmem⟩

/--
The infinite residual set consists of the starting values that remain in the
residual realization set at every positive symbolic depth.

Equivalently, `x ∈ infinite_residual_set` exactly when

    x ∈ residual_realizations m

for every `m ≥ 1`.

This is the formal counterpart of the manuscript set

    R_∞ = ⋂_{m ≥ 1} R_m.

Membership means that every finite realized division-word prefix remains
residual; no finite symbolic depth reaches the affine-contraction threshold.
-/
def infinite_residual_set : Set ℕ :=
  {x | ∀ m : ℕ, 1 ≤ m → x ∈ residual_realizations m}

/--
Membership in the infinite residual set is equivalent to survival in every
positive residual realization level.
-/
@[simp]
theorem mem_infinite_residual_set_iff
    {x : ℕ} :
    x ∈ infinite_residual_set ↔
      ∀ m : ℕ, 1 ≤ m → x ∈ residual_realizations m := by
  rfl

/--
The set of starting values that exit the residual forest at some finite
positive symbolic depth.

Thus `x ∈ finite_depth_exit_set` exactly when there exists a depth `m ≥ 1`
such that

    x ∈ first_contraction_layer m.

Equivalently, `x` survives residually through depth `m` but fails to survive
through depth `m + 1` for some finite positive `m`.

This is the set-theoretic union of all finite-depth first-contraction layers.
The adjective "finite-depth" refers to the symbolic depth of exit; the set
itself need not be finite.
-/
def finite_depth_exit_set : Set ℕ :=
  {x | ∃ m : ℕ, 1 ≤ m ∧ x ∈ first_contraction_layer m}

/--
Membership in the finite-depth exit set is equivalent to membership in some
first-contraction layer at a positive symbolic depth.

In particular,

    x ∈ finite_depth_exit_set

if and only if there exists `m ≥ 1` such that

    x ∈ first_contraction_layer m.
-/
@[simp]
theorem mem_finite_depth_exit_set_iff
    {x : ℕ} :
    x ∈ finite_depth_exit_set ↔
      ∃ m : ℕ, 1 ≤ m ∧ x ∈ first_contraction_layer m := by
  rfl

/--
The initial residual population decomposes into finite-depth exits and the
infinite residual set.

Every starting value in `residual_realizations 1` either exits the residual
forest at some finite positive symbolic depth or remains residual at every
positive symbolic depth:

    residual_realizations 1
      =
    finite_depth_exit_set ∪ infinite_residual_set.

The forward direction uses `residual_first_passage_or_survives`. If a starting
value is not infinitely residual, choose a positive depth at which it no
longer survives. Applying the finite first-passage theorem beyond that depth
forces an earlier first-contraction exit.

Conversely, a finite-depth exit lies in the residual level immediately before
that exit and therefore, by residual nesting, lies in the initial residual
level. An infinitely residual value belongs to the initial level by
definition.
-/
theorem residual_realizations_one_global_decomposition :
    residual_realizations 1 =
      finite_depth_exit_set ∪ infinite_residual_set := by
  ext x
  constructor
  · intro hx
    by_cases hinf :
        x ∈ infinite_residual_set
    · exact Or.inr hinf
    · left
      rw [mem_finite_depth_exit_set_iff]
      rw [mem_infinite_residual_set_iff] at hinf
      push Not at hinf
      obtain ⟨m, hm, hnot⟩ := hinf
      rcases
          residual_first_passage_or_survives m x hx with
        hstay | hexit
      · have hmemb :
            x ∈ residual_realizations m := by
          exact
            residual_realizations_nested_of_le
              (j := m)
              (m := 1 + m)
              hm
              (by omega)
              hstay
        exact (hnot hmemb).elim
      · obtain ⟨j, hj, _, hF⟩ := hexit
        exact ⟨j, hj, hF⟩
  · intro hx
    rcases hx with hexit | hinf
    · rw [mem_finite_depth_exit_set_iff] at hexit
      obtain ⟨m, hm, hF⟩ := hexit
      exact
        residual_realizations_nested_of_le
          (j := 1)
          (m := m)
          (by omega)
          hm
          hF.1
    · exact
        (mem_infinite_residual_set_iff.mp hinf)
          1
          (by omega)

/--
Finite-depth exits are disjoint from the infinite residual set.

If a starting value exits at positive depth `m`, then by definition it does
not belong to `residual_realizations (m + 1)`. An infinitely residual value,
on the other hand, belongs to every positive residual level, including
`m + 1`. Hence no starting value can belong to both sets.
-/
theorem finite_depth_exit_set_disjoint_infinite_residual_set :
    Disjoint finite_depth_exit_set infinite_residual_set := by
  rw [Set.disjoint_left]
  intro x hexit hinf
  rw [mem_finite_depth_exit_set_iff] at hexit
  rw [mem_infinite_residual_set_iff] at hinf
  obtain ⟨m, hm, hF⟩ := hexit
  exact hF.2 (hinf (m + 1) (by omega))

/--
The integers realizing a first-contraction word of symbolic length `m`.

Thus `x ∈ first_contraction_realizations_at_depth m` exactly when there
exists a division word `ω` such that

    first_contraction_word ω,
    ω.length = m,

and

    realizes x ω.

This is the symbolic realization counterpart of the set-theoretic
`first_contraction_layer`; their equality is established below.
-/
def first_contraction_realizations_at_depth
    (m : ℕ) : Set ℕ :=
  {x | ∃ ω : division_word,
    first_contraction_word ω ∧
      ω.length = m ∧
      realizes x ω}

/--
An integer realizing an admissible division word is odd.

Admissibility makes the word nonempty and forces its first prescribed
division count to be positive. Realization identifies that first symbol
with `division_count x`, so

    0 < division_count x.

Hence `x` is odd.
-/
lemma odd_of_admissible_realization
    {x : ℕ} {ω : division_word}
    (hω : admissible_division_word ω)
    (hr : realizes x ω) :
    Odd x := by
  cases ω with
  | nil =>
      have hpos : 0 < ([] : division_word).length :=
        hω.1
      simp at hpos
  | cons d tail =>
      /- Admissibility makes the first prescribed division count positive. -/
      have hdpos : 1 ≤ d :=
        hω.2 d (by simp)
      /- Realization identifies that first symbol with the actual division count of x. -/
      have hfirst : d = division_count x := by
        have heq :
            (d :: tail : division_word) =
              division_counts x (d :: tail).length := hr
        have hhead := congrArg List.head? heq
        simpa [division_counts, List.iterate] using hhead
      have hxpos : 1 ≤ division_count x := by
        rw [← hfirst]
        exact hdpos
      exact odd_of_division_count_pos x hxpos

/--
The set-theoretic exit layer of the residual forest is exactly the set of
realizations of first-contraction words.

For every positive symbolic depth `m`,

    first_contraction_layer m
      =
    first_contraction_realizations_at_depth (m + 1).

In the forward direction, if `x` survives residually through depth `m` but
not through depth `m + 1`, its actual division-count word of length `m + 1`
extends the residual length-`m` word. All proper nonempty prefixes therefore
remain below threshold, while the terminal word must reach the threshold;
otherwise `x` would still belong to `residual_realizations (m + 1)`.

Conversely, if `x` realizes a first-contraction word of length `m + 1`, its
length-`m` prefix is residual, so `x` survives through depth `m`. It cannot
also survive through depth `m + 1`, because equal-length realized words are
unique and the same word cannot be both residual at its terminal depth and
first-contractive there.

Thus symbolic first contraction and set-theoretic exit from the residual
forest coincide exactly.
-/
theorem first_contraction_layer_eq_realizations
    (m : ℕ)
    (hm : 1 ≤ m) :
    first_contraction_layer m =
      first_contraction_realizations_at_depth (m + 1) := by
  ext x
  constructor
  /-
  Forward: an exit from R_m determines the actual length-(m+1)
  division-count word of x.
  -/
  · intro hx
    change
      x ∈ residual_realizations m ∧
        x ∉ residual_realizations (m + 1) at hx
    obtain ⟨hxold, hnotnew⟩ := hx
    change
      ∃ ω : division_word,
        ω ∈ residual_words_at_depth m ∧
          realizes x ω at hxold
    obtain ⟨ω, hω, hreal⟩ := hxold
    change residual_word ω ∧ ω.length = m at hω
    obtain ⟨hres, hlen⟩ := hω
    let η : division_word := division_counts x (m + 1)
    have hηlen :
        η.length = m + 1 := by
      exact division_counts_length x (m + 1)
    have hηreal :
        realizes x η := by
      simp [η, realizes, division_counts_length]
    have hxodd : Odd x :=
      odd_of_admissible_realization hres.1 hreal
    have hηadm :
        admissible_division_word η := by
      exact division_counts_admissible
        x (m + 1) hxodd (by omega)
    /-
    The actual length-(m+1) word extends the residual word already
    realized through depth m.
    -/
    have hprefix :
        η.take m = ω := by
      calc
        η.take m = division_counts x m := by
          simpa [η] using
            (division_counts_take x m 1)
        _ = ω := by
          have h := hreal
          change ω = division_counts x ω.length at h
          rw [hlen] at h
          exact h.symm
    /-
    Hence every earlier prefix of η agrees with the corresponding
    residual prefix of ω.
    -/
    have htake
        (j : ℕ)
        (hj : j ≤ m) :
        η.take j = ω.take j := by
      calc
        η.take j = (η.take m).take j := by
          simp [List.take_take, Nat.min_eq_left hj]
        _ = ω.take j := by
          rw [hprefix]
    have hprior :
        ∀ j : ℕ,
          1 ≤ j →
          j < η.length →
          total_division_count (η.take j) <
            dyadic_threshold j := by
      intro j hjpos hjlt
      have hjm : j ≤ m := by
        omega
      have hbelow :=
        hres.2 j hjpos (by omega)
      simpa [htake j hjm] using hbelow
    /-
    The terminal word must reach threshold; otherwise η would itself
    be residual and x would survive to R_{m+1}.
    -/
    have hterminal :
        dyadic_threshold η.length ≤
          total_division_count η := by
      by_contra hfail
      have hbelow :
          total_division_count η <
            dyadic_threshold η.length := by
        omega
      have hηres : residual_word η := by
        constructor
        · exact hηadm
        · intro j hjpos hjle
          by_cases hjlt : j < η.length
          · exact hprior j hjpos hjlt
          · have hjEq : j = η.length := by
              omega
            subst j
            simpa only [List.take_length] using hbelow
      apply hnotnew
      change
        ∃ ρ : division_word,
          ρ ∈ residual_words_at_depth (m + 1) ∧
            realizes x ρ
      exact ⟨η, ⟨hηres, hηlen⟩, hηreal⟩
    change
      ∃ η : division_word,
        first_contraction_word η ∧
          η.length = m + 1 ∧
          realizes x η
    exact
      ⟨η, ⟨hηadm, hterminal, hprior⟩,
        hηlen, hηreal⟩
  /-
  Reverse: a first-contraction realization survives through depth m
  via its residual length-m prefix.
  -/
  · intro hx
    change
      ∃ η : division_word,
        first_contraction_word η ∧
          η.length = m + 1 ∧
          realizes x η at hx
    obtain ⟨η, hfirst, hlen, hreal⟩ := hx
    have hprefixlen :
        (η.take m).length = m := by
      simp [List.length_take, hlen]
    have hprefixadm :
        admissible_division_word (η.take m) := by
      constructor
      · change 0 < (η.take m).length
        omega
      · intro d hd
        exact
          hfirst.1.2 d
            (List.mem_of_mem_take hd)
    have hprefixres :
        residual_word (η.take m) := by
      constructor
      · exact hprefixadm
      · intro j hjpos hjle
        have hjm : j ≤ m := by
          omega
        have hjlt : j < η.length := by
          omega
        have hbelow :=
          hfirst.2.2 j hjpos hjlt
        simpa [
          List.take_take,
          Nat.min_eq_left hjm
        ] using hbelow
    have hxold :
        x ∈ residual_realizations m := by
      change
        ∃ ω : division_word,
          ω ∈ residual_words_at_depth m ∧
            realizes x ω
      exact
        ⟨η.take m,
          ⟨hprefixres, hprefixlen⟩,
          realizes_take hreal m⟩
    /-
    It cannot also survive to depth m+1: equal-length realizations are
    unique, and η is terminally contractive rather than residual.
    -/
    have hnotnew :
        x ∉ residual_realizations (m + 1) := by
      intro hxnew
      change
        ∃ ρ : division_word,
          ρ ∈ residual_words_at_depth (m + 1) ∧
            realizes x ρ at hxnew
      obtain ⟨ρ, hρ, hρreal⟩ := hxnew
      change residual_word ρ ∧ ρ.length = m + 1 at hρ
      obtain ⟨hρres, hρlen⟩ := hρ
      /- Equal-length realizations must be the same word. -/
      have heq : η = ρ := by
        exact
          realizes_eq_of_length_eq
            hreal hρreal (by omega)
      /- That word cannot be both residual and contractive. -/
      have hbelow :=
        residual_word_total_lt_threshold hρres
      rw [← heq] at hbelow
      have hcontract := hfirst.2.1
      omega
    change
      x ∈ residual_realizations m ∧
        x ∉ residual_realizations (m + 1)
    exact ⟨hxold, hnotnew⟩

/-! ## Residual Cylinder Mass and Natural Density -/

/--
At every positive depth, the residual realization set decomposes into the
first-contraction realizations at the next symbolic depth and the residual
realizations that survive one further step.

For `1 ≤ m`,

    residual_realizations m
      =
    first_contraction_realizations_at_depth (m + 1) ∪
      residual_realizations (m + 1).

This is the symbolic form of `residual_realizations_conservation`, obtained
by identifying the set-theoretic exit layer with the realizations of
first-contraction words.

The two sets in the union are disjoint by
`first_contraction_layer_disjoint_next` together with
`first_contraction_layer_eq_realizations`.
-/
theorem residual_realizations_first_contraction_decomposition
    (m : ℕ)
    (hm : 1 ≤ m) :
    residual_realizations m =
      first_contraction_realizations_at_depth (m + 1) ∪
        residual_realizations (m + 1) := by
  calc
    residual_realizations m =
        first_contraction_layer m ∪
          residual_realizations (m + 1) :=
      residual_realizations_conservation m hm
    _ =
        first_contraction_realizations_at_depth (m + 1) ∪
          residual_realizations (m + 1) := by
      rw [first_contraction_layer_eq_realizations m hm]

/--
The total cylinder mass assigned to the residual words at symbolic depth `m`.

Each residual word `ω` contributes the mass of its exact realization cylinder,

    1 / 2 ^ (total_division_count ω + 1),

and `residual_mass m` is the finite sum of these contributions over
`residual_words_at_depth m`.

The later density theorem shows that this symbolic cylinder sum is exactly
the ordinary natural density of `residual_realizations m`.
-/
noncomputable def residual_mass (m : ℕ) : ℝ :=
  ((residual_words_at_depth_finite m).toFinset).sum
    (fun ω =>
      (1 : ℝ) /
        (2 : ℝ) ^ (total_division_count ω + 1))

/--
Residual mass is nonnegative at every symbolic depth.

Each term in the finite sum defining `residual_mass m` is a nonnegative
cylinder mass, so their sum is nonnegative.
-/
theorem residual_mass_nonneg (m : ℕ) :
    0 ≤ residual_mass m := by
  unfold residual_mass
  apply Finset.sum_nonneg
  intro ω hω
  positivity

/--
A starting integer cannot realize two distinct residual words at the same
symbolic depth.

If `ω` and `η` both belong to `residual_words_at_depth m` and the same
integer `x` realizes both, then `ω = η`.

Thus the residual realization cylinders at a fixed symbolic depth are
pairwise disjoint at the level of starting integers, so finite-level counts
can be summed without double counting.
-/
theorem residual_realization_unique_at_depth
    (m : ℕ)
    {x : ℕ}
    {ω η : division_word}
    (hω : ω ∈ residual_words_at_depth m)
    (hη : η ∈ residual_words_at_depth m)
    (hrω : realizes x ω)
    (hrη : realizes x η) :
    ω = η := by
  change residual_word ω ∧ ω.length = m at hω
  change residual_word η ∧ η.length = m at hη
  exact
    realizes_eq_of_length_eq
      hrω hrη (hω.2.trans hη.2.symm)

/--
The number of starting integers below `N` whose trajectories remain residual
through symbolic depth `m`.

Equivalently, `residual_realization_count m N` counts the integers `x < N`
such that

    x ∈ residual_realizations m.

This is the counting function whose normalized limit will be shown to equal
`residual_mass m`.
-/
noncomputable def residual_realization_count
    (m N : ℕ) : ℕ := by
  classical
  exact Nat.count
    (fun x : ℕ => x ∈ residual_realizations m) N

/--
The residual realization count at depth `m` is the sum of the realization
counts of the residual words at that depth.

For every cutoff `N`,

    residual_realization_count m N
      =
    ∑ ω ∈ residual_words_at_depth m,
      realization_count ω N.

The sum is exact because a starting integer can realize at most one residual
word of the fixed symbolic length `m`. Thus the individual realization
counts contribute without double counting.

This is the finite-counting identity that later allows the natural density
of `residual_realizations m` to be computed by summing the densities of its
residual realization cylinders.
-/
theorem residual_realization_count_eq_sum
    (m N : ℕ) :
    residual_realization_count m N =
      ((residual_words_at_depth_finite m).toFinset).sum
        (fun ω => realization_count ω N) := by
  classical
  let s : Finset division_word :=
    (residual_words_at_depth_finite m).toFinset
  /- Replace membership in the finite residual level by membership in s. -/
  have hmem (ω : division_word) :
      ω ∈ s ↔ ω ∈ residual_words_at_depth m := by
    simp [s]
  /-
  A starting integer is residual at depth m exactly when it realizes
  some word in the finite residual level.
  -/
  have hexists (x : ℕ) :
      (∃ ω ∈ s, realizes x ω) ↔
        x ∈ residual_realizations m := by
    constructor
    · rintro ⟨ω, hω, hr⟩
      change
        ∃ ω : division_word,
          ω ∈ residual_words_at_depth m ∧
            realizes x ω
      exact ⟨ω, (hmem ω).mp hω, hr⟩
    · intro hx
      change
        ∃ ω : division_word,
          ω ∈ residual_words_at_depth m ∧
            realizes x ω at hx
      obtain ⟨ω, hω, hr⟩ := hx
      exact ⟨ω, (hmem ω).mpr hω, hr⟩
  /-
  Fixed-depth uniqueness turns the sum of realization indicators
  into the indicator of the residual realization set.
  -/
  have hindicator (x : ℕ) :
      (∑ ω ∈ s,
        if realizes x ω then (1 : ℕ) else 0) =
          if x ∈ residual_realizations m then 1 else 0 := by
    have hunique :
        ∀ ω ∈ s,
          ∀ η ∈ s,
            realizes x ω →
            realizes x η →
            ω = η := by
      intro ω hω η hη hrω hrη
      exact
        residual_realization_unique_at_depth
          m
          ((hmem ω).mp hω)
          ((hmem η).mp hη)
          hrω
          hrη
    calc
      (∑ ω ∈ s,
          if realizes x ω then (1 : ℕ) else 0)
          =
          (if ∃ ω ∈ s, realizes x ω then 1 else 0) := by
            exact
              Finset.sum_ite_zero
                s
                (fun ω => realizes x ω)
                hunique
                (1 : ℕ)
      _ =
          (if x ∈ residual_realizations m then 1 else 0) := by
            simp only [hexists x]
  /- Sum the pointwise indicator identity over all starting integers below N. -/
  change
    residual_realization_count m N =
      ∑ ω ∈ s, realization_count ω N
  induction N with
  | zero =>
      simp [residual_realization_count, realization_count]
  | succ N ih =>
      calc
        residual_realization_count m (N + 1)
            =
            residual_realization_count m N +
              (if N ∈ residual_realizations m then 1 else 0) := by
                simp only [
                  residual_realization_count,
                  Nat.count_succ
                ]
        _ =
            (∑ ω ∈ s, realization_count ω N) +
              (∑ ω ∈ s,
                if realizes N ω then (1 : ℕ) else 0) := by
                rw [ih, ← hindicator N]
        _ =
            ∑ ω ∈ s,
              (realization_count ω N +
                if realizes N ω then 1 else 0) := by
                rw [Finset.sum_add_distrib]
        _ =
            ∑ ω ∈ s, realization_count ω (N + 1) := by
                apply Finset.sum_congr rfl
                intro ω hω
                simp only [
                  realization_count,
                  Nat.count_succ
                ]

/--
The ordinary natural density of the residual realization set at symbolic
depth `m` is exactly its finite cylinder mass.

More precisely,

    residual_realization_count m N / N → residual_mass m

as `N → ∞`.

At fixed symbolic depth, the residual realization count is the exact finite
sum of the realization counts of the residual words at that depth. Each such
word is admissible, so its realization cylinder has natural density

    1 / 2 ^ (total_division_count ω + 1).

Since the residual level is finite, these individual limits may be summed,
and the resulting limit is precisely the finite sum defining
`residual_mass m`.

Thus the symbolic residual mass and the arithmetic natural density of the
corresponding residual starting integers coincide exactly.
-/
theorem residual_realization_count_has_natural_density
    (m : ℕ) :
    Filter.Tendsto
      (fun N : ℕ =>
        (residual_realization_count m N : ℝ) / N)
      Filter.atTop
      (nhds (residual_mass m)) := by
  classical
  let s : Finset division_word :=
    (residual_words_at_depth_finite m).toFinset
  /- Sum the natural-density limits of the finitely many residual cylinders. -/
  have hsum :
      Filter.Tendsto
        (fun N : ℕ =>
          s.sum (fun ω =>
            (realization_count ω N : ℝ) / N))
        Filter.atTop
        (nhds
          (s.sum (fun ω =>
            (1 : ℝ) /
              (2 ^ (total_division_count ω + 1) : ℝ)))) := by
    apply tendsto_finsetSum s
    intro ω hω
    have hωmem :
        ω ∈ residual_words_at_depth m := by
      simpa [s] using hω
    change
      residual_word ω ∧ ω.length = m at hωmem
    have hωadm :
        admissible_division_word ω :=
      hωmem.1.1
    obtain ⟨r, hr, _⟩ :=
      realization_residue_exists_unique' hωadm
    exact realization_cylinder_has_natural_density hr
  /-
  The exact counting decomposition identifies the normalized residual
  count with the finite sum of normalized cylinder counts.
  -/
  have hcount (N : ℕ) :
      (residual_realization_count m N : ℝ) / N =
        s.sum (fun ω =>
          (realization_count ω N : ℝ) / N) := by
    rw [residual_realization_count_eq_sum m N]
    simp only [s, Nat.cast_sum, Finset.sum_div]
  /- The sum of the limiting cylinder densities is residual_mass m. -/
  have hmass :
      s.sum (fun ω =>
        (1 : ℝ) /
          (2 ^ (total_division_count ω + 1) : ℝ)) =
        residual_mass m := by
    rfl
  /- Transport the finite-sum convergence through these exact identities. -/
  have hfunctions :
      (fun N : ℕ =>
        (residual_realization_count m N : ℝ) / N) =
      (fun N : ℕ =>
        s.sum (fun ω =>
          (realization_count ω N : ℝ) / N)) := by
    funext N
    exact hcount N
  rw [hfunctions]
  rw [← hmass]
  exact hsum

/-! ## Exit-Layer Density and Finite-Stage Mass Conservation -/

/--
The number of starting integers below `N` that leave the residual forest
when passing from symbolic depth `m` to depth `m + 1`.

Equivalently, `first_contraction_layer_count m N` counts the integers
`x < N` such that

    x ∈ first_contraction_layer m.

This counting function will be used to express the mass lost between
successive residual levels.
-/
noncomputable def first_contraction_layer_count
    (m N : ℕ) : ℕ := by
  classical
  exact Nat.count
    (fun x : ℕ => x ∈ first_contraction_layer m) N

/--
Finite residual counts satisfy an exact one-step conservation law.

For every positive symbolic depth `m` and cutoff `N`,

    residual_realization_count m N
      =
    first_contraction_layer_count m N
      + residual_realization_count (m + 1) N.

Every starting integer below `N` that is residual at depth `m` belongs
to exactly one of two classes: it either exits the residual forest at the
transition to depth `m + 1`, or it remains residual through that next depth.

Thus the set-theoretic decomposition of the residual forest lifts exactly
to finite counting.
-/
theorem residual_realization_count_conservation
    (m N : ℕ)
    (hm : 1 ≤ m) :
    residual_realization_count m N =
      first_contraction_layer_count m N +
        residual_realization_count (m + 1) N := by
  classical
  /-
  Pointwise, residual membership at depth m splits into exactly one of
  exit at the next step or survival to depth m + 1.
  -/
  have hpartition (x : ℕ) :
      (if x ∈ residual_realizations m then 1 else 0) =
        (if x ∈ first_contraction_layer m then 1 else 0) +
          (if x ∈ residual_realizations (m + 1) then 1 else 0) := by
    by_cases hnew : x ∈ residual_realizations (m + 1)
    · have hold : x ∈ residual_realizations m :=
        residual_realizations_nested m hm hnew
      have hnot : x ∉ first_contraction_layer m := by
        intro hf
        change
          x ∈ residual_realizations m ∧
            x ∉ residual_realizations (m + 1) at hf
        exact hf.2 hnew
      simp [hold, hnew, hnot]
    · by_cases hold : x ∈ residual_realizations m
      · have hf : x ∈ first_contraction_layer m := by
          change
            x ∈ residual_realizations m ∧
              x ∉ residual_realizations (m + 1)
          exact ⟨hold, hnew⟩
        simp [hold, hnew, hf]
      · have hf : x ∉ first_contraction_layer m := by
          intro hf
          change
            x ∈ residual_realizations m ∧
              x ∉ residual_realizations (m + 1) at hf
          exact hold hf.1
        simp [hold, hnew, hf]
  /- Accumulate the pointwise partition over all starting integers below N. -/
  induction N with
  | zero =>
      simp [
        residual_realization_count,
        first_contraction_layer_count
      ]
  | succ N ih =>
      calc
        residual_realization_count m (N + 1)
            =
            residual_realization_count m N +
              (if N ∈ residual_realizations m then 1 else 0) := by
                simp only [
                  residual_realization_count,
                  Nat.count_succ
                ]
        /- Insert the inductive count identity and the pointwise partition at N. -/
        _ =
            (first_contraction_layer_count m N +
              residual_realization_count (m + 1) N) +
              ((if N ∈ first_contraction_layer m then 1 else 0) +
                (if N ∈ residual_realizations (m + 1) then 1 else 0)) := by
                rw [ih, hpartition N]
        _ =
            (first_contraction_layer_count m N +
              (if N ∈ first_contraction_layer m then 1 else 0)) +
              (residual_realization_count (m + 1) N +
                (if N ∈ residual_realizations (m + 1) then 1 else 0)) := by
                omega
        _ =
            first_contraction_layer_count m (N + 1) +
              residual_realization_count (m + 1) (N + 1) := by
                simp only [
                  first_contraction_layer_count,
                  residual_realization_count,
                  Nat.count_succ
                ]

/--
The first-contraction layer between depths `m` and `m + 1` has ordinary
natural density equal to the residual mass lost across that refinement step.

For `1 ≤ m`,

    first_contraction_layer_count m N / N
      →
    residual_mass m - residual_mass (m + 1)

as `N → ∞`.

The residual realization sets at depths `m` and `m + 1` already have natural
densities `residual_mass m` and `residual_mass (m + 1)`. Exact finite-count
conservation identifies the first-contraction count with the difference of
their counting functions, so passing to the limit gives the difference of
their masses.

Thus the mass lost from the residual forest at one refinement step is
exactly the natural density of the integers exiting at that step.
-/
theorem first_contraction_layer_count_has_natural_density
    (m : ℕ)
    (hm : 1 ≤ m) :
    Filter.Tendsto
      (fun N : ℕ =>
        (first_contraction_layer_count m N : ℝ) / N)
      Filter.atTop
      (nhds (residual_mass m - residual_mass (m + 1))) := by
  /-
  Subtract the established natural-density limits of two consecutive
  residual levels.
  -/
  have hold :=
    residual_realization_count_has_natural_density m
  have hnew :=
    residual_realization_count_has_natural_density (m + 1)
  have hsub := hold.sub hnew
  /-
  Finite-count conservation identifies this difference pointwise with
  the normalized first-contraction count.
  -/
  have hpoint (N : ℕ) :
      (first_contraction_layer_count m N : ℝ) / N =
        (residual_realization_count m N : ℝ) / N -
          (residual_realization_count (m + 1) N : ℝ) / N := by
    have hcount :=
      residual_realization_count_conservation m N hm
    have hcast :
        (residual_realization_count m N : ℝ) =
          (first_contraction_layer_count m N : ℝ) +
            (residual_realization_count (m + 1) N : ℝ) := by
      exact_mod_cast hcount
    rw [hcast]
    ring
  /- Transport the difference limit through the pointwise equality. -/
  have hfunctions :
      (fun N : ℕ =>
        (first_contraction_layer_count m N : ℝ) / N) =
      (fun N : ℕ =>
        (residual_realization_count m N : ℝ) / N -
          (residual_realization_count (m + 1) N : ℝ) / N) := by
    funext N
    exact hpoint N
  rw [hfunctions]
  exact hsub

/--
Residual mass is nonincreasing across every positive symbolic depth.

For `1 ≤ m`,

    residual_mass (m + 1) ≤ residual_mass m.

By `first_contraction_layer_count_has_natural_density`, the difference

    residual_mass m - residual_mass (m + 1)

is the ordinary natural density of the first-contraction layer at that
refinement step. Since such a density is nonnegative, the residual mass
cannot increase with symbolic depth.
-/
theorem residual_mass_antitone_step
    (m : ℕ)
    (hm : 1 ≤ m) :
    residual_mass (m + 1) ≤ residual_mass m := by
  have hnonneg :
      0 ≤ residual_mass m - residual_mass (m + 1) := by
    apply ge_of_tendsto'
      (first_contraction_layer_count_has_natural_density m hm)
    intro N
    positivity
  exact sub_nonneg.mp hnonneg

/--
Residual mass losses telescope across any finite sequence of refinement
steps.

For symbolic depth `m` and number of steps `k`,

    ∑ j ∈ Finset.range k,
      (residual_mass (m + j) -
        residual_mass (m + j + 1))
      =
    residual_mass m - residual_mass (m + k).

Each summand is the mass lost at one successive refinement step. Their finite
sum therefore equals the total residual mass lost between the initial depth
`m` and the final depth `m + k`.

Together with `first_contraction_layer_count_has_natural_density`, this is
the finite-stage mass-conservation identity for the residual forest.
-/
theorem residual_mass_telescoping
    (m k : ℕ) :
    (∑ j ∈ Finset.range k,
      (residual_mass (m + j) -
        residual_mass (m + j + 1))) =
      residual_mass m - residual_mass (m + k) := by
  induction k with
  | zero =>
      simp
  | succ k ih =>
      rw [Finset.sum_range_succ, ih]
      have hindex :
          m + (k + 1) = m + k + 1 := by
        omega
      rw [hindex]
      ring

end Collatz
