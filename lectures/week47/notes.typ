#import "../templates/tma4265-notes.typ": *
#import "@preview/muchpdf:0.1.2": muchpdf

#import "@preview/lemmify:0.1.7": default-theorems, new-theorems, thm-numbering-heading
#show figure.where(kind: "solution-group"): set block(breakable: true)

#import "../utils.typ": transition-diagram, transition-figure


#show link: set text(fill: blue)


#show: icml.with(
  title: [
    Week 47: Exam preparation
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
asdf


= Problems


#problem(name: [Exam 2026])[
  Occurrence of E. coli bacteria in drinking water from a given water source can be modelled by a Poisson process N with intensity measure $lambda$. Let $X = N(V)$ and $Y = N(W)$ be the number of viable cells in two samples given by regions $V$ and $W$ in the fluid. To define a stochastic process it is necessary to specify its index set $cal(I)$ and its state space $cal(S)$.
  + What are the index set and state space of the Poisson process $N$?
  + How is $N$ connected to the unknown underlying probability space $Omega$ as defined in the textbook used in the course. Note: As always, the space $Omega$ need not be specified here.
  + What are the defining properties of the space $Omega$ according to the mathematical model introduced by Kolmogorov?
  + Both $X$ and $Y$ are random variables and then they have well defined cumulative distributions $F_X$ and $F_Y$ . What does this mean in terms of the assumptions on $Omega$ Prove that if $X$ and $Y$ are random variables, then $X − Y$ is a random variable.
  // + How is the distribution of $(X, Y)$ and $X − Y$ determined by $lambda$? How is this connected to $Omega$
]
#solution[
  + Assume the fluid has a volume in 3 dimensional space. In a spatial Poisson random measure, the process is indexed by spatial regions rather than scalar time points. Therefore, $cal(I)$ is the collection of all measurable subsets of the fluid volume, i.e. the Borel $sigma$-algebra $cal(B)(RR^3)$. The output of the process $N$ counts the number of occurrences of E. coli bacteria in each region, which is a non-negative integer. Therefore, $cal(S) = NN_0 = {0, 1, 2,dots}$.
  + For any fixed, specified spatial region $V in cal(I)$, the $N(V)$ is a real-valued random variable defined on the underlying probability space $Omega$. That is, $N(V)$ is a measurable function mapping outcomes from the sample space $Omega$ to the state space $cal(S)$
    $
      N(V): Omega --> cal(S).
    $
    An individual outcome $omega in Omega$ represents a single complete physical realization of the exact positions of all E. coli bacteria dispersed throughout the entire water source.
  + $Omega$ acts as the base of a probability space $(Omega, cal(F), P)$, defined by three core axioms:
    - Sample space $Omega$: A non-empty set containing all mutually exclusive possible elemental outcomes $omega$ of the random experiment.
    - $sigma$-algebra $cal(F)$: A collection of subsets of Ω representing all observable “events”. $cal(F)$ must contain $Omega$ itself and be closed under complementation and countable unions.
    - Probability measure $P$: A function $P: cal(F) -> [0,1]$ assigning probabilities to events. Must satisfy non-negativity, normalization, and countable additivity.
  + Saying $X$ has a well-defined cumulative distribution function $F_X (x) = P(X <= x)$ means that the preimage of the interval $(−oo, x]$ under the mapping $X$ is guaranteed to be a measurable event inside our $sigma$-algebra $cal(F)$. Formally, for any $x in RR$
    $
      {omega in Omega | X(omega) <= x} in F quad forall x in RR.
    $
    To prove that $Z = X − Y$ is a random variable, we need to show that
    $
      {omega in Omega | X(omega) − Y(omega) <= z} in F quad forall z in RR.
    $
    We can rewrite the strict inequality $X < Y + z$ by exploiting the fact that the set of rational numbers $QQ$  is dense in $RR$. There exists a rational number $q in QQ$ separating $X$ and $Y + z$ if and only if $X < Y + z$. Therefore
    $
      {omega in Omega | X(omega) − Y(omega) <= z} = union_(q in QQ) ({omega in Omega | X(omega) <= q} inter {omega in Omega | Y(omega) > q - z}).
    $
    As both $X$ and $Y$ are random variables, the sets ${omega in Omega | X(omega) <= q}$ and
    $
      {omega in Omega | Y(omega) > q - z} = Omega \\ {omega in Omega | Y(omega) <= q - z}
    $
    are measurable events in $cal(F)$. The intersection of two measurable events is also a measurable event, and the countable union of measurable events is also a measurable event. Thus, the set ${omega | X − Y < z} in cal(F)$. Taking the complement confirms ${omega | X − Y <= z} in cal(F)$, proving $X − Y$ is a measurable random variable.
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

#problem(name: [Exam 2025])[
  What is the mathematical definition of a stochastic process $X$? Use $X_1, X_2, dots$ to define a stochastic process $X$. What is the probability distribution of $X$ in this particular case?
]
#solution[
  A stochastic process in an indexed family of random elements in a state space. The index set can be an arbitrary non-empty set. However, the index set $NN = {1, 2, dots}$ would a natural choice for most examples you might see. The state space $cal(S)$ can be an arbitrary sample space, which is a non-empty set equipped with a family of events $cal(F)$. Each random element is a function $X_i: Omega -> cal(S)$ so that
  $
    (X_i in A) = {omega in Omega | X_i(omega) in A} in cal(F)
  $
  is an event in $Omega$ whenever $A$ is an event in $cal(S)$. The probability distribution of a stochastic process is defined by all finite-dimensional distributions.
]

#problem(name: [Exam 2024])[
  A GPS device gives a position $(X, Y)$ which is bivariate normal with expectation $(10"m", 20"m")$, standard deviations $(1"m", 1"m")$, and correlation $0.9$.
  - Find the distribution of $W = X + Y$.
  - It assumed above that $X$ and $Y$ are random variables. What is the definition of a random variable in axiomatic probability theory?
  - Prove that $W$ is a random variable using the axioms for events.
]
#solution[
  - The sum of two jointly normal random variables is also normally distributed. Computing the mean and variance of $W$ gives
    $
           mu & = 10"m" + 20"m" = 30"m", \
      sigma^2 & = "Var"(X + Y) = "Var"(X) + "Var"(Y) + 2"Cov"(X, Y) \
              & = sigma_1^2 + sigma_2^2 + 2 rho sigma_1 sigma_2 = 1"m"^2 + 1"m"^2 + 2 dot 0.9 dot 1"m" dot 1"m" = 3.8"m"^2.
    $
  - A random variable is a function $W:Omega -> RR$ so that
    $
      (W <= w) = {omega in Omega | W(omega) <= w} in cal(F)
    $
    is an event for all $w in RR$.
  - Similar as earlier task, we show that $(W <= w) in cal(F)$ by using that the rationals $QQ$ are dense in $RR$.

]
