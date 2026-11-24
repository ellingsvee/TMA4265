#import "../templates/tma4265-notes.typ": *
#import "@preview/muchpdf:0.1.2": muchpdf

#import "@preview/lemmify:0.1.7": default-theorems, new-theorems, thm-numbering-heading
#show figure.where(kind: "solution-group"): set block(breakable: true)

#import "../utils.typ": transition-diagram, transition-figure


#show link: set text(fill: blue)


#show: icml.with(
  title: [
    Week 48: Exam preparation 2
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

= Checklist
You should be able to:
+ Explain why a process is a CTMC or a birth-and-death process, and draw the transition diagram.
+ Write down the generator $bf(A)$ and the Kolmogorov forward equations, and solve them for two states.
+ Find the stationary distribution, and use first-step analysis for expected times and absorption probabilities.
+ Describe how to simulate a CTMC from $bf(A)$.
+ Explain the A/B/$s$ notation, and use Little's law and the M/M/1, M/M/$s$ and M/M/$oo$ queues.
+ Find the effective arrival rate and the fraction of lost customers.
+ Condition a multivariate normal on some of its components.
+ Compute probabilities for Brownian motion given its past or future values, check if a process is a Brownian motion, and use the reflection principle.

#pagebreak()
= Theory
== Continuous-time Markov chains
A DTMC can only jump at the times $1, 2, 3, dots$. A CTMC can jump at _any_ time $t >= 0$: it stays in a state for a random time, and then jumps to a new state.

#definition(name: [Continuous-time Markov chain])[
  A process ${X(t) : t >= 0}$ with countable state space $cal(S)$ is a (time-homogeneous) continuous-time Markov chain (CTMC) if
  $
    P(X(s + t) = j | X(s) = i, X(u) = x(u), 0 <= u < s) = P(X(t) = j | X(0) = i) = P_(i,j)(t).
  $
  Given the present, the past is irrelevant.
]

In state $i$, each possible jump $i -> j$ happens after an independent $"Exp"(q_(i,j))$ time, and the chain makes the jump that happens first.

#theorem(name: [Structure of a CTMC])[
  - The sojourn time in $i$ is $"Exp"(q_i)$ with $q_i = sum_(j != i) q_(i,j)$, independent of everything else.
  - The next state is $j$ with probability $q_(i,j) \/ q_i$. These jump probabilities form the _embedded_ DTMC.
  Both follow from competing exponentials: the minimum of independent $"Exp"(q_(i,j))$ is $"Exp"(q_i)$, and the time for $j$ is the smallest with probability $q_(i,j)\/q_i$.
]

#remark()[
  To "explain that this is a CTMC/birth-and-death process":
  + Give the state space (f.ex. number of customers) and index set $t >= 0$.
  + Argue that all the waiting times (arrivals, services, repairs) are independent and exponential. By the memoryless property, the future then only depends on the current state.
  + Find the rates using competing exponentials. With $k$ busy servers, the time until the next service completion is $min(T_1, dots, T_k) tilde.op "Exp"(k mu)$.
  A _birth-and-death process_ is a CTMC on ${0, 1, 2, dots}$ that only moves one step at a time (birth with rate $lambda_k$ and death with rate $mu_k$).
]

#definition(name: [Generator])[
  The rates $q_(i,j) = lim_(h -> 0^+) P_(i,j)(h)\/h$ for $i != j$ and $q_i = sum_(j != i) q_(i,j)$ form the generator (infinitesimal matrix)
  $
    bf(A) = [a_(i,j)], quad a_(i,j) = cases(
      q_(i,j) quad & i != j,
      -q_i & i = j,
    )
  $
  so the rows of $bf(A)$ sum to zero. For a birth-and-death process, $q_(i,i+1) = lambda_i$, $q_(i,i-1) = mu_i$ and $q_i = lambda_i + mu_i$.

  The rate $q_(i,j)$ means that in a short time $h$, the chain jumps from $i$ to $j$ with probability $approx q_(i,j) h$. For the two-state chain $0 ->^lambda 1$ and $1 ->^mu 0$,
  $
    bf(A) = mat(-lambda, lambda; mu, -mu).
  $
]

The generator gives the rates. The Kolmogorov equations turn these into the probabilities $P_(i,j)(t)$.

