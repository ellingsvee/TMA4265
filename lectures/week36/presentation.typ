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
  = Week 36: Long Run Behavior of Markov Chains (Part 1)
]

==

Interested in exploring the long-term behavior of Markov chains
$
  lim_(t -> oo) P_(i, j)^((t)) = lim_(t -> oo) P(X_t = j | X_0 = i).
$
For this we need to introduce some additional concepts.


==

#definition(name: [Limiting distribution])[
  Consider a DT-MC ${X_t}$. We call $bold(pi) = (pi_0, pi_1, dots)^top$ the _limiting distribution_ if the following two conditions are satisfied:
  + The limits $pi_j = lim_(t->oo) P_(i, j)^((t))$ exist for $j = 0, 1, dots$ and do not depend on $i$.
  + $sum_(j=0)^oo pi_j = 1$.

  Notes:
  - $1. ==> 2.$ for finite state spaces ${0, 1, dots, N}$, but not necessarily for infinite state spaces.
  - $pi_j$ can be interpreted as the probability of being in state $j$ after many transitions.
  // - I let $bold(pi)$ be a column vector, but some authors let it be a row vector. The two conventions are equivalent, but resulting matrix equations look different.
]

==

#definition(name: [Regular Markov chain])[
  Consider a DT-MC ${X_t}$ with finite state space ${0, 1, dots, N}$ and transition probability matrix $bf(P)$. If there exists a positive integer $k>0$ so that all elements of $bf(P)^k$ are strictly positive, we call $bf(P)$ and ${X_t}$ _regular_.

  // Written more mathematically, we have $bf(P) "regular" <==> exists k > 0 "s.t." P_(i, j)^((k)) > 0 "for all" i, j in S$.
]


== Problem 1

Are
$
  bf(A) = mat(
    1, 0;
    0, 1
  ),
  quad bf(B) = mat(
    0, 1;
    1, 0
  )
  quad "and/or" quad
  bf(C) = mat(
    1\/2, 1\/2, 0;
    1\/2, 0, 1\/2;
    0, 1\/2, 1\/2;
  )
$
regular?

==
#theorem()[
  Let ${X_t}$ be a regular DT-MC with finite state space ${0, 1, dots, N}$ and transition probability matrix $bf(P)$. Then the limiting distribution $bold(pi)$:
  // + Exists and for any initial state $i$ satisfies $pi_j = lim_(t->oo) P_(i, j)^((t)) > 0$ for all $j = 0, 1, dots, N$.
  + Exists and for any initial state $i$ satisfies
    $
      pi_j = lim_(t->oo) P_(i, j)^((t)) > 0
      quad "for all" j = 0, 1, dots, N.
    $
  // + Is the unique non-negative solution of $pi_j = sum_(k=0)^(N) pi_k P_(k, j)$ for $j = 0, 1, dots, N$ and $sum_(j=0)^(N) pi_j = 1$.
  + Is the unique non-negative solution of $bold(pi) = bf(P)^top bold(pi)$ and $bold(1)^top bold(pi) = 1.$
]<thm-limiting-distribution>

Importantly, regularity is a *sufficient (but not necessary)* condition for the existence of a limiting distribution.

==
#definition(name: [Stationary distribution])[
  A probability distribution $bold(pi) = (pi_0, pi_1, dots)^top$ is called a _stationary distribution_ if
  $
    pi_j = sum_(i=0)^oo pi_i P_(i,j), quad j = 0, 1, dots,
  $
  or, equivalently, $bold(pi) = bf(P)^top bold(pi) <==> (bf(P)^top - bf(I))bold(pi) = bold(0)$.

  Notes:
  - If $X_0 tilde.op bold(pi)$, then $X_t tilde.op bold(pi)$ for every $t >= 0$.
  - $"Limiting distribution" ==> "Stationary distribution"$ (but not the other way around).

]<def-stationary-distribution>

== Problem 2: Fixing the LF from Exercise 3

Consider the transition probability matrix
$
  bf(P) = mat(
    p, q, 0;
    0, p, q;
    q, 0, p;
  ),
$
where $p, q >= 0$ and $p + q = 1$. Consider the cases
- $0 < p < 1$ and $q = 1 - p > 0$
- $p = 1$ and $q = 0$.
- $p = 0$ and $q = 1$
For each case, determine whether the limiting distribution exists and/or whether the stationary distribution exists. Compute the $bold(pi) = (pi_0, pi_1, pi_2)^top$ as a function of $p$ and $q$.


