#import "../templates/tma4265-notes.typ": *
#import "@preview/muchpdf:0.1.2": muchpdf

#import "@preview/lemmify:0.1.7": default-theorems, new-theorems, thm-numbering-heading
#show figure.where(kind: "solution-group"): set block(breakable: true)

#import "../utils.typ": transition-diagram, transition-figure


#show link: set text(fill: blue)


#show: icml.with(
  title: [
    Week 47: Exam preparation 1
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

// This is the first of two exam preparation sessions. Today we cover the "first half" of the course: probability theory, discrete-time Markov chains and Poisson processes. Next week we cover continuous-time Markov chains, queueing theory and Brownian motion. We cannot go through everything, so the focus is on key concepts and the problem types that keep showing up on the exam.

= About the exam
Past exams with solutions are at #link("https://www.math.ntnu.no/emner/TMA4265/exams/"). Some observations from 2024–2026:
- Learn to use the blue book!
- Check which formulas are given in the exam. This way you avoid wasting space on your A5 sheet.
- Almost every problem has "explain" or "define" parts. Cheap points if you know the definitions.
  - F.ex. "explain that this is a Markov chain" or "what is the definition of a random variable?".
- Use a clear notation. Try to convey your understanding.
// - "Quantify the uncertainty" means you should give the standard deviation.

= Checklist
You should be able to:
+ Define random variables and stochastic processes, and prove that $X + Y$ is a random variable.
+ Explain why a process is a Markov chain, and compute probabilities with $bf(P)^n$.
+ Use first-step analysis for absorption probabilities, expected times and expected visits.
+ Classify a chain, and decide if $bold(pi)$ is unique and limiting.
+ Compute $bold(pi)$ and use it for long-run fractions of time.
+ Use the exponential and gamma distributions and the memoryless property.
+ Use uniform arrival times given $N(t) = n$, superposition and thinning.
// + Discuss model assumptions, and describe a simulation algorithms with uncertainty quantification.
+ Describe how to simulate a Poisson process.


#pagebreak()
= Theory
== Probability theory
A probability space $(Omega, cal(E), P)$ consists of a sample space $Omega$, a family of events $cal(E)$ and a probability $P$ (Kolmogorov).

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

#definition(name: [Random variable])[
  A random variable (RV) is a function $X: Omega -> RR$ such that
  $
    (X <= x) = {omega in Omega: X(omega) <= x} in cal(E) quad "for all" x in RR.
  $
  This guarantees that the CDF $F_X (x) = P(X <= x)$ is well defined.
]

#definition(name: [Stochastic process])[
  A stochastic process is a family ${X_t : t in cal(I)}$ of random variables $X_t: Omega -> cal(S)$ on the same probability space, with _index set_ $cal(I)$ and _state space_ $cal(S)$. Its distribution is given by the finite-dimensional distributions
  $
    P(X_(t_1) in A_1, dots, X_(t_n) in A_n), quad t_1, dots, t_n in cal(I), quad n = 1, 2, dots
  $
]

#remark()[
  Typical index sets and state spaces:
  - Discrete-time Markov chain: $cal(I) = {0, 1, dots}$ and $cal(S)$ countable (f.ex. ${0, 1, 2}$).
  - Poisson process: Often $cal(I) = [0, oo)$ and $cal(S) = {0, 1, dots}$.
  // - Poisson process in space: $cal(I)$ is the family of (Borel) regions $A subset.eq RR^3$ and $cal(S) = {0, 1, dots}$.
  // - Brownian motion: $cal(I) = [0, oo)$ and $cal(S) = RR$.
  // For a Markov chain, the finite-dimensional distributions are fully determined by the initial distribution and $bf(P)$, since
  // $
  //   P(X_0 = i_0, dots, X_n = i_n) = P(X_0 = i_0) P_(i_0, i_1) dots.c P_(i_(n-1), i_n).
  // $
]

