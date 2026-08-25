
#import "../templates/tma4265-notes.typ": *
#import "@preview/muchpdf:0.1.2": muchpdf

#import "@preview/lemmify:0.1.7": default-theorems, new-theorems, thm-numbering-heading
#show figure.where(kind: "solution-group"): set block(breakable: true)

#import "@preview/fletcher:0.5.8" as fletcher: diagram, edge, node

#import "../utils.typ": transition-diagram, transition-figure

#let week35-theorems = default-theorems(
  "week35-thm-group",
  thm-styling: thm-styling,
  thm-numbering: thm-numbering-heading.with(max-heading-level: 1),
  max-reset-level: 1,
)
#let corollary = week35-theorems.corollary
#let proposition = week35-theorems.proposition
#let lemma = week35-theorems.lemma
#let theorem = week35-theorems.theorem
#let definition = week35-theorems.definition
#let remark = week35-theorems.remark
#let proof = week35-theorems.proof
#let example = week35-theorems.example
#show: week35-theorems.rules

#show link: set text(fill: blue)
#let bf(x) = math.bold(math.upright(x))

#show: icml.with(
  title: [
    Week 35: Discrete-time Markov chains
  ],

  authors: (
    (
      name: "Elling Svee (elling.svee@ntnu.no)",
    ),
  ),
  n_columns: 1,
  paper-size: "a4",
  // bibliography: bibliography("../refs.bib"),
)

#show figure.where(kind: "solution-group"): set block(breakable: true)

_These notes are written by me, so errors may and will occur. When in doubt, trust the book and Gunnar's lectures!_

= Motivation
See #link("https://youtu.be/KZeIEiBrT_w?si=bvamNeo_-fDDLxxx", "Veritasium: The Strange Math That Predicts (Almost) Anything") for a nice video on the topic.


Some research questions we might attempt to answer:
- How much uranium do we need to build a nuclear bomb?
- How many people will get Covid-19 within the next 6 months?
- How many times do we need to shuffle a deck of cards before it is sufficiently random?


Some interesting applications of Markov chains:
- *Google's PageRank algorithm:* Google’s original PageRank algorithm models a person randomly clicking from one webpage to another. The long-run probability of being on each page, i.e. the stationary distribution of the Markov chain, provides a measure of how “important” that page is.
- *Diffusion models for generative AI:* Image generators based on diffusion gradually add noise to an image and then learn how to reverse this process to generate new images. The forward diffusion process is sometimes formulated as a Markov chain. Here, the next noisy image depends only on the current noisy image, not on the entire previous history.
- *Language models and early text generation:* Before LLMs, Markov models were commonly used to generate text by predicting the next word or character from the current one (or from the last few).
- *Monte Carlo and MCMC methods:* Very important in statistics and machine learning, Markov chains are used to sample from complex distributions.
- *Hidden Markov models:* A type of statistical model that shows up in many applications, for example speech recognition and GPS systems.
- *Gaussian Markov Random Fields:* A computationally efficient model that I worked on during my #link("https://nva.sikt.no/registration/0199c37fabdb-cdded069-577d-44ab-b56a-2bfc82e7e20c", "master's thesis").


#pagebreak()
= Theory

We will go through the basics of discrete-time Markov chains and perform first-step analysis. Next week we will explore the long-term behavior of Markov chains.

== Definitions and basic concepts

#definition(name: [Discrete-time stochastic process])[
  A discrete-time stochastic process is a family of random variables ${X_t : t in T}$ where $T$ is discrete.

  We call $X_t$ the _state_ at time $t$, and the set of all possible states the _state space_.
]

#example(name: [Finite and infinite state spaces])[
  - Consider a student in Trondheim who is either at home (H), at Gløshaugen (G), or at Samfundet (S). The student moves between these three locations, so the state space is ${H, G, S}$.
  - Consider the number of unread messages a student has at the end of each day. New messages may arrive and old messages may be read, so the number changes from day to day. Let $X_t$ denote the number of unread messages on day $t$. The state space is ${0, 1, 2, dots}$.
]

