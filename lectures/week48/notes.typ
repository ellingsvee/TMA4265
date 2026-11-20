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

// This is the second of two exam preparation sessions. Last week we covered probability theory, discrete-time Markov chains and Poisson processes. Today we cover continuous-time Markov chains, queueing theory, Gaussian processes and Brownian motion.

= About the exam
Past exams with solutions are at #link("https://www.math.ntnu.no/emner/TMA4265/exams/"). Some observations from 2024–2026:
- The exam comes with a formula sheet. For this half of the course it contains
  - the birth-and-death definition, Kolmogorov's forward and backward equations and the formula $pi_k = theta_k pi_0$,
  - Little's law $L = lambda_a W$ and the limiting distributions of the M/M/1 and M/M/$oo$ queues,
  - the conditional distribution of a multivariate normal, and the properties of Brownian motion.

  Do not waste space on your A5 sheet on these!
- The CTMC/queueing problems follow the same recipe: _explain_ the model, draw the transition diagram, write down the generator, find the stationary distribution and _interpret_ it. A simulation algorithm is often asked for.
- Brownian motion has not been asked in 2024–2026, but it is part of the curriculum (it was asked in 2022 and 2023).

= Checklist
You should be able to:
+ Explain why a process is a CTMC or a birth-and-death process, and draw the transition diagram.
+ Write down the generator $bf(A)$ and the Kolmogorov forward equations, and solve them for two states.
+ Find the stationary distribution, and use first-step analysis for expected times and absorption probabilities.
+ Describe how to simulate a CTMC from $bf(A)$.
+ Explain Kendall's notation, and use Little's law and the M/M/1, M/M/$s$ and M/M/$oo$ queues.
+ Find the effective arrival rate and the fraction of lost customers.
+ Condition a multivariate normal on some of its components.
+ Compute with the covariance $min(s, t)$ of Brownian motion, check if a process is a Brownian motion, and use the reflection principle.

#pagebreak()
= Theory
== Continuous-time Markov chains
#definition(name: [Continuous-time Markov chain])[
  A process ${X(t) : t >= 0}$ with countable state space $cal(S)$ is a (time-homogeneous) continuous-time Markov chain (CTMC) if
  $
    P(X(s + t) = j | X(s) = i, X(u) = x(u), 0 <= u < s) = P(X(t) = j | X(0) = i) = P_(i,j)(t).
  $
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
]

#theorem(name: [Structure of a CTMC])[
  - The sojourn time in $i$ is $"Exp"(q_i)$, independent of everything else.
  - The next state is $j$ with probability $q_(i,j) \/ q_i$. These jump probabilities form the _embedded_ DTMC.
]

#remark()[
  To "explain that this is a CTMC/birth-and-death process":
  + Give the state space (f.ex. number of customers) and index set $t >= 0$.
  + Argue that all the waiting times (arrivals, services, repairs) are independent and exponential. By the memoryless property, the future then only depends on the current state.
  + Find the rates using competing exponentials. With $k$ busy servers, the time until the next service completion is $min(T_1, dots, T_k) tilde.op "Exp"(k mu)$.
]

#theorem(name: [Kolmogorov equations])[
  The matrix $bf(P)(t) = [P_(i,j)(t)]$ satisfies the forward and backward equations
  $
    bf(P)'(t) = bf(P)(t) bf(A) quad "and" quad bf(P)'(t) = bf(A) bf(P)(t), quad bf(P)(0) = bf(I),
  $
  with solution $bf(P)(t) = exp(t bf(A)) = sum_(n=0)^oo (t bf(A))^n \/ n!$. The entry $P_(i,j)(t)$ is the probability of being in $j$ at time $t$ when starting in $i$. If $bold(p)(t)$ is the row vector of probabilities $P(X(t) = j)$, then $bold(p)'(t) = bold(p)(t) bf(A)$.
]

#remark(name: [Two-state chain])[
  For $0 ->^lambda 1$ and $1 ->^mu 0$, solving the forward equation with $P_(1,0)(t) = 1 - P_(1,1)(t)$ gives
  $
    P_(1,1)(t) = lambda / (lambda + mu) + mu / (lambda + mu) e^(-(lambda + mu) t).
  $
  This was asked in 2025 (see Week 39). Learn the integrating factor method!
]

