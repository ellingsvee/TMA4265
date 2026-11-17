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
  = Week 47: Exam preparation 1
]

== My plan
This week:
- Probability theory
- Discrete-time Markov chains
- Poisson processes

Next week:
- Continuous-time Markov chains
- Queueing theory
- Brownian motion

*Alternatively:* You can suggest topics or problems that you want me to cover!



== General tips
- Learn to use the blue book!
- Check which formulas are given in the exam. This way you avoid wasting space on your A5 sheet.
- Almost every problem has "explain" or "define" parts. Cheap points if you know the definitions.
  - F.ex. "explain that this is a Markov chain" or "what is the definition of a random variable?".
- Use a clear notation. Try to convey your understanding.


= Proability theory
// _The curse and blessing of Gunnar Taraldsen..._

==
Kolmogorov: A probability space $(Omega, cal(E), P)$ consists of a sample space $Omega$, a family of events $cal(E)$ and a probability $P$.
#definition(name: [$sigma$-algebra])[
  The family of events $cal(E)$ is a $sigma$-algebra on $Omega$, i.e.
  - $Omega in cal(E)$.
  - If $A in cal(E)$, then $A^C in cal(E)$.
  - If $A_1, A_2, ... in cal(E)$, then $union_(i=1)^(oo) A_i in cal(E)$.
  // Since $inter_i A_i = (union_i A_i^C)^C$, $cal(E)$ is also closed under countable intersections.
]
#definition(name: [Probability])[
  A probability on $(Omega, cal(E))$ is a function $P: cal(E) -> RR$ such that
  - $P(A) >= 0$ for all $A in cal(E)$.
  - $P(Omega) = 1$.
  - If $A_1, A_2, ... in cal(E)$ are pairwise disjoint, then $P(union_(i=1)^(oo) A_i) = sum_(i=1)^(oo) P(A_i)$.
]

==
#definition(name: [Random variable])[
  A random variable (RV) is a function $X: Omega -> RR$ such that
  $
    (X <= x) = {omega in Omega: X(omega) <= x} in cal(E) quad "for all" x in RR.
  $
  This guarantees that the CDF $F_X (x) = P(X <= x)$ is well defined.
]

== Connection to our course
#definition(name: [Stochastic process])[
  A stochastic process is a family ${X_t : t in cal(I)}$ of random variables $X_t: Omega -> cal(S)$ on the same probability space, with _index set_ $cal(I)$ and _state space_ $cal(S)$. Its distribution is given by the finite-dimensional distributions
  $
    P(X_(t_1) in A_1, dots, X_(t_n) in A_n), quad t_1, dots, t_n in cal(I), quad n = 1, 2, dots
  $
]
#pause
*Typical index sets and state spaces:*
- Discrete-time Markov chain: $cal(I) = {0, 1, dots}$ and $cal(S)$ countable (f.ex. ${0, 1, 2}$).
- Poisson process: Often $cal(I) = [0, oo)$ and $cal(S) = {0, 1, dots}$.
// - Poisson process in space: $cal(I)$ is the family of (Borel) regions $A subset.eq RR^3$ and $cal(S) = {0, 1, dots}$.
// - Brownian motion: $cal(I) = [0, oo)$ and $cal(S) = RR$.
// For a Markov chain, the finite-dimensional distributions are fully determined by the initial distribution and $bf(P)$, since
// $
//   P(X_0 = i_0, dots, X_n = i_n) = P(X_0 = i_0) P_(i_0, i_1) dots.c P_(i_(n-1), i_n).
// $


== Problem: Exam 2026
Occurrence of E. coli bacteria in drinking water from a given water source can be modelled by a Poisson process N with intensity measure $lambda$. Let $X = N(V)$ and $Y = N(W)$ be the number of viable cells in two samples given by regions $V$ and $W$ in the fluid.
+ What are the index set $cal(I)$ and state space $cal(S)$ of the Poisson process $N$?
+ How is $N$ connected to the unknown underlying probability space $Omega$?
+ What are the defining properties of the space $Omega$ according to the mathematical model introduced by Kolmogorov?
+ Both $X$ and $Y$ are random variables and then they have well defined cumulative distributions $F_X$ and $F_Y$ . What does this mean in terms of the assumptions on $Omega$ Prove that if $X$ and $Y$ are random variables, then $X − Y$ is a random variable.