#definition(name: [Discrete-time Markov chain])[
  A discrete-time Markov chain is a discrete-time stochastic process ${X_t : t in 0,1,dots}$ that satisfies the _Markov property_
  $
    P(X_(t+1) = j | X_0 = i_0, dots, X_t = i_t) = P(X_(t+1) = j | X_t = i_t),
  $
  for $t = 0, 1, dots$ and all states $i_0, dots, i_t, j$ for which the conditioning event has positive probability.
]

#definition(name: [One-step transition probabilities])[
  For a discrete-time Markov chain ${X_t : t in 0,1,dots}$, we call
  $
    P_(i, j)^(t,t+1) = P(X_(t+1) = j | X_t = i)
  $
  the _one-step transition probabilities_ from state $i$ to state $j$ at time $n$.

  From now on, we always assume _time-homogeneous_ transition probabilities, meaning $P_(i, j)^(t, t+1) = P_(i, j)$ for all $t=0,1,dots$ and all states $i$ and $j$.
]

#example()[
  The Markov property and time-homogeneity simplify transition probabilities give some nice simplifications. See that for all $t = 0, 1, dots$
  - $P(X_(t+1) = j | X_t = i) = P_(i, j)^(t, t+1) = P_(i, j) = P_(i, j)^(0, 1) = P(X_(1) = j | X_0 = i)$.
  - $P(X_(t+1) = j | X_0 = i_0, dots, X_t = i) = P(X_(t+1) = j | X_t = i) = P_(i, j)$.
  - By repeatedly applying Bayes' theorem, we also find
  $
    P(X_0 = i_0, dots, X_t = i_t) & = P(X_0 = i_0) P(X_1 = i_1 | X_0 = i_0) dot dots dot P(X_t = i_t | X_(t-1) = i_(t-1)) \
                                  & = P(X_0 = i_0) P_(i_0, i_1) dot dots dot P_(i_(t-1), i_t).
  $
]

#definition(name: [Transition probability matrix])[
  For a discrete-time Markov chain with a finite state space ${0,1,dots,N}$, we call
  $
    bf(P) = mat(
      P_(0,0), P_(0,1), dots, P_(0,N);
      P_(1,0), P_(1,1), , dots.v;
      dots.v, , dots.down, ;
      P_(N,0), dots, , P_(N,N)
    )
  $
  the _transition probability matrix_.

  Note that for an infinite state space ${0, 1, dots}$, we can envision an infinitely-sized matrix. Also be aware that I use the convention of writing matrices in bold $bf(P)$, and the entries of the matrix in normal font $P_(i, j)$.
]

#definition(name: [Transition diagram])[
  Let ${X_n : n=0,1,dots}$ be a discrete-time Markov chain. A _state transition diagram_ visualizes the transition probabilities as a weighted directed graph, where the nodes are the states and the edges are the possible transitions marked with the transition probabilities.
]


#theorem(name: [$n$-step transition probabilities])[
  For a time-homogeneous Markov chain ${X_n : n=0,1,dots}$ with countable state space $S$ and any $m >= 0$, we have
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



== First-step analysis

First-step analysis is a technique for analyzing Markov chains by breaking down the probabilities that can arise at the end of the first step.

#example(name: [Absorbing state])[
  Let ${X_n : n = 0, 1, dots}$ be a Markov chain on the state space ${0, 1, 2}$ and with transition probability matrix
  $
    bf(P) = mat(
      1, 0, 0;
      0.2, 0.5, 0.3;
      0, 0, 1;
    ).
  $
  The corresponding transition diagram is
  #transition-figure()[
    #transition-diagram(
      ($0$, $1$, $2$),
      (
        (1, 0, 0),
        (0.2, 0.5, 0.3),
        (0, 0, 1),
      ),
      positions: ((0, 0), (2, 0), (4, 0)),
      loop-angles: (180deg, 90deg, 0deg),
    )
  ]


  See that once the process reaches state $0$ or $2$, it will stay there forever. This is an example of _absorbing_ states.
]



