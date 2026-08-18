#import "@local/icml-presentation:1.0.0": *

#import "@preview/muchpdf:0.1.2": muchpdf

#import "@preview/lemmify:0.1.7": default-theorems, new-theorems, thm-numbering-heading

#show: icml-presentation.with(
  header-right: none,
  font-size: 20pt,
  language: "en",
  raw-lang: "bash",
  bibliography: bibliography("../refs.bib"),
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

= Sample spaces and events

== Theory based on #tc(<karr1993probability>)

Informally, a _random experiment_ has the following objects:
+ Set of outcomes: $Omega$ with possible outcomes $omega in Omega$.
+ Event: Subsets of $Omega$ for which probabilities are defined.
+ Sample space: Set of outcomes $Omega$ equipped with a family of events $cal(E)$.

#definition(name: [$sigma$-algebra])[
  A $sigma$-algebra $cal(E)$ on $Omega$ is a family of subsets of $Omega$ satisfying
  - $Omega in cal(E)$
  - If $A in cal(E)$, then $A^C = Omega \\ A in cal(E)$.
  - If $A_1, A_2, ... in cal(E)$, then $union_(i=1)^(oo) A_i in cal(E)$.
]<sigma-algebra>

#definition(name: [Events])[
  The family of events $cal(E)$ is a $sigma$-algebra on the set of outcomes $Omega$.
]

== Problem 1
Let $Omega = {1, 2, 3}$ and $cal(E) = {emptyset, Omega, {1}, {2, 3}}$.
+ Show that $Omega$ equipped with $cal(E)$ is a sample space (i.e. a measurable space).
+ Is ${1, 2}$ an event?
+ How many subsets of $Omega$ are events?
+ Every event is a set, but every set is not an event. Explain this.

= Probabilities, cumulative distributions and random variables

== Theory 1

#definition(name: [Probability])[
  A probability on sample space $(Omega, cal(E))$ is a function $P: cal(E) -> RR$ such that
  - $P(A) >= 0$ for all $A in cal(E)$.
  - $P(Omega) = 1$.
  - If $A_1, A_2, ... in cal(E)$ are pairwise disjoint, then $P(union_(i=1)^(oo) A_i) = sum_(i=1)^(oo) P(A_i)$.
]

#definition(name: [Cumulative distribution function])[
  The cumulative distribution function (CDF) of $P$ is the function $F_P: RR -> [0, 1]$ defined by $F_P (t) = P(-oo <= t)$.
]

== Problem 2
Let $X: Omega → RR$ be such that $(X <= q)$ is an event for all $q in QQ$.
+ Prove that the CDF $F(x) = P(X <= x)$ is defined for all real $x$.
+ Prove that $(X <= x)$ is an event.
+ Prove that $(X in A)$ is an event when $A$ is an interval.
+ #text(fill: luma(150))[Prove that $X$ is a RV.]
+ #text(fill: luma(150))[Is $(X in A)$ an event when $A$ is an arbitrary set?]


== Theory 2
#definition(name: [Random variable])[
  A random variable (RV) is a function $X: Omega -> RR$ such that
  $
    X^(-1)(B) = {omega in Omega: X(omega) in B} in cal(E)
  $
  for every $B in cal(B)(RR)$.
]

#proposition(name: [Simplified criteria for RV])[
  A function $X: Omega -> RR$ is a RV if
  $
    (X <= x) in cal(E)
  $
  for every $x in RR$.
]


== Problem 2 continued
Let $X: Omega → RR$ be such that $(X <= q)$ is an event for all $q in QQ$.
+ Prove that the CDF $F(x) = P(X <= x)$ is defined for all real $x$.
+ Prove that $(X <= x)$ is an event.
+ Prove that $(X in A)$ is an event when $A$ is an interval.
+ Prove that $X$ is a RV.
+ Is $(X in A)$ an event when $A$ is an arbitrary set?

= Expectation (for simple random variables)

== Theory

#definition(name: [Simple RV])[
  A RV $X$ is simple if it takes on only finitely many values. We can write this as
  $
    X = sum_(i=1)^n a_i bb(1)_(A_i)
  $
  where $n < oo$, $a_i in RR$, $A_i in cal(E)$, and $bb(1)(dot)$ is the indicator function.
]

#definition(name: [Expectation of simple RVs])[
  The expectation of a simple RV $X = sum_(i=1)^n a_i bb(1)_(A_i)$ is defined as
  $
    EE[X] = sum_(i=1)^n a_i P(X in A_i).
  $
]

== Problem 3
Let $X$ and $Y$ be simple RVs, and let $alpha, beta in RR$. Prove
- Constants are preserved: If $X = c$ for some $c in RR$, then $EE[X] = c$.
- Monotonicity: If $X <= Y$, then $EE[X] <= EE[Y]$.
- Linearity: $EE[alpha X + beta Y] = alpha EE[X] + beta EE[Y]$.
- Relation to probability: If $A in cal(E)$, then $EE[bb(1)(A)] = P(A)$.

== Problem 4
Let $X : Omega → Omega_X$ be such that $(X in A) = {omega : X(omega) in A}$ is an event in $Omega$ whenever $A$ is an event in $Omega_X$, e.g. $X$ is a random element in $Omega_X$.
+ Show that $P_X (A) = P(X in A)$ defines a probability distribution. This $P_X$ is the distribution of $X$ with a corresponding expectation $EE[X]$.
+ Show that $EE[phi(X)] = EE_X [phi]$ when $phi : Omega_X -> RR$ is simple and measurable.
+ Let $X$ and $Y$ be simple RVs. Prove that $Z = (X, Y)$ is simple.