The following proof was asked on the 2024, 2025 and 2026 exams.
#theorem()[
  If $X$ and $Y$ are random variables, then $X + Y$ and $X - Y$ are random variables.
]
#proof()[
  First, $(X < q) = union_(n=1)^oo (X <= q - 1\/n)$ is an event. Since $QQ$ is countable and dense in $RR$, $X + Y < z$ if and only if $X < q < z - Y$ for some $q in QQ$. Hence
  $
    (X + Y < z) = union_(q in QQ) [(X < q) inter (Y < z - q)] in cal(E),
  $
  and $(X + Y <= z) = inter_(n=1)^oo (X + Y < z + 1\/n) in cal(E)$. For $X - Y$, note that $-Y$ is a RV since $(-Y <= y) = (Y < -y)^C in cal(E)$.
]

#theorem(name: [Laws of total expectation and variance])[
  $
    EE[X] = EE[EE[X | Y]] quad "and" quad "Var"[X] = EE["Var"[X | Y]] + "Var"[EE[X | Y]].
  $
]

// #remark(name: [Normal distribution tricks])[
//   The kont-exam in 2026 started with standard normal calculations using a table. Useful tricks are
//   - $P(Z^2 > c) = P(|Z| > sqrt(c)) = 2(1 - Phi(sqrt(c)))$.
//   - Factor polynomials, e.g. $P(Z^2 - 3Z + 2 < 0) = P(1 < Z < 2)$.
//   // - $integral_a^b e^(-x^2\/2) dif x = sqrt(2 pi) (Phi(b) - Phi(a))$.
//   - If $(X, Y)$ is bivariate normal, then $X + Y$ is normal with variance $sigma_X^2 + sigma_Y^2 + 2 rho sigma_X sigma_Y$.
// ]

#pagebreak()
== Discrete-time Markov chains
// === Definitions and $n$-step probabilities
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

#theorem(name: [Chapman–Kolmogorov])[
  The $n$-step transition probabilities $P_(i,j)^((n)) = P(X_(m+n) = j | X_m = i)$ are the entries of $bf(P)^n$.
  // If $X_m$ has distribution $bold(u)$, i.e. $u_i = P(X_m = i)$, then
  // $
  //   P(X_(m+n) = j) = sum_(i in cal(S)) u_i P_(i,j)^((n)) = [(bf(P)^top)^n bold(u)]_j.
  // $
]

#remark()[
  To "explain that this is a Markov chain":
  + Give the state space and index set.
  + Argue that the next state only depends on the current state, and that the transition probabilities don't change over time.
  + Give $bf(P)$ (rows sum to one) and draw the transition diagram.
]
#remark()[
  Probabilities "backwards" in time use Bayes rule and Markov property, f.ex.
  $
    P(X_4 = 0 | X_3 = 1, X_5 = 0) = (P_(1,0) P_(0,0)) / (P_(1,0)^((2))).
  $
]

// === First-step analysis
#theorem(name: [First-step analysis])[
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

// #remark()[
//   Tips for first-step analysis:
//   - Define your notation ($u_i$, $v_i$) and state the boundary conditions.
//   - If $0$ is absorbing, then $P(T_0 <= n | X_0 = i) = P_(i,0)^((n))$.
//   - To find $P(T_A < T_B)$, you can make $A$ and $B$ absorbing.
// ]

// === Classification and long-run behavior
Core definitions (Weeks 36 and 37):
- $i$ and $j$ _communicate_ if they are accessible from each other. This splits $cal(S)$ into classes, and the chain is irreducible if there is only one.
- The period is $d(i) = gcd{n >= 1: P_(i,i)^((n)) > 0}$. If $P_(i,i) > 0$, then $d(i) = 1$ (aperiodic).
- Let $tau_i = min{n >= 1: X_n = i}$ be the return time to $i$, $f_(i,i) = P(tau_i < oo | X_0 = i)$ the return probability and $m_i = EE[tau_i | X_0 = i]$ the mean return time.
- $i$ is _recurrent_ if $f_(i,i) = 1$ and _transient_ otherwise. It is _positive recurrent_ if also $m_i < oo$.
- In a finite chain, closed classes are positive recurrent and the rest are transient.

#theorem()[
  An irreducible Markov chain has a stationary distribution $bold(pi)$,
  $
    pi_j >= 0, quad pi_j = sum_(i in cal(S)) pi_i P_(i,j) quad "and" quad sum_(i in cal(S)) pi_i = 1,
  $
  if and only if it is positive recurrent. Then $bold(pi)$ is unique and $pi_j = 1\/m_j$. If the chain is also aperiodic, $bold(pi)$ is the limiting distribution.
]

