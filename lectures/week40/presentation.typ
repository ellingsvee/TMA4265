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
  aspect-ratio: "16-9",
)

#title-slide[
  = Week 40: More on continuous-time Markov Chains
]

== Repetition from last week
#definition(name: [Continuous-time Markov Chain])[
  A stochastic process ${X(t): t >= 0}$ with discrete state space $cal(S)$ that satisfies the Markov property and has stationary transition probabilities.
]

*Recall:*
- Markov property:
  $
    P(X(s+t) = j | X(s) = i, X(u) = x(u), 0 <= u < s) = P(X(t+s) = j | X(s) = i).
  $
- Stationary transition probabilities: $ P(X(s+t) = j | X(s) = i) = P(X(t) = j | X(0) = i). $
- Transition probability function $P_(i,j)(t) = P(X(t) = j | X(0) = i)$

== Repetition from last week
#theorem()[
  In a birth-and-death process with birth rates $lambda_i$ and death rates $mu_i$, the following holds:
  - Independent sojourn times.
  - $S_i tilde.op "Exp"(lambda_i + mu_i)$ for $i>=0$.
  - Jump probabilities in state $i$
  $
    P(i -> i-1) = mu_i / (lambda_i + mu_i) quad "and" quad P(i -> i+1) = lambda_i / (lambda_i + mu_i).
  $
]


= This week
==
#theorem(name: [Forward Kolmogorov differential equations])[
  For a birth-and-death process on $cal(S) = {0, 1, 2, dots}$, the $P_(i,j)(t)$ satisfy  $ P_(i,0)^' (t) &= -lambda_0 P_(i,0)(t) + mu_1 P_(i,1)(t), quad t >= 0 \
  P_(i,j)^' (t) &= lambda_(j-1) P_(i,j-1)(t) - (lambda_j + mu_j) P_(i,j)(t) + mu_(j+1) P_(i,j+1)(t), quad t >= 0, quad j >= 1, $
  with initial conditions $P_(i,j)(0) = delta_(i,j)$.
]


*Trick:* Solve using integrating factor. For ODE/IVP
$
  (dif y)/(dif x) + P(x) y = Q(x)
$
we multiply each side by $mu(x) = exp(integral P(x) dif x)$ and use the product rule.

== Problem
A machine works ($1$) or is broken ($0$). Time to breakdown is $"Exp"(mu)$, and time to repair is $"Exp"(lambda)$, and all sojourn times are independent. The machine works at time $t=0$. Calculate the probability that the machine works at time $t=10$.

== Problem
A pure birth process starting from $X(0) = 0$ has birth parameters
$
  lambda_0 = 1, quad lambda_1 = 3, quad lambda_2 = 2, quad lambda_3 = 5.
$
Let $W_1$, $W_2$ and $W_3$ be the stochastic times it takes the process to reach states $1$, $2$ and $3$.
+ Determine the transition probability functions
  $
    P_n (t) = P(X(t) = n|X(0) = 0), quad n = 0, 1, 2, 3.
  $
+ Write $W_3$ as a sum of sojourn times and thereby deduce that the mean time is $EE[W_3] = 11\/6$.
+ Determine the mean of $W_1 + W_2 + W_3$.
+ Determine the variance of $W_3$.


==
#theorem()[
  For a birth-and-death process without absorbing states,
  $
    pi_j = lim_(t->oo) P_(i, j)(t), quad j = 0, 1, dots,
  $
  exists and are not dependent on $i$.

  *Remarks:*
  - If $sum_(j = 0)^(oo) pi_j = 1$, the $bold(pi) = (pi_0, pi_1, dots)^top$is called a limiting distribution.
  - If the limiting distribution exists, it is also a stationary distribution
    $
      pi_j = sum_(i = 0)^(oo) pi_i P_(i, j)(t), quad j = 0, 1, dots, quad t >= 0.
    $
]

== Towards some practical formulas

- Kolmogorov forward equations
  $
    P_(i,0)^' (t) &= -lambda_0 P_(i,0)(t) + mu_1 P_(i,1)(t), quad t >= 0 \
    P_(i,j)^' (t) &= lambda_(j-1) P_(i,j-1)(t) - (lambda_j + mu_j) P_(i,j)(t) + mu_(j+1) P_(i,j+1)(t), quad t >= 0, quad j >= 1,
  $
- Take the limit $t -> oo$ and use that $P_(i,j)^' (t) -> 0$
  $
    0 & = -lambda_0 pi_0 + mu_1 pi_1, \
    0 & = lambda_(j-1) pi_(j-1) - (lambda_j + mu_j) pi_j + mu_(j+1) pi_(j+1), quad j >= 1.
  $
