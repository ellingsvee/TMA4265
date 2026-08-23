
#import "../templates/tma4265-notes.typ": *
#import "@preview/muchpdf:0.1.2": muchpdf

#import "@preview/lemmify:0.1.7": default-theorems, new-theorems, thm-numbering-heading
#show figure.where(kind: "solution-group"): set block(breakable: true)

#import "@preview/fletcher:0.5.8" as fletcher: diagram, edge, node

#import "../utils.typ": transition-diagram, transition-figure

#show link: set text(fill: blue)


#show: icml.with(
  title: [
    Week 35: Introduction to discrete-time Markov chains
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

_These notes are written by myself, and errors may and will occur. When in doubt, trust the book and Gunnars lectures!_

= Motivation and cool uses of Markov chains

Some interesting applications of Markov chains:
- *Google's PageRank algorithm:* Google’s original PageRank algorithm models a person randomly clicking from one webpage to another. The long-run probability of being on each page, i.e. the stationary distribution of the Markov chain, provides a measure of how “important” that page is.
- *Diffusion models for generative AI:* Image generators based on diffusion gradually add noise to an image and then learn how to reverse this process to generate new images. The forward diffusion process is sometimes formulated as a Markov chain. Here, the next noisy image depends only on the current noisy image, not on the entire previous history.
- *Language models and early text generation:* Before LLMs, Markov models were commonly used to generate text by predicting the next word or character from the current one (or from the last few).
- *Monte Carlo and MCMC methods:* Very important in statistics and machine learning, Markov chains are used to sample from complex distributions.

Some research questions we might attempt to answer:
- How much uranium do we need to build a nuclear bomb?
- How many people will get Covid within the next 6 months?
- How many times do we need to shuffle a deck of cards before it is sufficiently random?

See #link("https://youtu.be/KZeIEiBrT_w?si=bvamNeo_-fDDLxxx", "Veritasium: The Strange Math That Predicts (Almost) Anything") for a nice video on Markov chains.


#pagebreak()
= Theory

#definition(name: [Discrete-time stochastic process])[
  A discrete-time stochastic process is a family of random variables ${X_t : t in T}$ where $T$ is discrete.

  We call $X_t$ the _state_ at time $t$, and the set of all possible states the _state space_.
]

#definition(name: [Discrete-time Markov chain])[
  A discrete-time Markov chain is a discrete-time stochastic process ${X_n : n in 0,1,dots}$ that satisfies the _Markov property_
  $
    P(X_(n+1) = j | X_n = i, X_(n-1) = i_(n-1), dots, X_0 = i_0) = P(X_(n+1) = j | X_n = i),
  $
  for $n = 0, 1, dots$ and for all states $i$ and $j$.
]

#definition(name: [One-step transition probabilities])[
  For a discrete-time Markov chain ${X_n : n in 0,1,dots}$, we call
  $
    P_(i, j)^(n,n+1) = P(X_(n+1) = j | X_n = i)
  $
  the _one-step transition probabilities_ from state $i$ to state $j$ at time $n$.

  Note that we will always assume stationary transition probabilities, meaning $P_(i, j)^(n,n+1) = P_(i, j)$ for all $n=0,1,dots$ and all states $i$ and $j$.
]

#example()[
  The Markov property and the stationarity assumptions can simplify transition probabilities, see that
  $
    P(X_(t+1) = j | X_t = i, X_(t-1) = i_(t-1), dots, X_0 = i_0) = P(X_(t+1) = j | X_t = i) = P(X_1 = j | X_0 = i) = P_(i j)
  $
  for all $t in T$. Similarly, it is a good exercise to show that
  $
    P(X_0 = i_0, dots, X_t = i_t) & = P(X_0 = i_0) P(X_1 = i_1 | X_0 = i_0) dot dots dot P(X_t = i_t | X_(t-1) = i_(t-1)) \
                                  & = P(X_0 = i_0) P_(i_0, i_1) dot dots dot P_(i_(t-1), i_t).
  $
]

#definition(name: [Transition probability matrix])[
  For a discrete-time Markov chain with a finite state space ${0,1,dots,N}$, we call
  $
    P = mat(
      P_(0,0), P_(0,1), dots, P_(0,N);
      P_(1,0), P_(1,1), , dots.v;
      dots.v, , dots.down, ;
      P_(N,0), dots, , P_(N,N)
    )
  $
  the _transition probability matrix_.

  Note that for an infinite state space ${0, 1, dots}$, we can envision an infinitely-sized matrix.
]