#theorem(name: [Kolmogorov equations])[
  The matrix $bf(P)(t) = [P_(i,j)(t)]$ satisfies the forward and backward equations
  $
    bf(P)'(t) = bf(P)(t) bf(A) quad "and" quad bf(P)'(t) = bf(A) bf(P)(t), quad bf(P)(0) = bf(I),
  $
  with solution $bf(P)(t) = exp(t bf(A)) = sum_(n=0)^oo (t bf(A))^n \/ n!$. The entry $P_(i,j)(t)$ is the probability of being in $j$ at time $t$ when starting in $i$. If $bold(p)(t)$ is the row vector of probabilities $P(X(t) = j)$, then $bold(p)'(t) = bold(p)(t) bf(A)$.
]

#remark(name: [Two-state chain])[
  For $0 ->^lambda 1$ and $1 ->^mu 0$, the forward equation for $P_(1,1)$ is, using $P_(1,0)(t) = 1 - P_(1,1)(t)$,
  $
    P'_(1,1)(t) = lambda P_(1,0)(t) - mu P_(1,1)(t) = lambda - (lambda + mu) P_(1,1)(t).
  $
  This is a linear ODE. With $P_(1,1)(0) = 1$, the integrating factor $e^((lambda + mu) t)$ gives
  $
    P_(1,1)(t) = lambda / (lambda + mu) + mu / (lambda + mu) e^(-(lambda + mu) t).
  $
  As $t -> oo$, $P_(1,1)(t) -> lambda\/(lambda + mu)$, which is the stationary probability of state $1$. This was asked in 2025 (see Week 39). Learn the integrating factor method!
]

In the long run, the rate out of each state equals the rate into it ("flow in" = "flow out").

#theorem(name: [Stationary distribution])[
  For an irreducible CTMC, the limiting distribution $pi_j = lim_(t -> oo) P_(i,j)(t)$ (if it exists) is the solution of
  $
    bold(pi) bf(A) = bold(0), quad sum_j pi_j = 1, quad "i.e." quad underbrace(pi_j q_j, "rate out of" j) = underbrace(sum_(k != j) pi_k q_(k,j), "rate into" j).
  $
  For a birth-and-death process this reduces to $lambda_(k-1) pi_(k-1) = mu_k pi_k$ (the rate from $k - 1$ to $k$ equals the rate from $k$ to $k - 1$), which gives $pi_k = theta_k pi_0$ (formula sheet). The value $pi_j$ is the long-run fraction of time spent in $j$.
]

Starting in $i$, we first spend on average $1\/q_i$ time in $i$. Then we jump to $j$ with probability $q_(i,j)\/q_i$, and by the Markov property the process continues from $j$. This gives the following.

#theorem(name: [First-step analysis])[
  Let $v_i$ be the expected time until hitting $A$ when starting in $i$. Then $v_i = 0$ for $i in A$ and
  $
    v_i = 1 / q_i + sum_(j != i) q_(i,j) / q_i v_j, quad i in.not A.
  $
  Absorption probabilities only depend on _where_ the chain jumps, not _when_, so they are computed in the embedded DTMC (Week 40).
]

#remark(name: [Simulation])[
  The structure theorem translates directly into an algorithm. Given $X(0) = i$ and a time horizon $T$:
  + Draw a sojourn time $S tilde.op "Exp"(q_i)$ and set $t <- t + S$. Stop if $t > T$.
  + Draw the next state $j$ with probabilities $q_(i,j)\/q_i$, i.e. $-a_(i,j)\/a_(i,i)$. Set $i <- j$ and go to 1.
  Everything we need is in the generator: $q_i = -a_(i,i)$ and $q_(i,j) = a_(i,j)$. Estimate f.ex. $P_(i,j)(T)$ by the fraction $hat(p)$ of $M$ runs ending in $j$, with standard error $sqrt(hat(p)(1 - hat(p))\/M)$.
]

#pagebreak()
== Queueing theory
In a queue, customers arrive, wait in line if all servers are busy, are served, and leave. A queue is written A/B/$s$ (/capacity), where A is the arrival process, B the service time distribution and $s$ the number of servers. M means Markovian (Poisson arrivals or exponential service times). For example, M/M/1 is a queue with Poisson arrivals, exponential service times and one server. In an M/M/$s$ queue, the number of customers $X(t)$ in the system (queue plus service) is a birth-and-death process.

#theorem(name: [Little's law])[
  In the long run,
  $
    L = lambda_a W, quad L_Q = lambda_a W_Q, quad W = W_Q + 1/mu,
  $
  where $L$ ($L_Q$) is the mean number of customers in the system (queue), $W$ ($W_Q$) is the mean time a customer spends in the system (queue), $lambda_a$ is the rate of customers that actually enter and $1\/mu$ the mean service time.

  For example, if $10$ students arrive per hour and each stays $1\/2$ hour, there are on average $L = 10 dot 1\/2 = 5$ students present.
]

