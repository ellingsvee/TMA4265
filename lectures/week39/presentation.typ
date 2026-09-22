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
  = Week 38: Continuous-time Markov Chains
]

== Recall from discrete-time Markov chains
#definition(name: [Discrete-time stochastic process])[
  A discrete-time stochastic process is a family of random variables ${X_t : t in T}$ where $T$ is discrete.
]
#definition(name: [Discrete-time Markov chain])[
  A discrete-time Markov chain is a discrete-time stochastic process ${X_t : t in 0,1,dots}$ that satisfies the _Markov property_
  $
    P(X_(t+1) = j | X_0 = i_0, dots, X_t = i_t) = P(X_(t+1) = j | X_t = i_t).
  $
]

#definition(name: [One-step transition probabilities])[
  For a discrete-time Markov chain ${X_t : t in 0,1,dots}$, we call
  $
    P_(i, j)^(t,t+1) = P(X_(t+1) = j | X_t = i)
  $
  the _one-step transition probabilities_ from state $i$ to state $j$ at time $t$.
]

= Theory

==
#definition(name: [Continuous-time Markov Chain])[
  A continuous-time Markov Chain (CTMC) is a stochastic process ${X(t): t >= 0}$ with discrete state space $cal(S)$ that satisfies the Markov property.


  For all $s >= 0$, $t > 0$, and $i,j in cal(S)$, we have
  - Markov property:
    $
      P(X(s+t) = j | X(s) = i, X(u) = x(u), 0 <= u < s) = P(X(t+s) = j | X(s) = i).
    $
  - Stationary transition probabilities: $ P(X(s+t) = j | X(s) = i) = P(X(t) = j | X(0) = i). $
]
== Problem (warm-up)
Show that the Poisson process ${X(t): t>=0}$ with rate $lambda$ satisfies the Markov property
$
  P(X(s+t) = j | X(s) = i, X(u) = x(u), 0 <= u < s) = P(X(t+s) = j | X(s) = i).
$

==

#definition(name: [Transition probability functions])[
  Let ${X(t): t>=0}$ be a CTMC with state space $cal(S)$. We call
  $
    P_(i,j)(t) = P(X(t) = j | X(0) = i), quad t >= 0, quad i,j in cal(S)
  $
  the transition probability functions.
]

#theorem(name: [Chapman-Kolmogorov])[
  For a CTMC,
  $
    P_(i,j)(s+t) = sum_(k=0)^(oo) P_(i,k)(s) P_(k,j)(t)
  $
  for all $t,s>=0$ and $i,j = 0, 1, dots$.
]

== Motivating birth-and-death processes
- One step at a time: $i -> i+1$ (birth) or $i -> i-1$ (death).
- When in state $i$: $lambda_i = "rate of births"$ and $mu_i = "rate of deaths"$.
- Formally, the jumps are defined using a little-$o$ notation. F.ex.
  $
    P_(i, i+1)(h) = lambda_i h + "o"(h) "as" h -> 0^+
  $
  describes that over a very short time interval $h$, the $P("one birth") approx lambda_i h$.
- Similarly, the probability of remaining in the same state is
  $
    P_(i, i)(h) = 1 - (lambda_i + mu_i)h + "o"(h) "as" h -> 0^+.
  $

==

#definition(name: [Birth-and-death process])[
  Let ${X(t): t>=0}$ be a CTMC with state space $cal(S) = {0, 1, 2, dots}$. Then ${X(t): t>=0}$ is called a birth-and-death with birth rates $lambda_i$ and death rates $mu_i$ if $P_(i,j)(t)$ satisfies
  + $P_(i, i+1)(h) = lambda_i h + "o"(h)$ as $h -> 0^+$ for $i>=0$.
  + $P_(i, i-1)(h) = mu_i h + "o"(h)$ as $h -> 0^+$ for $i>=1$.
  + $P_(i, i)(h) = 1 - (lambda_i + mu_i)h + "o"(h)$ as $h -> 0^+$ for $i>=0$.
  + $P_(i, j)(0) = delta_(i, j)$.
  + $mu_0 = 0$, $lambda_0 > 0$, and $lambda_i, mu_i > 0$ for $i>=1$.

  // Remarks:
  // - At most two possible jumps: $i -> i+1$ and $i -> i-1$.
  // - Birth and death rates are called transition rates.
  //
]
#definition(name: [Pure birth and pure death processes])[
  - Pure birth process: $mu_i = 0$ for all $i>=0$.
  - Pure death process: $lambda_i = 0$ for all $i>=1$.
]
//
// ==
// #theorem(name: [Exponentially distributed sojourn times])[
//   - Pure birth process with $lambda_i>0$ for all $i>=0$. Sojourn times are independent and $S_i tilde.op "Exp"(lambda_i)$.
//   - Pure death process with starting state $N$ and where $mu_i > 0$ for $i = 1, dots, N$. Sojourn times are independent and $S_i tilde.op "Exp"(mu_i)$ for $i = 1, dots, N$.
// ]
//

