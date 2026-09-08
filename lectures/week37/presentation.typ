#import "../templates/tma4265-presentation.typ": *

#import "@preview/muchpdf:0.1.2": muchpdf

#import "@preview/lemmify:0.1.7": default-theorems, new-theorems, thm-numbering-heading
#import "@preview/subpar:0.2.2"

#import "../utils.typ": transition-diagram, transition-figure


#let bf(x) = math.bold(math.upright(x))
#set math.mat(delim: "[")

#show: icml-presentation.with(
  header-right: none,
  font-size: 20pt,
  language: "en",
  raw-lang: "bash",
)

#title-slide[
  = Week 37: Long Run Behavior of Markov Chains (Part 2)
]

== Recap from last week


#definition(name: [Limiting distribution])[
  Consider chain ${X_t}$. $bold(pi) = (pi_0, pi_1, dots)^top$ is the _limiting distribution_ if:
  + The limits $pi_j = lim_(t->oo) P_(i, j)^((t))$ exist for all $i$ and $j$.
  + $sum_(j=0)^oo pi_j = 1$.
]


#definition(name: [Regular Markov chain])[
  Consider chain ${X_t}$ with finite state space ${0, 1, dots, N}$ and transition probability matrix $bf(P)$. If there exists a positive integer $k>0$ so that all elements of $bf(P)^k$ are strictly positive, we call $bf(P)$ and ${X_t}$ _regular_.

  // Written more mathematically, we have $bf(P) "regular" <==> exists k > 0 "s.t." P_(i, j)^((k)) > 0 "for all" i, j in S$.
]

= Week 37

==

#definition(name: [Communication])[
  Let ${X_t: t = 0, 1, dots}$ be a Markov chain with transition probability matrix $bf(P)$.
  - State $j$ is _accessible_ from state $i$ if there exists an integer $n >= 0$ such that $P_(i,j)^((n)) > 0$.
  - If states $i$ and $j$ are accessible from each other, they _communicate_. Write as $i tilde.op j$.
]


#theorem(name: [Communication is an equivalence relation])[
  - Reflexivity: $i tilde.op i$ for every state $i$.
  - Symmetry: if $i tilde.op j$, then $j tilde.op i$.
  - Transitivity: if $i tilde.op j$ and $j tilde.op k$, then $i tilde.op k$.
]


Relation partitions the state space into _equivalence classes_ of communicating states.

==
#definition(name: [Irreducibility])[
  A Markov chain is _irreducible_ if it has exactly one communication class, meaning that all states communicate. Otherwise, the chain is _reducible_.
]


== Problem
Consider two Markov chain with the transition probability matrices
$
  bf(A) = mat(
    1\/3, 1\/3, 1\/3, 0;
    1\/3, 1\/3, 0, 1\/3;
    0, 0, 1\/2, 1\/2;
    0, 0, 1\/2, 1\/2;
  )
  quad "and" quad
  bf(B) = mat(
    0, 1, 0;
    0, 0, 1;
    1, 0, 0;
  )
$
For each chain, determine how many equivalence classes it has and whether it is irreducible or reducible.


==
#definition(name: [Periodicity])[
  The _period_ of state $i$, denoted by $d(i)$, is
  $
    d(i) = gcd{n >= 1: P_(i,i)^((n)) > 0}.
  $
  If $P_(i,i)^((n)) = 0$ for every $n >= 1$, we define $d(i)=0$.


  // See that $d(i) = 1$ if $P_(i, i)>0$.
]


#theorem()[
  If $i tilde.op j$, then $d(i)=d(j)$.
]<thm-periodicity-is-class-property>

Notes:
- A state with $d(i)=1$ is called _aperiodic_.
- For an irreducible chain, it is therefore either fully _periodic_ or _aperiodic_.

== Problem

Consider the Markov chains specified by the transition probability matrices
$
  bf(A) = mat(
    1, 0, , dots.c, 0;
    0, 1, 0, dots.c, 0;
    dots.v, , dots.down, , dots.v;
    0, , dots.c, 0, 1;
  ), quad
  bf(B) = mat(
    0, 1, 0, dots.c, 0;
    0, 0, 1, dots.c, 0;
    dots.v, , dots.down, , dots.v;
    1, 0, 0, dots.c, 0;
  )
  quad "and" quad
  bf(C) = mat(
    0, 1, 0, 0;
    0, 0, 1, 0;
    0, 0, 0, 1;
    1\/2, 0, 1\/2, 0;
  ).