#corollary()[
  A finite irreducible chain has a unique stationary distribution. If it is also aperiodic, this is the limiting distribution.
]

// #theorem(name: [Long-run averages])[
//   For an irreducible positive recurrent Markov chain with stationary distribution $bold(pi)$, we have with probability one
//   - Long-run fraction of time in $j$: $lim_(n -> oo) 1/n sum_(k=0)^(n-1) bb(1){X_k = j} = pi_j$.
//   - Long-run average reward per step, when the reward $r(i)$ depends on the state: $lim_(n -> oo) 1/n sum_(k=0)^(n-1) r(X_k) = sum_i pi_i r(i)$.
//   - Long-run average reward per transition, when the reward $r(i,j)$ depends on the transition: $lim_(n -> oo) 1/n sum_(k=0)^(n-1) r(X_k, X_(k+1)) = sum_i sum_j pi_i P_(i,j) r(i,j)$.
//   This holds also when the chain is periodic, so the stationary distribution always has the interpretation of a long-run fraction of time.
// ]

#remark(name: [Common tricks])[
  - If an absorbing state can be reached from everywhere, the long-run fraction of time in every other state is $0$.
  - If $X_1 tilde.op bold(pi)$, then $X_n tilde.op bold(pi)$ for all $n$.
]

#pagebreak()
== Poisson processes
A Poisson process ${N(t): t >= 0}$ with rate $lambda$:
- $N(0) = 0$
- Independent increments and $N(s + t) - N(s) tilde.op "Poisson"(lambda t)$.
- Sojourn times are i.i.d. $"Exp"(lambda)$.
- Waiting time $W_n$ until the $n$-th event is $"Gamma"(n, lambda)$.

#theorem(name: [Memoryless property])[
  If $T tilde.op "Exp"(lambda)$, then $P(T > t + s | T > t) = P(T > s)$. The exponential is the only continuous distribution with this property.
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

#theorem(name: [Superposition and competing exponentials])[
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

#theorem(name: [Compound Poisson process])[
  For $Y(t) = sum_(i=1)^(N(t)) C_i$ with i.i.d. $C_i$ independent of $N(t)$,
  $
    EE[Y(t)] = lambda t EE[C] quad "and" quad "Var"[Y(t)] = lambda t EE[C^2].
  $
]

#remark(name: [Inhomogeneous and spatial Poisson processes])[
  - Inhomogeneous: $N(t) - N(s) tilde.op "Poisson"(integral_s^t lambda(u) dif u)$. Useful when the rate varies over the day.
  - Spatial: $N(A) tilde.op "Poisson"(lambda(A))$, independent for disjoint regions. Split overlapping $V$ and $W$ into $V \\ W$, $W \\ V$ and $V inter W$. This gives f.ex. $"Cov"(N(V), N(W)) = lambda(V inter W)$.
]

#remark(name: [Discussing the Poisson assumptions])[
  Is a Poisson process reasonable? Check
  - One event at a time?
  - Independent counts in disjoint intervals?
  - Constant rate? If not, can we use an inhomogeneous process?
  // F.ex. buses follow a schedule, so the times between them are far from exponential.
]

#remark(name: [Simulation])[
  Simulate on $[0, t]$ by either:
  - Adding $"Exp"(lambda)$ sojourn times until the sum exceeds $t$.
  - Drawing $n tilde.op "Poisson"(lambda t)$ and sorting $n$ i.i.d. $"Uniform"(0, t)$ points.
  Estimate a probability by the fraction $hat(p)$ of $M$ runs, with standard error $sqrt(hat(p)(1 - hat(p))\/M)$.
]

#pagebreak()


= Problems
// All exams and solutions are found at #link("https://www.math.ntnu.no/emner/TMA4265/exams/"). For a 90 minute session, the most important problems are August 2026 Problems 2 and 3. The rest can be mentioned briefly or left as self-study.

== Probability theory