#theorem(name: [Stationary distribution])[
  For an irreducible CTMC, the limiting distribution $pi_j = lim_(t -> oo) P_(i,j)(t)$ (if it exists) is the solution of
  $
    bold(pi) bf(A) = bold(0), quad sum_j pi_j = 1, quad "i.e." quad underbrace(pi_j q_j, "rate out of" j) = underbrace(sum_(k != j) pi_k q_(k,j), "rate into" j).
  $
  For a birth-and-death process this reduces to $lambda_(k-1) pi_(k-1) = mu_k pi_k$ (rate across each cut), which gives $pi_k = theta_k pi_0$ (formula sheet). The value $pi_j$ is the long-run fraction of time spent in $j$.
]

#theorem(name: [First-step analysis])[
  Let $v_i$ be the expected time until hitting $A$ when starting in $i$. Then $v_i = 0$ for $i in A$ and
  $
    v_i = 1 / q_i + sum_(j != i) q_(i,j) / q_i v_j, quad i in.not A.
  $
  Absorption probabilities only depend on the jump probabilities, so they are computed in the embedded DTMC (Week 40).
]

#remark(name: [Simulation])[
  Given $X(0) = i$ and a time horizon $T$:
  + Draw a sojourn time $S tilde.op "Exp"(q_i)$ and set $t <- t + S$. Stop if $t > T$.
  + Draw the next state $j$ with probabilities $q_(i,j)\/q_i$, i.e. $-a_(i,j)\/a_(i,i)$. Set $i <- j$ and go to 1.
  Estimate f.ex. $P_(i,j)(T)$ by the fraction $hat(p)$ of $M$ runs ending in $j$, with standard error $sqrt(hat(p)(1 - hat(p))\/M)$.
]

#pagebreak()
== Queueing theory
A queue is described by Kendall's notation A/B/$s$ (/capacity): A is the arrival process, B the service time distribution and $s$ the number of servers. M means Markovian (Poisson arrivals or exponential service times). In an M/M/$s$ queue, the number of customers $X(t)$ in the system (queue plus service) is a birth-and-death process.

#theorem(name: [Little's law])[
  In the long run,
  $
    L = lambda_a W, quad L_Q = lambda_a W_Q, quad W = W_Q + 1/mu,
  $
  where $L$ ($L_Q$) is the mean number of customers in the system (queue), $W$ ($W_Q$) is the mean time a customer spends in the system (queue), $lambda_a$ is the rate of customers that actually enter and $1\/mu$ the mean service time.
]

#definition(name: [Stable queue])[
  A queue is _stable_ if the number of customers $X(t)$ has a limiting distribution $bold(pi)$. For a birth-and-death process this holds if and only if $sum_(k=0)^oo theta_k < oo$, so that $pi_0 = 1 \/ sum_k theta_k > 0$. Otherwise $pi_k = 0$ for all $k$, and the queue grows without bound.

  Intuitively, the servers must work faster than customers arrive. A queue with finite capacity is always stable, since the sum is finite.
]

#theorem(name: [Standard queues])[
  Let $lambda$ be the arrival rate and $mu$ the service rate of each server.
  - M/M/1: $lambda_k = lambda$ and $mu_k = mu$. Stable if and only if $rho = lambda\/mu < 1$, and then $pi_k = (1 - rho) rho^k$ is geometric, and
    $
      L = rho / (1 - rho), quad W = L / lambda = 1 / (mu - lambda).
    $
  - M/M/$s$: $lambda_k = lambda$ and $mu_k = min(k, s) mu$. Stable if and only if $lambda < s mu$. For $k >= s$ the $theta_k$ are geometric with ratio $lambda\/(s mu)$.
  - M/M/$oo$: $lambda_k = lambda$ and $mu_k = k mu$. Always stable with $X tilde.op "Poisson"(lambda\/mu)$, so $L = lambda\/mu$ and $W = 1\/mu$.
]

#remark(name: [Lost customers])[
  If arrivals are turned away (full system or balking), not all $lambda$ arrivals enter. Since Poisson arrivals see the system in its stationary distribution, the fraction of lost customers is $pi_"full"$ and
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
]

