#import "../templates/tma4265-notes.typ": *
#import "@preview/muchpdf:0.1.2": muchpdf

#import "@preview/lemmify:0.1.7": default-theorems, new-theorems, thm-numbering-heading
#show figure.where(kind: "solution-group"): set block(breakable: true)

// #import "@preview/fletcher:0.5.8" as fletcher: diagram, edge, node
// #import "../utils.typ": transition-diagram, transition-figure

#show link: set text(fill: blue)


#show: icml.with(
  title: [
    Week 38: Poisson Processes
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

#definition(name: [Homogeneous Poisson process])[
  A Poisson process with rage $lambda > 0$ is an integer-valued stochastic process ${X(t): t >= 0}$ for which we have
  + For any time points $0 = t_0 < t_1 < dots < t_n$, the increments
    $
      X(t_1) - X(t_0), X(t_2) - X(t_1), dots, X(t_n) - X(t_{n-1})
    $
    are independent.

  + For any $s>=0$ and $t>0$, $X(s + t) - X(s) tilde.op "Poisson"(lambda t)$.
  + $X(0) = 0$.

  Remarks
  - $X(t) = X(t) - X(0) tilde.op "Poisson"(lambda t)$.
  - $"Var"[X(t)] = EE[X(t)] = lambda t$.
]


#definition(name: [Inhomogeneous Poisson process])[
  An inhomogeneous Poisson process with rate $lambda(t) >= 0$ with $t >= 0$ is an integer-valued stochastic process ${X(t): t >= 0}$ for which
  + Independent increments.
  + For $s>=0$ and $t>0$, $X(s + t) - X(s) tilde.op "Poisson"(integral_s^(s+t) lambda(x) dif x)$.
  + $X(0) = 0$.

  Remarks:
  - $lambda(t) = lambda_0 ==>$ (homogeneous) Poisson process.
  - Intuition is area under the curve (x-axis is time, y-axis is rate).
]

#definition(name: [Waiting time])[
  The waiting time $W_n$ is the time of the occurrence of the $n$-th event. We define $W_0 = 0$.
]

#definition(name: [Sojourn time])[
  The differences $S_n = W_(n+1) - W_n$ are called sojourn times (interarrival times).

  The intuition is that $S_n$ is the time spent in state $n$.
]

#definition(name: [Exponential distribution])[
  A random variable $Y$ has an exponential distribution with rate $lambda > 0$ if
  $
    f(y) = lambda e^(-lambda y), quad y > 0.
  $
  We write $Y tilde.op "Exp"(lambda)$.

  Remarks:
  - We use a rate parameterization, but some use a scale parameterization $theta = 1\/lambda$.
  - $EE[Y] = 1\/lambda$ and $"Var"[Y] = 1\/lambda^2$.
]

#theorem()[
  Let ${X(t): t>=0}$ be a Poisson process with rate $lambda$. Then $S_0, S_1, dots, S_(n-1) tilde.op^("iid") "Exp"(lambda)$ for all $n >= 1$.
]

#definition(name: [Gamma distribution])[
  A random variable $Y$ has a gamma distribution with shape parameter $alpha > 0$ and rate parameter $lambda > 0$ if
  $
    f(y) = (lambda^alpha )/(Gamma(alpha)) y^(alpha - 1) e^(-lambda y), quad y > 0.
  $
  We write $Y tilde.op "Gamma"(alpha, lambda)$.

  Remarks:
  - $EE[Y] = alpha\/lambda$ and $"Var"[Y] = alpha\/lambda^2$.
  - $"Gamma"(1, lambda) = "Exp"(lambda)$.
]

#theorem()[
  For a Poisson process with rate $lambda$, we have $W_n tilde.op "Gamma"(n, lambda)$ for all $n >= 1$.
]

#theorem()[
  Let $W_1, dots, W_n$ be the occurrence times in a Poisson process $X(t)$ with rate $lambda$. Then
  $
    f(w_1, dots, w_n | X(t) = n) = n! / t^n, quad 0 < w_1 < dots < w_n <= t.
  $

  Interpretation:
  - Let $V_1, dots, V_n$ be the (unsorted) locations of the $n$ jumps, then $V_1, dots, V_n | X(t) = n tilde.op^("iid") U(0,t)$, meaning
    $
      f(v_1, dots, v_n | X(t) = n) = 1 / t^n, quad 0 < v_1, dots, v_n <= t.
    $
    The $n!$ terms comes from the $n!$ orderings of $v_1,dots,v_n$.
]