= Discrete-time Markov chains

==

#definition(name: [Markov chain])[
  A process ${X_n : n = 0, 1, dots}$ with countable state space $cal(S)$ is a (time-homogeneous) Markov chain if
  - Markov property:
    $
      P(X_(n+1) = j | X_0 = i_0, dots, X_(n-1) = i_(n-1), X_n = i) = P(X_(n+1) = j | X_n = i).
    $
  - Time-homogeneity/stationarity:
    $
      P(X_(n+1) = j | X_n = i) = P_(i,j).
    $
]

#pause
*Explain that this is a Markov chain:*
+ Give the state space and index set.
+ Argue that the next state only depends on the current state, and that the transition probabilities don't change over time.
+ Give $bf(P)$ (rows sum to one) and draw the transition diagram.

==
#theorem(name: [Chapman–Kolmogorov])[
  The $n$-step transition probabilities
  $
    P_(i,j)^((n)) = P(X_(m+n) = j | X_m = i)
  $
  are the entries of $bf(P)^n$.
  // If $X_m$ has distribution $bold(u)$, i.e. $u_i = P(X_m = i)$, then
  // $
  //   P(X_(m+n) = j) = sum_(i in cal(S)) u_i P_(i,j)^((n)) = [(bf(P)^top)^n bold(u)]_j.
  // $
]

#pause
*Trick:* Probabilities "backwards" in time use Bayes rule and Markov property. F.ex.
$
  P(X_4 = 0 | X_3 = 1, X_5 = 0) = (P_(1,0) P_(0,0)) / (P_(1,0)^((2))).
$

== First step analysis
// To me I rely on "intuition" and manual derivations rather than memorizing formulas.
*In my opinion, performing first-step analysis is more about understanding than about remembering formulas!*

#pause
#text(size: 11pt)[
  Condition on the first step to get linear equations. Let $T_A = min{n >= 0: X_n in A}$.
  - Probability of hitting $A$ before $B$, $u_i = P(T_A < T_B | X_0 = i)$:
    $
      u_i = cases(
        1 & "if" i in A,
        0 & "if" i in B,
        sum_(k in cal(S)) P_(i,k) u_k quad & "otherwise".
      )
    $
  - Expected time until hitting $A$, $v_i = EE[T_A | X_0 = i]$:
    $
      v_i = cases(
        0 & "if" i in A,
        1 + sum_(k in.not A) P_(i,k) v_k quad & "otherwise".
      )
    $
  - Expected number of visits to $j$ before hitting $A$, $w_(i,j)$: For $i, j in.not A$
    $
      w_(i,j) = bb(1){i = j} + sum_(k in.not A) P_(i,k) w_(k,j).
    $
  - Mean return time to $j$: $m_j = 1 + sum_(k != j) P_(j,k) v_k$ with $A = {j}$. Note that return times use $n >= 1$, hitting times $n >= 0$.
]
// #text(size: 18pt)[
//   *Tips:*
//   - Clearly define your notation (f.ex. what you mean by $u_i$ and $v_i$).
//   - If $0$ is absorbing, then $P(T_0 <= n | X_0 = i) = P_(i,0)^((n))$.
//   - To find $P(T_A < T_B)$, you can make $A$ and $B$ absorbing.
// ]

== Problem: Exam 2026
#text(size: 18pt)[
  // A subscription service classifies each customer each week into one of three states: $0$ (cancelled subscription), $1$ (at risk) and $2$ (active). The weekly evolution is modelled as a
  Markov chain ${X_t : t = 0, 1, dots}$ with state space $cal(S) = {0, 1, 2}$ and transition matrix
  $
    bf(P) = mat(
      1, 0, 0;
      1\/4, 1\/2, 1\/4;
      1\/4, 1\/4, 1\/2
    ).
  $
  Let $T = min{t >= 1 : X_t = 0}$. Determine the following:
  // + If the customer is at risk in week 23, what is the probability that the customer has cancelled the subscription in week 25?
  + $P(X_2 = 0 | X_0 = 1)$?
  + $P(T <= 3 | X_0 = 2)$?
  + $P("state 1 is visited at least once before state 0" | X_0 = 2)$?
  + $EE[T | X_0 = 2]$?
  + $EE[sum_(t=0)^(T-1) bb(1){X_t = 1} | X_0 = 2]$?
  + $lim_(n -> oo) 1/n sum_(t=0)^(n-1) bb(1){X_t = 2}$?
]