#definition(name: [Brownian motion])[
  ${B(t) : t >= 0}$ is a Brownian motion with variance parameter $sigma^2$ if $B(0) = 0$, it has independent increments, $B(t) - B(s) tilde.op N(0, sigma^2 (t - s))$ for $s < t$, and continuous paths. It is _standard_ if $sigma^2 = 1$. Equivalently, it is a Gaussian process with continuous paths and
  $
    m(t) = 0 quad "and" quad C(s, t) = sigma^2 min(s, t).
  $
]

#remark(name: [Is it a Brownian motion?])[
  To show that a process $X$ built from $B$ is a standard Brownian motion, check that it is a Gaussian process (linear in $B$), that $X(0) = 0$, $EE[X(t)] = 0$, $"Cov"(X(s), X(t)) = min(s, t)$ and that the paths are continuous. To show that it is _not_, find one property that fails, f.ex. the variance.
]

#definition(name: [Brownian bridge])[
  The Brownian bridge is $B^0 (t) = B(t) | B(1) = 0$ for $t in [0, 1]$. It is a Gaussian process with
  $
    m(t) = 0 quad "and" quad C(s, t) = s (1 - t), quad 0 <= s <= t <= 1.
  $
  The process $B(t) - t B(1)$ has the same distribution.
]

#theorem(name: [Reflection principle])[
  For a standard Brownian motion, $a > 0$ and $T_a = min{t >= 0 : B(t) = a}$,
  $
    P(max_(0 <= u <= t) B(u) >= a) = P(T_a <= t) = 2 P(B(t) >= a) = 2 (1 - Phi(a / sqrt(t))).
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
  + With $theta_0 = 1$, $theta_1 = 20\/12 = 5\/3$ and $theta_2 = (20\/12)^2 = 25\/9$, we get $sum_k theta_k = 49\/9$ and
    $
      bold(pi) = (9/49, 15/49, 25/49) approx (0.18, 0.31, 0.51).
    $
  + A customer is lost when arriving to $2$ cars. Poisson arrivals see the stationary distribution, so the fraction lost is $pi_2 = 25\/49 approx 51%$. The effective arrival rate is $lambda_a = 20 dot 24\/49 approx 9.8$ cars per hour.
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
#problem(name: [Exam 2022, Problem 4 b)–d)])[
  Guests arrive to a museum according to a Poisson process with rate $lambda = 10$ guests per hour. Each guest who arrives is either quick or slow. A quick guest spends a time in the museum that follows an exponential distribution with expected value $0.25$ hours, and a slow guest spends a time that follows an exponential distribution with expected value $1$ hour. For each guest, there is a probability $p = 0.9$ that the guest is quick. All guests are independent of each other and the arrival process, and the museum is always open. Let $X_"quick" (t)$ be the number of quick guests in the museum.
  + Explain why ${X_"quick" (t) : t >= 0}$ is an M/M/$oo$ queue, and determine its birth and death rates.
  + You can assume as known that the long-run fraction of time with $0$ slow guests is $0.3679$. Calculate the long-run fraction of time with $0$ quick guests, and with $0$ guests in total. How much money can be saved per day by turning off the lights ($2000$ kroner per hour) when the museum is empty?
  + Explain why the total number of guests $X(t)$ is not a birth-and-death process. A long time has passed, and there is one guest in the museum. What is the probability that this guest is quick?
]
#solution[
  + By thinning, quick guests arrive according to a Poisson process with rate $p lambda = 9$ per hour. Each quick guest stays an independent $"Exp"(4)$ time, and all guests are "served" at the same time (no queue), so this is an M/M/$oo$ queue with
    $
      lambda_k = 9, quad mu_k = 4 k.
    $
  + In the long run $X_"quick" tilde.op "Poisson"(9\/4)$, so the fraction of time with no quick guests is $e^(-9\/4) approx 0.105$. (Similarly, $X_"slow" tilde.op "Poisson"(1 dot 1)$, which gives $e^(-1) = 0.3679$.) By thinning the two processes are independent, so
    $
      P("empty") = e^(-9\/4) e^(-1) = e^(-3.25) approx 0.039.
    $
    The savings are $0.039 dot 24 dot 2000 approx 1861$ kroner per day.
  + In state $1$, the rate of departure depends on whether the guest is quick ($4$) or slow ($1$), which is not determined by $X(t)$ alone. Hence the death rate is not a function of the state. Using independence and the Poisson probabilities,
    $
      P("quick" | X = 1) = (P(X_"q" = 1) P(X_"s" = 0)) / (P(X_"q" = 1) P(X_"s" = 0) + P(X_"q" = 0) P(X_"s" = 1)) = (9\/4) / (9\/4 + 1) = 9/13 approx 0.69.
    $
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