// #definition(name: [Little $o$-notation])[
//   Let $f,g: [0, oo) -> RR$. We can use little $o$-notation in two ways:
//   + $f(n) = o(g(n))$ as $n -> oo$ $<==> lim_(n->oo) f(n) \/ g(n) = 0$.
//   + $f(h) = o(g(h))$ as $h -> 0^+$ $<==> lim_(h->0^+) f(h) \/ g(h) = 0$.
//
//   Interpretation:
//   + $f$ grows much slower than $g$ as $n -> oo$.
//   + $f$ goes much quicker to $0$ than $g$ as $h -> 0^+$.
// ]
//
// #theorem(name: [Law of rare events])[
//   Let $p_1, p_2, dots in [0, 1]$ be a sequence so that $lim_(n->oo) n dot p_n = lambda < oo$, then
//   $
//     lim_(n->oo) binom(n, k) p_n^k (1 - p_n)^(n-k) = (lambda^k)/k! e^(-lambda), quad k = 0, 1, dots.
//   $
//
//   Remarks:
//   - Mani independent trials ($n >> 1$) and success is rare ($p << 1$) , then the number of successes is approximately Poisson distributed.
//   - $lim_(n->oo)p_n dot n = lambda <==> p_n = lambda \/ n + o(1\/n)$ as $n -> oo$.
// ]
//
// #definition(name: [Poisson process (part 2)])[
//   A Poisson process with rate $lambda > 0$ is an increasing integer-valued stochastic process ${X(t): t >= 0}$ where
//   + Independent increments.
//   + Stationary increments: The distribution of $X(s + t) - X(s)$ depends only on $t$.
//   + $P(X(h) - X(0) = 1) = lambda h + o(h)$ as $h -> 0^+$.
//   + $P(X(h) - X(0) = 0) = 1 - lambda h + o(h)$ as $h -> 0^+$.
//   + $X(0) = 0$.
// ]



#pagebreak()
#problem()[
  Arrival of customers follow a homogeneous Poisson process with rate $lambda = 4$ customers per hour. The store opens at 09:00. Calculate the probability that exactly one customer has arrived by 09:30 and exactly five customers have arrived by 11:30.
]
#solution()[
  Let $X(t)$ denote the number of arrivals by time $t$. Then
  $
    P(X(1\/2) = 1, X(5\/2) = 5) & = P(X(1\/2) - X(0) = 1, X(5\/2) - X(1\/2) = 4) \
                                & = P(X(1\/2) - X(0) = 1) dot P(X(5\/2) - X(1\/2) = 4) \
                                & = 2^(1)/1! e^(-2) dot 2^(4)/4! e^(-8) approx 0.0155.
  $
]

#problem()[
  Arrival of customers follow an inhomogeneous Poisson process with rate $lambda(t) = t$. The store opens at 09:00. Calculate the probability of no arrivals by 10:00.
]
#solution()[
  $
    mu = integral_0^1 lambda(t) dif t = 1\/2 ==> P(X(1) = 0) = (1\/2)^(0)/0! e^(-1\/2) approx 0.607.
  $
]

#pagebreak()
#problem()[
  The occurrences of a rare disease follows a Poisson process with rate $lambda = 2$ per month. Calculate the following:
  - The probability that the first case occurs after 1 month.
  - The expected time to the $10$-th case occurs.
]
#solution()[
  - $S_0 tilde.op "Exp"(2) ==> P(S_0 > 1) = integral_1^(oo) 2 e^(-2 t) dif t = e^(-2) approx 0.135$.
  - $W_10 tilde.op "Gamma"(10, 2) ==> EE[W_10] = 10\/2 = 5$.
]

