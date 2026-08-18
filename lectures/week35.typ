#import "@local/icml:1.0.0": *
#import "@preview/muchpdf:0.1.2": muchpdf

#import "@preview/lemmify:0.1.7": default-theorems, new-theorems, thm-numbering-heading
#import "@preview/fletcher:0.5.8" as fletcher: diagram, edge, node

#show: icml.with(
  title: [
    Discrete-time Markov Chains
  ],

  authors: (
    (
      name: "Elling Svee",
      email: "elling.svee@ntnu.no",
    ),
  ),
  n_columns: 1,
  paper-size: "a4",
  // bibliography: bibliography("refs.bib"),
)

= Relevant theory

#definition(name: [Discrete-time stochastic process])[
  A discrete-time stochastic process is a family of random variables
  $
    {X_t : t in T}
  $
  where $T$ is discrete. Note that we call $X_t$ the _state_ at time $t$, and the set of all possible states the _state space_.
]

#definition(name: [Discrete-time Markov chain])[
  A discrete-time Markov chain is a discrete-time stochastic process ${X_n : n = 0,1,...}$ that satisfies the Markov property
  $
    P {X_(n+1) = j | X_n = i, X_(n-1) = i_(n-1), ..., X_0 = i_0 } = P { X_(n+1) = j | X_n = i }
  $
  for $n = 0,1,2,...$, and for all states $i$ and $j$.
]

#definition(name: [One-step transition probabilities])[
  For a discrete-time Markov chain ${X_n : n = 0,1,...}$,
]

= Problems

#problem(name: "Exam 2025, Question 1")[
  Hello
]
#solution[
  Hello answer
]