#problem(name: [Exam 2026])[
  Occurrence of E. coli bacteria in drinking water from a given water source can be modelled by a Poisson process N with intensity measure $lambda$. Let $X = N(V)$ and $Y = N(W)$ be the number of viable cells in two samples given by regions $V$ and $W$ in the fluid.
  + What are the index set and state space of the Poisson process $N$?
  + How is $N$ connected to the unknown underlying probability space $Omega$ as defined in the textbook used in the course. Note: As always, the space $Omega$ need not be specified here.
  + What are the defining properties of the space $Omega$ according to the mathematical model introduced by Kolmogorov?
  + Both $X$ and $Y$ are random variables and then they have well defined cumulative distributions $F_X$ and $F_Y$ . What does this mean in terms of the assumptions on $Omega$ Prove that if $X$ and $Y$ are random variables, then $X − Y$ is a random variable.
  // + How is the distribution of $(X, Y)$ and $X − Y$ determined by $lambda$? How is this connected to $Omega$
]
#solution[
  + The process counts bacteria in regions of space, so the index set is the family of Borel sets in $RR^3$,
    $
      cal(I) = cal(B)(RR^3).
    $
    Since $N(A)$ is the number of bacteria in $A$, the state space is $cal(S) = {0, 1, 2, dots}$. We assume the intensity $lambda$ is zero outside the fluid.
  + $N = {N(A) : A in cal(I)}$ is a family of random variables on the same probability space $(Omega, cal(E), P)$. Each $N(A)$ is a function
    $
      N(A): Omega -> cal(S), quad omega |-> N(A)(omega),
    $
    with $(N(A) <= n) in cal(E)$ for all $n$. An outcome $omega in Omega$ is one realization of the positions of all bacteria in the water source, and $N(A)(omega)$ is the number of them that lie in $A$.
  + Kolmogorov's model is a probability space $(Omega, cal(E), P)$, where
    - $Omega$ is a non-empty set of outcomes $omega$.
    - $cal(E)$ is a $sigma$-algebra on $Omega$. It contains $Omega$ and is closed under complements and countable unions.
    - $P: cal(E) -> RR$ is a probability. It satisfies $P(A) >= 0$, $P(Omega) = 1$ and countable additivity for pairwise disjoint events.
  + That $X$ is a random variable means that
    $
      (X <= x) = {omega in Omega : X(omega) <= x} in cal(E) quad "for all" x in RR.
    $
    Then $F_X (x) = P(X <= x)$ is well defined, since $P$ is only defined on $cal(E)$. The same holds for $Y$.

    We want to show that $(X - Y <= z) in cal(E)$ for all $z in RR$. We use that $cal(E)$ is closed under complements, countable unions and countable intersections (by De Morgans laws).

    *Step 1.* For any $x in RR$,
    $
      (X < x) = union_(n=1)^oo (X <= x - 1\/n) in cal(E),
    $
    since $X(omega) < x$ if and only if $X(omega) <= x - 1\/n$ for some $n$. Similarly, $(Y > y) = (Y <= y)^C in cal(E)$.

    *Step 2.* We claim that
    $
      (X - Y < z) = union_(q in QQ) [(X < q) inter (Y > q - z)].
    $
    To see this, fix an outcome $omega in Omega$ and write $a = X(omega)$ and $b = Y(omega) + z$. Then
    $
                    omega in (X - Y < z) & quad <==> quad a < b, \
      omega in (X < q) inter (Y > q - z) & quad <==> quad a < q < b.
    $
    So the claim says that $a < b$ if and only if $a < q < b$ for some $q in QQ$.
    - If $a < q < b$ for some $q$, then clearly $a < b$.
    - If $a < b$, then $(a, b)$ is a non-empty open interval. Since $QQ$ is dense in $RR$, every such interval contains a rational number, so there is a $q in QQ$ with $a < q < b$.

    By Step 1, $(X < q)$ and $(Y > q - z)$ are events, so their intersection is an event. Since $QQ$ is countable, the union is countable, and hence $(X - Y < z) in cal(E)$.

    *Step 3.* Since $X(omega) - Y(omega) <= z$ if and only if $X(omega) - Y(omega) < z + 1\/n$ for all $n$,
    $
      (X - Y <= z) = inter_(n=1)^oo (X - Y < z + 1\/n) in cal(E).
    $
    This holds for all $z in RR$, so $X - Y$ is a random variable.
  // + We note that the spatial regions $V$ and $W$ can overlap. We therefore have to partition their union into three mutually exclusive, disjoint spatial zones
  //   $
  //     R_1 = V \\ W, quad R_2 = W \\ V, quad R_3 = V inter W.
  //   $
  //   By the fundamental completely independent increments property of a spatial Poisson process, the bacterial cell counts inside disjoint regions form strictly independent Poisson random variables parameterized by the intensity $lambda$, so
  //   $
  //     N_1 = N(R_1) & tilde.op "Poisson"(lambda (V \\ W)), \
  //     N_2 = N(R_2) & tilde.op "Poisson"(lambda (W \\ V)), \
  //     N_3 = N(R_3) & tilde.op "Poisson"(lambda (V inter W)).
  //   $
  //   Clearly, $X = N_1 + N_3$ and $Y = N_2 + N_3$. The distribution of $(X, Y)$ is therefore determined by the product of the independent Poisson probability mass functions of $N_1$, $N_2$, and $N_3$. This gives a covariance governed by the shared overlap region $"Cov"(X, Y) = "Var"(N_3)= lambda (V inter W)$. For $X − Y = N_1 − N_2$, we see that this is the difference between two independent Poisson random variables. The connection to $Omega$ is that the
]

