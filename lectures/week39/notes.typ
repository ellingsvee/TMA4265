#import "../templates/tma4265-notes.typ": *
#import "@preview/muchpdf:0.1.2": muchpdf

#import "@preview/lemmify:0.1.7": default-theorems, new-theorems, thm-numbering-heading
#show figure.where(kind: "solution-group"): set block(breakable: true)

#import "../utils.typ": transition-diagram, transition-figure


#show link: set text(fill: blue)


#show: icml.with(
  title: [
    Week 39: Continuous-time Markov Chains
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

#let bf(x) = math.bold(math.upright(x))


_These notes are written by myself, and errors may and will occur. When in doubt, trust the book and Gunnars lectures!_


= Theory

#definition(name: [Continuous-time Markov Chain])[
  A continuous-time Markov Chain (CTMC) is a stochastic process ${X(t): t >= 0}$ with discrete state space $cal(S)$ that satisfies the Markov property.

  Remarks:
  - Markov property:
    $
      P(X(s+t) = j | X(s) = i, X(u) = x(u), 0 <= u < s) = P(X(t+s) = j | X(s) = i) quad forall s>=0, t>0,quad i,j in cal(S).
    $
  - Stationary transition probabilities:
    $
      P(X(s+t) = j | X(s) = i) = P(X(t) = j | X(0) = i) quad forall s>=0, t>0, quad i,j in cal(S).
    $
  // - In this course, we assume CTMC $=$ "Stationary" $+$ $cal(S) = {0, 1, 2, dots}$ unless otherwise stated.
]

// #example()[
//   We can show that a Poisson process ${X(t): t>=0}$ with rate $lambda$ satisfies the Markov property. Clearly, it has a discrete state space $cal(S) = {0, 1, 2, dots}$. For all $s>=0$, $t>0$ and $i,j in cal(S)$, we have
//   $
//     P(X(s+t) = j | X(s) = i, X(u) = x(u), 0 <= u < s) & = P(X(s+t) - X(s) = j-i) \
//                                                       & = P(X(s + t) = j | X(s) = i).
//   $
// ]

#definition(name: [Transition probability functions])[
  Let ${X(t): t>=0}$ be a CTMC with state space $cal(S)$. We call
  $
    P_(i j)(t) = P(X(t) = j | X(0) = i), quad t >= 0, quad i,j in cal(S)
  $
  the transition probability functions.
]

#example()[
  For a Poisson process ${X(t): t>=0}$ with rate $lambda$, we have
  $
    P_(i j)(t) & = P(X(t) = j | X(0) = i) \
               & = P(X(t) - X(0) = j-i) \
               & = cases(
                   (lambda t)^(j-i) / (j-i)! e^(-lambda t) quad & j >= i,
                   0 quad & "otherwise"
                 )
  $
]

#definition(name: [Birth-and-death process])[
  Let ${X(t): t>=0}$ be a CTMC with state space $cal(S) = {0, 1, 2, dots}$, and let
  $
    P_(i j)(t) = P(X(t) = j | X(0) = i), quad t >= 0, quad i,j in cal(S).
  $
  Then ${X(t): t>=0}$ is called a birth-and-death with birth rates $lambda_i$ and death rates $mu_i$ if $P_(i j)(t)$ satisfies
  + $P_(i, i+1)(h) = lambda_i h + "o"(h)$ as $h -> 0^+$ for $i>=0$.
  + $P_(i, i-1)(h) = mu_i h + "o"(h)$ as $h -> 0^+$ for $i>=1$.
  + $P_(i, i)(h) = 1 - (lambda_i + mu_i)h + "o"(h)$ as $h -> 0^+$ for $i>=0$.
  + $P_(i, i)(0) = delta_(i, j)$.
  + $mu_0 = 0$, $lambda_0 > 0$, and $lambda_i, mu_i > 0$ for $i>=1$.

  Remarks:
  - At most two possible jumps: $i -> i+1$ and $i -> i-1$.
  - Birth and death rates are called transition rates.
]

#definition(name: [Pure birth and death processes])[
  - Pure birth process: $mu_i = 0$ for all $i>=0$.
  - Pure death process: $lambda_i = 0$ for all $i>=1$.

  Remarks:
  - A Poisson process is a pure birth process with $lambda_i = lambda$ for all $i>=0$.
]

