
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
+ Event: Subsets of $Omega$ for which probabilities are defined.
+ Measurable space: Sample space $Omega$ equipped with a family of events $cal(E)$.

#definition(name: [$sigma$-algebra])[
  A $sigma$-algebra $cal(E)$ on $Omega$ is a family of subsets of $Omega$ satisfying
  - $Omega in cal(E)$
  - If $A in cal(E)$, then $A^C = Omega \\ A in cal(E)$.
  - If $A_1, A_2, ... in cal(E)$, then $union_(i=1)^(oo) A_i in cal(E)$.
]<sigma-algebra>

#definition(name: [Events])[
  The family of events $cal(E)$ is a $sigma$-algebra on the set of outcomes $Omega$.
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

#proposition(name: [Simplified criteria for RV])[
  A function $X: Omega -> RR$ is a RV if
  $
    (X <= x) := X^(-1)((-oo, x]) in cal(E)
  $
  for every $x in RR$.
]<random-variable-simplified-criteria>

#proposition(name: [Probability associated with RV])[
  If $X$ is a RV, then the function $P_X: cal(B)(RR) -> RR$ defined by
  $
    P_X (B) := P(X in B) = P(X^(-1)(B))
  $
  is a probability on $RR$.
]


#definition(name: [Cumulative distribution function associated with an RV])[
  The cumulative distribution function (CDF) of $X$ is the function $F_X: RR -> [0, 1]$ defined by
  $
    F_X (x) := P_X ((-oo, x]) = P(X <= x).
  $

]

#definition(name: [Simple RV])[
  A RV $X$ is simple if it takes on only finitely many values. One way to write this is
  $
    X = sum_(i=1)^n a_i bb(1)_(A_i)
  $
  where $n < oo$, $a_i in RR$, $A_i in cal(E)$, and $bb(1)(dot)$ is the indicator function. Alternatively, we can write a $X(Omega) = {X(omega) | omega in Omega} = {x_1, ... , x_n}$.
]

#definition(name: [Expectation of simple RVs])[
  The expectation of a simple RV $X = sum_(i=1)^n a_i bb(1)_(A_i)$ is defined as
  $
    EE[X] = sum_(i=1)^n a_i P(A_i).
  $
]

#pagebreak()
= Problems

#problem(name: [Sample spaces and events])[
  Let $Omega = {1, 2, 3}$ and $cal(E) = {emptyset, Omega, {1}, {2, 3}}$.
  + Show that ($Omega$, $cal(E)$) is a measurable space.
  + Is ${1, 2}$ an event?
  + How many subsets of $Omega$ are events?
  + Every event is a set, but every set is not an event. Explain this.
]
#solution[
  + Need to show that $cal(E)$ is a $sigma$-algebra on $Omega$. All the conditions listed in @sigma-algebra are easy to verify.
  + As ${1, 2} in.not cal(E)$, it is not an event.
  + There are four events, as listed in $cal(E)$.
  + Only the sets in $cal(E)$ are events. There are a total of $2^3 = 8$ subsets of $Omega$, but only four of them are events.
]

