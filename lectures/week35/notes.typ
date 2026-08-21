
#import "../templates/tma4265-notes.typ": *
#import "@preview/muchpdf:0.1.2": muchpdf

#import "@preview/lemmify:0.1.7": default-theorems, new-theorems, thm-numbering-heading
#show figure.where(kind: "solution-group"): set block(breakable: true)

#import "@preview/fletcher:0.5.8" as fletcher: diagram, edge, node

#import "../utils.typ": transition-diagram

// The ICML template floats figures of kind `image`.  Lemmify's examples and
// solutions are themselves figure-based blocks, so a nested floating figure
// may be placed outside its enclosing block.  Give transition diagrams their
// own non-floating figure kind instead.
#let transition-figure(body, caption: none) = figure(
  body,
  caption: if caption == none { none } else { h(0.25em) + caption },
  kind: "transition-diagram",
  supplement: [Figure],
)

#show link: set text(fill: blue)
#set math.mat(delim: "[")


#show: icml.with(
  title: [
    Week 35: Introduction to discrete-time Markov chains
  ],

  authors: (
    (
      name: "Elling Svee (elling.svee@ntnu.no)",
      // email: "elling.see@nine.no",
    ),
  ),
  n_columns: 1,
  paper-size: "a4",
  bibliography: bibliography("../refs.bib"),
)

#show figure.where(kind: "solution-group"): set block(breakable: true)

_These notes are written by myself, and errors may and will occur. When in doubt, trust the book and Gunnars lectures!_

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




#example(name: [Drawing transition diagrams])[
  For a state space $(0, 1, 2)$, consider the $3 times 3$ transition probability matrix
  $
    P = mat(
      0.5, 0.5, 0;
      0.25, 0.5, 0.25;
      0, 0.5, 0.5
    ).
  $<example-drawing-transition-diagrams>
  The corresponding transition diagram is illustrated in @first-tranition-diagram.

  #transition-figure(caption: [Transition diagram for @example-drawing-transition-diagrams])[
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


#pagebreak()
#problem(name: [Exam August 2025])[
  On any given day Maria is either cheerful ($"C"$), so-so ($"S"$), or glum ($"G"$). If she is cheerful today, then she will be $"C"$, $"S"$, or $"G"$ tomorrow with respective probabilities $0.5$, $0.4$, $0.1$. If Maria is feeling so-so today, then she will be $"C"$, $"S"$, or $"G"$ tomorrow with probabilities $0.3$, $0.4$, $0.3$. If she is glum today, then she will be $"C"$, $"S"$, or $"G"$ tomorrow with probabilities $0.2$, $0.3$, $0.5$. Let $X_n$ denote Maria’s mood on day $n$.

  Do the following:
  - Explain that Maria’s mood is a three-state Markov chain.
  - Illustrate with a transition probability graph, and determine the transition probability matrix $P$.
  - Assume that Maria is cheerful at day $1$, what is the probability that she is cheerful at day $3$?
  - Are $X_1$ and $X_2$ independent random variables?
  - What is the mathematical definition of a stochastic process $X$? Use $X_1, X_2, dots$ to define the stochastic process $X$ in this case. What is the probability distribution of $X$ in this case?
]<problem-marias-mood>
#solution()[
  - Maria’s mood is a three-state Markov chain because the probability of her mood tomorrow depends only on her mood today, and not on her mood on previous days. This satisfies the Markov property.
  - The transition diagram is illustrated in @marias-mood-tranition-diagram, and the transition probability matrix $P$ is given by
  $
    P = mat(
      0.5, 0.4, 0.1;
      0.3, 0.4, 0.3;
      0.2, 0.3, 0.5
    ).
  $


  #transition-figure(caption: [Transition diagram for @problem-marias-mood])[
    #transition-diagram(
      ($"C"$, $"S"$, $"G"$),
      (
        (0.5, 0.4, 0.1),
        (0.3, 0.4, 0.3),
        (0.2, 0.3, 0.5),
      ),
    )
  ]<marias-mood-tranition-diagram>

  - We compute
    $
      P(X_3 = "C" | X_1 = "C") = P(X_2 = "C" | X_0 = "C") = P_("C", "C")^((2))
    $
    Doing the matrix multiplication, we find
    $
      "TODO"
    $
    meaning that $P(X_3 = "C" | X_1 = "C") = 0.39$. Alternatively, we can compute this probability by summing over all possible states at day $2$
    $
      P(X_3 = "C" | X_1 = "C") & = sum_(k in {"C", "S", "G"}) P(X_3 = "C" | X_2 = k) P(X_2 = k | X_1 = "C") \
                               & = "TODO".
    $
  - Since we know the state at day $1$ is $X_1 = "C"$, the second day $X_2$ is independent of the first.
  - In Gunnars words: A stochastic process is an indexed family of random elements in a state space. The index set can be an arbitrary non-empty set. The state space can be an arbitrary sample space $S$. Each random element is a function $X_i : Omega -> S$ so that
    $
      X_i^(-1)(A) = {omega in Omega : X_i(omega) in A}
    $
    is an event in $S$. The probability distribution of a stochastic process is defined by all finite dimensional distributions. In this particular case it is determined by
    $
      P(X_1 = x_1, dots, X_n = x_n) = f(x_1, dots, x_n) = f(x_1) f(x_2 | x_1) dot dots dot f(x_n | x_(n-1))
    $
    with $x_i in {"C", "S", "G"}$,a and where $f(x_i|x_(i-1)) = P_(i-1, i)$.

]