#theorem(name: [Chapman-Kolmogorov])[
  For a CTMC, $P_(i,j)(s+t) = sum_(k=0)^(oo) P_(i,k)(s) P_(k,j)(t)$ for all $t,s>=0$ and $i,j in cal(S)$.
]
#proof()[
  By the law of total probability
  $
    P_(i,j)(s+t) & = P(X(s+t) = j | X(0) = i) \
                 & = sum_(k = 0)^(oo) P(X(s) = k | X(0) = i) P(X(s+t) = j | X(s) = k, X(0) = i) \
                 & = sum_(k = 0)^(oo) P_(i,k)(s) P_(k,j)(t)
  $
]

#theorem()[
  In a pure birth process with $lambda_i>0$ for all $i>=0$, the sojourn times are independent and $S_i tilde.op "Exp"(lambda_i)$.

  Remark: This fully characterizes pure birth processes, and provides an alternative definition.
]

#theorem()[
  Ina  pure death process with starting state $N$ (where $mu_i > 0$ for $i = 1, dots, N$), the sojourn times are independent and $S_i tilde.op "Exp"(mu_i)$ for $i = 1, dots, N$.
]

#theorem()[
  If $T_i tilde.op "Exp"(alpha_i)$ for $i = 1, dots, n$ are independent, then
  $
    min(T_1, dots, T_n) tilde.op "Exp"(sum_(i=1)^n alpha_i).
  $
]

#theorem()[
  $T tilde.op "Exp"(lambda)$ is memoryless, meaning $P(T > s+t | T > s) = P(T > t)$ for all $s,t >= 0$.

  Remark: $"Exp"(lambda)$ is the only memoryless continuous distribution on $(0,oo)$.
]

// #example()[
//   Consider two individuals. Individual $1$ dies at time $T_1$, and individual $2$ dies at time $T_2$. Assume $T_1, T_2 tilde.op^("iid") "Exp"(alpha)$ for $alpha>0$. Define ${X(t): t >= 0}$ be
//   $
//     X(t) = \# "of individuals alive at time" t.
//   $
//   Is this a CTMC?
//   - For it to be a CTMC, we must check
//     $
//       "CT MC" <==> cases(
//         1. " " S_2 tilde.op "Exp"(mu_2),
//         2. " " S_1 tilde.op "Exp"(mu_1),
//         3. " " S_1 "and" S_2 "are independent"
//       ).
//     $
//     As $S_2 = min{T_1, T_2}$, independent exponentials give that $S_2 tilde.op "Exp"(2 alpha)$. After individual $1$ (or $2$) dies, $T_2$ (or $T_1$) has no memory, and $S_1 tilde.op T_1 tilde.op "Exp"(alpha)$. We also have independence, so it is indeed a CT MC
//
//   Is it a birth-and-death process?
//   - Yes, it is a pure death process.
//
//   Determine the birth and death rates:
//   - $mu_2 = 2 alpha$, $mu_1 = alpha$, and $lambda_0 = lambda_1 = lambda_2 = 0$.
// ]


#theorem()[
  In a birth-and-death process with birth rates $lambda_i$ and death rates $mu_i$ for $i>=0$, we have
  - Sojourn times are independent.
  - $S_i tilde.op "Exp"(lambda_i + mu_i)$ for $i>=0$.
  - Jump probabilities in state $i$ are
    $
      P(i -> i-1) = mu_i / (lambda_i + mu_i), quad P(i -> i+1) = lambda_i / (lambda_i + mu_i).
    $

  Remark:
  - This is also valid for a finite state space $cal(S) = {0, 1, dots, N}$ and $lambda_N = 0$.
  - Here we use the term jump probability from state $i$ to state $j$ to denote the probability that the next transition in state $i$ will be to state $j$.
]


#definition(name: [Alternative definition of birth-and-death processes])[
  The birth and death process with birth rates ${lambda_i}$ and death rates ${mu_i}$ can be constructed in the following way.

  In each state $i$, there are two independent competing processes
  + $T_1 = "Time until birth" tilde.op "Exp"(lambda_i)$
  + $T_2 = "Time until death" tilde.op "Exp"(mu_i)$
  and
  + $"Sojourn time" = min{T_1, T_2}$
  + If $T_1 < T_2$ then $i -> i+1$ (birth), else $i -> i-1$ (death).

  Remark: $P(T_1 < T_2) = lambda_i\/(lambda_i + mu_i)$ and $S_i = min{T_1, T_2} tilde.op "Exp"(lambda_i + mu_i)$.
]

#theorem()[
  Under suitable regularity conditions
  $
    P_(i,0)^' (t) &= -lambda_0 P_(i,0)(t) + mu_1 P_(i,1)(t), quad t >= 0 \
    P_(i,j)^' (t) &= lambda_(j-1) P_(i,j-1)(t) - (lambda_j + mu_j) P_(i,j)(t) + mu_(j+1) P_(i,j+1)(t), quad t >= 0, quad j >= 1,
  $
  with initial conditions $P_(i,j)(0) = delta_(i,j)$. These are called the forward Kolmogorov differential equations.

  Remark:
  - Suitable is referring to non-explosive behavior. E.g. for a pure birth process we must have $sum_(i=0)^(oo) 1\/lambda_i = oo$.
]