$
Assume $bf(A)$ and $bf(B)$ are $n times n$.

For each chain do the following:
- Is the Markov chain reducible or irreducible? If it is reducible, specify its equivalence classes.
- Calculate the period of each state.

==
#theorem(name: [Regularity for finite chains])[
  A finite-state Markov chain is regular if and only if it is irreducible and aperiodic.
]<thm-regularity-for-finite-chains>

== Problem: Proving the theorem

Let ${X_n : n = 0, 1, dots}$ be a Markov chain with finite state space ${0, 1, dots, N}$. Show that if the Markov chain is aperiodic and irreducible, then it is regular and recurrent.

_(Recall that Markov chain is regular when there exists a positive integer $k>0$ so that all elements of $bf(P)^k$ are strictly positive.)_


==

#definition(name: [First-return probabilities])[
  $
    f_(i,i)^((n)) = P(X_n=i, X_nu != i " for " nu=1,2,dots,n-1 | X_0=i), quad n>=1,
  $
  // and we set $f_(i,i)^((0))=0$.

  // Notes:
  // - This is the probability of stating from state $i$, and the first return to state $i$ occurs at the $n$-th step.
  // - The probability of ever returning to state $i$ is $f_(i,i) = sum_(n=1)^oo f_(i,i)^((n))$.
  // - Clearly, $f_(i,i)^((0)) = P_(i,i)$, and $f_(i,i)^((n))$ may be calculated recursively as $P_(i,i)^((n)) = sum_(k=0)^(oo)f_(i,i)^((k)) P_(i,i)^((n-k))$.
]

#definition(name: [Recurrent and transient states])[
  State $i$ is _recurrent_ if $f_(i,i)=1$. It is _transient_ if $f_(i,i)<1$.

  // Intuition:
  // - If a state is recurrent, it is expected to be visited infinitely many times. If it is transient, it is expected to be visited only finitely many times.
  // - If a state is recurrent, the probability of returning to it after some finite length of time is $1$. If it is transient, the probability of returning to it after some finite length of time is less than $1$.
]
#theorem()[
  Recurrence and transience are class properties. If $i tilde.op j$ and $i$ is recurrent, then $j$ is recurrent.
]<thm-recurrence-is-class-property>

Intuition:
- If a state is recurrent, it is expected to be visited infinitely many times. Only finitely many visits for a transient state.
- The probability of ever returning to state $i$ is $sum_(n=1)^oo f_(i,i)^((n))$.

// ==
// #theorem()[
//   A state $i$ is recurrent if and only if
//   $
//     sum_(n=0)^oo P_(i,i)^((n)) = oo.
//   $
//   Equivalently, it is transient if and only $sum_(n=0)^oo P_(i,i)^((n)) < oo$.
//
//   Intuition:
//   - If a state is recurrent, it is expected to be visited infinitely many times. If it is transient, it is expected to be visited only finitely many times.
// ]
//
// #theorem()[
//   Recurrence and transience are class properties. If $i tilde.op j$ and $i$ is recurrent, then $j$ is recurrent.
// ]<thm-recurrence-is-class-property>


== Problem
A two-state Markov chain has the transition probability matrix
$
  bf(P) = mat(
    1-a, a;
    b, 1-b;
  ).
$
Determine the first-return distribution
$
  f_(0,0)^((n)) = P(X_n=0, X_nu != 0 " for " nu=1,2,dots,n-1 | X_0=0), quad n>=1,
$