== Long-run behavior
*Core definitions:*
- $i$ and $j$ _communicate_ if they are accessible from each other. This splits $cal(S)$ into classes, and the chain is irreducible if there is only one.
- The period is $d(i) = gcd{n >= 1: P_(i,i)^((n)) > 0}$. If $P_(i,i) > 0$, then $d(i) = 1$ (aperiodic).
- Let $tau_i = min{n >= 1: X_n = i}$ be the return time to $i$, $f_(i,i) = P(tau_i < oo | X_0 = i)$ is the return probability and $m_i = EE[tau_i | X_0 = i]$ the mean return time.
- $i$ is _recurrent_ if $f_(i,i) = 1$ and _transient_ otherwise. It is _positive recurrent_ if also $m_i < oo$.
- In a finite chain, closed classes are positive recurrent and the rest are transient.

==
#theorem()[
  An irreducible Markov chain has a stationary distribution $bold(pi)$,
  $
    pi_j = sum_(i in cal(S)) pi_i P_(i,j) quad "and" quad sum_(i in cal(S)) pi_i = 1,
  $
  if and only if it is positive recurrent. Then $bold(pi)$ is unique and $pi_j = 1\/m_j$. If the chain is also aperiodic, $bold(pi)$ is the limiting distribution.
]

#corollary()[
  A finite irreducible chain has a unique stationary distribution. If it is also aperiodic, this is the limiting distribution.
]
#pause
*Common tricks:*
- If an absorbing state can be reached from everywhere, the long-run fraction of time in every other state is $0$.
- If $X_1 tilde.op bold(pi)$, then $X_n tilde.op bold(pi)$ for all $n$.

== Problem: Exam 2023
Consider the Markov chain ${X_n : n = 0, 1, dots}$ with state space ${0, 1, 2}$ and transition matrix
$
  bf(P) = mat(
    alpha, 1 - alpha, 0;
    0, beta, 1 - beta;
    1 - phi, 0, phi
  ),
$
where $alpha, beta, phi in [0, 1]$ are known parameters.
+ Draw the transition diagram, noting when the various edges exist. What conditions are necessary for the chain to be irreducible? Assume these conditions hold. What are the equivalence classes? What are the periods of each state, and under what conditions? Is the chain recurrent?
+ Assume the chain is irreducible. Calculate the stationary distribution $bold(pi) = (pi_0, pi_1, pi_2)$. Is it a limiting distribution? Why or why not?


= Poisson processes
== Fundamentals
A Poisson process ${N(t): t >= 0}$ with rate $lambda$:
- $N(0) = 0$
- Independent increments and $N(s + t) - N(s) tilde.op "Poisson"(lambda t)$.
- Sojourn times are i.i.d. $"Exp"(lambda)$.
- Waiting time $W_n$ until the $n$-th event is $"Gamma"(n, lambda)$.
#pause
*Discussing the Poisson assumptions:*
- One event at a time?
- Independent counts in disjoint intervals?
- Constant rate? If not, can we use an inhomogeneous process?

== Core properties
#theorem(name: [Memoryless property])[
  If $T tilde.op "Exp"(lambda)$, then
  $
    P(T > t + s | T > t) = P(T > s).
  $
  The exponential is the only continuous distribution with this property.
]