#definition(name: [Stable queue])[
  A queue is _stable_ if the number of customers $X(t)$ has a limiting distribution $bold(pi)$. For a birth-and-death process this holds if and only if $sum_(k=0)^oo theta_k < oo$, so that $pi_0 = 1 \/ sum_k theta_k > 0$. Otherwise $pi_k = 0$ for all $k$, and the queue grows without bound.

  Intuitively, the servers must work faster than customers arrive, otherwise the queue grows forever. For M/M/1, $theta_k = (lambda\/mu)^k$, and the sum is finite if and only if $lambda < mu$. A queue with finite capacity is always stable, since the sum is finite.
]

#theorem(name: [Standard queues])[
  Let $lambda$ be the arrival rate and $mu$ the service rate of each server. With $k$ customers and $s$ servers, $min(k, s)$ servers are busy, so the death rate is $min(k, s) mu$.
  - M/M/1: $lambda_k = lambda$ and $mu_k = mu$. Stable if and only if $rho = lambda\/mu < 1$, and then $pi_k = (1 - rho) rho^k$ is geometric, and
    $
      L = rho / (1 - rho), quad W = L / lambda = 1 / (mu - lambda).
    $
  - M/M/$s$: $lambda_k = lambda$ and $mu_k = min(k, s) mu$. Stable if and only if $lambda < s mu$. For $k >= s$ the $theta_k$ are geometric with ratio $lambda\/(s mu)$.
  - M/M/$oo$: $lambda_k = lambda$ and $mu_k = k mu$. No one waits, and it is always stable with $X tilde.op "Poisson"(lambda\/mu)$, so $L = lambda\/mu$ and $W = 1\/mu$.
]

#remark(name: [Lost customers])[
  Sometimes arrivals are turned away, f.ex. because the system is full (the gas station) or because customers do not want to wait (balking). Then not all $lambda$ arrivals enter. Since Poisson arrivals see the system in its stationary distribution, the fraction of lost customers is $pi_"full"$ and
  $
    lambda_a = lambda (1 - pi_"full").
  $
  Use $lambda_a$, not $lambda$, in Little's law.
]

#pagebreak()
== Gaussian processes and Brownian motion
#definition(name: [Gaussian process])[
  ${X(t) : t in cal(I)}$ is a Gaussian process if $(X(t_1), dots, X(t_n))$ is multivariate normal for all $t_1, dots, t_n$. The distribution is then determined by the mean function $m(t) = EE[X(t)]$ and the covariance function $C(s, t) = "Cov"(X(s), X(t))$.
]

#remark(name: [Bivariate conditioning])[
  The formula sheet gives $EE[bold(x)_A | bold(x)_B]$ and $"Var"[bold(x)_A | bold(x)_B]$. For a bivariate normal $(X, Y)$ with correlation $rho$, this reduces to
  $
    Y | X = x tilde.op N(mu_Y + rho sigma_Y / sigma_X (x - mu_X), quad sigma_Y^2 (1 - rho^2)).
  $
  The mean moves in the direction of the correlation: if $rho > 0$ and $X$ is above its mean, we expect $Y$ to be above its mean too. The variance is reduced by the factor $1 - rho^2$, so the stronger the correlation, the more $X$ tells us about $Y$.
]

Brownian motion models a quantity that moves continuously but completely at random, like a pollen grain in water or a stock price. Think of a random walk that every $Delta t$ time units takes a step $+sigma sqrt(Delta t)$ or $-sigma sqrt(Delta t)$ with probability $1\/2$ each. At time $t$ it has taken $n = t\/Delta t$ independent steps, so its position has mean $0$ and variance $n sigma^2 Delta t = sigma^2 t$, and by the central limit theorem it is approximately normal. Letting $Delta t -> 0$ gives Brownian motion. The step size $sqrt(Delta t)$ is exactly what keeps the variance finite and non-zero in the limit.

#definition(name: [Brownian motion])[
  ${B(t) : t >= 0}$ is a Brownian motion with variance parameter $sigma^2$ if
  + $B(0) = 0$,
  + it has independent increments, i.e. $B(t_2) - B(t_1)$ and $B(t_4) - B(t_3)$ are independent for $t_1 < t_2 <= t_3 < t_4$,
  + $B(t) - B(s) tilde.op N(0, sigma^2 (t - s))$ for $s < t$,
  + the paths $t |-> B(t)$ are continuous.
  It is _standard_ if $sigma^2 = 1$. The first three properties are on the formula sheet.
]

