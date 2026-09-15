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
)

#title-slide[
  = Week 38: Poisson Processes
]

==

#figure()[
  #image(
    "figures/bridge.png",
  )
]


= Theory

==
#definition(name: [Homogeneous Poisson process])[
  A Poisson process with range $lambda > 0$ is an integer-valued stochastic process ${X(t): t >= 0}$ for which:
  + For any time points $0 = t_0 < t_1 < dots < t_n$, the increments
    $
      X(t_1) - X(t_0), X(t_2) - X(t_1), dots, X(t_n) - X(t_(n-1))
    $
    are independent.

  + For any $s>=0$ and $t>0$, $X(s + t) - X(s) tilde.op "Poisson"(lambda t)$.
  + $X(0) = 0$.

  Remarks
  - $X(t) = X(t) - X(0) tilde.op "Poisson"(lambda t)$.
  - $"Var"[X(t)] = EE[X(t)] = lambda t$.
]

== Problem
Arrival of customers follow a homogeneous Poisson process with rate $lambda = 4$ customers per hour. The store opens at 09:00. Calculate the probability that exactly one customer has arrived by 09:30 and exactly five customers have arrived by 11:30.

==
#definition(name: [Inhomogeneous Poisson process])[
  An inhomogeneous Poisson process with rate $lambda(t) >= 0$ with $t >= 0$ is an integer-valued stochastic process ${X(t): t >= 0}$ for which
  + Independent increments.
  + For $s>=0$ and $t>0$, $X(s + t) - X(s) tilde.op "Poisson"(integral_s^(s+t) lambda(x) dif x)$.
  + $X(0) = 0$.

  Remarks:
  - $lambda(t) = lambda_0 ==>$ Homogeneous Poisson process.
  - Intuition is area under the curve (x-axis is time, y-axis is rate).
]

== Problem

#text(
  fill: luma(50%),
)[Arrival of customers follow a homogeneous Poisson process with rate $lambda = 4$ customers per hour. The store opens at 09:00. Calculate the probability that exactly one customer has arrived by 09:30 and exactly five customers have arrived by 11:30.]

Arrival of customers follow an inhomogeneous Poisson process with rate $lambda(t) = t$. The store opens at 09:00. Calculate the probability of no arrivals by 10:00.



==
#definition(name: [Waiting time])[
  The waiting time $W_n$ is the time of the occurrence of the $n$-th event. We define $W_0 = 0$.
]

#definition(name: [Sojourn time])[
  The differences $S_n = W_(n+1) - W_n$ are called sojourn times (or interarrival times).

  The intuition is that $S_n$ is the time spent in state $n$.
]


==
#definition(name: [Exponential distribution])[
  A random variable $Y$ has an exponential distribution with rate $lambda > 0$ if
  $
    f(y) = lambda e^(-lambda y), quad y > 0.
  $
  We write $Y tilde.op "Exp"(lambda)$. Have $EE[Y] = 1\/lambda$ and $"Var"[Y] = 1\/lambda^2$.

  // Remarks:
  // - We use a rate parameterization, but some use a scale parameterization $theta = 1\/lambda$.
  // - $EE[Y] = 1\/lambda$ and $"Var"[Y] = 1\/lambda^2$.
]


#definition(name: [Gamma distribution])[
  A random variable $Y$ has a gamma distribution with shape parameter $alpha > 0$ and rate parameter $lambda > 0$ if
  $
    f(y) = (lambda^alpha )/(Gamma(alpha)) y^(alpha - 1) e^(-lambda y), quad y > 0.
  $
  We write $Y tilde.op "Gamma"(alpha, lambda)$. Have $EE[Y] = alpha\/lambda$ and $"Var"[Y] = alpha\/lambda^2$.

  Remark:
  - Be aware of scale parameterization $theta = 1\/lambda$ used by some authors and lectureres.
  - $"Gamma"(1, lambda) = "Exp"(lambda)$.
]

