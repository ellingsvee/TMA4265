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
  = Week 35: Discrete-time Markov chains
]

= Motivation

#subpar.grid(
  figure(image("figures/diffusion.jpg", width: 75%), caption: [Diffusion models]),
  figure(image("figures/drone.jpg", width: 75%), caption: [Drone localisation (HMM)]),

  figure(image("figures/googlesearch.png", width: 55%), caption: [Language prediction]),
  figure(image("figures/mcmc.png", width: 65%), caption: [Monte Carlo and MCMC]),

  columns: (auto, auto),
)

= Fundamentals
==
#definition(name: [Discrete-time stochastic process])[
  A discrete-time stochastic process is a family of random variables ${X_t : t in T}$ where the _index set_ $T$ is discrete.

  Call $X_t$ the _state_ at time $t$, and the set of all possible states the _state space_.
]

#definition(name: [Discrete-time Markov chain])[
  A DT-MC is a discrete-time stochastic process ${X_t : t in 0,1,dots}$ satisfying the _Markov property_
  $
    P(X_(t+1) = j | X_0 = i_0, dots, X_t = i_t) = P(X_(t+1) = j | X_t = i_t),
  $
  for $t = 0, 1, dots$ and all states $i_0, dots, i_t, j$ for which the conditioning event has positive probability.
]

== Example of finite state space: Trondheim student

#subpar.grid(
  figure(image("figures/glos.jpg", width: 80%), caption: [Gløshaugen (G)]),
  figure(image("figures/samf.jpg", width: 110%), caption: [Samfundet (S)]),
  figure(image("figures/sit.jpg", width: 100%), caption: [Hjem (H)]),

  columns: (auto, auto, auto),
)

== Example of infinite state space: Receiving and reading emails

#figure(image("figures/email.jpeg", width: 50%))

==
#definition(name: [One-step transition probabilities])[
  For a DT-MC ${X_t : t in 0,1,dots}$, we call
  $
    P_(i, j)^(t,t+1) = P(X_(t+1) = j | X_t = i)
  $
  the _one-step transition probabilities_ from state $i$ to state $j$ at time $t$.

  // From now on, we always assume _time-homogeneous_ transition probabilities, meaning $P_(i, j)^(t, t+1) = P_(i, j)$ for all $t=0,1,dots$ and all states $i$ and $j$.
]

Always assume _time-homogeneous_ transition probabilities, meaning $P_(i, j)^(t, t+1) = P_(i, j)$ for all $t=0,1,dots$ and states $i$ and $j$.




==
#definition(name: [Transition diagram])[
  Let ${X_t : t=0,1,dots}$ be a DT-MC. A _state transition diagram_ visualizes the transition probabilities as a weighted directed graph, where the nodes are the states and the edges are the possible transitions marked with the transition probabilities.
]

// #transition-figure()[
//   #transition-diagram(
//     ($"A"$, $"B"$),
//     (
//       (0.2, 0.8),
//       (0.5, 0.5),
//     ),
//     node-radius: 10.5mm,
//     node-stroke: 1pt,
//     edge-stroke: 1pt,
//     positions: ((1, 0), (4, 0)),
//     label-size: 16pt,
//   )]

#definition(name: [Transition probability matrix])[
  For a DT-MC with a finite state space ${0,1,dots,N}$, the _transition probability matrix_ is
  $
    bf(P) = mat(
      P_(0,0), P_(0,1), dots, P_(0,N);
      P_(1,0), P_(1,1), , dots.v;
      dots.v, , dots.down, ;
      P_(N,0), dots, , P_(N,N)
    ).
  $

  // Note that for an infinite state space ${0, 1, dots}$, we can envision an infinitely-sized matrix. Also be aware that I use the convention of writing matrices in bold $bf(P)$, and the entries of the matrix in normal font $P_(i, j)$.
]

== Problem 1: From Exercise 2
Consider the DT-MC ${X_t : t = 0, 1, 2, ...}$ with state space ${"A", "B", "C"}$ and transition probability
matrix given by
$
  bf(P) = mat(
    0.1, 0.7, 0.2;
    0.5, 0.1, 0.4;
    0.3, 0.6, 0.1;
  ).
$
Knowing that $P(X_0 = "A") = 0.2$, $P(X_0 = "B") = 0.5$ and $P(X_0 = "C") = 0.3$:
- Draw the corresponding transition diagram.

- Compute $P(X_0 = "A", X_1 = "B", X_2 = "C")$
- Compute $P(X_1 = "A")$
- Compute $P(X_1 = "C")$ (here you can use that $P(X_1 = "B") = 0.37$)


==

#theorem(name: [$n$-step transition probabilities])[
  For a time-homogeneous DT-MC ${X_t : t=0,1,dots}$ with countable state space $S$ and any $m >= 0$, we have
  $
    P(X_(m+n) = j | X_m = i) = P_(i, j)^((n)) = sum_(k in S) P_(i, k) P_(k, j)^((n-1)), quad n > 0,
  $<eqn-n-step-transition-probabilities>
  where we define
  $
    P_(i, j)^((0)) = cases(
      1 "if" i = j,
      0 "otherwise"
    )
  $
]