#theorem(name: [Waiting times])[
  For $W_n tilde.op "Gamma"(n, lambda)$:
  - $EE[W_n] = n\/lambda$ and $"SD"[W_n] = sqrt(n)\/lambda$.
  - $P(W_n > t) = P(N(t) <= n - 1) = sum_(k=0)^(n-1) e^(-lambda t) (lambda t)^k / k!$.
  - $2 lambda W_n tilde.op chi^2_(2n)$, so quantiles can be found from a $chi^2$-table.
  // - CLT: For large $n$, $W_n approx N(n\/lambda, n\/lambda^2)$.
]

// #theorem(name: [Conditional arrival times])[
//   Given $N(t) = n$, the (unordered) arrival times are i.i.d. $"Uniform"(0, t)$. Hence, for $s < t$,
//   $
//     N(s) | N(t) = n tilde.op "Binomial"(n, s\/t).
//   $
// ]

== Simulating a Poisson process
*Simulate on $[0, t]$ by either:*
- Adding $"Exp"(lambda)$ sojourn times until the sum exceeds $t$.
- Drawing $n tilde.op "Poisson"(lambda t)$ and sorting $n$ i.i.d. $"Uniform"(0, t)$ points.

== Constructing new Poisson processes
#theorem()[
  Let $N_1$ and $N_2$ be independent Poisson processes with rates $lambda_1$ and $lambda_2$.
  - $N_1 + N_2$ is a Poisson process with rate $lambda_1 + lambda_2$.
  - For independent $T_1 tilde.op "Exp"(lambda_1)$ and $T_2 tilde.op "Exp"(lambda_2)$, $min(T_1, T_2) tilde.op "Exp"(lambda_1 + lambda_2)$ and
    $
      P(T_1 < T_2) = lambda_1 / (lambda_1 + lambda_2),
    $
    which is the probability that the next event comes from $N_1$.
]

#theorem(name: [Thinning])[
  If each event is independently of type 1 with probability $p$, the type 1 and type 2 events are independent Poisson processes with rates $p lambda$ and $(1 - p) lambda$.
]

== Problem: Exam 2026
#text(size: 18pt)[
  The times $T_1, T_2, dots$ between notifications on Monica's phone are independent with density
  $
    f(t) = cases(
      beta^(-1) e^(-t\/beta) quad & t > 0,
      0 & "otherwise",
    )
  $
  where $beta = 707$ seconds. Find:
  + The expected time between two notifications.
  + The probability that an interval is shorter than $707$ seconds.
  + The probability that at least $8$ of $10$ intervals are shorter than $707$ seconds.
  + The probability of waiting at least $5$ more minutes, given no notification in the first $15$ minutes.
  + The standard deviation of $V = T_1 + dots + T_10$.
  + The value $v$ such that $P(V > v) = 0.95$.
  // + The probability of at least $3$ notifications in the first $30$ minutes, given $10$ notifications in one hour.
  + Newspaper notifications form an independent Poisson process with rate $1\/(15 "min")$. The expected time between notifications of either type, and the probability that the next one is from Fjøsbok.
]



==
#theorem(name: [Compound Poisson process])[
  For $Y(t) = sum_(i=1)^(N(t)) C_i$ with i.i.d. $C_i$ independent of $N(t)$,
  $
    EE[Y(t)] = lambda t EE[C] quad "and" quad "Var"[Y(t)] = lambda t EE[C^2].
  $
]

== Problem: Exam 2021
Customers arrive at a store according to a Poisson process with rate $lambda = 60$ customers per hour. Customers sometimes forget items in the store. Assume that the number of items forgotten by each customer is Poisson distributed with mean $0.02$, and that the numbers are independent between customers. Calculate the expected value and the variance of the number of items forgotten during an eight hour period.



== Checklist
+ Define random variables and stochastic processes, and prove that $X + Y$ is a random variable.
+ Explain why a process is a Markov chain, and compute probabilities with $bf(P)^n$.
+ Use first-step analysis for absorption probabilities, expected times and expected visits.
+ Classify a chain, and decide if $bold(pi)$ is unique and limiting.
+ Compute $bold(pi)$ and use it for long-run fractions of time.
+ Use the exponential and gamma distributions and the memoryless property.
+ Use uniform arrival times given $N(t) = n$, superposition and thinning.
+ Describe how to simulate a Poisson process.