#theorem(name: [Brownian motion is a Gaussian process])[
  Brownian motion is a Gaussian process with continuous paths and
  $
    m(t) = 0 quad "and" quad C(s, t) = sigma^2 min(s, t).
  $
  In particular $B(t) tilde.op N(0, sigma^2 t)$, so the typical distance from $0$ grows like $sigma sqrt(t)$.
]
Any vector $(B(t_1), dots, B(t_n))$ is a linear transformation of independent normal increments, and hence multivariate normal. For the covariance, let $s <= t$ and write $B(t) = B(s) + (B(t) - B(s))$. The increment is independent of $B(s)$, so $"Cov"(B(s), B(t)) = "Var"(B(s)) = sigma^2 s$. The paths are continuous, but so rough that they are nowhere differentiable.

#remark(name: [Is it a Brownian motion?])[
  To show that a process $X$ is a standard Brownian motion, check that it is a Gaussian process (f.ex. linear in $B$) with continuous paths, that $X(0) = 0$, $EE[X(t)] = 0$ and $"Cov"(X(s), X(t)) = min(s, t)$. To show that it is _not_, find one property that fails, f.ex. the variance. For example, $X(t) = 1/a B(a^2 t)$ is a standard Brownian motion since $"Cov"(X(s), X(t)) = 1/a^2 a^2 min(s, t)$, but $W(t) = t B(t)$ is not since $"Var"[W(t)] = t^3$ (Exam 2022).
]

#remark(name: [Using the past and the future])[
  Most exam questions about Brownian motion are of one of the following types. Let $s < t$.
  - *No information:* $B(t) tilde.op N(0, sigma^2 t)$, so $P(B(t) > a) = 1 - Phi(a\/(sigma sqrt(t)))$.
  - *Given the past:* Write $B(t) = B(s) + (B(t) - B(s))$, where the increment is independent of $B(s)$. So the process "starts afresh" from the current value,
    $
      B(t) | B(s) = x tilde.op N(x, sigma^2 (t - s)).
    $
    Hence Brownian motion is a Markov process.
  - *Given the future:* By the conditioning formula with $"Var"(B(t)) = sigma^2 t$ and $"Cov"(B(s), B(t)) = sigma^2 s$,
    $
      B(s) | B(t) = b tilde.op N(s / t b, sigma^2 (s (t - s)) / t).
    $
    The mean is the straight line from $(0, 0)$ to $(t, b)$. The variance is $0$ at both ends and largest in the middle. With $t = 1$ and $b = 0$ we get the _Brownian bridge_ $B^0 (s) = B(s) | B(1) = 0$, a Gaussian process with $m(s) = 0$ and $C(s, u) = s(1 - u)$ for $s <= u$ (Exam 2023 below). The process $B(s) - s B(1)$ has the same distribution.
  If the process starts in $x_0 != 0$, f.ex. a price, work with $X(t) - x_0$, which is a Brownian motion.
]

#theorem(name: [Reflection principle])[
  Let $a > 0$ and let $T_a = min{t >= 0 : B(t) = a}$ be the first time $B$ hits $a$. Then
  $
    P(T_a <= t) = P(max_(0 <= u <= t) B(u) >= a) = 2 P(B(t) >= a) = 2 (1 - Phi(a / (sigma sqrt(t)))).
  $
  The first equality holds since the paths are continuous, so the maximum is above $a$ exactly when the path has hit $a$. For the second, once the path hits $a$ at time $T_a$, it starts afresh from $a$ and is equally likely to end above or below $a$ at time $t$ (reflect the rest of the path in $a$). So $P(B(t) >= a | T_a <= t) = 1\/2$, and since $B(t) >= a$ requires $T_a <= t$,
  $
    P(B(t) >= a) = P(T_a <= t) dot 1/2.
  $
]

#remark(name: [Simulation])[
  - Brownian motion on $t_i = i Delta t$: Set $B(t_0) = 0$ and $B(t_i) = B(t_(i-1)) + sqrt(Delta t) Z_i$ with $Z_i$ i.i.d. $N(0, 1)$.
  - A Gaussian vector $N(bold(mu), bf(Sigma))$: Compute the Cholesky factor $bf(Sigma) = bf(L) bf(L)^top$, draw $bold(z) tilde.op N(bold(0), bf(I))$ and return $bold(mu) + bf(L) bold(z)$. This works since $"Cov"(bf(L) bold(z)) = bf(L) bf(I) bf(L)^top = bf(Sigma)$.
]