==
#theorem()[
  In a birth-and-death process with birth rates $lambda_i$ and death rates $mu_i$, the following holds:
  - Independent sojourn times.
  - $S_i tilde.op "Exp"(lambda_i + mu_i)$ for $i>=0$.
  - Jump probabilities in state $i$ are
    $
      P(i -> i-1) = mu_i / (lambda_i + mu_i) quad "and" quad P(i -> i+1) = lambda_i / (lambda_i + mu_i).
    $
]

== Problem
Consider the birth-and-death process with $cal(S) = {0, 1, 2}$, birth rates $lambda_0 = 5$, $lambda_1 = 4$ and $lambda_2 = 0$, and death rates $mu_1 = 3$ and $mu_2 = 7$.
+ Draw the transition diagram.
+ Calculate expected sojourn times.
+ Calculate the probability that state $2$ follows state $1$.
+ Assume $X(0) = 0$. Calculate the probability that two consecutive births occur.


== Problem (part 1)
#text(size: 18pt)[
  A parking garage opens at 08:00 and closes at 16:00. We model the arrival of cars to the parking garage during opening hours as a Poisson process with rate $lambda = 0.5 "cars"\/"min"$. For now, assume that the garage has room for infinitely many cars.
  +
    - Calculate the probability that no car has arrived at 08:05.
    - Compute the expected number of cars that will arrive during the first 15 minutes of opening hours.
    - Given that two cars will arrive during the first 10 minutes, compute the probability that no cars arrive during the first 5 minutes.
  + Customers spend on average 100 kr for parking, independently of each other, with standard deviation of 10 kr.
    - Calculate the expected value of the total income at the garage during one day.
    - Calculate the variance of the total income at the garage during one day.
]


==

#theorem()[
  $T tilde.op "Exp"(lambda)$ is memoryless, meaning $P(T > s+t | T > s) = P(T > t)$ for all $s,t >= 0$.

  Remark: It is the only memoryless continuous distribution on $(0,oo)$.
]


#theorem()[
  If $T_i tilde.op "Exp"(alpha_i)$ for $i = 1, dots, n$, and $T_1, dots, T_n$ are independent, then
  $
    min(T_1, dots, T_n) tilde.op "Exp"(sum_(i=1)^n alpha_i).
  $
]


== Problem (part 2)
#text(size: 18pt)[
  Assume additionally that cars, independently of each other and their arrival times, spend a stochastic time in the parking garage, which follows an exponential distribution with expectation $1\/mu = 30 "minutes"$. After the time has passed, the car immediately exists the parking garage. Further, the parking garage has a maximum capacity of $N_max = 20 "cars"$, and cars that arrive when the garage is full will drive past the garage without forming a queue. Under these assumptions, the number of cars $X(t)$ in the garage at time $t$ is a birth-and-death process.
  +
    - Determine the birth and death rates of the process.
    - Draw a transition diagram for the process.
  // - Two cars are in the parking garage at 16:00, and no new cars may enter. The two cars will leave according to the rates described above. Let T be the time until the parking garage is empty, and determine the probability density, $f_T (t)$.
  + Ignore the opening hours and assume that the parking garage is always open. There are currently 16 cars in the parking garage.
    - Determine the distribution of the time until the number of cars in the garage changes.
    - Calculate the probability that the next time the number of cars in the garage changes, it will be a car that leaves.
]

== Towards the Kolmogorov forward equations

Consider a pure birth process with $lambda_0 != lambda_i$. Derive $P_(0, 1)(t)$.

#pause

Integrating factor. For ODE/IVP
$
  (dif y)/(dif x) + P(x) y = Q(x)
$
we multiply each side by $mu(x) = exp(integral P(x) dif x)$ and use the product rule.



==
#theorem(name: [Forward Kolmogorov differential equations])[
  For a birth-and-death process with birth rates $lambda_i$ and death rates $mu_i$, the $P_(i,j)(t)$ satisfy  $ P_(i,0)^' (t) &= -lambda_0 P_(i,0)(t) + mu_1 P_(i,1)(t), quad t >= 0 \
  P_(i,j)^' (t) &= lambda_(j-1) P_(i,j-1)(t) - (lambda_j + mu_j) P_(i,j)(t) + mu_(j+1) P_(i,j+1)(t), quad t >= 0, quad j >= 1, $
  with initial conditions $P_(i,j)(0) = delta_(i,j)$.
]

== Problem
A machine works ($1$) or is broken ($0$). Time to breakdown is $"Exp"(mu)$, and time to repair is $"Exp"(lambda)$. All sojourn times are independent. The machine works at time $t=0$. Calculate the probability that the machine works at time $t=10$.

