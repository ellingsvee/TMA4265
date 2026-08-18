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
      name: "Elling Svee",
      email: "elling.svee@ntnu.no",
    ),
  ),
  n_columns: 1,
  paper-size: "a4",
  bibliography: bibliography("refs.bib"),
)

_These notes are written by myself, and errors may and will occur. When in doubt, trust the book and Gunnars lectures!_

= Theory based on #tc(<karr1993probability>)

Informally, a _random experiment_ has the following objects:
+ Sample space: The set $Omega$ with all possible outcomes.
+ Outcome: An element $omega in Omega$ of the sample space.
+ Event: Subsets of $Omega$ for which probabilities are defined.

#definition(name: [$sigma$-algebra])[
  A $sigma$-algebra $cal(E)$ on $Omega$ is a family of subsets of $Omega$ satisfying the following
  - $Omega in cal(E)$
  - If $A in cal(E)$, then $A^C = Omega \\ A in cal(E)$.
  - If $A_1, A_2, ... in cal(E)$, then $union_(i=1)^(oo) A_i in cal(E)$.
]<sigma-algebra>

#definition(name: [Events])[
  The family of events associated with a random experiment with sample space $Omega$ is a $sigma$-algebra $cal(E)$ on $Omega$.
]

#definition(name: [Probability])[
  A probability on $(Omega, cal(E))$ is a function $P: cal(E) -> RR$ such that
  - $P(A) >= 0$ for all $A in cal(E)$.
  - $P(Omega) = 1$.
  - If $A_1, A_2, ... in cal(E)$ are pairwise disjoint, then $P(union_(i=1)^(oo) A_i) = sum_(i=1)^(oo) P(A_i)$.
]

#definition(name: [Cumulative distribution function])[
  The cumulative distribution function (CDF) of $P$ is the function $F_P: RR -> [0, 1]$ defined by $F_P (t) = P(-oo <= t)$.
]

#definition(name: [Random variable])[
  A random variable is a function $X: Omega -> RR$ such that
  $
    X^(-1)(B) = {omega in Omega: X(omega) in B} in cal(E)
  $
  for every $B in cal(B)(RR)$. Here $cal(B)(RR)$ denotes the Borel $sigma$-algebra on $RR$, which is the smallest $sigma$-algebra containing all open intervals in $RR$ @karr1993probability.
]

#proposition(name: [Simplified criteria for random variable])[
  A function $X: Omega -> RR$ is a random variable if $(X <= x) in cal(E)$ for every $x in RR$. See #tc(<karr1993probability>) for a proof.
]<random-variable-simplified-criteria>

#definition(name: [Simple random variable])[
  A random variable $X$ is simple if it takes on only finitely many values. One way to write this is
  $
    X = sum_(i=1)^n a_i bb(1)(A_i)
  $
  where $n < oo$, $a_i in RR$, $A_i in cal(E)$, and $bb(1)(dot)$ is the indicator function. Alternatively, we can write a $X(Omega) = {X(omega) | omega in Omega} = {x_1, ... , x_n}$.
]

#definition(name: [Expectation of simple random variables])[
  The expectation of a simple random variable $X = sum_(i=1)^n a_i bb(1)(A_i)$ is defined as
  $
    EE[X] = sum_(i=1)^n a_i P(A_i).
  $
]
#proposition(name: [Some important properties of expectation])[
  Let $X$ and $Y$ be random variables, and let $alpha, beta in RR$. Then
  - Constants are preserved: If $X = c$ for some $c in RR$, then $EE[X] = c$.
  - Monotonicity: If $X <= Y$, then $EE[X] <= EE[Y]$.
  - Linearity: $EE[alpha X + beta Y] = alpha EE[X] + beta EE[Y]$.
  - Relation to probability: If $A in cal(E)$, then $EE[bb(1)(A)] = P(A)$.


]

#pagebreak()
= Problems

#problem()[
  Let $Omega = {1, 2, 3}$ and $cal(E) = {emptyset, Omega, {1}, {2, 3}}$.
  + Show that $Omega$ equipped with $cal(E)$ is a sample space (i.e. a measurable space).
  + Is ${1, 2}$ an event?
  + How many subsets of $Omega$ are events?
  + Every event is a set, but every set is not an event. Explain this.
]
#solution[
  + As I interpret the question and terminology, this asks that we show that $cal(E)$ is a $sigma$-algebra on $Omega$. All the conditions listed in @sigma-algebra are easy to verify.
  + As ${1, 2} in.not cal(E)$, it is not an event.
  + There are four events, as listed in $cal(E)$.
  + Only the sets in $cal(E)$ are events. There are a total of $2^3 = 8$ subsets of $Omega$, but only four of them are events.
]