#pagebreak()
= Problems
// The most important problems are Exam 2024 Problem 3 and Exam August 2026 Problem 4. The rest can be mentioned briefly or left as self-study. Exam 2025 Problem 3 (two-state CTMC) is solved in the Week 39 notes.

== Continuous-time Markov chains

#problem(name: [Exam 2024, Problem 3])[
  Potential customers arrive at a one-pump gas station at a Poisson rate of $20$ cars per hour. However, customers will only enter the station for gas if there are no more than one car at the gas station. Suppose the amount of time required to service a car at the pump is exponentially distributed with a mean of five minutes. Let $N(t)$ be the number of cars at the gas station at time $t$.
  + Explain that $N$ can be modeled as a birth-death stochastic process. Calculate the birth-death rates and illustrate the process using a graph.
  + Determine the generator matrix (infinitesimal matrix) $bf(A)$.
  + Describe an algorithm for simulation of $N$ based on the elements of $bf(A)$.
  + Give an interpretation of the elements of the matrix $bf(P)(t) = exp(t bf(A))$.
  + Assume $N(0) = 0$. What is the expected time until the first occurrence of two cars at the station?
  + Determine the stationary distribution of $N$.
  + What fraction of potential customers are lost?
]
#solution[
  + A car enters if there are $0$ or $1$ cars at the station, so the state space is $cal(S) = {0, 1, 2}$ and the index set is $t >= 0$. Arrivals form a Poisson process, so the time until the next arrival is $"Exp"(20)$ (per hour), and service times are independent $"Exp"(mu)$ with $mu = 1\/(5 "min") = 12$ per hour. All clocks are exponential and independent, so by the memoryless property the future only depends on the current number of cars. Cars arrive and leave one at a time, so $N$ is a birth-and-death process with
    $
      lambda_0 = lambda_1 = 20, quad lambda_2 = 0, quad mu_1 = mu_2 = 12.
    $
    #transition-figure()[
      #transition-diagram(
        ($0$, $1$, $2$),
        (
          (0, $20$, 0),
          ($12$, 0, $20$),
          (0, $12$, 0),
        ),
        positions: ((0, 0), (2, 0), (4, 0)),
      )
    ]
  + With rows summing to zero,
    $
      bf(A) = mat(
        -20, 20, 0;
        12, -32, 20;
        0, 12, -12
      ).
    $
  + Start in $i = N(0)$ at time $t = 0$.
    + Draw $S tilde.op "Exp"(-a_(i,i))$ and set $t <- t + S$. Stop if $t$ exceeds the time horizon.
    + Jump to $j != i$ with probability $a_(i,j) \/ (-a_(i,i))$. Here this means $0 -> 1$ with probability $1$, $1 -> 2$ with probability $20\/32$ and $1 -> 0$ with probability $12\/32$, and $2 -> 1$ with probability $1$.
    + Record $(t, j)$, set $i <- j$ and go to 1.
  + $P_(i,j)(t) = P(N(s + t) = j | N(s) = i)$ is the probability of $j$ cars at the station $t$ hours later, given $i$ cars now. Each row is a probability distribution, and as $t -> oo$ every row converges to the stationary distribution.
  + Let $v_i$ be the expected time until $N = 2$ when starting in $i$, so $v_2 = 0$. First-step analysis gives
    $
      v_0 = 1/20 + v_1, quad v_1 = 1/32 + 12/32 v_0 + 20/32 dot 0.
    $
    Inserting the second into the first, $5/8 v_0 = 1/20 + 1/32$, so $v_0 = 0.13$ hours $= 7.8$ minutes.
  + Solve the matrix system $bf(A)^top bold(pi) = bold(0)$, but replace the last row with the $pi_0 + pi_1 + pi_2 = 1$. This gives
    $
      mat(
        -20, 12, 0;
        20, -32, 12;
        1, 1, 1
      )
      mat(pi_0; pi_1; pi_2)
      =
      mat(0; 0; 1)
      quad ==> quad
      bold(pi) = (9/49, 15/49, 25/49) approx (0.18, 0.31, 0.51).
    $
  + A customer is lost when arriving to $2$ cars. Poisson arrivals see the stationary distribution, so the fraction lost is $pi_2 = 25\/49 approx 51%$. The effective arrival rate is $lambda_a = 20 dot 25\/49 approx 10.2$ cars per hour.
]

