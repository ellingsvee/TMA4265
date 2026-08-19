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

== Some practical info

Why even more classes for this course:
- Interactive lectures in my head means:
  - I will go over some relevant theory
  - You will have a bit of time to work on exercises
  - I will go over my suggestions for solutions
- Will try to choose problems from previous exams, but you can also suggest problems (send me an email or something...).
- If you want, I can also focus on reviewing some of the relevant theory.

Also:
- The timeslot is terrible. Please suggest alternative times that would work for you?
- I am away throughout October, so no lectures then. Will inform on Wiki.

= Measurable spaces and probabilities

==

Informally, a _random experiment_ has the following objects:
+ Sample space: Set $Omega$ with possible outcomes $omega in Omega$.
+ Events: Set $cal(E)$, where each event in $cal(E)$ contains zero or more outcomes.
+ Probabilities: A function $P$ that assigns a probability to each event.
// + Measurable space: Sample space $Omega$ equipped with a family of events $cal(E)$.

We sometimes call $(Omega, cal(E))$ a _measurable space_, and $(Omega, cal(E), P)$ a _probability space_.

==

#definition(name: [$sigma$-algebra])[
  A $sigma$-algebra $cal(E)$ on $Omega$ is a family of subsets of $Omega$ satisfying
  - $Omega in cal(E)$
  - If $A in cal(E)$, then $A^C = Omega \\ A in cal(E)$.
  - If $A_1, A_2, ... in cal(E)$, then $union_(i=1)^(oo) A_i in cal(E)$.
]<sigma-algebra>

#definition(name: [Events])[
  The family of events $cal(E)$ is a $sigma$-algebra on $Omega$.
]

#definition(name: [Probability])[
  A probability on $(Omega, cal(E))$ is a function $P: cal(E) -> RR$ such that
  - $P(A) >= 0$ for all $A in cal(E)$.
  - $P(Omega) = 1$.
  - If $A_1, A_2, ... in cal(E)$ are pairwise disjoint, then $P(union.big_(i=1)^(oo) A_i) = sum_(i=1)^(oo) P(A_i)$.
]

== Problem 1
Let $Omega = {1, 2, 3}$ and $cal(E) = {emptyset, Omega, {1}, {2, 3}}$.
+ Show that ($Omega$, $cal(E)$) is a measurable space.
+ How many subsets of $Omega$ are events? Can you give an example of a set that is not an event?
+ Give an example of a probability $P$ on $(Omega, cal(E))$.

= Random variables

==
#definition(name: [Random variable])[
  A random variable (RV) is a function $X: Omega -> RR$ such that
  $
    X^(-1)(B) := {omega in Omega: X(omega) in B} in cal(E)
  $
  for every $B in cal(B)(RR)$. Here $cal(B)(RR)$ denotes the Borel $sigma$-algebra on $RR$, which is the smallest $sigma$-algebra containing all open intervals in $RR$.
]

== Problem 2
Let $X$ be a RV for the probability space. Show that the function $P_X: cal(B)(RR) -> RR$ defined by
$
  P_X (B) := P(X in B) = P(X^(-1)(B))
$
is a probability on $(RR, cal(B)(RR))$ when $P: cal(E) -> RR$ is a probability on $(Omega, cal(E))$.

== Problem 3
Let $X: Omega -> RR$ be such that $(X <= q)$ is an event for all $q in QQ$.
+ Prove that $X^(-1)((-oo, x]) = (X <= x)$ is an event for every $x in RR$.
+ Prove that $X^(-1)(I)$ is an event for every interval $I subset.eq RR$.
+ Define $cal(M)_X := {A subset.eq RR: X^(-1)(A) in cal(E)}$, and show that $cal(M)_X$ is a $sigma$-algebra on $RR$.
+ Use the preceding parts to prove that $X$ is a RV.


= Expectation

==
#definition(name: [Simple RV])[
  A RV $X$ is simple if it takes on only finitely many values. We can write this as $X(Omega) = {X(omega) | omega in Omega} = {x_1, ... , x_n}$ for a finite $n$.

  Defining $A_i = {omega in Omega: X(omega) = x_i}$, we have that $A_1, ... , A_n$ is a disjoint partition of $Omega$, and $X$ can be expressed as $X = sum_(i=1)^n x_i bb(1)_(A_i)$.
]

#definition(name: [Expectation of simple RVs])[
  The expectation of a simple RV $X = sum_(i=1)^n x_i bb(1)_(A_i)$ is defined as $EE[X] = sum_(i=1)^n x_i P(A_i)$.
]<expectation-for-simple-rvs>

== Problem 4
Let $X$ and $Y$ be simple RVs, and let $alpha, beta in RR$. Prove
- Relation to probability: If $A in cal(E)$, then $EE[bb(1)_(A)] = P(A)$.
- Constants are preserved: If $X = c in RR$, then $EE[X] = c$.
- Monotonicity: If $X <= Y$, then $EE[X] <= EE[Y]$.
- Linearity: $EE[alpha X + beta Y] = alpha EE[X] + beta EE[Y]$.


= To conclude...a more general definition of expectation

= Thank you for showing up!
