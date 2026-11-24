#import "../templates/tma4265-presentation.typ": *

#import "@preview/muchpdf:0.1.2": muchpdf

#import "@preview/lemmify:0.1.7": default-theorems, new-theorems, thm-numbering-heading
#import "@preview/subpar:0.2.2"

#import "../utils.typ": transition-diagram, transition-figure


#let bf(x) = math.bold(math.upright(x))
#set math.mat(delim: "[")


#let captionless-subpar-grid(..args) = subpar.grid(
  show-sub-caption: (num, it) => it.body,
  ..args,
)

#show: icml-presentation.with(
  header-right: none,
  font-size: 20pt,
  language: "en",
  raw-lang: "bash",
  aspect-ratio: "16-9",
)

#title-slide[
  = Week 48: Exam preparation 2
]

== My plan
Last week:
- Probability theory
- Discrete-time Markov chains
- Poisson processes

This week:
- Continuous-time Markov chains
- Queueing theory
- Gaussian processes and Brownian motion

= As a start, some additional tips
== My "way" of answering on exams
#v(-0.5em)
- Answer in BLACK, comments in BLUE.
- Use whiteout to remove mistakes.
#figure[
  #image(
    "figures/exam_example.png",
    width: 50%,
  )
]

== Also...
- Active recall: "Talk thorough" the material to yourself.
#pause
- WALK to Sluppen without listening to music.
#pause
- Study to the bitter end. The "take a break the day before" is BS...


= Continuous-time Markov chains

== From discrete to continuous time
// A DTMC can only jump at the times $1, 2, 3, dots$. A CTMC can jump at _any_ time $t >= 0$.
// It stays in a state for a random time, and then jumps to a new state.
// #pause
#definition(name: [Continuous-time Markov chain])[
  A process ${X(t) : t >= 0}$ with countable state space $cal(S)$ is a (time-homogeneous) CTMC if
  $
    P(X(s + t) = j | X(s) = i, X(u) = x(u), 0 <= u < s) = P(X(t) = j | X(0) = i) = P_(i,j)(t).
  $
]
*Interpretation:* Given the present, the past is irrelevant. $P_(i,j)(t)$ is the probability of being in $j$ at time $t$ when starting in $i$.

== How a CTMC moves
In state $i$, each possible jump $i -> j$ happens after an independent $"Exp"(q_(i,j))$ time, and the chain makes the jump that happens first.

#pause
#theorem(name: [Structure of a CTMC])[
  - The sojourn time in $i$ is $"Exp"(q_i)$ with $q_i = sum_(j != i) q_(i,j)$.
  - The next state is $j$ with probability $q_(i,j) \/ q_i$.
]

==
*Explain that this is a CTMC:*
+ Give the state space and the index set $t >= 0$.
+ Argue that all the waiting times are independent and exponential. By the memoryless property, the future then only depends on the current state.
+ Find the rates using competing exponentials. With $k$ busy servers, the time until the next service completion is $min(T_1, dots, T_k) tilde.op "Exp"(k mu)$.

#pause
*Birth-and-death process:*
A CTMC on ${0, 1, 2, dots}$ that only moves one step at a time (birth with rate $lambda_k$ and death with rate $mu_k$).

== The generator (not covered by me before now...)
The rate $q_(i,j)$ means that in a short time $h$, the chain jumps from $i$ to $j$ with probability $approx q_(i,j) h$. Collect all rates in a _generator_ matrix.


#pause
#definition(name: [Generator])[
  $
    bf(A) = [a_(i,j)], quad a_(i,j) = cases(
      q_(i,j) quad & i != j,
      -q_i & i = j,
    )
  $
  so the rows of $bf(A)$ sum to zero. For a birth-and-death process, $q_(i,i+1) = lambda_i$ and $q_(i,i-1) = mu_i$.
]

#pause
*Example:* For the two-state chain $0 ->^lambda 1$ and $1 ->^mu 0$,
$
  bf(A) = mat(-lambda, lambda; mu, -mu).
$

== Kolmogorov equations
// The generator gives the rates. The Kolmogorov equations turn these into the probabilities $P_(i,j)(t)$.
#theorem(name: [Kolmogorov equations])[
  The matrix $bf(P)(t) = [P_(i,j)(t)]$ satisfies the forward and backward equations
  $
    // bf(P)'(t) = bf(P)(t) bf(A) quad "and" quad bf(P)'(t) = bf(A) bf(P)(t), quad bf(P)(0) = bf(I),
    bf(P)'(t) = bf(P)(t) bf(A) quad "and" quad bf(P)(0) = bf(I),
  $
  with solution $bf(P)(t) = exp(t bf(A)) = sum_(n=0)^oo (t bf(A))^n \/ n!$.
]