==
#theorem()[
  Let ${X(t): t>=0}$ be a Poisson process with rate $lambda$. Then $S_0, S_1, dots, S_(n-1) tilde.op^("iid") "Exp"(lambda)$ for all $n >= 1$.
]

#theorem()[
  For a Poisson process with rate $lambda$, we have $W_n tilde.op "Gamma"(n, lambda)$ for all $n >= 1$.
]

== Problem
The occurrences of a rare disease follows a Poisson process with rate $lambda = 2$ per month. Calculate the following:
- The probability that the first case occurs after 1 month.
- The expected time to the $10$-th case occurs.

== Problem
Let ${X(t): t>=0}$ be a Poisson process with rate $lambda > 0$. Show that $W_1 | X(t) = 1 tilde.op U(0, T)$

== Problem
Arrivals follow a Poisson process with rate $lambda$. A store opens at 09:00. Calculate the probability that exactly $5$ people have arrived by 10:00, conditional that exactly $10$ people will arrive by 11:00.

== Problem: Exam

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

= VM 2026 by Norsk Regnesentral

#figure()[
  #image(
    "figures/vm.png",
    width: 80%,
  )
]

== How to do something like this?

#figure()[
  #image(
    "figures/nr_metodikk.png",
    width: 80%,
  )
]

==
- Treat goals scored by each team as *independent Poisson RVs*.
- Suppose team $A$ plays team $B$. Let $s_A$ and $s_B$ denote their strength parameters, and let $n$ denote the expected number of goals scored by one team when two equally strong teams meet. Then
  $
    X_A tilde.op "Poisson"(lambda_A), quad X_B tilde.op "Poisson"(lambda_B),
  $
  with
  $
    lambda_A = n s_A / s_B, quad lambda_B = n s_B / s_A.
  $
// Thus, if $A$ is twice as strong as $B$, its expected number of goals increases, while $B$'s expected number decreases. The two goal counts are assumed independent.

==
From the Poisson distribution, we can calculate the probability of every possible score. For example,
$
  P(X_A = i, X_B = j) = P(X_A = i) P(X_B = j) = (lambda_A^i)/i! e^(-lambda_A) (lambda_B^j)/j! e^(-lambda_B), quad i,j = 0, 1, dots.
$
The probability that $A$ wins is therefore
$
  P(A "wins") = sum_(i > j) P(X_A = i, X_B = j),
$
and similarly one obtains probabilities for a draw or a $B$ victory.

==
The strengths $s_A, s_B, dots$ and the baseline $n$ have to be estimated. According to NR, they initially used expert assessments expressed as hypothetical match results,. As real tournament matches were played, those observations were incorporated into the estimates. This was done using maximum likelihood estimation, which you learned in the introductory statistics course. The likelihood was modified do that very large victories were down-weighted, and they used a penalty term pulling different strengths towards each other to avoid overfitting.

==

#figure()[
  #image(
    "figures/solbakken.png",
    width: 70%,
  )
]

==

Think about what are the limitations or potential inaccuracies of this model. For example, I think assuming that scoring goals is independent between the two teams is a bit of a stretch. Assuming a constant rate of scoring goals throughout the match could also be unrealistic. Other extensions could be separate attacking and defensive strengths, home advantage, dependence between the score counts of the two teams, and so on.













== Problem: Exercise 5
The number of goals scored by Vålerenga IF during a football match is Poisson distributed with an average of $lambda_"V" = 1.2$ goals per match while the number of goals scored by Rosenborg BK is Poisson distributed with an average of $lambda_"R" = 2$ goals per match. The number of goals scored by Vålerenga is independent of the number of goals scored by Rosenborg. Assume that a football match lasts for exactly $90$ minutes ($2 times 45$ minutes) and that Vålerenga plays a match against Rosenborg:
- What is the distribution for the total number of goals scored in this match?
- What is the probability that there are no goals during the first half of the match?
- What is the probability that the final result is 2–2?
- What is the expected time until the first goal in this match?
- Assume that no goals are scored the first 15 minutes of the match. What is the probability that Vålerenga score at least one goal before the break at 45 minutes?



== Towards continuous-time Markov chains

No