#definition(name: [Hitting time])[
  Let ${X_n: n= 0, 1, dots}$ be a Markov chain, and let $A$ be a set of states. The _hitting time_ of $A$ is the random variable
  $
    T_A = inf {n >= 0 : X_n in A}.
  $
  We specify $inf emptyset = oo$, meaning $T_A=oo$ if the chain never reaches $A$.
]

#definition(name: [Absorbing state])[
  For a Markov chain, a state $i$ such that $P_(i,j) = 0$ for all $j != i$ is called absorbing. A set of states $A$ is absorbing if $P_(i,j) = 0$ for all $i in A$ and $j in.not A$.
]

#theorem()[
  Let ${X_n: n= 0, 1, dots}$ be a Markov chain with state space $S = {0, 1, dots, N}$ and transition probability matrix $P$. Let $A subset.eq S$ be an absorbing set of states.
  - If $u_i$ is the probability of absorption in $j in A$ starting from $X_0 = i$, then
    $
      u_i = P(X_(T_A) = j | X_0 = i) = cases(
        1 quad & "if" i = j,
        0 quad & "if" i in A "and" i != j,
        P_(i, j) + sum_(k in A^("C")) P_(i,k) u_k quad & "otherwise".
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

#pagebreak()
#problem(name: [Problem 1 in Exercise 2: Part 1])[

  Consider the Markov chain ${X_n : n = 0, 1, 2, ...}$ with state space ${"A", "B", "C"}$ and transition probability
  matrix given by
  $
    bf(P) = mat(
      0.1, 0.7, 0.2;
      0.5, 0.1, 0.4;
      0.3, 0.6, 0.1;
    ).
  $
  The probability distribution of the initial state $X_0$ is given by $P(X_0 = "A") = 0.2$, $P(X_0 = "B") = 0.5$ and $P(X_0 = "C") = 0.3$. Do the following:
  - Draw the corresponding transition diagram.

  - Compute $P(X_0 = "A", X_1 = "B", X_2 = "C")$
  - Compute $P(X_1 = "A")$
  - Compute $P(X_1 = "C")$ (here it is useful to know that $P(X_1 = "B") = 0.37$)
]<problem-exercise-2-part-1>
#solution()[
  - The corresponding transition diagram is
  #transition-figure()[
    #transition-diagram(
      ($"A"$, $"B"$, $"C"$),
      (
        (0.1, 0.7, 0.2),
        (0.5, 0.1, 0.4),
        (0.3, 0.6, 0.1),
      ),
    )
  ]<tranition-diagram>
  - Using Bayes' rule
    $
      P(X_0 = "A", X_1 = "B", X_2 = "C") & = P(X_2 = "C" | X_1 = "B", X_0 = "A") dot P(X_0 = "A", X_1 = "B") \
                                         & = P(X_2 = "C" | X_1 = "B") dot P(X_1 = "B" | X_0 = "A") dot P(X_0 = "A") \
                                         & = P_(B, C) dot P_(A, B) dot P(X_0 = "A") \
                                         & = 0.4 dot 0.7 dot 0.2 = 0.056
    $
  - Using the law of total probability
    $
      P(X_1 = "A") & = sum_(k in {"A", "B", "C"}) P(X_1 = "A" | X_0 = k) P(X_0 = k) \
                   & = 0.1 dot 0.2 + 0.5 dot 0.5 + 0.3 dot 0.3 \
                   & = 0.36.
    $
  - $P(X_1 = "C") & = 1 - P(X_1 = "A") - P(X_1 = "B") = 1 - 0.36 - 0.37 = 0.27$.
]