- Reorganize to get
  $
             lambda_0 pi_0 & = mu_1 pi_1, \
    (lambda_j + mu_j) pi_j & = lambda_(j-1) pi_(j-1) + mu_(j+1) pi_(j+1), quad j >= 1.
  $

==
#theorem()[
  When the limiting distribution $bold(pi)$ exists, it is the unique solution to
  $
             lambda_0 pi_0 & = mu_1 pi_1, \
    (lambda_j + mu_j) pi_j & = lambda_(j-1) pi_(j-1) + mu_(j+1) pi_(j+1), quad j >= 1, \
     sum_(j = 0)^(oo) pi_j & = 1.
  $

  *Remark:* This is quite intuitive, as "Rate in = Rate out" with "Rate" being the number of events per unit time.
  // - "Rate in" $= pi_(i-1) lambda_(i-1) + pi_(i+1)mu_(i+1)$. Here $pi_(i-1)$ is the proportion of time in state $i-1$, and $lambda(i-1)$ is the rate of leaving state $i-1$ to state $i$.
]<thm:limiting-distribution-unique-solution>

== Problem
Consider a CTMC
#transition-figure()[
  #transition-diagram(
    ($0$, $1$),
    (
      (0, $lambda$),
      ($mu$, 0),
    ),
    node-radius: 10.0mm,
    node-stroke: 1.5pt,
    edge-stroke: 1.5pt,
    label-size: 18pt,
    positions: ((0, 0), (3, 0)),
  )
]
with $lambda, mu > 0$. Derive the long-run proportion of time spent in state $0$.

==

#theorem()[
  For a birth-and-death process without absorbing states, we have
  $
    pi_i = theta_i pi_0 = theta_i / (sum_(k = 0)^(oo) theta_k), quad i = 0, 1, dots,
  $
  where $theta_0 = 1$ and
  $
    theta_i = lambda_0 / mu_1 dot lambda_1 / mu_2 dot dots dot lambda_(i-1) / mu_i = (product_(j = 0)^(i-1) lambda_j)/(product_(j = 1)^(i) mu_j), quad i = 1, 2, dots.
  $
]<thm:limiting-distribution-unique-solution-without-absorbing-states>



== Problem
Consider a CTMC
#transition-figure()[
  #transition-diagram(
    ($0$, $1$, $2$),
    (
      (0, 1, 0),
      (4, 0, 4),
      (0, 1, 0),
    ),
    positions: ((0, 0), (2, 0), (4, 0)),
    loop-angles: (180deg, 90deg, 0deg),
    node-radius: 10.0mm,
    node-stroke: 1.5pt,
    edge-stroke: 1.5pt,
    label-size: 18pt,
  )
]
Calculate $pi_0$, $pi_1$ and $pi_2$.





//
// == Problem: Continuation of parking garage example
// Assume that a parking garage has a maximum capacity of $20$ cars and is always open. The arrival of cars is a Poisson process with rate $lambda = 0.5 "cars"\/"min"$, where cars will drive past the garage (and not form a queue) if the parking garage is full. The cars spend, independently of each other and their arrival times, a stochastic time in the parking garage. Each stochastic time follows an exponential distribution with expected value $1\/mu = 30 "minutes"$. After the time in the parking garage ends, the car immediately exists the parking garage. In the exercise sheet for week 41, you found the birth and death rates of the resulting birth-and-death process.
// + Determine the limiting probabilities $pi_i$ for $i = 0, 1, dots , 20$ as functions of $lambda$ and $mu$. Derive a practical formula for computing the numerical value of $pi_20$.
// + Compute the numerical value of the long-run mean number of cars in the parking garage.
//
//

// == Problem
// #text(size: 18pt)[
//   A tourist guide can be hired to give sightseeing tours with his boat. If the guide is free, the time it takes an interested tourist to negotiate the price is exponentially distributed with mean $1\/mu_1$. Assume that the probability that no agreement is reached and the tourist leaves is $0 < alpha < 1$. If the tourist and the guide reach an agreement, they immediately start the tour. The duration of the tour is exponentially distributed with mean $1\/mu_2$. Assume that interested tourists arrive at the harbor according to a Poisson process with rate $lambda$, but will not wait in line and leave immediately if the guide is not free. Assume further that the Poisson process, the negotiation time, the duration of the tour and whether the tourist and the guide achieve an agreement are independent.
//   + Compute the long-run mean proportion of time that the guide is free.
//   + You arrive at the harbor and see that the guide is currently negotating with a potential customer. Determine the expected time you would need to wait until the guide is free.
//   + Determine the long-run proportion of the $lambda$ tourists that arrive per time unit that will go on a sightseeing tour.
// ]