== Two-state chain
For $0 ->^lambda 1$ and $1 ->^mu 0$, the forward equation for $P_(1,1)$ is
$
  P'_(1,1)(t) = lambda P_(1,0)(t) - mu P_(1,1)(t) = lambda - (lambda + mu) P_(1,1)(t),
$
using $P_(1,0)(t) = 1 - P_(1,1)(t)$. This is a linear ODE, which we can solve using an integrating factor.

== In the long run...

#theorem(name: [Stationary distribution])[
  For an irreducible CTMC, the limiting distribution $pi_j = lim_(t -> oo) P_(i,j)(t)$ solves
  $
    bold(pi) bf(A) = bold(0), quad sum_j pi_j = 1, quad "i.e." quad underbrace(pi_j q_j, "rate out of" j) = underbrace(sum_(k != j) pi_k q_(k,j), "rate into" j).
  $
]
*Intuition:*
- $pi_j$ is the long-run fraction of time spent in $j$.
- "Flow in" = "Flow out"

== First-step analysis
*Idea:* Starting in $i$, we first spend on average $1\/q_i$ time in $i$. Then we jump to $j$ with probability $q_(i,j)\/q_i$, and by the Markov property the process continues from $j$.

#theorem(name: [First-step analysis])[
  Let $v_i$ be the expected time until hitting $A$ when starting in $i$. Then $v_i = 0$ for $i in A$ and
  $
    v_i = 1 / q_i + sum_(j != i) q_(i,j) / q_i v_j, quad i in.not A.
  $
]

#pause
Absorption probabilities only depend on _where_ the chain jumps, not _when_. They are computed with the jump probabilities $q_(i,j)\/q_i$, exactly as for a DTMC.

== Simulating a CTMC
The structure theorem translates directly into an algorithm.

Given $X(0) = i$ and a time horizon $T$, set $t = 0$:
+ Draw a sojourn time $S tilde.op "Exp"(q_i)$ and set $t <- t + S$. Stop if $t > T$.
+ Draw the next state $j$ with probabilities $q_(i,j)\/q_i = -a_(i,j)\/a_(i,i)$. Set $i <- j$ and go to 1.

// #pause
// Everything we need is in the generator: $q_i = -a_(i,i)$ on the diagonal, and $q_(i,j) = a_(i,j)$ off the diagonal.

== Problem: Exam 2024
#text(size: 18pt)[
  Potential customers arrive at a one-pump gas station at a Poisson rate of $20$ cars per hour. However, customers will only enter the station for gas if there are no more than one car at the gas station. Suppose the amount of time required to service a car at the pump is exponentially distributed with a mean of five minutes. Let $N(t)$ be the number of cars at the gas station at time $t$.
  + Explain that $N$ can be modeled as a birth-death stochastic process. Calculate the birth-death rates and illustrate the process using a graph.
  + Determine the generator matrix (infinitesimal matrix) $bf(A)$.
  // + Describe an algorithm for simulation of $N$ based on the elements of $bf(A)$.
  // + Give an interpretation of the elements of the matrix $bf(P)(t) = exp(t bf(A))$.
  + Assume $N(0) = 0$. What is the expected time until the first occurrence of two cars at the station?
  + Determine the stationary distribution of $N$.
  + What fraction of potential customers are lost?
]


= Queueing theory

== Describing a queue
A queue is written A/B/$s$, where
- A is the arrival process,
- B is the service time distribution,
- $s$ is the number of servers.

M means Markovian, i.e. Poisson arrivals or exponential service times.

#pause
*Example:* M/M/1 is a queue with Poisson arrivals, exponential service times and one server. In an M/M/$s$ queue, the number of customers $X(t)$ in the system (queue plus service) is a birth-and-death process.

== Little's law
#theorem(name: [Little's law])[
  In the long run,
  $
    L = lambda_a W
    // , quad L_Q = lambda_a W_Q, quad W = W_Q + 1/mu,
  $
  where
  - $L$ is the mean number of customers in the system,
  - $W$ is the mean time a customer spends in the system,
  - $lambda_a$ is the rate of customers that actually enter.
]
#pause
*Example:* If $10$ students arrive per hour and each stays $1\/2$ hour, there are on average
$
  L = 10 dot 1\/2 = 5 "students present."
$

== Stable queues
If customers arrive faster than they are served, the queue grows forever.

#pause
#definition(name: [Stable queue])[
  A queue is _stable_ if $X(t)$ has a limiting distribution $bold(pi)$. For a birth-and-death process this holds if and only if
  $
    sum_k theta_k < oo, quad theta_k = (lambda_0 lambda_1 ... lambda_(k-1)) \/ (mu_1 mu_2 ... mu_k),
  $
  so that $pi_0 = 1 \/ sum_k theta_k > 0$ and $pi_k = theta_k pi_0$.
]