#pagebreak()
#problem(name: [Problem 1 in Exercise 2: Part 2])[
  Consider the same Markov chain as in @problem-exercise-2-part-1. It has state space ${"A", "B", "C"}$ and transition probability matrix
  $
    bf(P) = mat(
      0.1, 0.7, 0.2;
      0.5, 0.1, 0.4;
      0.3, 0.6, 0.1;
    )
  $
  The probability distribution of the initial state $X_0$ is given by $P(X_0 = "A") = 0.2$, $P(X_0 = "B") = 0.5$ and $P(X_0 = "C") = 0.3$. Note that
  $
    bf(P)^(2) = mat(
      0.42, 0.26, 0.32;
      0.22, 0.6, 0.18;
      0.36, 0.33, 0.31;
    )
    quad "and" quad
    bf(P)^(3) = mat(
      0.268, 0.512, 0.220;
      0.376, 0.322, 0.302;
      0.294, 0.471, 0.235;
    ).
  $
  Compute the following probabilities:
  - $P(X_3 = "A")$
  - $P(X_6 = "A" | X_3 = "C")$
  - $P(X_3 = "A" | X_1 = "B", X_0 = "A")$
  - $P(X_3 = "C" | X_6 = "A")$

]
#solution()[
  - Using the law of total probability
    $
      P(X_3 = "A") & = sum_(k in {"A", "B", "C"}) P(X_3 = "A" | X_0 = k) P(X_0 = k) \
                   & = P_(A, A)^((3)) dot P(X_0 = "A") + P_(B, A)^((3)) dot P(X_0 = "B") + P_(C, A)^((3)) dot P(X_0 = "C") \
                   & = 0.268 dot 0.2 + 0.367 dot 0.5 + 0.294 dot 0.3 \
                   & = 0.3298.
    $
  - Using time-homogeneity
    $
      P(X_6 = "A" | X_3 = "C") = P(X_3 = "A" | X_0 = "C") = P_("C", "A")^((3)) = 0.294.
    $
  - Using the Markov property and time-homogeneity
    $
      P(X_3 = "A" | X_1 = "B", X_0 = "A") = P(X_3 = "A" | X_1 = "B") = P(X_2 = "A" | X_0 = "B") = P_("B", "A")^((2)) = 0.22.
    $
  - Using Bayes' rule, the law of total probability, the Markov property and time-homogeneity
    $
      P(X_3 = "C" | X_6 = "A")
      & = P(X_6 = "A" , X_3 = "C") / P(X_6 = "A") \
      & = (P(X_6 = "A" | X_3 = "C") P(X_3 = "C")) / (sum_(k in {"A", "B", "C"}) P(X_6 = "A" | X_3 = k) P(X_3 = k)) \
      & = (P(X_3 = "A" | X_0 = "C") P(X_3 = "C")) / (sum_(k in {"A", "B", "C"}) P(X_3 = "A" | X_0 = k) P(X_3 = k)) \
      &= 0.245
    $
]

#pagebreak()
#problem(name: [Exam December 2024])[
  A taxi driver provides service in two zones of a city. Fares picked up in zone A will have destinations in zone A with probability $0.6$ or in zone B with probability $0.4$. Fares picked up in zone B will have destinations in zone A with probability $0.3$ or in zone B with probability $x$.
  - Explain that $x = 0.7$.
  - Write down the transition matrix for the resulting Markov chain and illustrate with a graph with transition probabilities.
  - What is the state space? What is the index set of the stochastic process?
  - Assume the driver starts in zone A. What is the probability that the driver ends in zone A after two fares? After four fares?
]
#solution()[
  - Since the total probability must sum to $1$, we have $x = 1 - 0.3 = 0.7$.
  - The transition matrix is given by
    $
      bf(P) = mat(
        0.6, 0.4;
        0.3, 0.7
      ),
    $
    while the corresponding transition diagram is
    #transition-figure()[
      #transition-diagram(
        ($"A"$, $"B"$),
        (
          (0.6, 0.4),
          (0.3, 0.7),
        ),
      )]
  - As we have two zones, the state space is ${"A", "B"}$. The index set of the stochastic process is ${0, 1, dots}$, where $X_0$ is the driver's initial zone before any fares and $X_n$ is the zone after the $n$-th fare.
  - We have $X_0 = "A"$, and want to compute $P(X_2 = "A" | X_0 = "A")$ and $P(X_4 = "A" | X_0 = "A")$. Using the transition matrix, we can compute
    $
      bf(P)^(2)
      = bf(P) dot bf(P)
      = mat(
        0.6, 0.4;
        0.3, 0.7
      ) dot mat(
        0.6, 0.4;
        0.3, 0.7
      )
      = mat(
        0.48, 0.52;
        0.39, 0.61
      ),
    $
    and
    $
      bf(P)^(4)
      = bf(P)^(2) dot bf(P)^(2)
      = mat(
        0.48, 0.52;
        0.39, 0.61
      ) dot mat(
        0.48, 0.52;
        0.39, 0.61
      )
      = mat(
        0.4332, 0.5668;
        0.4251, 0.5749
      ).
    $
    Picking the corresponding entries, we find
    $
      P(X_2 = "A" | X_0 = "A") = P_("A", "A")^((2)) = 0.48
      quad "and" quad
      P(X_4 = "A" | X_0 = "A") = P_("A", "A")^((4)) = 0.4332.
    $
]