// #pagebreak()
// #problem(name: [Exam 2025])[
//   What is the mathematical definition of a stochastic process $X$? Use $X_1, X_2, dots$ to define a stochastic process $X$. What is the probability distribution of $X$ in this particular case?
// ]
// #solution[
//   A stochastic process in an indexed family of random elements in a state space. The index set can be an arbitrary non-empty set. However, the index set $NN = {1, 2, dots}$ would a natural choice for most examples you might see. The state space $cal(S)$ can be an arbitrary sample space, which is a non-empty set equipped with a family of events $cal(F)$. Each random element is a function $X_i: Omega -> cal(S)$ so that
//   $
//     (X_i in A) = {omega in Omega | X_i(omega) in A} in cal(F)
//   $
//   is an event in $Omega$ whenever $A$ is an event in $cal(S)$. The probability distribution of a stochastic process is defined by all finite-dimensional distributions.
// ]

// #pagebreak()
// #problem(name: [Exam 2024])[
//   A GPS device gives a position $(X, Y)$ which is bivariate normal with expectation $(10"m", 20"m")$, standard deviations $(1"m", 1"m")$, and correlation $0.9$.
//   - Find the distribution of $W = X + Y$.
//   - It assumed above that $X$ and $Y$ are random variables. What is the definition of a random variable in axiomatic probability theory?
//   - Prove that $W$ is a random variable using the axioms for events.
// ]
// #solution[
//   - The sum of two jointly normal random variables is also normally distributed. Computing the mean and variance of $W$ gives
//     $
//            mu & = 10"m" + 20"m" = 30"m", \
//       sigma^2 & = "Var"(X + Y) = "Var"(X) + "Var"(Y) + 2"Cov"(X, Y) \
//               & = sigma_1^2 + sigma_2^2 + 2 rho sigma_1 sigma_2 = 1"m"^2 + 1"m"^2 + 2 dot 0.9 dot 1"m" dot 1"m" = 3.8"m"^2.
//     $
//   - A random variable is a function $W:Omega -> RR$ so that
//     $
//       (W <= w) = {omega in Omega | W(omega) <= w} in cal(F)
//     $
//     is an event for all $w in RR$.
//   - Similar as earlier task, we show that $(W <= w) in cal(F)$ by using that the rationals $QQ$ are dense in $RR$.
// ]

// #problem(name: [Exam August 2026, Problem 1])[
//   _Source:_ #link("https://www.math.ntnu.no/emner/TMA4265/exams/2026_tma4265ExamAug.pdf")[Exam], #link("https://www.math.ntnu.no/emner/TMA4265/exams/2026_tma4265ExamAugLF.pdf")[solutions].
//
//   _Covers:_ Standard normal calculations with a table, e.g. $P(Z^2 > 1.69)$, $P(Z^2 - 3Z + 2 < 0)$ and $integral_(0.5)^(1.5) e^(-x^2\/2) dif x$. Good as a quick warm-up.
// ]
// // TODO: Write problem and solution