#pagebreak()
#problem()[
  Let ${X(t): t>=0}$ be a Poisson process with rate $lambda > 0$. Show that $W_1 | X(t) = 1 tilde.op U(0, T)$
]
#solution()[
  For $0 < w < T$, we have
  $
    P(W_1 <= w | X(t) = 1) & = P(W_1 <= w, X(t) = 1) / P(X(t) = 1) \
                           & = P(X(w) - X(0) = 1, X(t) - X(w) = 0) / P(X(t) - X(0) = 1) \
                           & = (
                             (lambda w)^(1)/1! e^(-lambda w) dot (lambda (t - w))^(0)/0! e^(-lambda (t - w))
                             ) / (
                             (lambda t)^(1)/1! e^(-lambda t)
                             ) \
                           & = w\/t.
  $
  Therefore,
  $
    f(w | X(t) = 1) = dif/(dif w) P(W_1 <= w | X(t) = 1) = dif/(dif w) (w\/t) = 1\/t, quad 0 < w < t,
  $
  which means $W_1 | X(t) = 1 tilde.op U(0, t)$.
]

#pagebreak()
#problem()[
  Arrivals follow a Poisson process with rate $lambda$. A store opens at 09:00. Calculate the probability that exactly $5$ people have arrived by 10:00, conditional that exactly $10$ people will arrive by 11:00.
]
#solution()[
  Conditional on $X(2) = 10$, the $10$ arrival times are iid. $U(0, 2)$. This means that we have $10$ independent trials, $5$ successes, and success probability $p = 1\/2$. Therefore, we have a binomial distribution with parameters $n = 10$ and $p = 1\/2$. Hence,
  $
    P(X(1) = 5 | X(2) = 10) = binom(10, 5) (1/2)^5 (1 - 1/2)^5 approx, 0.246.
  $
]


#pagebreak()
#problem()[
  A certain scientific theory supposes that mistakes in cell division occur according to a Poisson process with rate $2.5$ per year, and that an individual dies when $196$ such mistakes have occurred. Assuming this theory, find
  +
    - The expected time until occurrence of the first mistake in cell division.
    - The expected lifetime of an individual.
    - The lifetime is uncertain. Quantify the uncertainty

  +
    - Calculate an approximation to the probability that an individual reaches an age of $90$ years using the central limit theorem.
    - The probability that an individual reaches an age of $90$ years can be calculated using Monte Carlo simulation. Describe an algorithm based on sampling from an exponential distribution.

  +
    - Determine a formula for an exact calculation of the probability that an individual reaches an age of $90$ years using the Poisson probability distribution.
    - Determine a formula for an exact calculation of the probability that an individual reaches an age of $90$ years using the gamma probability distribution.
]
#solution()[

  +
    - $S_0 tilde.op "Exp"(2.5) ==> EE[S_0] = 1\/2.5 = 0.4$ years.
    - $W_196 tilde.op "Gamma"(196, 2.5) ==> EE[W_196] = 196\/2.5 = 78.4$ years.
    - $"SD"[W_196] = sqrt("Var"[W_196]) = sqrt(196)\/2.5 = 5.6$ years.
  +
    - The sojourn times $S_0, S_1, dots, S_195$ are iid. $"Exp"(2.5)$, so we can use the central limit theorem to approximate the distribution of $W_196 = S_0 + S_1 + dots + S_195$. We have
      $
        EE[W_196] = 78.4, quad "Var"[W_196] = 31.36 ==> "SD"[W_196] = 5.6.
      $
      Therefore,
      $
        P(W_196 > 90) approx P(Z > (90 - 78.4) / 5.6) = P(Z > 2.0714) approx 0.0192.
      $
    - Algorithm for Monte Carlo simulation:
      1. Sample $196$ sojourn times $S_0, S_1, dots, S_195 tilde.op^("iid") "Exp"(2.5)$.
      2. Calculate the lifetime $W_196 = S_0 + S_1 + dots + S_195$.
      3. Repeat steps 1 and 2 for a large number of iterations.
      4. Count the number of lifetimes that exceed $90$ years and divide by the total number of iterations to estimate the probability.
  +
    - Let $M(t) tilde.op "Possion"(lambda t)$ be the number of mistakes in cell division by time $t$. Then
      $
        P(W_196 > 90) = P(M(90) < 196) = sum_(k=0)^(195) (225^k)/k! e^(-225).
      $
    - We know that $W_196 tilde.op "Gamma"(196, 2.5)$, so we can use the cumulative distribution function of the gamma distribution to calculate
      $
        P(W_196 > 90) = 1 - P(W_196 <= 90) = 1 - F_W (90).
      $
]