#pagebreak()
#problem(name: "Expected time to absorption")[
  Let ${X_t : t = 0, 1, dots}$ be a Markov chain on the state space ${0, 1, 2}$. The transition probability matrix is
  $
    bf(P) = mat(
      1, 0, 0;
      alpha, beta, gamma;
      0, 0, 1;
    ),
  $
  with $alpha, beta, gamma > 0$ and $alpha + beta + gamma = 1$. Assuming $X_0 = 1$, answer the following
  - What is the probability of absorption in state $0$?
  - What is the expected time until absorption in state $0$ or $2$? You might need the formula for a geometric series $sum_(t=0)^oo r^t = 1 \/ (1 - r)$.
]
#solution()[
  - Letting $A = {0, 2}$, we denote $u_i = P(X_(T_A) = 0 | X_0 = i)$ for $i in {0, 1, 2}$. Clearly, $u_0 = 1$ and $u_2 = 0$, and the question is how to find $u_1$. Using the law of total probability, Bayes' rule and the Markov property, we have
    $
      u_1 & = sum_(k in {0, 1, 2}) P(X_(T_A) = 0, X_1 = k | X_0 = 1) \
          & = sum_(k in {0, 1, 2}) P(X_(T_A) = 0 | X_1 = k, X_0 = 1) P(X_1 = k | X_0 = 1) \
          & = sum_(k in {0, 1, 2}) P(X_(T_A) = 0 | X_1 = k) P_(1, k) \
          & = sum_(k in {0, 1, 2}) u_k P_(1, k) \
          & = u_0 alpha + u_1 beta + u_2 gamma \
          & = alpha + beta u_1.
    $
    Solving for $u_1$ gives
    $
      u_1 = alpha / (1 - beta) = alpha / (alpha + gamma).
    $
  - Let $v_i = EE[T_A | X_0 = i]$ for $i in {0, 1, 2}$. Clearly, $v_0 = v_2 = 0$. Starting from state $1$, the chain remains in state $1$ with probability $beta$, and is absorbed with probability $alpha + gamma = 1 - beta$. Hence, $P(T_A = t) = beta^(t-1) (1-beta)$ for $n = 1, 2, dots$. Using the formula for the expected value of a discrete random variable, we have
    $
      v_1 & = sum_(t=1)^oo t P(T_A = t) \
          & = sum_(t=1)^oo t beta^(t-1) (1-beta) \
          & = (1-beta) sum_(t=1)^oo t beta^(t-1)
    $
    Here we can use a trick by differentiating the geometric series $sum_(t=0)^oo beta^t = 1 \/ (1 - beta)$  to see
    $
      sum_(t=0)^oo t beta^(t-1) = sum_(t=1)^oo t beta^(t-1) = 1 / (1 - beta)^2.
    $
    Hence, we have
    $
      v_1 = (1-beta) / (1 - beta)^2 = 1 / (1 - beta) = 1 / (alpha + gamma).
    $
]


= Towards long-term behavior
One of the powers of Markov chains is that they allow us to study the long-term behavior of a system. For example, considering
$
  bf(P) = mat(
    0.8, 0.2;
    0.3, 0.7
  ),
$
we have
$
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
Therefore, regardless of the initial state, the probability of being in state $0$ after many transitions is approximately $0.6$, while the probability of being in state $1$ is approximately $0.4$. Next week, see study whether the limit
$
  lim_(n -> oo) P_(i, j)^((n)) = lim_(n -> oo) P(X_n = j | X_0 = i).
$
exists and, when it does, determine its value.