#pause
*Example:* For M/M/1, $theta_k = (lambda\/mu)^k$. The sum is finite if and only if $lambda < mu$. A queue with finite capacity is always stable, since the sum is finite.

==
// With $k$ customers and $s$ servers, $min(k, s)$ servers are busy. Each finishes at rate $mu$, so the death rate is $min(k, s) mu$.

*Standard queues you might encounter:*
- M/M/1: $lambda_k = lambda$ and $mu_k = mu$. Stable if and only if $rho = lambda\/mu < 1$, and then $pi_k = (1 - rho) rho^k$, $L = rho \/ (1 - rho)$ and $W = 1 \/ (mu - lambda)$.
- M/M/$s$: $lambda_k = lambda$ and $mu_k = min(k, s) mu$. Stable if and only if $lambda < s mu$.
- M/M/$oo$: $lambda_k = lambda$ and $mu_k = k mu$. No one waits, and it is always stable with $X tilde.op "Poisson"(lambda\/mu)$.

== Problem: Exam 2021
#text(size: 18pt)[
  Customers arrive to a store according to a Poisson process with rate $lambda = 60$ per hour. There is one server, and service times are independent and exponential with mean $1\/mu = 6$ minutes. An arriving customer always joins the queue if there are two or less customers in the service area. If there are three or more, the customer joins with probability $0 < p < 1$, and otherwise leaves. Let $X(t)$ be the number of customers queuing or receiving service.
  + Explain why $X$ is a birth-and-death process. Determine the birth and death rates as functions of $p$, and draw the transition diagram.
  + Derive the limiting distribution as a function of $p$. What is the necessary condition on $p$ for it to exist? Give an intuitive explanation.
  + _(Extra)_ Let $p = 0.1$. What fraction of the customers are lost, and how long does an entering customer spend in the store on average?
]


= Gaussian processes and Brownian motion

==
*NOTE:*

_Brownian motion has not been asked in 2024–2026, but it is part of the curriculum..._

_(...it is also quite cool and applicable:) )_

== Gaussian processes
#definition(name: [Gaussian process])[
  ${X(t) : t in cal(I)}$ is a Gaussian process if $(X(t_1), dots, X(t_n))$ is multivariate normal for all $t_1, dots, t_n$. The distribution is determined by the mean function $m(t) = EE[X(t)]$ and the covariance function $C(s, t) = "Cov"(X(s), X(t))$.
]
== Conditioning on a normal variable
The formula sheet gives the general case. For $(X, Y)$ bivariate normal with correlation $rho$,
$
  Y | X = x tilde.op N(mu_Y + rho sigma_Y / sigma_X (x - mu_X), sigma_Y^2 (1 - rho^2)).
$

#pause
*Interpretation:*
- The mean moves in the direction of the correlation: if $rho > 0$ and $X$ is above its mean, we expect $Y$ to be above its mean too.
- The variance is reduced by the factor $1 - rho^2$. The stronger the correlation, the more $X$ tells us about $Y$.


== Example from spatial statistics (TMA4250)
#captionless-subpar-grid(
  figure(
    caption: [True field $X$ and obs. $Y$],
  )[
    #image(
      "figures/gp/true_field.pdf",
      width: 100%,
    )
  ],
  figure(
    caption: [Posterior $EE[X|Y]$],
  )[
    #image(
      "figures/gp/kriging_mean.pdf",
      width: 100%,
    )
  ],
  figure(
    caption: [Posterior $"Var"[X|Y]$],
  )[
    #image(
      "figures/gp/kriging_variance.pdf",
      width: 100%,
    )
  ],

  columns: (auto, auto, auto),
  column-gutter: -0.5em,
)

== Example from spatial statistics (TMA4250)
#figure[
  #image(
    "figures/gp/US_Rainfall.jpg",
    width: 50%,
  )
]


== Problem: Exam 2024
A GPS device gives a position $(X, Y)$ which is bivariate normal with expectation $(10"m", 20"m")$, standard deviations $(1"m", 1"m")$, and correlation $0.9$.
+ Determine the distribution of $Y$ conditionally given that $X = 9"m"$.
+ Find $EE(Y | X = x)$ as a function of $x$ between $5"m"$ and $15"m"$.

#v(1.0em)
#text(
  fill: luma(120),
)[
  Recall formula: $Y | X = x tilde.op N(mu_Y + rho sigma_Y / sigma_X (x - mu_X), sigma_Y^2 (1 - rho^2))$.
]

== Brownian motion
*Idea:* A random walk taking a step $plus.minus sigma sqrt(Delta t)$ every $Delta t$ time units. Let $Delta t -> 0$.

