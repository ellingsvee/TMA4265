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

== About the exam
- The formula sheet contains
  - the birth-and-death definition, Kolmogorov's equations and $pi_k = theta_k pi_0$,
  - Little's law $L = lambda_a W$ and the limiting distributions of M/M/1 and M/M/$oo$,
  - the conditional multivariate normal and the properties of Brownian motion.
#pause
- The CTMC/queueing problems follow the same recipe: _explain_ the model, draw the transition diagram, write down the generator, find the stationary distribution and _interpret_ it. A simulation algorithm is often asked for.
#pause
- Brownian motion has not been asked in 2024–2026, but it is part of the curriculum.


= Continuous-time Markov chains

==
#definition(name: [Continuous-time Markov chain])[
  A process ${X(t) : t >= 0}$ with countable state space $cal(S)$ is a (time-homogeneous) CTMC if
  $
    P(X(s + t) = j | X(s) = i, X(u) = x(u), 0 <= u < s) = P(X(t) = j | X(0) = i) = P_(i,j)(t).
  $
]

#definition(name: [Generator])[
  The rates $q_(i,j)$ for $i != j$ and $q_i = sum_(j != i) q_(i,j)$ form the generator
  $
    bf(A) = [a_(i,j)], quad a_(i,j) = cases(
      q_(i,j) quad & i != j,
      -q_i & i = j,
    )
  $
  so the rows of $bf(A)$ sum to zero. For a birth-and-death process, $q_(i,i+1) = lambda_i$ and $q_(i,i-1) = mu_i$.
]

==
#theorem(name: [Structure of a CTMC])[
  - The sojourn time in $i$ is $"Exp"(q_i)$, independent of everything else.
  - The next state is $j$ with probability $q_(i,j) \/ q_i$.
]

#pause
*Explain that this is a CTMC/birth-and-death process:*
+ Give the state space and index set $t >= 0$.
+ Argue that all the waiting times  are independent and exponential. By the memoryless property, the future then only depends on the current state.
+ Find the rates using competing exponentials. With $k$ busy servers, the time until the next service completion is $min(T_1, dots, T_k) tilde.op "Exp"(k mu)$.

==
#theorem(name: [Kolmogorov equations])[
  The matrix $bf(P)(t) = [P_(i,j)(t)]$ satisfies the forward and backward equations
  $
    bf(P)'(t) = bf(P)(t) bf(A) quad "and" quad bf(P)'(t) = bf(A) bf(P)(t), quad bf(P)(0) = bf(I),
  $
  with solution $bf(P)(t) = exp(t bf(A)) = sum_(n=0)^oo (t bf(A))^n \/ n!$.
]
*Interpretation:* $P_(i,j)(t)$ is the probability of being in $j$ at time $t$ when starting in $i$.

#pause
*Two-state chain:* For $0 ->^lambda 1$ and $1 ->^mu 0$, the forward equation gives
$
  P_(1,1)(t) = lambda / (lambda + mu) + mu / (lambda + mu) e^(-(lambda + mu) t).
$
Learn integrating factors!!!

==
#theorem(name: [Stationary distribution])[
  For an irreducible CTMC, the limiting distribution $pi_j = lim_(t -> oo) P_(i,j)(t)$ solves
  $
    bold(pi) bf(A) = bold(0), quad sum_j pi_j = 1, quad "i.e." quad underbrace(pi_j q_j, "rate out of" j) = underbrace(sum_(k != j) pi_k q_(k,j), "rate into" j).
  $
  For a birth-and-death process, $lambda_(k-1) pi_(k-1) = mu_k pi_k$, which gives $pi_k = theta_k pi_0$.
]

#pause
#theorem(name: [First-step analysis])[
  Let $v_i$ be the expected time until hitting $A$ when starting in $i$. Then $v_i = 0$ for $i in A$ and
  $
    v_i = 1 / q_i + sum_(j != i) q_(i,j) / q_i v_j, quad i in.not A.
  $
]

== Simulating a CTMC
Given $X(0) = i$ and a time horizon $T$:
+ Draw a sojourn time $S tilde.op "Exp"(q_i)$ and set $t <- t + S$. Stop if $t > T$.
+ Draw the next state $j$ with probabilities $q_(i,j)\/q_i = -a_(i,j)\/a_(i,i)$. Set $i <- j$ and go to 1.

