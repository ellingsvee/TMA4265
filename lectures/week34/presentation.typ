#import "@local/icml-presentation:1.0.0": *

#import "@preview/muchpdf:0.1.2": muchpdf

#import "@preview/lemmify:0.1.7": default-theorems, new-theorems, thm-numbering-heading

#show: icml-presentation.with(
  header-right: none,
  font-size: 20pt,
  language: "en",
  raw-lang: "bash",
)

#title-slide[
  = Week 34: Probability theory
]

==
*Some practical info:*
- Interactive lectures means:
  - I will go over some relevant theory
  - You will have a bit of time to work on exercises
  - I will go over my suggestions for solutions
- The timeslot is terrible. Please suggest alternative times that would work for you?
- I am away throughout October, so no lectures then. Will inform on Wiki.

= Sample spaces, events and measurable spaces

== Theory

Informally, a _random experiment_ has the following objects:
+ Sample space: Set $Omega$ with possible outcomes $omega in Omega$.
+ Events: Subsets of $Omega$ for which probabilities are defined.
+ Measurable space: Sample space $Omega$ equipped with a family of events $cal(E)$.

#definition(name: [$sigma$-algebra])[
  A $sigma$-algebra $cal(E)$ on $Omega$ is a family of subsets of $Omega$ satisfying
  - $Omega in cal(E)$
  - If $A in cal(E)$, then $A^C = Omega \\ A in cal(E)$.
  - If $A_1, A_2, ... in cal(E)$, then $union_(i=1)^(oo) A_i in cal(E)$.
]<sigma-algebra>

#definition(name: [Events])[
  The family of events $cal(E)$ is a $sigma$-algebra on $Omega$.
]

== Problem 1
Let $Omega = {1, 2, 3}$ and $cal(E) = {emptyset, Omega, {1}, {2, 3}}$.
+ Show that ($Omega$, $cal(E)$) is a measurable space.
+ Is ${1, 2}$ an event?
+ How many subsets of $Omega$ are events?
+ Every event is a set, but every set is not an event. Explain this.

= Probabilities and random variables

== Theory

#definition(name: [Probability])[
  A probability on $(Omega, cal(E))$ is a function $P: cal(E) -> RR$ such that
  - $P(A) >= 0$ for all $A in cal(E)$.
  - $P(Omega) = 1$.
  - If $A_1, A_2, ... in cal(E)$ are pairwise disjoint, then $P(union_(i=1)^(oo) A_i) = sum_(i=1)^(oo) P(A_i)$.
  We often call the tuple $(Omega, cal(E), P)$ a _probability space_.
]


#definition(name: [Random variable])[
  A random variable (RV) is a function $X: Omega -> RR$ such that
  $
    X^(-1)(B) := {omega in Omega: X(omega) in B} in cal(E)
  $
  for every $B in cal(B)(RR)$. Here $cal(B)(RR)$ denotes the Borel $sigma$-algebra on $RR$, which is the smallest $sigma$-algebra containing all open intervals in $RR$.
]

#proposition(name: [Probability associated with RV])[
  If $X$ is a RV, then the function $P_X: cal(B)(RR) -> RR$ defined by
  $
    P_X (B) := P(X in B) = P(X^(-1)(B))
  $
  is a probability on $RR$. We will prove this in the last problem.
]


#definition(name: [Cumulative distribution function associated with an RV])[
  The cumulative distribution function (CDF) of $X$ is the function $F_X: RR -> [0, 1]$ defined by
  $
    F_X (x) := P_X ((-oo, x]) = P(X <= x).
  $

]

== Problem 2
Let $X: Omega -> RR$ be such that $(X <= q)$ is an event for all $q in QQ$.
+ Prove that $X^(-1)((-oo, x]) = (X <= x)$ is an event for every $x in RR$.
+ Prove that $X^(-1)(I)$ is an event for every interval $I subset.eq RR$.
+ Define
  $
    cal(E)_X := {B subset.eq RR: X^(-1)(B) in cal(E)},
  $
  and that $cal(E)_X$ is a $sigma$-algebra on $RR$.
+ Use the preceding parts to prove that $X$ is a RV. Conclude that its CDF $F_X (x)$ is defined for every $x in RR$.

= Expectation

== Theory

#definition(name: [Simple RV])[
  A RV $X$ is simple if it takes on only finitely many values. We can write this as $X(Omega) = {X(omega) | omega in Omega} = {x_1, ... , x_n}$ for a finite $n$. Defining $A_i = {omega in Omega: X(omega) = x_i}$, we have that $A_1, ... , A_n$ is a disjoint partition of $Omega$, and $X$ can be expressed as $X = sum_(i=1)^n x_i bb(1)_(A_i)$.
]

#definition(name: [Expectation of simple RVs])[
  The expectation of a simple RV $X = sum_(i=1)^n a_i bb(1)_(A_i)$ is defined as $EE[X] = sum_(i=1)^n a_i P(A_i)$.
]<expectation-for-simple-rvs>

== Problem 3
Let $X$ and $Y$ be simple RVs, and let $alpha, beta in RR$. Prove
- Constants are preserved: If $X = c$ for some $c in RR$, then $EE[X] = c$.
- Monotonicity: If $X <= Y$, then $EE[X] <= EE[Y]$.
- Linearity: $EE[alpha X + beta Y] = alpha EE[X] + beta EE[Y]$.
- Relation to probability: If $A in cal(E)$, then $EE[bb(1)(A)] = P(A)$.

== Problem 4
Let $X : Omega -> RR$ be an RV, and let $phi: cal(B)(RR) -> RR$ be a simple and measurable function.
+ Show that $P_X (B) = P(X in B)$ defines a probability on $(RR, cal(E)_X)$.
+ Show that $EE[phi(X)] = EE_X [phi]$ with $EE_X [dot]$ denoting the expectation with respect to the probability $P_X$.

= To conclude...a more general definition of expectation
