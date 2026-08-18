
#import "@local/icml:1.0.0": *
#import "@preview/muchpdf:0.1.2": muchpdf

#import "@preview/lemmify:0.1.7": default-theorems, new-theorems, thm-numbering-heading
#import "@preview/fletcher:0.5.8" as fletcher: diagram, edge, node




#show link: set text(fill: blue)


#show: icml.with(
  title: [
    Week 34: Probability theory
  ],

  authors: (
    (
      name: "Elling Svee (elling.svee@ntnu.no)",
      // email: "elling.svee@ntnu.no",
    ),
  ),
  n_columns: 1,
  paper-size: "a4",
  bibliography: bibliography("../refs.bib"),
)

_These notes are written by myself, and errors may and will occur. When in doubt, trust the book and Gunnars lectures!_

= Theory based on #tc(<karr1993probability>)

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
  for every $B in cal(B)(RR)$. Here $cal(B)(RR)$ denotes the Borel $sigma$-algebra on $RR$, which is the smallest $sigma$-algebra containing all open intervals in $RR$ @karr1993probability.
]


#definition(name: [Simple RV])[
  A RV $X$ is simple if it takes on only finitely many values. We can write this as $X(Omega) = {X(omega) | omega in Omega} = {x_1, ... , x_n}$ for a finite $n$. Defining $A_i = {omega in Omega: X(omega) = x_i}$, we have that $A_1, ... , A_n$ is a disjoint partition of $Omega$, and $X$ can be expressed as $X = sum_(i=1)^n x_i bb(1)_(A_i)$.
]

#definition(name: [Expectation of simple RVs])[
  The expectation of a simple RV $X = sum_(i=1)^n a_i bb(1)_(A_i)$ is defined as $EE[X] = sum_(i=1)^n a_i P(A_i)$.
]<expectation-for-simple-rvs>


#pagebreak()
= Problems

#problem(name: [Measurable spaces and probabilities])[
  Let $Omega = {1, 2, 3}$ and $cal(E) = {emptyset, Omega, {1}, {2, 3}}$.
  + Show that ($Omega$, $cal(E)$) is a measurable space.
  + How many subsets of $Omega$ are events? Can you give an example of a set that is not an event?
  + Give an example of a probability $P$ on $(Omega, cal(E))$.

]
#solution[
  + Need to show that $cal(E)$ is a $sigma$-algebra on $Omega$. All the conditions listed in @sigma-algebra are easy to verify.
  + There are four events, as listed in $cal(E)$. For an examples of a  set that is not an event, we can consider ${1, 2}$. An example is ${1, 2} subset Omega$, which is not an event since  ${1, 2} in.not cal(E)$.
  // + Only the sets in $cal(E)$ are events. There are a total of $2^3 = 8$ subsets of $Omega$, but only four of them are events.
  + One example is
    $
      P(emptyset) = 0, quad
      P({1}) = 1 \/ 3, quad
      P({2, 3}) = 2 \/ 3, quad
      P(Omega) = 1.
    $
    It is easy to verify that this function satisfies the conditions of a probability.
]

#pagebreak()
#problem(name: [Random variables])[
  Let $X: Omega -> RR$ be such that $(X <= q)$ is an event for all $q in QQ$.
  + Prove that $X^(-1)((-oo, x]) = (X <= x)$ is an event for every $x in RR$.
  + Prove that $X^(-1)(I)$ is an event for every interval $I subset.eq RR$.
  + Define
    $
      cal(E)_X := {A subset.eq RR: X^(-1)(A) in cal(E)},
    $
    and that $cal(E)_X$ is a $sigma$-algebra on $RR$.
  + Use the preceding parts to prove that $X$ is a RV.
  // Conclude that its CDF $F_X (x)$ is defined for every $x in RR$.
]
#pagebreak()
#solution()[
  + There is a rational number between any two different real numbers. Choose $q_n in QQ$ for every $n in NN$ such that
    $
      x < q_n < x + 1/n.
    $
    If $X <= x$ then $X <= q_n$, and if $X > x$ then eventually $q_n < X$. Therefore we have
    $
      (X <= x) = inter.big_(n=1)^oo (X <= q_n).
    $<event-intersection>
    Since
    $
      inter.big_(n=1)^oo (X <= q_n)
      = (union.big_(n=1)^oo (X <= q_n)^C)^C in cal(E),
    $
    the $sigma$-algebra is closed under countable intersections, giving that $(X <= x)$ is an event.
  + We also have that strict inequalities are events. This is because
    $
      (X < x) = union.big_(q in QQ \ q < x) (X <= q).
    $
    which is a countable union of events. Complements give
    $
      (X > a) = (X <= a)^C, quad
      (X >= a) = (X < a)^C,
    $
    meaning these are also events. Any interval can be made by intersecting sets of these four types. For example,
    $
      (a < X <= b) = (X > a) inter (X <= b),
    $
    meaning $X^(-1)(I) = (X in I)$ is an event whenever $I$ is an interval.

  + First, $RR in cal(E)_X$ because $X^(-1)(RR) = Omega in cal(E)$. If $B in cal(E)_X$, then
    $
      X^(-1)(A^C) = (X^(-1)(A))^C in cal(E),
    $
    so $A^C in cal(E)_X$. Finally, if $A_1, A_2, ... in cal(E)_X$ then
    $
      X^(-1)(union.big_(n=1)^oo A_n)
      = union.big_(n=1)^oo X^(-1)(A_n)
      in cal(E).
    $
    Therefore $union.big_(n=1)^oo A_n in cal(E)_X$, and $cal(E)_X$ is a $sigma$-algebra on $RR$.

  + Let $cal(I)$ be the family of open intervals in $RR$. Part 2 shows that $cal(I) subset.eq cal(E)_X$. Since the Borel $sigma$-algebra $cal(B)(RR)$ is the smallest $sigma$-algebra containing all open intervals, we have
    $
      cal(B)(RR) subset.eq cal(E)_X.
    $
    Consequently, $X^(-1)(B) in cal(E)$ for every $B in cal(B)(RR)$, which proves that $X$ is a RV.
  // Furthermore, $(X <= x)$ is an event for every $x in RR$, so
  //   $
  //     F_X (x) = P(X <= x)
  //   $
  //   is defined for every $x in RR$.
]