#pagebreak()
== Queueing theory

#problem(name: [Exam August 2026, Problem 4])[
  Students seeking help arrive at a help desk according to a Poisson process with rate $lambda = 10\/"hour"$. Assume there are $s = 4$ assistants each with expected service time $5$ minutes, corresponding to exponential rate $mu = 1\/(5 "minutes")$.
  + Explain how this can be modeled as an M/M/$s$ queue.
  + Illustrate the Markov-process with a transition graph.
  + Determine the generator matrix $bf(Q)$ of the process, and write down the Kolmogorov forward equation using matrix notation.
  + Explain how the stationary distribution can be determined.
  + The queue law $L = lambda W$ is fundamental. Explain what the symbols can mean in the context of the help desk.
]
#solution[
  + Let $X(t)$ be the number of students at the help desk (waiting or being helped), with state space ${0, 1, 2, dots}$. Arrivals are Poisson (the first M), service times are independent $"Exp"(mu)$ (the second M), and there are $s = 4$ servers. We assume an unlimited queue and that a free assistant immediately takes the next student. All clocks are exponential, so $X$ is a birth-and-death process with $mu = 12$ per hour and
    $
      lambda_k = 10, quad mu_k = min(k, 4) dot 12.
    $
    The death rate is $k mu$ when $k <= 4$ students are being helped, since the time until the first of $k$ services ends is $"Exp"(k mu)$.
  + The transition graph is
    #transition-figure()[
      #transition-diagram(
        ($0$, $1$, $2$, $3$, $4$, $5$, $dots.c$),
        (
          (0, $lambda$, 0, 0, 0, 0, 0),
          ($mu$, 0, $lambda$, 0, 0, 0, 0),
          (0, $2mu$, 0, $lambda$, 0, 0, 0),
          (0, 0, $3mu$, 0, $lambda$, 0, 0),
          (0, 0, 0, $4mu$, 0, $lambda$, 0),
          (0, 0, 0, 0, $4mu$, 0, $lambda$),
          (0, 0, 0, 0, 0, $4mu$, 0),
        ),
        positions: ((0, 0), (1.5, 0), (3, 0), (4.5, 0), (6, 0), (7.5, 0), (9, 0)),
        node-radius: 4.5mm,
      )
    ]
  + With rates per hour,
    $
      bf(Q) = mat(
        -10, 10, 0, 0, 0, 0, dots.c;
        12, -22, 10, 0, 0, 0, dots.c;
        0, 24, -34, 10, 0, 0, dots.c;
        0, 0, 36, -46, 10, 0, dots.c;
        0, 0, 0, 48, -58, 10, dots.c;
        dots.v, dots.v, dots.v, dots.v, dots.down, dots.down, dots.down
      ).
    $
    The forward equation is $bf(P)'(t) = bf(P)(t) bf(Q)$ with $bf(P)(0) = bf(I)$.
  + Solve $bold(pi) bf(Q) = bold(0)$ with $sum_k pi_k = 1$. For a birth-and-death process this is $lambda pi_(k-1) = mu_k pi_k$, so $pi_k = theta_k pi_0$ with
    $
      theta_k = cases(
        (lambda\/mu)^k \/ k! quad & k <= 4,
        (lambda\/mu)^4 \/ 4! dot (lambda \/ (4 mu))^(k - 4) quad & k >= 4,
      )
    $
    and $pi_0 = 1 \/ sum_k theta_k$. The tail is a geometric series, which converges since $lambda = 10 < 4 mu = 48$. Here $pi_0 approx 0.43$.
  + $L$ is the long-run mean number of students at the help desk, $lambda = 10$ per hour is the arrival rate, and $W$ is the mean time a student spends at the help desk (waiting plus being helped). The same holds for the queue only, $L_Q = lambda W_Q$.

    With numbers, the probability of having to wait is $P(X >= 4) approx 1.1%$, so $W_Q approx 0$, $W approx 5$ minutes and $L = lambda W approx 10 dot 5\/60 approx 0.84$ students. Four assistants is a lot!
]