#theorem()[
  Recognizing that @eqn-n-step-transition-probabilities is a matrix multiplication, we can write
  $
    bf(P)^((n)) = bf(P) dot bf(P)^((n-1)), quad n > 0,
  $
  and iteratively applying this gives
  $
    bf(P)^((n)) = underbrace(bf(P) dot bf(P) dot dots dot bf(P), n) = bf(P)^n.
  $
]

== Problem 2: From Exercise 2 cont.
Consider the same Markov chain as in Problem 1. We know that

$
  bf(P) = mat(
    0.1, 0.7, 0.2;
    0.5, 0.1, 0.4;
    0.3, 0.6, 0.1;
  ), quad
  bf(P)^(2) = mat(
    0.42, 0.26, 0.32;
    0.22, 0.6, 0.18;
    0.36, 0.33, 0.31;
  ), quad
  bf(P)^(3) = mat(
    0.268, 0.512, 0.220;
    0.376, 0.322, 0.302;
    0.294, 0.471, 0.235;
  ),
$
and that $P(X_0 = "A") = 0.2$, $P(X_0 = "B") = 0.5$ and $P(X_0 = "C") = 0.3$.

Compute the following probabilities:
- $P(X_3 = "A")$
- $P(X_6 = "A" | X_3 = "C")$
- $P(X_3 = "A" | X_1 = "B", X_0 = "A")$
- $P(X_3 = "C" | X_6 = "A")$


== Problem 3: Exam 2024
A taxi driver provides service in two zones of a city. Fares picked up in zone A will have destinations in zone A with probability $0.6$ or in zone B with probability $0.4$. Fares picked up in zone B will have destinations in zone A with probability $0.3$ or in zone B with probability $x$.

- Explain that $x = 0.7$.
- Write down the transition matrix and draw the transition probabilities.
- What is the state space? What is the index set of the stochastic process?
- Assume the driver starts in zone A. What is the probability that the driver ends in zone A after two fares? After four fares?


= First-step analysis
==
#definition(name: [Hitting time])[
  Let ${X_t: t= 0, 1, dots}$ be a Markov chain, and let $A$ be a set of states. The _hitting time_ of $A$ is the random variable
  $
    T_A = inf {t >= 0 : X_t in A}.
  $
  We specify $inf emptyset = oo$, meaning $T_A=oo$ if the chain never reaches $A$.
]

#definition(name: [Absorbing state])[
  For a Markov chain, a state $i$ such that $P_(i,j) = 0$ for all $j != i$ is called absorbing. A set of states $A$ is absorbing if $P_(i,j) = 0$ for all $i in A$ and $j in.not A$.
]

== Problem 4: Analysing absorption

Let ${X_t : t = 0, 1, dots}$ be a Markov chain on the state space ${0, 1, 2}$. The transition probability matrix is
$
  bf(P) = mat(
    1, 0, 0;
    alpha, beta, gamma;
    0, 0, 1;
  ),
$
with $alpha, beta, gamma > 0$ and $alpha + beta + gamma = 1$. Assume $X_0 = 1$.
- What is the probability of absorption in state $0$?
- What is the expected time until absorption in state $0$ or $2$? You will need the formula for a geometric series $sum_(t=0)^oo r^t = 1 \/ (1 - r)$

==
#theorem()[
  Let ${X_t: t= 0, 1, dots}$ be a Markov chain with state space $S = {0, 1, dots, N}$ and transition probability matrix $bf(P)$. Let $A subset.eq S$ be an absorbing set of states.
  - If $u_i$ is the probability of absorption in $j in A$ starting from $X_0 = i$, then
    $
      u_i = P(X_(T_A) = j | X_0 = i) = cases(
        1 quad & "if" i = j,
        0 quad & "if" i in A "and" i != j,
         // P_(i, j) + sum_(k in A^("C")) P_(i,k) u_k quad & "otherwise".
        sum_(k in S) P_(i,k) u_k quad & "otherwise".
      )
    $
  - If $v_i = EE[T_A | X_0 = i]$ is the expected time until absorption starting from $X_0 = i$, then
    $
      v_i = cases(
        0 quad & "if" i in A,
        1 + sum_(k in A^("C")) P_(i,k) v_k quad & "otherwise"
      )
    $<thm-expected-time-to-absorption>
]

= Towards long-term behaviour...
$
  bf(P) = mat(
    0.8, 0.2;
    0.3, 0.7
  ), quad
  bf(P)^(2) = mat(
    0.7, 0.3;
    0.45, 0.55
  ), quad
  bf(P)^(10) approx mat(
    0.600391, 0.3996090;
    0.599414, 0.400586
  ), quad
  bf(P)^(100) approx mat(
    0.6, 0.4;
    0.6, 0.4
  ).
$


