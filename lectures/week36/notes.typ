#import "../templates/tma4265-notes.typ": *
#import "@preview/muchpdf:0.1.2": muchpdf

#import "@preview/lemmify:0.1.7": default-theorems, new-theorems, thm-numbering-heading
#show figure.where(kind: "solution-group"): set block(breakable: true)

#import "@preview/fletcher:0.5.8" as fletcher: diagram, edge, node

#import "../utils.typ": transition-diagram, transition-figure

#show link: set text(fill: blue)


#show: icml.with(
  title: [
    Week 36: Long Run Behavior of Markov Chains
  ],

  authors: (
    (
      name: "Elling Svee (elling.svee@ntnu.no)",
    ),
  ),
  n_columns: 1,
  paper-size: "a4",
  bibliography: bibliography("../refs.bib"),
)

#show figure.where(kind: "solution-group"): set block(breakable: true)

#let bf(x) = math.bold(math.upright(x))


_These notes are written by myself, and errors may and will occur. When in doubt, trust the book and Gunnars lectures!_


= Theory

We are now interested in exploring the long-term behavior of Markov chains, meaning determining the limit
$
  lim_(n -> oo) P_(i, j)^((n)) = lim_(n -> oo) P(X_n = j | X_0 = i).
$
For this we have to introduce some additional terminology and definitions.

#definition(name: [Regular Markov chain])[
  Consider a Markov chain ${X_n: n= 0, 1, dots}$ with finite state space ${0, 1, dots, N}$ and transition probability matrix $bf(P)$. If there exists a positive integer $k>0$ so that all elements of $bf(P)^k$ are strictly positive, we call $bf(P)$ and ${X_n}$ _regular_.

  Written more mathematically, we have
  $
    bf(P) "regular" <==> exists k > 0 "s.t." P_(i, j)^((k)) > 0 "for all" i, j in S.
  $
]

#example()[
  See that
  $
    bf(P) = mat(
      1\/2, 1\/2, 0;
      1\/2, 0, 1\/2;
      0, 1\/2, 1\/2;
    )
  $
  is regular since
  $
    bf(P)^(2) = mat(
      ast, ast, ast;
      ast, ast, ast;
      ast, ast, ast;
    ).
  $
  While a trivial example of a non-regular transition matrix is the identity $P = I$.
]

#definition(name: [Limiting distribution])[
  Consider a discrete-time Markov chain ${X_n}$. We call $bold(pi) = (pi_0, pi_1, dots)$ the _limiting distribution_ is the following two conditions are satisfied:
  + $pi_j = lim_(n->oo) P_(i, j)^((n))$ for $j = 0, 1, dots$ all exist and do not depend on $i$.
  + $sum_(j=0)^oo pi_j = 1$.

  Notes:
  - $1. ==> 2.$ for finite state spaces ${0, 1, dots, N}$, but not necessarily for infinite state spaces.
  - $pi_j$ can be interpreted as the probability of being in state $j$ after many transitions.
]

#theorem()[
  Let ${X_n}$ be a regular discrete-time Markov chain with state space ${0, 1, dots, N}$ and transition probability matrix $P$. Then the limiting distribution $bold(pi)$:
  + Exists and for any initial state $i$ satisfies $pi_j = lim_(n->oo) P_(i, j)^((n)) > 0$ for all $j = 0, 1, dots, N$.
  + Is the unique non-negative solution of $pi_j = sum_(k=0)^(N) pi_k P_(k, j)$ for $j = 0, 1, dots, N$ and $sum_(j=0)^(N) pi_j = 1$.
  Notes:
  - Regularity implies existence and uniqueness of the limiting distribution.
  - $bold(pi)^top = bold(pi)^top bf(P) <==> bold(pi) = bf(P)^top bold(pi) <==> (bf(I) - bf(P)) bold(pi) = bold(0)$ .
]

#definition(name: [Doubly stochastic])[
  The transition probability matrix $bf(P)$ is called _doubly stochastic_ if
  $
    sum_(k=0)^(N) P_(i, k) = sum_(k=0)^(N) P_(k, j) = 1
  $
  for all states $i$ and $j$.
]