#pagebreak()
== Discrete-time Markov chains

#problem(name: [Exam August 2026, Problem 2])[
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
#solution[
  + By time-homogeneity this is the two-step probability
    $
      P_(1,0)^((2)) = P_(1,0) P_(0,0) + P_(1,1) P_(1,0) + P_(1,2) P_(2,0) = 1/4 + 1/2 dot 1/4 + 1/4 dot 1/4 = 7/16 approx 0.44.
    $
  + Since $0$ is absorbing, $T <= 3$ is the same event as $X_3 = 0$. We first need
    $
      P_(2,0)^((2)) = P_(2,0) + P_(2,1) P_(1,0) + P_(2,2) P_(2,0) = 1/4 + 1/4 dot 1/4 + 1/2 dot 1/4 = 7/16.
    $
    Conditioning on the first step,
    $
      P(T <= 3 | X_0 = 2) = P_(2,0)^((3)) = P_(2,0) + P_(2,1) P_(1,0)^((2)) + P_(2,2) P_(2,0)^((2)) = 1/4 + 1/4 dot 7/16 + 1/2 dot 7/16 = 37/64 approx 0.58.
    $
  + Let $u_i$ be the probability of visiting $1$ before $0$ when starting in $i$. Then $u_0 = 0$ and $u_1 = 1$, and first-step analysis gives
    $
      u_2 = 1/4 u_0 + 1/4 u_1 + 1/2 u_2 = 1/4 + 1/2 u_2 quad => quad u_2 = 1/2.
    $
  + Let $v_i = EE[T | X_0 = i]$ for $i = 1, 2$. Since we start outside $0$, first-step analysis gives
    $
      v_1 & = 1 + 1/2 v_1 + 1/4 v_2, quad v_2 & = 1 + 1/4 v_1 + 1/2 v_2.
    $
    By symmetry $v_1 = v_2 = v$, so $v = 1 + 3/4 v$ and $v_2 = 4$ weeks.
  + For $i = 1, 2$, let $g_i$ be the expected number of weeks in state $1$ before absorption when starting in $i$. The current week counts $1$ if we are in state $1$, and the count stops if the chain jumps to $0$. Conditioning on the first step gives
    $
      g_1 & = 1 + 1/2 g_1 + 1/4 g_2, quad
            g_2 & = 0 + 1/4 g_1 + 1/2 g_2.
    $
    The second equation gives $g_2 = 1/2 g_1$, so $g_1 = 1 + 1/2 g_1 + 1/8 g_1$, which gives $g_1 = 8\/3$ and $g_2 = 4\/3 approx 1.33$ weeks.

  // In matrix form this is $bold(g) = bold(e)_1 + bf(Q) bold(g)$ with $bf(Q) = mat(1\/2, 1\/4; 1\/4, 1\/2)$ the restriction of $bf(P)$ to ${1, 2}$, so $bold(g) = (bf(I) - bf(Q))^(-1) bold(e)_1$ is the column of $bf(W) = (bf(I) - bf(Q))^(-1)$ for state $1$.
  + State $0$ is absorbing and can be reached from both $1$ and $2$, so the customer cancels with probability one. The long-run proportion of time active is therefore 0%.
]