#pagebreak()
#problem(name: [Probability associated with RV])[
  Let $X$ be a RV. Show that the function $P_X: cal(B)(RR) -> RR$ defined by
  $
    P_X (B) := P(X in B) = P(X^(-1)(B))
  $
  is a probability on $RR$.
]
#solution()[
  For $P_X$ to define a probability distribution on $(RR, cal(E)_X)$, we simply check the three conditions:
  - With $A in cal(E)_X$ we have $P_X (B) = P(X in B) >= 0$ since $P(dot)$ is a probability.
  - $P_X (RR) = P(X in RR) = P(Omega) = 1$.
  - With pairwise disjoint $B_1, B_2, ... in cal(B)(RR)$, we have
    $
      P_X (union.big_(i=1)^(oo) B_i)
      = P(X^(-1) (union.big_(i=1)^(oo) B_i))
      = P(union.big_(i=1)^(oo) X^(-1)(B_i))
      = sum_(i=1)^(oo) P(X^(-1)(B_i))
      = sum_(i=1)^(oo) P_X (B_i).
    $
]



#pagebreak()
#problem(name: [Proving some important properties of expectation for simple RVs])[
  Let $X$ and $Y$ be simple RVs, and let $alpha, beta in RR$. Prove
  - Constants are preserved: If $X = c$ for some $c in RR$, then $EE[X] = c$.
  - Monotonicity: If $X <= Y$, then $EE[X] <= EE[Y]$.
  - Linearity: $EE[alpha X + beta Y] = alpha EE[X] + beta EE[Y]$.
  - Relation to probability: If $A in cal(E)$, then $EE[bb(1)(A)] = P(A)$.
]
#solution()[
  Denote the simple RVs as $X = sum_(i=1)^n a_i bb(1)_(A_i)$ and $Y = sum_(j=1)^m b_j bb(1)_(B_j)$.
  - If $X(omega) = c in RR$ for every $omega in Omega$, then $EE[X] = EE[c] = c P(Omega) = c$.
  - If $X <= Y$, then $a_i <= b_j$ whenever $A_i inter B_j != emptyset$. Since both $A_i$ and $B_j$ give a disjoint partitions of $Omega$, we have
    $
      EE[X] = sum_(i=1)^n a_i P(A_i)
      = sum_(i=1)^n sum_(j=1)^m a_i P(A_i inter B_j)
      <= sum_(i=1)^n sum_(j=1)^m b_j P(A_i inter B_j)
      = sum_(j=1)^m b_j P(B_j)
      = EE[Y].
    $
  - We can express
    $
      alpha X + beta Y
      = sum_(i=1)^n sum_(j=1)^m (alpha a_i + beta b_j) bb(1)_(A_i inter B_j),
    $
    meaning that $alpha X + beta Y$ is also simple. Thus
    $
      EE[alpha X + beta Y] & = sum_(i=1)^n sum_(j=1)^m (alpha a_i + beta b_j) P(A_i inter B_j) \
                           & = alpha sum_(i=1)^n sum_(j=1)^m a_i P(A_i inter B_j)
                             + beta sum_(i=1)^n sum_(j=1)^m b_j P(A_i inter B_j) \
                           & = alpha sum_(i=1)^n a_i P(A_i)
                             + beta sum_(j=1)^m b_j P(B_j) \
                           & = alpha EE[X] + beta EE[Y].
    $
  - As $bb(1)_(A) = 1 dot bb(1)_(A) + 0 dot bb(1)_(A^C)$, the indicator function is clearly simple. This means
    $
      EE[bb(1)(A)] = 1 dot P(A) + 0 dot P(A^C) = P(A).
    $

]

#pagebreak()
#proposition(name: [A more General definition of the expectation])[
  A more general definition of expectation is using the Lebesgue integral
  $
    EE[X] = integral_Omega X dif P.
  $
  All the details of this is likely beyond the scope of this course. However, we can still try to gain a bit of insight. For a RV $X: Omega -> RR$ with $X(omega) = x$, we can rewrite this as an integral over $RR$
  $
    EE[X] = integral_Omega X(omega) dif P(omega) = integral_RR x dif P(X^(-1)(x)) = integral_RR x dif P_X (x).
  $
  For a simple RV, the $dif P_X (x)$ is a discrete measure, and the integral reduces to the sum in @expectation-for-simple-rvs. If $X$ is a continuous RV, then the $dif P_X (x) = f_X (x) dif x$, where $f_X$ is the probability density function of $X$. For the $dif x$ we can use the standard Riemann integral. This gives the familiar expression
  $
    EE[X] = integral_RR x f_X (x) dif x,
  $
  that you might remember from the first course in statistics.
]