#definition(name: [Transition diagram])[
  Let ${X_n : n=0,1,dots}$ be a discrete-time Markov chain. A _state transition diagram_ visualizes the transition probabilities as a weighted directed graph, where the nodes are the states and the edges are the possible transitions marked with the transition probabilities.
]


#example(name: [Drawing transition diagrams])[
  For a state space $(0, 1, 2)$, consider the $3 times 3$ transition probability matrix
  $
    P = mat(
      0.5, 0.5, 0;
      0.25, 0.5, 0.25;
      0, 0.5, 0.5
    ).
  $<example-drawing-transition-diagrams>
  The corresponding transition diagram is

  #transition-figure()[
    #transition-diagram(
      ($0$, $1$, $2$),
      (
        (0.5, 0.5, 0),
        (0.25, 0.5, 0.25),
        (0, 0.5, 0.5),
      ),
    )
  ]<first-tranition-diagram>
]

#theorem(name: [$n$-step transition probabilities])[
  For a Markov chain ${X_n : n=0,1,dots}$ and any $m >= 0$, we have
  $
    P(X_(m+n) = j | X_m = i) = P_(i, j)^((n)) = sum_(k=0)^(oo) P_(i, k) P_(k, j)^((n-1)), quad n > 0,
  $
  where we define
  $
    P_(i, j)^((0)) = cases(
      1 "if" i = j,
      0 "otherwise"
    )
  $
]


#theorem()[
  The $n$-step transition probabilities can be computed be matrix multiplication. If $P^(n) = [P_(i, j)^((n))]$, then
  $
    P^(n) = underbrace(P dot P dot dots dot P, n) = P^n.
  $
]

#definition(name: [Hitting time])[
  For ${X_n: n= 0, 1, dots}$ be a Markov chain and $A$ be a set of states. The _hitting time_ of $A$ is the random variable
  $
    T_A = min {n >= 0 : X_n in A}
  $
]

#definition(name: [Absorbing state])[
  For a Markov chain, a state $i$ such that $P_(i,j) = 0$ for all $j != i$ is called absorbing. A set of states $A$ is absorbing if $P_(i,j) = 0$ for all $i in A$ and $j in.not A$.
]

#theorem()[
  Let ${X_n: n= 0, 1, dots}$ be a Markov chain with state space $S = {0, 1, dots, N}$ and transition probability matrix $P$. Let $A subset S$ be an absorbing set of states.
  - If $u_i$ is the probability of absorption in $j in A$ starting on $X_0 = i$. Then
    $
      u_i = P(X_(T_A) = j | X_0 = i) = cases(
        1 quad & "if" i = j,
        0 quad & "if" i in A "and" i != j,
        P_(i, j) + sum_(k in S \\ A) P_(i,k) u_k quad & "otherwise".
      )
    $
  - If $v_i = EE[T_A | X_0 = i]$ is the expected time until absorption starting on $X_0 = i$, then
    $
      v_i = cases(
        0 quad & "if" i in A,
        1 + sum_(k in S \\ A) P_(i,k) v_k quad & "otherwise"
      )
    $<thm-expected-time-to-absorption>
]

For next week, we are interested in exploring the long-term behavior of Markov chains, meaning determining the limit
$
  lim_(n -> oo) P_(i, j)^((n)) = lim_(n -> oo) P(X_n = j | X_0 = i).
$
This is one of the most important questions in Markov chain theory, and we will see some interesting applications!