// #pagebreak()
// #problem(name: [Exam December 2023, Problem 1])[
//   The Markov chain ${X_n : n = 0, 1, dots}$ has discrete state space $cal(S)$ and transition matrices $bf(P)(n)$, where $P(X_(n+1) = j | X_n = i) = P_(i,j)(n)$. Unless stated otherwise, we assume that the Markov chain has two properties: the Markov property and stationarity.
//   + Define what it means for ${X_n}$ to satisfy the Markov property and stationarity, in words and using mathematical notation.
//   + Assume $cal(S) = {0, 1, 2, 3}$, $X_0 = 3$ and
//     $
//       bf(P)(n) = mat(
//         1/3, 0, 0, 2/3;
//         1/2, 0, 1/3, 1/6;
//         0, 1/2, 1/2, 0;
//         1/2, 0, 1/2, 0
//       ), quad n = 0, 1, dots
//     $
//     Let $tau_3 = min{n >= 1 : X_n = 3}$ (note that $n >= 1$). Use first-step analysis to find the expected time until the chain returns to state $3$, $EE[tau_3 | X_0 = 3]$. Remember to define your notation.
// ]
// #solution[
//   + The Markov property: Given the present state, the past gives no further information about the future, i.e.
//     $
//       P(X_(n+1) = j | X_n = i, X_(n-1) = i_(n-1), dots, X_0 = i_0) = P(X_(n+1) = j | X_n = i).
//     $
//     Stationarity: The transition probabilities do not depend on time, i.e. $bf(P)(n) = bf(P)$ for all $n$.
//   + Let $T_3 = min{n >= 0 : X_n = 3}$ and $v_i = EE[T_3 | X_0 = i]$. Then $v_3 = 0$ and $v_i = 1 + sum_j P_(i,j) v_j$ for $i != 3$, which gives
//     $
//       v_0 & = 1 + 1/3 v_0, \
//       v_1 & = 1 + 1/2 v_0 + 1/3 v_2, \
//       v_2 & = 1 + 1/2 v_1 + 1/2 v_2.
//     $
//     The first equation gives $v_0 = 3\/2$, and the third gives $v_2 = 2 + v_1$. Inserting into the second,
//     $
//       v_2 - 2 = 1 + 3/4 + 1/3 v_2 quad => quad v_2 = 45/8.
//     $
//     Conditioning on the first step from $3$,
//     $
//       EE[tau_3 | X_0 = 3] = 1 + P_(3,0) v_0 + P_(3,2) v_2 = 1 + 1/2 dot 3/2 + 1/2 dot 45/8 = 73/16 approx 4.56.
//     $
// ]

#pagebreak()
#problem(name: [Exam December 2023, Problem 2])[
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
]
#solution[
  + The transition diagram is
    #transition-figure()[
      #transition-diagram(
        ($0$, $1$, $2$),
        (
          ($alpha$, $1 - alpha$, 0),
          (0, $beta$, $1 - beta$),
          ($1 - phi$, 0, $phi$),
        ),
        node-radius: 4.5mm,
        radius: 17mm,
      )
    ]
    The self-loops exist when $alpha, beta, phi > 0$, and the edges $0 -> 1 -> 2 -> 0$ exist when $alpha, beta, phi < 1$. The only way to move between the states is through the cycle $0 -> 1 -> 2 -> 0$, so the chain is irreducible if and only if $alpha < 1$, $beta < 1$ and $phi < 1$.

    Then there is one equivalence class ${0, 1, 2}$, and all states have the same period. If at least one of $alpha, beta, phi$ is positive, there is a self-loop and the period is $1$. If $alpha = beta = phi = 0$, the chain moves deterministically around the cycle and the period is $3$. The chain is finite and irreducible, and therefore recurrent.
  + The stationary equations are
    $
      pi_0 & = alpha pi_0 + (1 - phi) pi_2, \
      pi_1 & = (1 - alpha) pi_0 + beta pi_1, \
      pi_2 & = (1 - beta) pi_1 + phi pi_2,
    $
    together with $pi_0 + pi_1 + pi_2 = 1$. The first two equations give
    $
      (1 - alpha) pi_0 = (1 - beta) pi_1 = (1 - phi) pi_2,
    $
    i.e. the flow around the cycle is the same through every state. Hence $pi_i$ is proportional to one over the probability of leaving $i$,
    $
      pi_0 = (1\/(1 - alpha)) / D, quad pi_1 = (1\/(1 - beta)) / D, quad pi_2 = (1\/(1 - phi)) / D, quad "where" quad D = 1/(1 - alpha) + 1/(1 - beta) + 1/(1 - phi).
    $
    The stationary distribution is unique since the chain is finite and irreducible. It is a limiting distribution if the chain is also aperiodic, i.e. unless $alpha = beta = phi = 0$. //In the periodic case $P_(i,i)^((n)) = 0$ unless $n$ is a multiple of $3$, so $P_(i,j)^((n))$ does not converge.
]