== Problem: Exam 2021 (Part 1)
#text(size: 18pt)[
  Customers arrive in a store according to a Poisson process with rate $lambda=60$ customers per hour. The store has one server, and all customers in the service area are either in service or waiting in a queue. An arrival begins service immediately if the server is idle. If the server is busy, the customer joins the queue with probability $1$ when there are at most two customers in the service area. With three or more, the customer joins the queue with probability $0<p<1$, or leaves immediately with probability $1-p$. Joining decisions are independent across customers. Service times are i.i.d. exponential with mean $1\/mu=6$ minutes and are independent of the arrival process. Whenever service is completed, the customer at the front of the queue immediately begins service.

  Let $X(t)$ denote the number of customers either queuing or receiving service at time $t$.
  - Assume that time is measured in hours, and determine the birth rates and the death rates as functions of $p$. Draw the transition diagram.
  - Let $p=0.1$, and assume that there are currently three customers queuing or receiving service.
    - Calculate the probability that exactly two customers finish their service times before the next customer joins the queue.
    - Calculate the expected time until the next customer joins the queue.
]

==
#theorem()[
  For a birth-and-death process ${X(t): t >= 0}$ with state space $cal(S)$, let $A subset cal(S)$ and let
  $
    v_i = EE[min {t >= 0: X(t) in A} | X(0) = i], quad i in cal(S).
  $
  If there are no absorbing states outside $A$, the expected times can be found by solving
  $
                                           v_i & = 0, quad                                                &     i in A, \
    v_i = EE[S_i] + sum_(j != i) P(i -> j) v_j & = 1/(lambda_i + mu_i) + sum_(j != i) P(i -> j) v_j, quad & i in.not A.
  $
  // Remark:
  // - Similarly, for DTMC we had $v_i = 1 + sum_(j in cal(S)) P_(i,k) v_k$ for $i in.not A$. Do not mix these two equations!
  *Remark:* This is close to the first-step analysis we did for DTMCs.
]


== Problem: Exam 2021 (Part 2)
#text(size: 18pt)[
  Customers arrive in a store according to a Poisson process with rate $lambda=60$ customers per hour. The store has one server, and all customers in the service area are either in service or waiting in a queue. An arrival begins service immediately if the server is idle. If the server is busy, the customer joins the queue with probability $1$ when there are at most two customers in the service area. With three or more, the customer joins the queue with probability $0<p<1$, or leaves immediately with probability $1-p$. Joining decisions are independent across customers. Service times are i.i.d. exponential with mean $1\/mu=6$ minutes and are independent of the arrival process. Whenever service is completed, the customer at the front of the queue immediately begins service.

  - Derive the limiting probabilities $pi_i = lim_(t -> oo) P(X(t) = i)$ for $i = 0, 1, dots$ as functions of $p$.
  - What is the necessary condition on $p$ for ${X(t): t>=0}$ to have a limiting distribution? Give an intuitive explanation for the condition.
]

== Connection between CTMCs and DTMCs
#theorem()[
  For a birth-and-death process with absorbing states, the absorption probabilities are computed using the discrete-time Markov chain with one-step transition probabilities given by
  $
    P_(i, j) = P(i -> j), quad i != j,
  $
  and
  $
    P_(i, i) = cases(
      0 quad & "if" lambda_i + mu_i > 0,
      1 quad & "if" lambda_i + mu_i = 0
    ), quad i = 0, 1, dots.
  $
]


== Problem
Consider a CTMC
#transition-figure()[
  #transition-diagram(
    ($0$, $1$, $2$, $3$),
    (
      (0, 1, 0, 0),
      (3, 0, 2, 0),
      (0, 4, 0, 2),
      (0, 0, 4, 0),
    ),
    positions: ((0, 0), (2, 0), (4, 0), (6, 0)),
    node-radius: 10.0mm,
    node-stroke: 1.5pt,
    edge-stroke: 1.5pt,
    label-size: 18pt,
  )
]
Let $X(0) = 1$, compute the probability that we reach state $3$ before state $0$.

== Info about interactive lectures.
- I am going on a research visit to Emory University in Atlanta.
- No interactive lecture from week 41 to week 45.
- I will be back for week 46, and continue interactive lectures then.
- If any questions, ask on forum or by email.
- Good luck!