#pagebreak()
#problem(name: [Problem 1 in Exercise 2])[
  Consider the Markov chain ${X_n : n = 0, 1, 2, ...}$ with state space $Omega = {"A", "B", "C"}$ and transition probability
  matrix given by
  $
    P = mat(
      0.1, 0.7, 0.2;
      0.5, 0.1, 0.4;
      0.3, 0.6, 0.1;
    )
  $
  The probability distribution of the initial state $X_0$ is given by $P(X_0 = "A") = 0.2$, $P(X_0 = B) = 0.5$ and $P(X_0 = C) = 0.3$. Compute the following probabilities:
  - $P(X_3 = "A")$
  - $P(X_3 = "A" | X_1 = "B", X_0 = "A")$
  - $P(X_6 = "A" | X_3 = "C")$
  - $P(X_3 = "C" | X_6 = "A")$

  Note that
  $
    P^(2) = mat(
      0.42, 0.26, 0.32;
      0.22, 0.6, 0.18;
      0.36, 0.33, 0.31;
    )
    quad "and" quad
    P^(3) = mat(
      0.268, 0.512, 0.220;
      0.376, 0322, 0.302;
      0.294, 0.471, 0.235;
    ).
  $

]
#solution()[
  - By the law of total probability, we have
    $
      P(X_3 = "A") & = sum_(k in {"A", "B", "C"}) P(X_3 = "A" | X_0 = k) P(X_0 = k) \
                   & = 0.268 * 0.2 + 0.376 * 0.5 + 0.294 * 0.3 \
                   & = 0.3298.
    $
  - By the Markov property, we have
    $
      P(X_3 = "A" | X_1 = "B", X_0 = "A") = P(X_3 = "A" | X_1 = "B") = P_("B", "A")^((2)) = 0.22.
    $
  - Again by the Markov property, we have
    $
      P(X_6 = "A" | X_3 = "C") = P(X_3 = "A" | X_0 = "C") = P_("C", "A")^((3)) = 0.294.
    $
  - Here we need to use Bayes' theorem, the law of total probabilities and the Markov properties. We have
    $
      P(X_3 = "C" | X_6 = "A")
      & = P(X_6 = "A" , X_3 = "C") / P(X_6 = "A") \
      & = (P(X_6 = "A" | X_3 = "C") P(X_3 = "C")) / (sum_(k in {"A", "B", "C"}) P(X_6 = "A" | X_3 = k) P(X_3 = k)) \
      & = (P(X_3 = "A" | X_0 = "C") P(X_3 = "C")) / (sum_(k in {"A", "B", "C"}) P(X_3 = "A" | X_0 = k) P(X_3 = k)) \
      &= 0.245
    $
]


#pagebreak()
#problem(name: [Exam August 2025])[
  On any given day Maria is either cheerful ($"C"$), so-so ($"S"$), or glum ($"G"$). If she is cheerful today, then she will be $"C"$, $"S"$, or $"G"$ tomorrow with respective probabilities $0.5$, $0.4$, $0.1$. If Maria is feeling so-so today, then she will be $"C"$, $"S"$, or $"G"$ tomorrow with probabilities $0.3$, $0.4$, $0.3$. If she is glum today, then she will be $"C"$, $"S"$, or $"G"$ tomorrow with probabilities $0.2$, $0.3$, $0.5$. Let $X_n$ denote Maria’s mood on day $n$.

  Do the following:
  - Explain that Maria’s mood is a three-state Markov chain.
  - Illustrate with a transition probability graph, and determine the transition probability matrix $P$.
  - Assume that Maria is cheerful at day $1$, what is the probability that she is cheerful at day $3$?
  - Are $X_0$ and $X_1$ independent random variables?
  - What is the mathematical definition of a stochastic process $X$? Use $X_0, X_1, dots$ to define the stochastic process $X$ in this case. What is the probability distribution of $X$ in this case?
]<problem-marias-mood>
#solution()[
  - Maria’s mood is a three-state Markov chain because the probability of her mood tomorrow depends only on her mood today, and not on her mood on previous days. This satisfies the Markov property.
  - The transition probability matrix $P$ is given by
    $
      P = mat(
        0.5, 0.4, 0.1;
        0.3, 0.4, 0.3;
        0.2, 0.3, 0.5
      ),
    $
    while the corresponding transition diagram is
    #transition-figure()[
      #transition-diagram(
        ($"C"$, $"S"$, $"G"$),
        (
          (0.5, 0.4, 0.1),
          (0.3, 0.4, 0.3),
          (0.2, 0.3, 0.5),
        ),
      )
    ]<marias-mood-tranition-diagram>

  - We can compute this probability by summing over all possible states at day $2$
    $
      P(X_2 = "C" | X_0 = "C") = & sum_(k in {"C", "S", "G"}) P(X_2 = "C" | X_1 = k) P(X_1 = k | X_0 = "C") \
                               = & P(X_1 = "C" | X_0 = "C") P(X_1 = "C" | X_0 = "C") \
                                 & + P(X_2 = "C" | X_1 = "S") P(X_1 = "S" | X_0 = "C") \
                                 & + P(X_2 = "C" | X_1 = "G") P(X_1 = "G" | X_0 = "C") \
                               = & 0.5 * 0.5 + 0.3 * 0.4 + 0.1 * 0.2 = 0.39.
    $
    Alternatively, and in my opinion more elegant, we can use the $n$-step transition probabilities matrices. We have
    $
      P(X_2 = "C" | X_0 = "C") = P_("C", "C")^((2)),
    $
    and doing the matrix multiplication, we find
    $
      P^((2)) = P dot P = mat(
        0.5, 0.4, 0.1;
        0.3, 0.4, 0.3;
        0.2, 0.3, 0.5
      ) dot mat(
        0.5, 0.4, 0.1;
        0.3, 0.4, 0.3;
        0.2, 0.3, 0.5
      ) = mat(
        0.39, 0.39, 0.22;
        0.33, 0.37, 0.30;
        0.29, 0.35, 0.36
      ).
    $
    Therefore $P(X_2 = "C" | X_0 = "C") = 0.39$. Alternatively,


  - Since we know the state at day $1$ is $X_1 = "C"$, the second day $X_2$ is independent of the first.
  - In Gunnars words: A stochastic process is an indexed family of random elements in a state space. The index set can be an arbitrary non-empty set. The state space can be an arbitrary sample space $S$. Each random element is a function $X_i : Omega -> S$ so that
    $
      X_i^(-1)(A) = {omega in Omega : X_i (omega) in A}
    $
    is an event in $S$. The probability distribution of a stochastic process is defined by all finite dimensional distributions. In this particular case it is determined by
    $
      P(X_1 = x_1, dots, X_n = x_n) = f(x_1, dots, x_n) = f(x_1) f(x_2 | x_1) dot dots dot f(x_n | x_(n-1))
    $
    with $x_i in {"C", "S", "G"}$ and where $f(x_i|x_(i-1)) = P_(i-1, i)$.

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
      P = mat(
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
  - As we have two zones, the state space is ${"A", "B"}$. The index set of the stochastic process is ${0, 1, dots}$, where $0$ corresponds to the initial fare and $n$ corresponds to the $n$-th fare.
  - We have $X_0 = "A"$, and want to compute $P(X_2 = "A" | X_0 = "A")$ and $P(X_4 = "A" | X_0 = "A")$. Using the transition matrix, we can compute
    $
      P^((2))
      = P dot P
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
      P^((4))
      = P^(2) dot P^(2)
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
      P(X_2 = "A" | X_0 = "A") = P^((2))_(0, 0) = 0.48
      quad "and" quad
      P(X_4 = "A" | X_0 = "A") = P^((4))_(0, 0) = 0.4332.
    $
]