#pagebreak()
== Poisson processes

#problem(name: [Exam August 2026, Problem 3])[
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
#solution[
  + $T tilde.op "Exp"(1\/beta)$, so $EE[T] = beta = 707$ seconds, i.e. $11$ minutes and $47$ seconds.
  + $P(T < 707) = 1 - e^(-707\/707) = 1 - e^(-1) approx 0.63$.
  + Let $X$ be the number of short intervals. The intervals are independent, so $X tilde.op "Binomial"(10, p)$ with $p = 1 - e^(-1) approx 0.632$, and
    $
      P(X >= 8) = binom(10, 8) p^8 (1 - p)^2 + binom(10, 9) p^9 (1 - p) + p^10 approx 0.155 + 0.059 + 0.010 approx 0.22.
    $
  + We want $P(T > 20 "min" | T > 15 "min")$. By the memoryless property,
    $
      P(T > 20 "min" | T > 15 "min") = P(T > 5 "min") = e^(-300\/707) approx 0.65.
    $
  + The $T_i$ are i.i.d. with $"Var"[T_i] = beta^2$, so $"SD"[V] = sqrt(10 beta^2) = sqrt(10) beta approx 2236$ seconds.
  + $V tilde.op "Gamma"(10, 1\/beta)$, so $2V\/beta tilde.op chi^2_(20)$. Hence
    $
      P(V > v) = P(chi^2_(20) > (2v)/beta) = 0.95.
    $
    The table gives $chi^2_(0.95, 20) = 10.851$, so $v = 10.851 dot 707\/2 approx 3836$ seconds.
  // + We want $P(N(30) >= 3 | N(60) = 10)$, with time in minutes. Given $N(60) = 10$, the event times are i.i.d. uniform on $[0, 60]$, so $N(30) | N(60) = 10 tilde.op "Binomial"(10, 1\/2)$ and
  //   $
  //     P(N(30) >= 3 | N(60) = 10) = 1 - (binom(10, 0) + binom(10, 1) + binom(10, 2)) (1/2)^10 = 1 - 56/1024 approx 0.95.
  //   $
  + The rates are $lambda_F = 1\/707$ and $lambda_N = 1\/900$ per second. By superposition, all notifications form a Poisson process with rate $lambda_F + lambda_N$, so the expected time between notifications is
    $
      1 / (1\/707 + 1\/900) approx 396 "seconds".
    $
    The probability that the next notification is from Fjøsbok is
    $
      P(T_F < T_N) = lambda_F / (lambda_F + lambda_N) = 900 / 1607 approx 0.56.
    $
]


#pagebreak()
#problem(name: [Exam 2021, Problem 3 a)])[
  Customers arrive at a store according to a Poisson process with rate $lambda = 60$ customers per hour. Customers sometimes forget items in the store. Assume that the number of items forgotten by each customer is Poisson distributed with mean $0.02$, and that the numbers are independent between customers. Calculate the expected value and the variance of the number of items forgotten during an eight hour period.
]
#solution[
  Let $N(t)$ be the number of customers, and $C_1, C_2, dots tilde.op^"iid" "Poisson"(mu)$ with $mu = 0.02$ the number of items forgotten. The number of items forgotten after $t$ hours is the compound Poisson process
  $
    Y(t) = sum_(i=1)^(N(t)) C_i.
  $
  Conditioning on $N(8)$, the law of total expectation gives
  $
    EE[Y(8)] = EE[EE[Y(8) | N(8)]] = EE[N(8) mu] = 8 lambda mu = 8 dot 60 dot 0.02 = 9.6.
  $
  Since $"Var"[C_i] = mu$, the law of total variance gives
  $
    "Var"[Y(8)] = EE["Var"[Y(8) | N(8)]] + "Var"[EE[Y(8) | N(8)]] = EE[N(8) mu] + "Var"[N(8) mu] = 8 lambda mu + 8 lambda mu^2 approx 9.79.
  $
  // This agrees with $"Var"[Y(t)] = lambda t EE[C^2]$, since $EE[C^2] = mu + mu^2$.
]