== Problem: Exam 2024
#text(size: 18pt)[
  Potential customers arrive at a one-pump gas station at a Poisson rate of $20$ cars per hour. However, customers will only enter the station for gas if there are no more than one car at the gas station. Suppose the amount of time required to service a car at the pump is exponentially distributed with a mean of five minutes. Let $N(t)$ be the number of cars at the gas station at time $t$.
  + Explain that $N$ can be modeled as a birth-death stochastic process. Calculate the birth-death rates and illustrate the process using a graph.
  + Determine the generator matrix (infinitesimal matrix) $bf(A)$.
  + Describe an algorithm for simulation of $N$ based on the elements of $bf(A)$.
  + Give an interpretation of the elements of the matrix $bf(P)(t) = exp(t bf(A))$.
  + Assume $N(0) = 0$. What is the expected time until the first occurrence of two cars at the station?
  + Determine the stationary distribution of $N$.
  + What fraction of potential customers are lost?
]


= Queueing theory

==
*Kendall's notation* A/B/$s$:
- A is the arrival process
- B the service time distribution
- $s$ the number of servers.

In an M/M/$s$ queue, the number of customers $X(t)$ in the system (queue plus service) is a birth-and-death process. M means Markovian (Poisson arrivals or exponential service times).

#pause
#theorem(name: [Little's law])[
  In the long run,
  $
    L = lambda_a W, quad L_Q = lambda_a W_Q, quad W = W_Q + 1/mu,
  $
  where $L$ ($L_Q$) is the mean number of customers in the system (queue), $W$ ($W_Q$) is the mean time a customer spends in the system (queue) and $lambda_a$ is the rate of customers that actually enter.
]

==
#definition(name: [Stable queue])[
  A queue is _stable_ if $X(t)$ has a limiting distribution $bold(pi)$. For a birth-and-death process this holds if and only if $sum_k theta_k < oo$, so that $pi_0 = 1 \/ sum_k theta_k > 0$.
]
Intuitively, the servers must work faster than customers arrive. A finite capacity queue is always stable.

#pause
#theorem(name: [Standard queues])[
  - M/M/1: $lambda_k = lambda$ and $mu_k = mu$. Stable if and only if $rho = lambda\/mu < 1$, and then $pi_k = (1 - rho) rho^k$, $L = rho \/ (1 - rho)$ and $W = 1 \/ (mu - lambda)$.
  - M/M/$s$: $lambda_k = lambda$ and $mu_k = min(k, s) mu$. Stable if and only if $lambda < s mu$.
  - M/M/$oo$: $lambda_k = lambda$ and $mu_k = k mu$. Always stable with $X tilde.op "Poisson"(lambda\/mu)$.
]

== Lost customers
If arrivals are turned away (full system or balking), not all $lambda$ arrivals enter.

#pause
Poisson arrivals see the system in its stationary distribution (PASTA), so the fraction of lost customers is $pi_"full"$ and
$
  lambda_a = lambda (1 - pi_"full").
$
Use $lambda_a$, not $lambda$, in Little's law!

== Problem: Exam August 2026
Students seeking help arrive at a help desk according to a Poisson process with rate $lambda = 10\/"hour"$. Assume there are $s = 4$ assistants each with expected service time $5$ minutes, corresponding to exponential rate $mu = 1\/(5 "minutes")$.
+ Explain how this can be modeled as an M/M/$s$ queue.
+ Illustrate the Markov-process with a transition graph.
+ Determine the generator matrix $bf(Q)$ of the process, and write down the Kolmogorov forward equation using matrix notation.
+ Explain how the stationary distribution can be determined.
+ The queue law $L = lambda W$ is fundamental. Explain what the symbols can mean in the context of the help desk.

== Problem: Exam 2022
#text(size: 18pt)[
  Guests arrive to a museum according to a Poisson process with rate $lambda = 10$ guests per hour. Each guest is quick with probability $p = 0.9$, and otherwise slow. A quick guest spends an exponential time with mean $0.25$ hours in the museum, and a slow guest an exponential time with mean $1$ hour. All guests are independent of each other and the arrival process. Let $X_"quick" (t)$ be the number of quick guests in the museum.
  + Explain why ${X_"quick" (t) : t >= 0}$ is an M/M/$oo$ queue, and determine its birth and death rates.
  + You can assume as known that the long-run fraction of time with $0$ slow guests is $0.3679$. Calculate the long-run fraction of time with $0$ quick guests, and with $0$ guests in total. How much money can be saved per day by turning off the lights ($2000$ kroner per hour) when the museum is empty?
  + Explain why the total number of guests $X(t)$ is not a birth-and-death process. A long time has passed, and there is one guest in the museum. What is the probability that this guest is quick?
]


= Gaussian processes and Brownian motion

==
#definition(name: [Gaussian process])[
  ${X(t) : t in cal(I)}$ is a Gaussian process if $(X(t_1), dots, X(t_n))$ is multivariate normal for all $t_1, dots, t_n$. The distribution is determined by the mean function $m(t) = EE[X(t)]$ and the covariance function $C(s, t) = "Cov"(X(s), X(t))$.
]