#problem(name: "Expected time to absorption")[
  Let ${X_n | n = 0, 1, dots}$ be  a Markov chain with transition probability matrix
  $
    P = mat(
      1, 0, 0;
      alpha, beta, gamma;
      0, 0, 1;
    ),
  $
  where $alpha, beta, gamma > 0$ and $alpha + beta + gamma = 1$. Assume $x_0 = 1$.
  - What is the probability of absorption in state $0$?
  - What is the expected time until absorption in state $0$ or $2$?
]
#solution()[
  - For $T_A = min {n >= 0: X_n in A}$ we denote $u_i = P(X_(T_A) = 0 | X_0 = i)$ for $i = 0, 1, 2$. We want to find $u_1$. Clearly, $u_0 = 1$ and $u_2 = 0$. For $i = 1$, we have
    $
      u_1 & = sum_(k in {0, 1, 2}) P(X_(T_A) = 0, X_1 = k | X_0 = 1) \
          & = sum_(k in {0, 1, 2}) P(X_(T_A) = 0 | X_1 = k, X_0 = 1) P(X_1 = k | X_0 = 1) \
          & = sum_(k in {0, 1, 2}) P(X_(T_A) = 0 | X_1 = k) P_(1, k) \
          & = sum_(k in {0, 1, 2}) u_k P_(1, k) \
          & = u_0 alpha + u_1 beta + u_2 gamma \
          & = alpha + beta u_1.
    $
    Hence, we have
    $
      u_1 = alpha / (1 - beta) = alpha / (alpha + gamma).
    $
  - Using @thm-expected-time-to-absorption, we see that $v_0 = v_2 = 0$, while
    $
      v_1 & = 1 + sum_(k in {0, 1, 2}) P_(1, k) v_k \
          & = 1 + P_(1, 1) v_1 \
          & = 1 + beta v_1.
    $
    Hence, we have
  $
    v_1 = 1 / (1 - beta) = 1 / (alpha + gamma).
  $
]