#definition(name: [Brownian motion])[
  ${B(t) : t >= 0}$ is a Brownian motion with variance parameter $sigma^2$ if
  - $B(0) = 0$.
  - It has independent increments,
  - $B(t) - B(s) tilde.op N(0, sigma^2 (t - s))$ for $s < t$,
  - The paths are continuous, but nowhere differentiable.
  It is _standard_ if $sigma^2 = 1$.
]

==
#figure(
  caption: "Brown (1827) observed tiny particles from pollen jiggling in water. Einstein (1905) explained this as collisions with water molecules. Perrin's experiments (1908) confirmed his predictions, which convinced scientists that atoms exist.",
)[
  #image("figures/brownian_motion.png", width: 40%)
]


== Brownian motion is a Gaussian process
$B(t)$ is a sum of independent normal increments, so BM is a Gaussian process with
$
  m(t) = 0 quad "and" quad C(s, t) = sigma^2 min(s, t).
$

#pause
*Why:* For $s <= t$, write $B(t) = B(s) + (B(t) - B(s))$. The increment is independent of $B(s)$, so
$
  "Cov"(B(s), B(t)) & = "Cov"(B(s), B(s)) + "Cov"(B(s), B(t) - B(s)) \
                    & = "Var"(B(s)) + 0 = sigma^2 s.
$

== Using the past...
Let $s < t$.

#pause
*Given the past:* The process starts afresh from the current value,
$
  B(t) | B(s) = x tilde.op N(x, sigma^2 (t - s)).
$
#v(2.0em)
#figure()[
  #image("figures/brownian_bridge.png", width: 50%)
]

== ...and the future
Let $s < t$.


*Given the future:* Use the conditioning formula with $"Cov"(B(s), B(t)) = sigma^2 s$,
$
  B(s) | B(t) = b tilde.op N(s / t b, sigma^2 (s (t - s)) / t).
$
The mean is the straight line from $(0, 0)$ to $(t, b)$, and the variance is largest in the middle (so called _Brownian bridge_).
#figure()[
  #image("figures/brownian_bridge.png", width: 50%)
]

== Reflection principle
*Question:* What is the probability that $B$ reaches the level $a > 0$ before time $t$?

#pause
*Idea:* Once a path hits $a$, it is equally likely to end above or below $a$.

#pause
#theorem(name: [Reflection principle])[
  For $a > 0$ and $T_a = min{t >= 0 : B(t) = a}$,
  $
    P(T_a <= t) = P(max_(0 <= u <= t) B(u) >= a) = 2 P(B(t) >= a) = 2 (1 - Phi(a / (sigma sqrt(t)))).
  $
]
#v(-1.0em)
#figure()[
  #image("figures/reflection.png", width: 35%)
]
#v(-1.0em)

== Problem: Exam 2020
#text(size: 18pt)[
  Assume that we model the stock price of DNB as a Brownian motion ${B(t) : t >= 0}$, where $t$ is measured in hours, with variance parameter $sigma^2 = 5^2 "kr"^2$. When the stock market opens at 08:00, the stock price is $150 "kr"$.
  + Compute the probability that the stock price will exceed $170 "kr"$ at 12:00.
  + When the market closes at 16:00, we observe that the stock price is $200 "kr"$. Compute the conditional probability that the stock price at 12:00 exceeded $170 "kr"$.
  + _(Extra)_ Without the information from 16:00, what is the probability that the stock price reaches $170 "kr"$ at some time before 12:00?
]

== Problem: Checking BM conditions
Define the stochastic process ${X(t) : t >= 0}$ with variance parameter $sigma^2 > 0$ through the three properties:
- $X(0) = 0$.
- For $0 <= s < t$, the increment $X(t) - X(s)$ is normal with mean $0$ and variance $sigma^2 integral_s^t e^(-x) dif x$.
- For $0 <= t_1 < t_2 <= t_3 < t_4$, the two increments $X(t_2) - X(t_1)$ and $X(t_4) - X(t_3)$ are independent.
Derive $"Var"[X(t)]$. Is ${X(t) : t >= 0}$ a Brownian motion? A continuous-time Markov chain? A Gaussian process?

== Checklist
+ Explain why a process is a CTMC or a birth-and-death process, and draw the transition diagram.
+ Write down the generator $bf(A)$ and the Kolmogorov forward equations, and solve them for two states.
+ Find the stationary distribution, and use first-step analysis for expected times and absorption probabilities.
+ Describe how to simulate a CTMC from $bf(A)$.
+ Explain the A/B/$s$ notation, and use Little's law and the M/M/1, M/M/$s$ and M/M/$oo$ queues.
+ Find the effective arrival rate and the fraction of lost customers.
+ Condition a multivariate normal on some of its components.
+ Compute probabilities for Brownian motion given its past or future values, check if a process is a Brownian motion, and use the reflection principle.

= Good luck, and thank you for showing up to these lectures!