==
// #definition(name: [Mean recurrence time])[
//   The _mean recurrence time_ of state $i$ is $m_i = sum_(n=1)^oo n f_(i,i)^((n))$, and can be interpreted as the mean duration of time between visits to state $i$.
// ]
// #definition(name: [Positive and null recurrent])[
//   A recurrent state $i$ is _positive recurrent_ if $m_i<oo$ and _null recurrent_ if $m_i=oo$.
// ]
//
// #theorem()[
//   Consider a recurrent irreducible aperiodic Markov chain. Then
//   - $lim_(n->oo)P_(i,i)^((n)) = 1\/m_i$ for all states $i$.
//   - $lim_(n->oo)P_(j,i)^((n)) = lim_(n->oo)P_(i,i)^((n))$ for all states $i$ and $j$.
//
//   Note:
//   - Consider a reducible chain. If it has a recurrent aperiodic equivalence class, then the theorem still holds for all states in that equivalence class.
//   - $m_i$ can be infinite, in which case the limit is $0$.
// ]
//
// #theorem(name: [Finite irreducible chains are positive recurrent])[
//   Every state in a finite irreducible Markov chain is positive recurrent.
// ]
//
//
// #theorem(name: [Finite irreducible chains are recurrent])[
//   In a positive recurrent aperiodic equivalence class with states $j=0, 1, dots$, we have
//   - $lim_(n->oo)P_(j,j)^((n)) = pi_j = sum_(i=0)^(oo) pi_i P_(i,j)$ for all $j$, and $sum_(j=0)^(oo) pi_j = 1$.
//   - $bold(pi) = (pi_0, pi_1, dots)^top$ is uniquely determined by $pi_i >= 0$ such that
//     $
//       sum_(i=0)^(oo) pi_i = 1 quad "and" quad sum_(i=0)^(oo) pi_i P_(i,j) = pi_j, quad j = 0, 1, dots
//     $
// ]
//
// #definition(name: [Stationary distribution])[
//   Any $bold(pi) = (pi_0, pi_1, dots)^top$ with $pi_i >= 0$ such that
//   $
//     sum_(i=0)^(oo) pi_i = 1 quad "and" quad sum_(i=0)^(oo) pi_i P_(i,j) = pi_j, quad j = 0, 1, dots
//   $
//   is called a _stationary distribution_.
//
//   Note:
//   - Limiting distribution $==>$ Unique stationary distribution
//   - Stationary distribution does not imply limiting distribution.
// ]
//
// #theorem(name: [Stationary distributions and recurrence])[
//   For a positive recurrent irreducible Markov chain, the stationary distribution is unique and $pi_i = 1\/m_i$.
// ]<thm-stationary-distribution-and-recurrence>

#definition(name: [Mean recurrence time])[
  The mean recurrence time of state $i$ is
  $
    m_i = sum_(n=1)^oo n f_(i,i)^((n)),
  $
  the expected time between successive visits to state $i$.
]

#definition(name: [Positive and null recurrence])[
  A recurrent state $i$ is positive recurrent if $m_i < oo$, null recurrent if $m_i = oo$.
]

==
#definition(name: [Stationary distribution])[
  A probability vector $bold(pi) = (pi_0, pi_1, dots)^top$ is a
  stationary distribution if
  $
    sum_i pi_i = 1 quad "and" quad pi_j = sum_(i=1)^(oo) pi_i P_(i,j), quad j = 0, 1, dots.
  $

  Equivalently, for finite state spaces, $bold(pi) = bf(P)^top bold(pi)$ and $bold(1)^top bold(pi) = 1$.
]

#theorem(name: [Existence and uniqueness of stationary distributions])[
  An irreducible Markov chain has a stationary distribution if and only if it is positive recurrent. When it exists, the stationary distribution is unique and satisfies $pi_i = 1 \/ m_i$.
]<thm-stationary-distribution-and-recurrence>

==

#theorem(name: [When stationary distribution is limiting])[
  If an irreducible positive recurrent Markov chain is also aperiodic, then the unique stationary distribution is also the limiting distribution


  $
    lim_(n -> oo) P_(j,i)^((n)) = pi_i = 1 \/ m_i quad "for all states" i,j.
  $
]

#corollary(name: [Finite irreducible chains])[
  Every finite irreducible Markov chain is positive recurrent. Hence it has a unique stationary distribution. If it is also aperiodic, then this stationary distribution is also the limiting distribution $lim_(n -> oo) P_(j,i)^((n)) = pi_i$.
]

== Problem: Combining many concepts

We throw a fair coin repeatedly, and denote each outcome by $"H"$ (heads) or $"T"$ (tails). Let $n$ denote the $n$-th throw in a sequence, and define a stochastic process ${X_n : n = 0, 1, dots}$ by
$
  X_n = "The number of consecutive throws of H, including throw" n, quad n = 0, 1, dots .
$
Do the following:
- Explain why this is a Markov process. Specify the state space, and find the transition probabilities.
- Is this Markov chain irreducible?
- For each state, calculate its period.
- Show that the states are recurrent.
- Calculate the long run proportion of time that the sequence of throws ends in three or more heads.