#pagebreak()
#problem(name: [Exam 2021, Problem 3 b) and d)])[
  Customers arrive to a store according to a Poisson process with rate $lambda = 60$ per hour. There is one server, and service times are independent and exponential with mean $1\/mu = 6$ minutes. An arriving customer always joins the queue if there are two or less customers in the service area. If there are three or more, the customer joins with probability $0 < p < 1$, and otherwise leaves. Let $X(t)$ be the number of customers queuing or receiving service.
  + Explain why $X$ is a birth-and-death process. Determine the birth and death rates as functions of $p$, and draw the transition diagram.
  + Derive the limiting distribution as a function of $p$. What is the necessary condition on $p$ for it to exist? Give an intuitive explanation.
  + _(Extra, not part of the exam)_ Let $p = 0.1$. What fraction of the customers are lost, and how long does an entering customer spend in the store on average?
]
#solution[
  + The state space is ${0, 1, 2, dots}$ and the index set is $t >= 0$. The time until the next arrival is $"Exp"(60)$. With $3$ or more customers, each arrival joins independently with probability $p$, so by thinning the joining customers form a Poisson process with rate $60 p$. The time until the current service is finished is $"Exp"(mu)$ with $mu = 10$ per hour. All clocks are independent and exponential, so by the memoryless property the future only depends on the current number of customers. Customers arrive and leave one at a time, so $X$ is a birth-and-death process with
    $
      lambda_i = cases(
        60 quad & i = 0\, 1\, 2,
        60 p & i >= 3,
      )
      quad quad mu_i = 10, quad i >= 1.
    $
    #transition-figure()[
      #transition-diagram(
        ($0$, $1$, $2$, $3$, $4$, $dots.c$),
        (
          (0, $60$, 0, 0, 0, 0),
          ($10$, 0, $60$, 0, 0, 0),
          (0, $10$, 0, $60$, 0, 0),
          (0, 0, $10$, 0, $60p$, 0),
          (0, 0, 0, $10$, 0, $60p$),
          (0, 0, 0, 0, $10$, 0),
        ),
        positions: ((0, 0), (1.5, 0), (3, 0), (4.5, 0), (6, 0), (7.5, 0)),
        node-radius: 4.5mm,
      )
    ]
  + With $lambda\/mu = 6$, the formula sheet gives
    $
      theta_k = cases(
        6^k quad & k < 3,
        6^3 (6 p)^(k - 3) & k >= 3,
      )
      quad quad sum_(k=0)^oo theta_k = 1 + 6 + 36 + 216 sum_(j=0)^oo (6 p)^j = 43 + 216 / (1 - 6 p),
    $
    where the geometric series converges if and only if $6 p < 1$. Then $pi_0 = 1 \/ (43 + 216\/(1 - 6p))$ and $pi_k = theta_k pi_0$. If $p >= 1\/6$, the sum is infinite and $pi_k = 0$ for all $k$, so there is no limiting distribution.

    The condition is $p < 1\/6$, i.e. $60 p < 10$. When the queue is long, customers join at rate $60 p$ and leave at rate $10$. If they join faster than they are served, the queue grows forever. The states $0, 1, 2$ do not matter, since they are only finitely many.
  + With $p = 0.1$, $6 p = 0.6$ and $sum_k theta_k = 43 + 540 = 583$. Poisson arrivals see the stationary distribution (as in the gas station example), and an arriving customer is lost if there are $3$ or more customers (probability $540\/583 approx 0.93$) _and_ the customer decides to leave (probability $0.9$). So the fraction lost is
    $
      0.9 dot 540 / 583 approx 0.83, quad "and" quad lambda_a = 60 (1 - 0.83) approx 9.98 "per hour".
    $
    Using $sum_(j=0)^oo j a^j = a\/(1 - a)^2$ and $sum_(j=0)^oo a^j = 1\/(1 - a)$, so that $sum_(j=0)^oo (j + 3) 0.6^j = 0.6\/0.4^2 + 3\/0.4 = 3.75 + 7.5$,
    $
      L = sum_(k=0)^oo k pi_k = 1/583 (6 + 2 dot 36 + 216 sum_(j=0)^oo (j + 3) 0.6^j) = 1/583 (78 + 216 (3.75 + 7.5)) = 2508/583 approx 4.30.
    $
    By Little's law, $W = L\/lambda_a approx 0.43$ hours $approx 26$ minutes.
]

#pagebreak()
== Gaussian processes and Brownian motion