#theorem()[
  For a birth-and-death without absorbing states, the limiting probabilities
  $
    pi_j = lim_(t -> oo) P_(i,j)(t), quad j = 0, 1, dots
  $
  exist and are not dependent on the state $i$.

  Remark: If $sum_(j = 0)^oo pi_j = 1$, then $bold(pi) = (pi_0, pi_1, dots)^top$ is called the limiting (probability) distribution.
]

#theorem()[
  When the limiting distribution exists, it is the unique solution of
  - $lambda_0 pi_0 &= mu_1 pi_1$
  - $(lambda_j + mu_j) pi_j = lambda_(j-1) pi_(j-1) + mu_(j+1) pi_(j+1)$ for $j >= 1$
  - $sum_(j = 0)^(oo) pi_j = 1$

  Remarks:
  - This also works for finite state spaces $cal(S) = {0, 1, dots, N}$ with $lambda_N = 0$ and $mu_N > 0$.
  - There must be balance for each state: "Rate in" = "Rate out".
]


#pagebreak()
#problem()[
  Consider the birth-and-death process with $cal(S) = {0, 1, 2}$, birth rates $lambda_0 = 5$, $lambda_1 = 4$ and $lambda_2 = 0$, and death rates $mu_1 = 3$ and $mu_2 = 7$.
  + Draw the transition diagram.
  + Calculate expected sojourn times.
  + Calculate the probability that state $2$ follows state $1$.
  + Assume $X(0) = 0$. Calculate the probability that two consecutive births occur.
]
#solution()[
  + The transition diagram is
    #transition-figure()[
      #transition-diagram(
        ($0$, $0$, $2$),
        (
          (0, 5, 0),
          (3, 0, 4),
          (0, 7, 0),
        ),
        positions: ((0, 0), (2, 0), (4, 0)),
        loop-angles: (180deg, 90deg, 0deg),
      )
    ]
  + We use that the sojourn times are exponentially distributed with rate $lambda_i + mu_i$. Thus
    $
      EE[S_0] & = 1\/lambda_0 = 1\/5, \
      EE[S_1] & = 1\/(lambda_1 + mu_1) = 1\/(4 + 3) = 1\/7, \
      EE[S_2] & = 1\/mu_2 = 1\/7.
    $
  + By the jump probabilities, we have
    $
      P(1 -> 2) = lambda_1 / (lambda_1 + mu_1) = 4/7.
    $
  + Using the Markov property, we have
    $
      P(0 -> 1 -> 2) = P(0 -> 1) P(1 -> 2) = lambda_0 / (lambda_0 + mu_0) dot lambda_1 / (lambda_1 + mu_1) = 5/5 dot 4/7 = 4/7.
    $
]

#problem()[
  A machine works ($1$) or is broken ($0$). Time to breakdown is $"Exp"(mu)$, and time to repair is $"Exp"(lambda)$. All sojourn times are independent. The machine works at time $t=0$. Calculate the probability that the machine works at time $t=10$.
]
#solution()[
  We have
  $
    X(t) = cases(
      1 quad & "machine works at time" t,
      0 quad & "machine broken at time" t
    ),
  $
  and the goal is to find $P_(1, 1)(10) = P(X(10) = 1 | X(0)l = 1)$. By the forward Kolmogorov differential equations, we have
  $
    P_(1, 1)^' (t) & = lambda P_(1, 0)(t) - mu P_(1, 1)(t), \
    P_(1, 0)^' (t) & = 1 - P_(1, 1)(t)
  $
  for $t >= 0$ with initial conditions $P_(1, 1)(0) = 1$ and $P_(1, 0)(0) = 0$. Solving this system
  $
    & P_(1, 1)(t) + mu P_(1, 1)(t) = lambda [1 - P_(1, 1)(t)] \
    & <==> P_(1, 1)^' (t) + (lambda + mu) P_(1, 1)(t) = lambda "and" P_(1, 1)(0) = 1 \
    & ==> P_(1, 1)(t) = mu/(lambda + mu) e^(-(lambda + mu)t) + lambda/(lambda + mu).
  $
  Therefore, we have
  $
    P_(1, 1)(10) = mu/(lambda + mu) e^(-10(lambda + mu)) + lambda/(lambda + mu).
  $
]