#pagebreak()
#problem()[
  Let $X: Omega → RR$ be such that $(X <= q)$ is an event for all $q in QQ$.
  + Prove that the CDF $F(x) = P(X <= x)$ is defined for all real $x$.
  + Prove that $(X <= x)$ is an event.
  + Prove that $(X in A)$ is an event when $A$ is an interval.
  + Prove that $X$ is a random variable.
  + Is $(X in A)$ an event when $A$ is an arbitrary set?
]
#solution()[
  + To define $F(x)$, we must first show that $(X <= x)$ is an event for any $x in RR$. For each positive integer $n$, choose $q_n in QQ$ such that
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

  + This is exactly what @event-intersection proves.
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

  + We have shown that $(X <= x)$ is an event for every $x in RR$. The simplified criterion in @random-variable-simplified-criteria therefore shows that $X$ is a random variable.

  + Not necessarily. The definition only guarantees this when $A$ is a Borel set. For example, let
    $
      Omega = RR, quad cal(E) = cal(B)(RR), quad X(omega) = omega.
    $
    If $A$ is a non-Borel subset of $RR$, then $(X in A) = A$ is not an event. Such subsets exist, but we do not show this here.
]

#pagebreak()
#problem()[
  Let $X : Omega → Omega_X$ be such that $(X in A) = {omega : X(omega) in A}$ is an event in $Omega$ whenever $A$ is an event in $Omega_X$, e.g. $X$ is a random element in $Omega_X$.
  + Show that $P_X (A) = P(X in A)$ defines a probability distribution. This $P_X$ is the distribution of $X$ with a corresponding expectation $EE[X]$.
  + Show that $EE[phi(X)] = EE_X [phi]$ when $phi : Omega_X -> RR$ is simple and measurable.
  + Assume that $X(Omega) = {X(omega) | omega in Omega} = {x_1, ... , x_n}$, i.e. $X$ is simple. Prove $E[phi(X)] = sum_x phi(x) f(x)$, where $f(x) = P(X = x)$.
  + Let $X$ and $Y$ be simple random variables. Prove that $Z = (X, Y)$ is simple.
  + Use $phi(x, y) = alpha x + beta y$ to prove $EE[alpha X + beta Y] = alpha EE[X] + beta EE[Y]$
]
#solution()[
  + For $P_X(dot)$ to define a probability distribution on $(Omega_X, cal(E)_X)$, we simply check the three conditions:
  - For $A in cal(E)_X$ we have $P_X(A) = P(X in A) >= 0$ since $P(dot)$ is a probability.
  - $P_X (Omega_X) = P(X in Omega_X) = P({w in Omega: X(w) in Omega_X}) = P(Omega) = 1$.
  - For pairwise disjoint $A_1, A_2, ... in cal(E)_X$, we have
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
  + As $X(dot)$ is simple, we can write $X(dot) = sum_(i=1)^n x_i bb(1)_(A_i) (dot)$ for some $x_i in RR$ and $A_i in cal(E)$. Then
    $
      EE[phi(X)]
      = EE[sum_(i=1)^n phi(x_i) bb(1)_(A_i) (X)]
      = sum_(i=1)^n phi(x_i) EE[bb(1)_(A_i) (X)]
      = sum_(i=1)^n phi(x_i) P(A_i)
      = sum_x phi(x) f(x).
    $
  + As $X$ and $Y$ are simple, we can write $X = sum_(i=1)^n x_i bb(1)_(A_i)$ and $Y = sum_(j=1)^m y_j bb(1)_(B_j)$ for some $x_i, y_j in RR$ and $A_i, B_j in cal(E)$. Then
    $
      Z = (X, Y)
      = sum_(i=1)^n sum_(j=1)^m (x_i, y_j) bb(1)_(A_i inter B_j).
    $
    As $A_i inter B_j in cal(E)$, we see that $Z(dot)$ is simple.
  + Using the linearity of expectation, we have
    $
      EE[alpha X + beta Y]
      = EE[alpha X] + EE[beta Y]
      = alpha EE[X] + beta EE[Y].
    $



]