==
#definition(name: [Doubly stochastic])[
  The transition probability matrix $bf(P)$ is called _doubly stochastic_ if
  $
    sum_(k=0)^(N) P_(i, k) = sum_(k=0)^(N) P_(k, j) = 1
  $
  for all states $i$ and $j$.
]

==
#theorem(name: [Long-run fraction of time])[
  In a regular Markov chain ${X_t: t = 0, 1, dots}$, the limiting distribution $bold(pi) = (pi_0, pi_1, dots, pi_N)^top$ gives the long-run fraction of time spent in each state. I.e.,
  $
    pi_j = lim_(n->oo) EE [1/n sum_(k=0)^(n-1) bb(1){X_k = j} | X_0=i]
  $
  for any state $i$

]<thm-long-run-fraction-of-time>



== Problem 3: Putting things together to make our life easy

A Markov chain ${X_t : t = 0,1,...}$ has transition probability matrix
$
  bf(P) = mat(
    1\/2, 1\/2, 0, 0;
    1\/2, 0, 1\/2, 0;
    0, 1\/2, 0, 1\/2;
    0, 0, 1\/2, 1\/2;
  ).
$
What is its limiting distribution? What fraction of time, in the long run, does the chain spend in state 0?

== Problem 4: Exam August 2025

On any given day Maria is either cheerful ($"C"$), so-so ($"S"$), or glum ($"G"$). If she is cheerful today, then she will be $"C"$, $"S"$, or $"G"$ tomorrow with respective probabilities $0.5$, $0.4$, $0.1$. If Maria is feeling so-so today, then she will be $"C"$, $"S"$, or $"G"$ tomorrow with probabilities $0.3$, $0.4$, $0.3$. If she is glum today, then she will be $"C"$, $"S"$, or $"G"$ tomorrow with probabilities $0.2$, $0.3$, $0.5$. Let $X_n$ denote Maria’s mood on day $n$.
+
  - Explain that Maria’s mood is a three-state Markov chain.
  - Illustrate with a transition probability graph, and determine the transition probability matrix $bf(P)$.
+ Assume that Maria’s mood at day $27$ has a uniform probability distribution. What is the probability that Maria is glum at day $28$.
+
  - Explain that the Markov chain has a unique stationary distribution.
  - How often, on average, is Maria glum?
  - Is it possible that the distribution of $X_1$ equals the distribution of $X_n$ for all $n$?


= PageRank

== Hyperlink-transition matrix

For $n$ pages, let $d_i$ denote the number of links on page $i$.
$
  P_(i,j) = cases(
    1 \/ d_i & "if page" i "links to page" j,
    0 & "otherwise".
  )
$

*Example:*
$
  bf(P) = mat(
    1\/2, 1\/2, 0, 0;
    1\/3, 0, 1\/3, 1\/3;
    0, 0, 0, 0;
    0, 1, 0, 0;
  ).
$
== Handling _dangling_ pages

If a page has no outgoing links, we replace it by a uniform distribution

$
  S_(i,j) = cases(
    P_(i,j) & "if" d_i > 0,
    1 \/ n & "if" d_i = 0.
  )
$


*Example:*
$
  bf(S) = mat(
    1\/2, 1\/2, 0, 0;
    1\/3, 0, 1\/3, 1\/3;
    1\/4, 1\/4, 1\/4, 1\/4;
    0, 1, 0, 0;
  ).
$

== Ensuring regularity

No guarantee that $bf(S)$ is regular, which we handle through _teleportation_. Let $alpha in (0,1)$ be the probability of following a link, and let $bold(v)$ be a probability distribution with $v_j>0$.
$
  G_(i,j) = alpha S_(i,j) + (1 - alpha) v_j.
$
Usually $alpha = 0.85$ and $bold(v) = (1\/n, dots, 1\/n)^top$.

*Example:*
$
  bf(G) = alpha bf(S) + (1-alpha)/4 bold(1) bold(1)^top = mat(
    0.463, 0.463, 0.038, 0.038;
    0.321, 0.038, 0.321, 0.321;
    0.250, 0.250, 0.250, 0.250;
    0.038, 0.888, 0.038, 0.038;
  ).
$

== Finding the limiting distribution
From regularity, we know that the limiting distribution $bold(pi)$ exists and is unique. It satisfies $bold(pi) = bf(G)^top bold(pi)$ and $bold(1)^top bold(pi)=1$.

To find it quickly, we can start with an initial distribution $bold(pi)^(0) = (1\/n, dots, 1\/n)^top$ and iterate
$
  bold(pi)^(k+1) = bf(G)^top bold(pi)^(k)
$
until convergence. This is called the _power method_.

= Code example: Ranking Wikipedia pages