#problem(name: [Exam 2023, Problem 4])[
  Given standard Brownian motion ${B(t) : t >= 0}$, the Brownian bridge ${B^0 (t) : t in [0, 1]}$ can be defined as $B^0 (t) = B(t) | B(1) = 0$.
  + Derive the mean function $m(t) = EE[B^0 (t)]$ and covariance function $C(s, t) = "Cov"(B^0 (s), B^0 (t))$ for $s, t in [0, 1]$.
  + Write pseudocode to simulate a realization of the Brownian bridge at $t_i = i\/m$, $i = 0, dots, m$, using a function `rnorm(n)` that returns $n$ i.i.d. standard normal variables.
]
#solution[
  + Let $s <= t$. Since $"Cov"(B(s), B(t)) = min(s, t)$,
    $
      mat(B(s); B(t); B(1)) tilde.op N_3 (bold(0), mat(s, s, s; s, t, t; s, t, 1)).
    $
    Condition $bold(x)_A = (B(s), B(t))$ on $x_B = B(1) = 0$. With $bf(Sigma)_(A,B) = (s, t)^top$ and $Sigma_B = 1$,
    $
      EE[bold(x)_A | x_B = 0] = bold(0) + bf(Sigma)_(A,B) dot 1 dot (0 - 0) = bold(0),
    $
    $
      "Var"[bold(x)_A | x_B = 0] = mat(s, s; s, t) - mat(s; t) mat(s, t) = mat(s(1 - s), s(1 - t); s(1 - t), t(1 - t)).
    $
    Hence $m(t) = 0$ and $C(s, t) = s(1 - t)$ for $s <= t$.
  + The variance is $0$ at $t = 0$ and $t = 1$, so we simulate the interior points and add the known endpoints.
    + Set $t_i = i\/m$ for $i = 1, dots, m - 1$.
    + Build the covariance matrix $Sigma_(i,j) = min(t_i, t_j) (1 - max(t_i, t_j))$.
    + Compute the Cholesky factor $bf(L)$ with $bf(Sigma) = bf(L) bf(L)^top$.
    + Draw `z = rnorm(m-1)` and set $bold(b) = bf(L) bold(z)$, which is $N(bold(0), bf(Sigma))$.
    + Return $(0, t_1, dots, t_(m-1), 1)$ and $(0, b_1, dots, b_(m-1), 0)$.
    A simpler alternative: simulate $B$ by cumulative sums $B(t_i) = sum_(k=1)^i Z_k \/ sqrt(m)$ and return $B(t_i) - t_i B(1)$.
]

#problem(name: [Exam 2022, Problem 6])[
  Let ${B(t) : t >= 0}$ be standard Brownian motion.
  + Show that $X(t) = 1/a B(a^2 t)$ is a standard Brownian motion for $a > 0$.
  + Show that $W(t) = t B(t)$ is not a Brownian motion.
]
#solution[
  + $X$ is a linear transformation of $B$, so it is a Gaussian process with continuous paths and $X(0) = 0$. The mean is $0$, and for $s <= t$
    $
      "Cov"(X(s), X(t)) = 1/a^2 "Cov"(B(a^2 s), B(a^2 t)) = 1/a^2 a^2 s = s = min(s, t).
    $
    These are the mean and covariance functions of standard Brownian motion.
  + $"Var"[W(t)] = t^2 "Var"[B(t)] = t^3$. Brownian motion has variance $sigma^2 t$, which is linear in $t$, so $W$ is not a Brownian motion.
]