#pause
*Bivariate conditioning:* The formula sheet gives the general case. For $(X, Y)$ bivariate normal with correlation $rho$,
$
  Y | X = x tilde.op N(mu_Y + rho sigma_Y / sigma_X (x - mu_X), sigma_Y^2 (1 - rho^2)).
$

== Problem: Exam 2024
A GPS device gives a position $(X, Y)$ which is bivariate normal with expectation $(10"m", 20"m")$, standard deviations $(1"m", 1"m")$, and correlation $0.9$.
+ Determine the distribution of $Y$ conditionally given that $X = 9"m"$.
+ Find $EE(Y | X = x)$ as a function of $x$ between $5"m"$ and $15"m"$.

==
#definition(name: [Brownian motion])[
  ${B(t) : t >= 0}$ is a Brownian motion with variance parameter $sigma^2$ if $B(0) = 0$, it has independent increments, $B(t) - B(s) tilde.op N(0, sigma^2 (t - s))$ for $s < t$, and continuous paths. Equivalently, it is a Gaussian process with continuous paths and
  $
    m(t) = 0 quad "and" quad C(s, t) = sigma^2 min(s, t).
  $
]

#pause
*Is it a Brownian motion?* Check that the process is Gaussian (linear in $B$), starts in $0$, has mean $0$, covariance $min(s, t)$ and continuous paths. To show that it is _not_, find one property that fails, f.ex. the variance.

==
#definition(name: [Brownian bridge])[
  The Brownian bridge is $B^0 (t) = B(t) | B(1) = 0$ for $t in [0, 1]$. It is a Gaussian process with
  $
    m(t) = 0 quad "and" quad C(s, t) = s (1 - t), quad 0 <= s <= t <= 1.
  $
  The process $B(t) - t B(1)$ has the same distribution.
]

#pause
#theorem(name: [Reflection principle])[
  For a standard Brownian motion, $a > 0$ and $T_a = min{t >= 0 : B(t) = a}$,
  $
    P(max_(0 <= u <= t) B(u) >= a) = P(T_a <= t) = 2 P(B(t) >= a) = 2 (1 - Phi(a / sqrt(t))).
  $
]

// == Simulation
// - Brownian motion on $t_i = i Delta t$: Set $B(t_0) = 0$ and
//   $
//     B(t_i) = B(t_(i-1)) + sqrt(Delta t) Z_i, quad Z_i "i.i.d." N(0, 1).
//   $
// #pause
// - A Gaussian vector $N(bold(mu), bf(Sigma))$: Compute the Cholesky factor $bf(Sigma) = bf(L) bf(L)^top$, draw $bold(z) tilde.op N(bold(0), bf(I))$ and return $bold(mu) + bf(L) bold(z)$. This works since
//   $
//     "Cov"(bf(L) bold(z)) = bf(L) bf(I) bf(L)^top = bf(Sigma).
//   $
//
// == Problem: Exam 2023
// Given standard Brownian motion ${B(t) : t >= 0}$, the Brownian bridge ${B^0 (t) : t in [0, 1]}$ can be defined as $B^0 (t) = B(t) | B(1) = 0$.
// + Derive the mean function $m(t) = EE[B^0 (t)]$ and covariance function $C(s, t) = "Cov"(B^0 (s), B^0 (t))$ for $s, t in [0, 1]$.
// + Write pseudocode to simulate a realization of the Brownian bridge at $t_i = i\/m$, $i = 0, dots, m$, using a function `rnorm(n)` that returns $n$ i.i.d. standard normal variables.

== Problem: Exam 2022
Let ${B(t) : t >= 0}$ be standard Brownian motion.
+ Show that $X(t) = 1/a B(a^2 t)$ is a standard Brownian motion for $a > 0$.
+ Show that $W(t) = t B(t)$ is not a Brownian motion.


== Checklist
+ Explain why a process is a CTMC or a birth-and-death process, and draw the transition diagram.
+ Write down the generator $bf(A)$ and the Kolmogorov forward equations, and solve them for two states.
+ Find the stationary distribution, and use first-step analysis for expected times and absorption probabilities.
+ Describe how to simulate a CTMC from $bf(A)$.
+ Explain Kendall's notation, and use Little's law and the M/M/1, M/M/$s$ and M/M/$oo$ queues.
+ Find the effective arrival rate and the fraction of lost customers.
+ Condition a multivariate normal on some of its components.
+ Compute with the covariance $min(s, t)$ of Brownian motion, check if a process is a Brownian motion, and use the reflection principle.