#theorem()[
  Let the Markov chain ${X_n : n = 0, 1, dots}$ be regular with finite state space ${0, 1, dots, N}$. Is the transition probability matrix $bf(P)$ doubly stochastic, then the limiting distribution is uniform
  $
    bf(pi) = (1/(N+1), 1/(N+1), dots, 1/(N+1)).
  $
]

#theorem(name: [Long-run mean fraction of time])[
  In a regular Markov chain ${X_n: n = 0, 1, dots}$, the limiting distribution $bold(pi) = (pi_0, pi_1, dots, pi_N)$ gives the long-run mean fraction of time spent in each state
  $
    pi_j = lim_(n->oo) EE [
      1/n sum_(k=0)^(n-1) bb(1){X_k = j} | X_0 = i
    ]
  $
  for any state $i$.
]

An important thing to be aware of is that regularity is a sufficient condition for the existence of a limiting distribution, but not a necessary one. There are Markov chains that are not regular, but still have a limiting distribution. To explore this we need some additional definitions.

#definition(name: [Communication])[
  Let ${X_n: n = 0, 1, dots}$ be a Markov chain with state space ${0, 1, dots}$ and transition probability matrix $P$.
  - State $j$ is _accessible_ from state $i$ if there exists a positive integer $n >= 0$ so that $P_(i, j)^((n)) > 0$.
  - If states $i$ and $j$ are accessible from each other, they are said to _communicate_ and we write $i tilde.op j$.
]

#theorem(name: [Communication is an equivalence relation])[
  We have
  - Reflexivity: $i tilde.op i$ for all states $i$.
  - Symmetry: If $i tilde.op j ==> j tilde.op i$.
  - Transitivity: If $i tilde.op j$ and $j tilde.op k$, then $i tilde.op k$.

  The equivalence relation induces _equivalence classes_ consisting of sets of states that communicate.
]

#definition(name: [Irreducibility])[
  A Markov chain is _irreducible_ if the communication equivalence relation induces exactly one equivalence class, meaning that all states communicate with each other. If not, the Markov chain is _reducible_.
]

#definition(name: [Periodicity])[
  The _period_ of a state $i$, written $d(i)$, is
  $
    d(i) = gcd{n >= 1: P_(i, i)^((n)) > 0}.
  $
  If $P_(i, i)^((n)) = 0$ for all $n >= 1$, we define $d(i) = 0$. If $d(i) = 1$, we say that state $i$ is _aperiodic_.
]

#theorem()[
  If $i tilde.op j$, then $d(i) = d(j)$.

  Note that this means that periodicity is a property of the equivalence class.
]

Introducing some notation, we write
$
  f_(i,i)^((n)) = P(X_n = i, X_nu != i, nu = 1, 2, dots, n-1 | X_0 = i), quad n>0,
$
and define $f_(i, i)^((0)) = 0$. The probability of ever returning to state $i$ is then
$
  f_(i, i) = sum_(k=1)^oo f_(i, i)^((k)) = lim_(n->oo) sum_(k=1)^n f_(i, i)^((k)).
$
Note that a $f_(i,i) < 1$ there is a non-zero probability of never returning to state $i$.

#definition(name: [Recurrent and transient states])[
  State $i$ is _recurrent_ if the probability of returning to state $i$ in a finite number of time steps is one, i.e., $f_(i,i) = 1$. A state that is not recurrent, i.e., $f_(i,i) < 1$, is called _transient_.
]

#theorem()[
  A state $i$ is recurrent if and only if $sum_(n=0)^oo P_(i, i)^((n)) = oo$. Equivalently, a state $i$ is transient if and only if $sum_(n=0)^oo P_(i, i)^((n)) < oo$.

  We interpret this as the expected number of returns is finite for transient states and infinite for recurrent states.
]




#pagebreak()

#problem()[
  Consider the Markov chain with transition probability matrix
  $
    bf(P) = mat(
      1\/3, 1\/3, 1\/3, 0;
      1\/3, 1\/3, 0, 1\/3;
      0, 0, 1\/2, 1\/2;
      0, 0, 1\/2, 1\/2;
    ).
  $
  - How many equivalence classes does this Markov chain have?
  - Is the Markov chain irreducible or reducible?
]