#problem(name: [Exam 2024, Problem 4 a)])[
  A GPS device gives a position $(X, Y)$ which is bivariate normal with expectation $(10"m", 20"m")$, standard deviations $(1"m", 1"m")$, and correlation $0.9$.
  + Determine the distribution of $Y$ conditionally given that $X = 9"m"$.
  + Plot $EE(Y | X = x)$ as a function of $x$ between $5"m"$ and $15"m"$.
]
#solution[
  + By the conditioning formula with $sigma_X = sigma_Y = 1"m"$ and $rho = 0.9$,
    $
      EE[Y | X = 9] = 20 + 0.9 (9 - 10) = 19.1"m", quad "Var"[Y | X = 9] = 1 - 0.9^2 = 0.19"m"^2,
    $
    so $Y | X = 9 tilde.op N(19.1"m", 0.19"m"^2)$, with standard deviation $0.44"m"$. Knowing $X$ reduces the uncertainty in $Y$.
  + $EE[Y | X = x] = 20 + 0.9 (x - 10)$ is a straight line with slope $0.9$ through $(10, 20)$, going from $15.5"m"$ at $x = 5"m"$ to $24.5"m"$ at $x = 15"m"$.
]

#problem(name: [Exam 2020, Problem 3])[
  Assume that we model the stock price of DNB as a Brownian motion ${B(t) : t >= 0}$, where $t$ is measured in hours, with variance parameter $sigma^2 = 5^2 "kr"^2$. When the stock market opens at 08:00, the stock price is $150 "kr"$.
  + Compute the probability that the stock price will exceed $170 "kr"$ at 12:00.
  + When the market closes at 16:00, we observe that the stock price is $200 "kr"$. Compute the conditional probability that the stock price at 12:00 exceeded $170 "kr"$.
  + _(Extra, cf. Exam 2013 and 2014)_ Without the information from 16:00, what is the probability that the stock price reaches $170 "kr"$ at some time before 12:00?
]
#solution[
  Let $t = 0$ be 08:00, so that 12:00 is $t = 4$ and 16:00 is $t = 8$. Then $W(t) = B(t) - 150$ is a Brownian motion starting in $0$ with $sigma = 5$.
  + $W(4) tilde.op N(0, 25 dot 4)$, so
    $
      P(B(4) > 170) = P(W(4) > 20) = P(Z > 20 / 10) = 1 - Phi(2) approx 0.023.
    $
  + We observe $W(8) = 50$. By the formula for conditioning on the future with $s = 4$ and $t = 8$,
    $
      W(4) | W(8) = 50 tilde.op N(4/8 dot 50, 25 dot (4 dot 4)/8) = N(25, 50),
    $
    so
    $
      P(W(4) > 20 | W(8) = 50) = P(Z > (20 - 25) / sqrt(50)) = P(Z > -0.71) approx 0.76.
    $
    Knowing that the price ended high makes it much more likely that it was high at 12:00 too.
  + By the reflection principle,
    $
      P(max_(0 <= u <= 4) W(u) >= 20) = 2 P(W(4) >= 20) approx 2 dot 0.023 = 0.046.
    $
]


#problem(name: [Checking BM conditions])[
  Define the stochastic process ${X(t) : t >= 0}$ with variance parameter $sigma^2 > 0$ through the three properties:
  - For $0 <= s < t$, the increment $X(t) - X(s)$ is normal with mean $0$ and variance $sigma^2 integral_s^t e^(-x) dif x$.
  - For $0 <= t_1 < t_2 <= t_3 < t_4$, the two increments $X(t_2) - X(t_1)$ and $X(t_4) - X(t_3)$ are independent.
  - $X(0) = 0$.
  Derive $"Var"[X(t)]$. Is ${X(t) : t >= 0}$ a Brownian motion? A continuous-time Markov chain? A Gaussian process?
]
#solution[
  - *Variance:* Since $X(0) = 0$, $X(t) = X(t) - X(0)$ is the increment from $0$ to $t$. Using the first property with $s = 0$,
    $
      "Var"[X(t)] = sigma^2 integral_0^t e^(-x) dif x = sigma^2 (1 - e^(-t)).
    $
  - *Brownian motion:* No. For a BM, $"Var"[X(t)] = sigma^2 t$. Also, the increment $X(t) - X(s)$ has variance $sigma^2 (e^(-s) - e^(-t))$, which depends on _where_ the interval is and not only on its length $t - s$.
  - *CTMC:* By the independent increments, the future only depends on the present value, so $X$ has the Markov property. However, the state space is $RR$ and not countable, so it is not a Markov _chain_.
  - *Gaussian process:* Yes. Any $(X(t_1), dots, X(t_n))$ is a linear transformation of the independent Gaussian increments, and hence multivariate normal. As for BM, $"Cov"(X(s), X(t)) = "Var"[X(s)] = sigma^2 (1 - e^(-s))$ for $s <= t$.
]