#pagebreak()
#problem(name: [CDFs and RVs])[
  Let $X: Omega → RR$ be such that $(X <= q)$ is an event for all $q in QQ$.
  + Prove that $(X <= x)$ is an event for every $x in RR$.
  + Prove that $(X in A)$ is an event when $A$ is an interval.


  + Define $cal(E)_X := {B subset.eq RR : X^(-1)(B) in cal(E)}$ and prove that $cal(E)_X$ is a $sigma$-algebra on $RR$.

  + Prove that $X$ is a RV and that the CDF $F(x) = P(X <= x)$ is defined.
]
#solution()[

  + For each positive integer $n$, choose $q_n in QQ$ such that
    $
      x < q_n < x + 1/n.
    $
    Such rational numbers exist because there is a rational number between any two different real numbers.


    If $X <= x$, then $X <= q_n$ for every $n$, and if $X > x$, then eventually $q_n < X$. Therefore we have
    $
      (X <= x) = inter.big_(n=1)^oo (X <= q_n).
    $<event-intersection>
    Each $(X <= q_n)$ is an event by assumption. A $sigma$-algebra is closed under countable intersections, since
    $
      inter.big_(n=1)^oo E_n
      = (union.big_(n=1)^oo E_n^C)^C.
    $
    Thus $(X <= x)$ is an event, and $F(x) = P(X <= x)$ is defined for every $x in RR$.
  + We also have that that strict inequalities are events. This is because
    $
      (X < x) = union.big_(q in QQ, q < x) (X <= q).
    $
    which is a countable union of events. Complements give
    $
      (X > a) = (X <= a)^C, quad
      (X >= a) = (X < a)^C.
    $
    Any interval can be made by intersecting sets of these four types. For example,
    $
      (a < X <= b) = (X > a) inter (X <= b).
    $
    Hence $(X in A)$ is an event whenever $A$ is an interval.



  +


  + We have already proved that $(X <= x)$ is an event for every $x in RR$. The simplified criterion in @random-variable-simplified-criteria therefore shows that $X$ is a RV. It also means that the probability $P(X <= x)$ exists, meaning the CDF is defined.
]


#pagebreak()
#problem(name: [Probing some important properties of expectation for simple RVs])[
  Let $X$ and $Y$ be simple RVs, and let $alpha, beta in RR$. Prove
  - Constants are preserved: If $X = c$ for some $c in RR$, then $EE[X] = c$.
  - Monotonicity: If $X <= Y$, then $EE[X] <= EE[Y]$.
  - Linearity: $EE[alpha X + beta Y] = alpha EE[X] + beta EE[Y]$.
  - Relation to probability: If $A in cal(E)$, then $EE[bb(1)(A)] = P(A)$.
]
#proof()[
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
#problem(name: [Slightly generalizing the notion of the RV])[
  Let $X : Omega → Omega_X$ be such that $(X in A) = {omega : X(omega) in A}$ is an event in $Omega$ whenever $A$ is an event in $Omega_X$, e.g. $X$ is a random element in $Omega_X$.
  + Show that $P_X (A) = P(X in A)$ defines a probability distribution.
  + Show that $EE[phi(X)] = EE_X [phi]$ when $phi : cal(B)(RR) -> RR$ is simple and measurable.
]
#solution()[
  + For $P_X$ to define a probability distribution on $(Omega_X, cal(E)_X)$, we simply check the three conditions:
    - With $A in cal(E)_X$ we have $P_X(A) = P(X in A) >= 0$ since $P(dot)$ is a probability.
    - $P_X (Omega_X) = P(X in Omega_X) = P({w in Omega: X(w) in Omega_X}) = P(Omega) = 1$.
    - With pairwise disjoint $A_1, A_2, ... in cal(E)_X$, we have
      $
        P_X (union.big_(i=1)^(oo) A_i)
        = P(X in union.big_(i=1)^(oo) A_i)
        = P(union.big_(i=1)^(oo) (X in A_i))
        = sum_(i=1)^(oo) P(X in A_i)
        = sum_(i=1)^(oo) P_X (A_i).
      $


  + As $phi(dot)$ is simple and measurable, we can write $phi(dot) = sum_(i=1)^n a_i bb(1)_(A_i) (dot)$ for some $a_i in RR$ and $A_i in cal(E)_X$. Then
    $
      EE[phi(X)]
      = EE[sum_(i=1)^n a_i bb(1)_(A_i) (X)]
      = sum_(i=1)^n a_i EE[bb(1)_(A_i) (X)]
      = sum_(i=1)^n a_i P(X in A_i)
      = sum_(i=1)^n a_i P_X (A_i)
      = EE_X [phi].
    $



]
