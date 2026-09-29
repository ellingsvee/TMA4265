#import "../templates/tma4265-notes.typ": *
#import "@preview/muchpdf:0.1.2": muchpdf

#import "@preview/lemmify:0.1.7": default-theorems, new-theorems, thm-numbering-heading
#show figure.where(kind: "solution-group"): set block(breakable: true)

#import "../utils.typ": transition-diagram, transition-figure


#show link: set text(fill: blue)


#show: icml.with(
  title: [
    Week 40: More on continuous-time Markov Chains
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

= Repetition from last week

#theorem(name: [Forward Kolmogorov differential equations])[
  For a birth-and-death process on $cal(S) = {0, 1, 2, dots}$,
  $
    P_(i,0)^' (t) &= -lambda_0 P_(i,0)(t) + mu_1 P_(i,1)(t), quad t >= 0 \
    P_(i,j)^' (t) &= lambda_(j-1) P_(i,j-1)(t) - (lambda_j + mu_j) P_(i,j)(t) + mu_(j+1) P_(i,j+1)(t), quad t >= 0, quad j >= 1,
  $
  with initial conditions $P_(i,j)(0) = delta_(i,j)$.
]<thm:forward-kolmogorov-differential-equations>


= Theory



#theorem()[
  For a birth-and-death process without absorbing states,
  $
    pi_j = lim_(t->oo) P_(i, j)(t), quad j = 0, 1, dots,
  $
  exists and are not dependent on $i$.

  Remark:
  - $pi_j = 0$ for all states $j$ is possible.
  - If $sum_(j = 0)^(oo) pi_j = 1$, the $bold(pi) = (pi_0, pi_1, dots)^top$is called the limiting distribution.
  - If the limiting distribution exists, it is also a stationary distribution. We can see this since
    $
      pi_j = lim_(s->oo) P_(i, j)(s+t) = lim_(s->oo) sum_(k = 0)^(oo) P_(i, k)(s) P_(k, j)(t) = sum_(k = 0)^(oo) pi_k P_(k, j)(t), quad j = 0, 1, dots, quad t>=0.
    $
]

The general importance of of birth and death processes as models derives in large part from the availability of standard formulas for determining if a limiting distribution exists and what its values are when it does. These formulas follow from the Kolmogorov forward differential equations in @thm:forward-kolmogorov-differential-equations. Taking the limit as $t->oo$ in these equations, we see
$
  0 &= -lambda_0 pi_0 + mu_1 pi_1, \
  0 &= lambda_(j-1) pi_(j-1) - (lambda_j + mu_j) pi_j + mu_(j+1) pi_(j+1), quad j >= 1.
$
Here we get zeroes on the left-hand side because the limiting distribution is converging to a constant.

#theorem()[
  When the limiting distribution $bold(pi)$ exists, it is the unique solution to
  $
             lambda_0 pi_0 & = mu_1 pi_1, \
    (lambda_j + mu_j) pi_j & = lambda_(j-1) pi_(j-1) + mu_(j+1) pi_(j+1), quad j >= 1, \
     sum_(j = 0)^(oo) pi_j & = 1.
  $

  Remark: This is quite intuitive, as "Rate in = Rate out" with "Rate" being the number of events per unit time.
  // - "Rate in" $= pi_(i-1) lambda_(i-1) + pi_(i+1)mu_(i+1)$. Here $pi_(i-1)$ is the proportion of time in state $i-1$, and $lambda(i-1)$ is the rate of leaving state $i-1$ to state $i$.
]<thm:limiting-distribution-unique-solution>

#theorem()[
  For a birth-and-death process without absorbing states, we have
  $
    pi_i = theta_i pi_0 =  theta_i / (sum_(k = 0)^(oo) theta_k), quad i = 0, 1, dots,
  $
  where $theta_0 = 1$ and
  $
    theta_i = lambda_0 / mu_1 dot lambda_1 / mu_2 dot dots dot lambda_(i-1) / mu_i = (product_(j = 0)^(i-1) lambda_j)/(product_(j = 1)^(i) mu_j), quad i = 1, 2, dots.
  $
]<thm:limiting-distribution-unique-solution-without-absorbing-states>


#theorem()[
  For a birth-and-death process ${X(t): t >= 0}$ with state space $cal(S)$, let $A subset cal(S)$ and let
  $
    v_i = EE[min {t >= 0: X(t) in A} | X(0) = i], quad i in cal(S).
  $
  If there are no absorbing states outside $A$, the expected times can be found by solving
  $
    v_i = 0, quad i in A, \
    v_i = EE[S_i] + sum_(j != i) P(i -> j) v_j = 1/(lambda_i + mu_i) + sum_(j != i) P(i -> j) v_j, quad i in.not A.
  $
  // Remark:
  // - Similarly, for DTMC we had $v_i = 1 + sum_(j in cal(S)) P_(i,k) v_k$ for $i in.not A$. Do not mix these two equations!
]

#theorem()[
  For a birth-and-death process, absorption probabilities are computed using the discrete-time Markov chain with one-step transition probabilities given by
  $
    P_(i, j) = P(i -> j), quad i != j,
  $
  and
  $
    P_(i, i) = cases(
      0 quad & "if" lambda_i + mu_i > 0,
      1 quad & "if" lambda_i + mu_i = 0
    ), quad i = 0, 1, dots.
  $
]<thm:absorption-probabilities-birth-and-death-process>


#pagebreak()
= Problems
#problem()[
  A machine works ($1$) or is broken ($0$). Time to breakdown is $"Exp"(mu)$, and time to repair is $"Exp"(lambda)$. All sojourn times are independent. The machine works at time $t=0$. Calculate the probability that the machine works at time $t=10$.
]
#solution()[
  We have
  $
    X(t) = cases(
      1 quad & "machine works at time" t,
      0 quad & "machine broken at time" t
    ),
  $
  and the goal is to find $P_(1, 1)(10) = P(X(10) = 1 | X(0) = 1)$. By the forward Kolmogorov differential equations, we have
  $
    P_(1, 1)^' (t) & = lambda P_(1, 0)(t) - mu P_(1, 1)(t), \
    // P_(1, 0)^' (t) & = 1 - P_(1, 1)(t)
  $
  and initial conditions $P_(1, 1)(0) = 1$. As we only have two states, we also know that $P_(1, 0)(t) = 1 - P_(1, 1)(t)$, and we can rewrite the differential equation as
  $
    P_(1, 1)^'(t) + mu P_(1, 1)(t) = lambda [1 - P_(1, 1)(t)]
    <==> P_(1, 1)^' (t) + (lambda + mu) P_(1, 1)(t) = lambda
    // & ==> P_(1, 1)(t) = mu/(lambda + mu) e^(-(lambda + mu)t) + lambda/(lambda + mu).
  $
  Again, applying the integrating factor $e^((lambda + mu) t)$ gives
  $
    e^((lambda + mu) t) (dif/(dif t) P_(1, 1)(t) + (lambda + mu) P_(1, 1)(t)) = lambda e^((lambda + mu) t) \
    ==> dif/(dif t) (e^((lambda + mu) t) P_(1, 1)(t)) = lambda e^((lambda + mu) t) \
    ==> e^((lambda + mu) t) P_(1, 1)(t) = integral_0^t lambda e^((lambda + mu) tau) dif tau + C = lambda / (lambda + mu) (e^((lambda + mu) t) - 1) + C \
    ==> P_(1, 1)(t) = lambda / (lambda + mu) (1 - e^(-(lambda + mu) t)) + C e^(-(lambda + mu) t).
  $
  The initial value $P_(1, 1)(0) = 1$ gives $C = 1$, meaning
  $
    P_(1, 1)(10) = lambda/(lambda + mu) (1 - e^(-(lambda + mu) 10)) + e^(-(lambda + mu) 10) = lambda/(lambda + mu) + mu/(lambda + mu) e^(-(lambda + mu) 10).
  $


]


#pagebreak()
#problem(name: [Problem 1, Exercise 6])[
  A pure birth process starting from $X(0) = 0$ has birth parameters $lambda_0 = 1$, $lambda_1 = 3$, $lambda_2 = 2$ and $lambda_3 = 5$. Let $W_1$, $W_2$ and $W_3$ be the stochastic times it takes the process to reach states $1$, $2$ and $3$, respectively.
  + Determine the transition probability functions $P_n (t) = P(X(t) = n|X(0) = 0)$ for $n = 0, 1, 2, 3$.
  + Write $W_3$ as a sum of sojourn times and thereby deduce that the mean time is $EE[W_3] = 11\/6$.
  + Determine the mean of $W_1 + W_2 + W_3$.
  + Determine the variance of $W_3$.
]
#solution()[
  + By the forward Kolmogorov differential equations, we have
    $
      P_0^' (t) & = - lambda_0 P_0 (t), \
      P_n^' (t) & = lambda_(n-1) P_(n-1)(t) - lambda_n P_n (t), quad n = 1, 2, 3
    $
    where the initial conditions are $P_0 (0) = 1$ and $P_n (0) = 0$ for $n = 1, 2, 3$. 

    We have to solve the system of differential equations recursively. Starting with $P_0 (t)$, we have the integrating factor $e^(integral_0^t lambda_0 dif tau) = e^(lambda_0 t)$, so
    $
      &e^(lambda_0 t) (dif/(dif t) P_0 (t) + lambda_0 P_0 (t)) = dif/(dif t) (e^(lambda_0 t) P_0 (t)) = 0 \
      &==> e^(lambda_0 t) P_0 (t) = C \
      &==> P_0 (t) = C e^(-lambda_0 t).
    $
    With the initial condition $P_0 (0) = 1$, we find $C = 1$, giving $P_0 (t) = e^(-lambda_0 t) = e^(-t)$.

    For state $1$, we have
      $
        P_1^' (t) + lambda_1 P_1 (t) = lambda_0 P_0 (t) = e^(-t).
      $
      Using the integrating factor $e^(integral_0^t lambda_1 dif tau) = e^(lambda_1 t)$, we have
      $
        &e^(lambda_1 t) (dif/(dif t) P_1 (t) + lambda_1 P_1 (t)) = dif/(dif t) (e^(lambda_1 t) P_1 (t)) = e^(lambda_1 t) e^(-t) = e^((lambda_1 - 1) t) \
        &==> e^(lambda_1 t) P_1 (t) = integral_0^t e^((lambda_1 - 1) tau) dif tau + C = 1/(lambda_1 - 1) (e^((lambda_1 - 1) t) - 1) + C \
        &==> P_1 (t) = 1/(lambda_1 - 1) (e^(-t) - e^(-lambda_1 t)) + C e^(-lambda_1 t).
      $
      and using the initial condition $P_1 (0) = 0$, we find $C = 0$, giving
      $
        P_1 (t) = 1/(lambda_1 - 1) (e^(-t) - e^(-lambda_1 t)) = 1/2 (e^(-t) - e^(-3 t)).   
      $
    The same method can be applied to the remaining equations, giving
      $
        P_2(t) & = 3/2 (e^(-t) - 2e^(-2t) + e^(-3t)), \
        P_3(t) & = 3/4 e^(-t) - 2e^(-2t) + 3/2 e^(-3t) - 1/4 e^(-5t).
      $
  + Letting $S_0$, $S_1$ and $S_2$ be the sojourn times, we want to estimate $W_3 = S_0 + S_1 + S_2$. As $S_i tilde.op "Exp"(lambda_i)$ and using the linearity of the expectation
    $
      EE[W_3] = sum_(i = 0)^(2) EE[S_i] = 1/lambda_0 + 1/lambda_1 + 1/lambda_2 = 1 + 1/3 + 1/2 = 11/6.
    $
  + Since $W_1=S_0$, $W_2=S_0+S_1$, and $W_3=S_0+S_1+S_2$, we have
    $
      EE[W_1+W_2+W_3] = 3EE[S_0] + 2EE[S_1] + EE[S_2] = 3 + 2/3 + 1/2 = 25/6.
    $
  + Since the sojourn times in this pure birth process are independent, we have
    $
      "Var"[W_3] = sum_(i=0)^(2) "Var"[S_i] = 1/lambda_0^2 + 1/lambda_1^2 + 1/lambda_2^2 = 1 + 1/9 + 1/4 = 49/36.
    $
]

// #pagebreak()
// #problem(name: [Exam 2025, Problem 3])[
//   A student at a lecture is at any time either focusing on the lecture or not. Assume that the expected length of the focused periods is $5$ minutes and that the expected length of the unfocused periods is $1$ minute.
//   -
//     + Explain that a (simplified) model of the student is as a two-state continuous time Markov chain X with state space ${0, 1}$.
//     + Determine the infinitesimal matrix $A$ of $X$.
//     + Assume the student is focused at the start of the lecture. What is the probability of the student being focused $10$ minutes later?
//   Assume that a group of $n = 40$ students is modeled identically as above by $X_1, dots, X_n$ independent two-state continuous Markov chains.
//   -
//     + Prove that $Z = X_1 + dots + X_n$ is a Markov chain.
//     + Determine a differential equation for the probability distribution of $Z$.
//     + Assume all students are focused at the beginning of the lecture. What is the expected number of focused students $10$ minutes later?
// ]
// #solution()[
//   -
//     + The student is either focused ($1$) or unfocused ($0$). We model the focused and unfocused periods as independent exponential sojourn times with means $5$ and $1$ minutes, respectively. With this modeling assumption, the future evolution depends only on the current state, so $X$ is a two-state CTMC.
//     + As $EE[S_1] = 5 = 1\/mu_1$ and $EE[S_0] = 1 = 1\/lambda_0$, we have $mu_1 = 1\/5$ and $lambda_0 = 1$. Therefore,
//       $
//         A = mat(
//           -lambda_0, lambda_0;
//           mu_1, -mu_1
//         ) = mat(
//           -1, 1;
//           1\/5, -1\/5
//         ).
//       $
//     + We are interested in $P_(1, 1)(10)$. Denote $p(t) = P_(1, 1)(t)$. By the forward Kolmogorov differential equations and using $P_(1,0)(t) = 1-p(t)$, we have
//       $
//         p^' (t) = lambda_0 (1 - p(t)) - mu_1 p(t) = 1 - p(t) - 1/5 p(t) = 1 - 6/5 p(t)
//       $
//       with initial condition $p(0) = 1$. Solving this differential equation and inserting $t=10$ gives
//       $
//         P_(1, 1)(10) = 1/6 e^(-12) + 5/6 approx 0.8333.
//       $
//   -
//     + Since the individual chains are independent, their joint process is a CTMC. When $Z=k$, exactly $k$ students can lose focus, each at rate $1\/5$, and $n-k$ students can gain focus, each at rate $1$. Thus, the transition rates depend on the joint state only through $Z$. It follows that $Z$ is a birth-and-death CTMC on ${0, dots, n}$, with birth rates $lambda_k=n-k$ and death rates $mu_k=k\/5$.
//     + Let $q_k(t)=P(Z(t)=k)$. For $k=0,dots,40$, the forward equations are
//       $
//         q_k^'(t) = (41-k)q_(k-1)(t) - (40-k+k/5)q_k(t) + (k+1)/5 q_(k+1)(t),
//       $
//       where terms with indices outside ${0,dots,40}$ are omitted. If all students are initially focused, $q_40(0)=1$ and $q_k(0)=0$ for $k != 40$.
//     + We are interested in $EE[Z(10) | X_i(0) = 1, i=1,dots,40] = sum_(i=1)^40 EE[X_i(10)| X_i(0) = 1]$ by linearity of expectation. As $X_i(t) in {0, 1}$, we have
//       $
//         EE[X_i (10) | X_i (0) = 1] = P(X_i (10) = 1 | X_i (0) = 1) = P_(1, 1)(10) = 1/6 e^(-12) + 5/6.
//       $
//       Therefore
//       $
//         EE[Z(10) | X_i(0) = 1, i=1,dots,40] = 40 (1/6 e^(-12) + 5/6) approx 33.33.
//       $
//
// ]

#pagebreak()
#problem()[
  Consider a CTMC
  #transition-figure()[
    #transition-diagram(
      ($0$, $1$),
      (
        (0, $lambda$),
        ($mu$, 0),
      ),
    )
  ]
  with $lambda, mu > 0$. Derive the long-run proportion of time spent in state $0$.
]
#solution()[
  Recall that "Rate in = Rate out". Thus
  $
    pi_0 lambda = pi_1 mu
    quad ==> quad
    pi_1 = lambda/mu pi_0,
  $
  giving
  $
    pi_0 + pi_1 = pi_0(1 + lambda/mu) = 1 quad ==> quad pi_0 = mu/(lambda + mu).
  $
]

#problem()[
  Consider a CTMC
  #transition-figure()[
    #transition-diagram(
      ($0$, $1$, $2$),
      (
        (0, 1, 0),
        (4, 0, 4),
        (0, 1, 0),
      ),
      positions: ((0, 0), (2, 0), (4, 0)),
      loop-angles: (180deg, 90deg, 0deg),
    )
  ]
  Calculate $pi_0$, $pi_1$ and $pi_2$.
]
#solution()[
  See
  $
    theta_0 = 1, quad theta_1 = lambda_0 / mu_1 = 1 / 4, quad theta_2 = theta_1 dot lambda_1 / mu_2 = 1/4 dot 4 / 1 = 1,
  $
  so
  $
    sum_(k = 0)^(2) theta_k = 1 + 1/4 + 1 = 9/4.
  $
  Giving
  $
    pi_0 & = 1 / (sum_(k = 0)^(2) theta_k) = 4 / 9, quad pi_1 & = theta_1 pi_0 = 1/4 dot 4/9 = 1/9, quad pi_2 & = theta_2 pi_0 = 1 dot 4/9 = 4/9.
  $
]


// #pagebreak()
// #problem()[
//   Consider a CTMC
//   #transition-figure()[
//     #transition-diagram(
//       ($0$, $1$, $2$),
//       (
//         (0, 1, 0),
//         (2, 0, 1),
//         (0, 2, 0),
//       ),
//       positions: ((0, 0), (2, 0), (4, 0)),
//     )
//   ]
//   For $X(0) = 0$, compute the expected time to reach state $2$.
// ]
// #solution()[
//   For the birth-and-death process ${X(t): t>=0}$, we have
//   $
//     v_i = EE[min {t >= 0: X(t) = 2} | X(0) = 0], quad i = 0, 1, 2.
//   $
//   We have
//   $
//     v_2 & = 0, \
//     v_1 & = 1/(lambda_1 + mu_1) + lambda_1/(lambda_1 + mu_1) v_2 + mu_1/(lambda_1 + mu_1) v_0 \
//         & = 1/3 + 2/3 v_0, \
//     v_0 & = 1/lambda_0 + v_1 = 1 + v_1.
//   $
//   Solving this system we find
//   $
//     v_0 = 1 + v_1 = 1 + 1/3 + 2/3 v_0
//     quad ==> quad v_0 = 4.
//   $
// ]
//
// #pagebreak()
// #problem(name: [Continuation of parking garage problem])[
//   Assume that a parking garage has a maximum capacity of $20$ cars and is always open. The arrival of cars is a Poisson process with rate $lambda = 0.5 "cars"\/"min"$, where cars will drive past the garage (and not form a queue) if the parking garage is full. The cars spend, independently of each other and their arrival times, a stochastic time in the parking garage. Each stochastic time follows an exponential distribution with expected value $1\/mu = 30 "minutes"$. After the time in the parking garage ends, the car immediately exists the parking garage. In the exercise sheet for week 41, you found the birth and death rates of the resulting birth-and-death process.
//   + Determine the limiting probabilities $pi_i$ for $i = 0, 1, . . . , 20$ as functions of $lambda$ and $mu$, and then compute the numerical value of $pi_20$.
//   + Compute the numerical value of the long-run mean number of cars in the parking garage.
// ]
// #solution()[
//   + From @thm:limiting-distribution-unique-solution we have the limiting probabilities as the solution to
//     $
//               lambda_0 pi_0 & = mu_1 pi_1, \
//       (lambda_i + mu_i) pi_i & = lambda_(i-1) pi_(i-1) + mu_(i+1) pi_(i+1), quad i = 1, dots, 19, \
//                 mu_20 pi_20 & = lambda_19 pi_19, \
//       sum_(i = 0)^(20) pi_i & = 1.
//     $
//     From last week we found that $lambda_i = lambda$ and $mu_i = i mu$. Based on @thm:limiting-distribution-unique-solution-without-absorbing-states we also have that the solution to these equations are given by $pi_i = theta_i pi_0, quad i = 1, dots, 20$, where $theta_0 = 1$ and
//     $
//       theta_i = (product_(j = 0)^(i-1) lambda_j)/(product_(j = 1)^(i) mu_j) = (lambda^i)/(mu^i i!), quad i = 1, dots, 20.
//     $
//     Determining $pi_0$ from the normalization condition gives
//     $
//       sum_(i = 0)^(20) pi_i = pi_0 sum_(i = 0)^(20) theta_i = 1
//       quad ==> quad
//       pi_0 = 1/(sum_(i = 0)^(20) theta_i) = 1/(sum_(i = 0)^(20) lambda^i/(mu^i i!)).
//     $
//     To simplify this expression, we can optionally use the cumulative distribution function of the Poisson distribution
//     $
//       F(x; nu) = sum_(i = 0)^(x) nu^i/i! e^(-nu).
//     $
//     Using $nu = lambda\/mu$, we can then write
//     $
//       pi_0 = 1/(sum_(i = 0)^(20) (lambda\/mu)^i/i!) = 1/(F(20; nu) e^(nu)),
//     $
//     giving
//     $
//       pi_j = nu^(i)/i! pi_0 = nu^i/i! 1/(F(20; nu) e^(nu)) = 1/F(20; nu) nu^(i)/i! e^(-nu) = f(j; nu)/F(20; nu),
//     $
//     where $f(j; nu)$ is the probability mass function of the Poisson distribution.
//   + The long-run mean number of cars $N$ in the garage is
//     $
//     EE[N] = sum_(i = 0)^(20) i pi_i = pi_0 sum_(i = 0)^(20) i nu^(i)/i! = nu pi_0 sum_(i = 1)^(19) nu^(i)/i!  = nu pi_0 sum_(i = 0)^(19) f(i; nu) e^nu = nu e^nu pi_0 F(19; nu) = nu F(19; nu)/F(20; nu).
//     $
// ]

// #pagebreak()
// #problem()[
// A tourist guide can be hired to give sightseeing tours with his boat. If the guide is free, the time it takes an interested tourist to negotiate the price is exponentially distributed with mean $1\/mu_1$. Assume that the probability that no agreement is reached and the tourist leaves is $0 < alpha < 1$. If the tourist and the guide reach an agreement, they immediately start the tour. The duration of the tour is exponentially distributed with mean $1\/mu_2$. Assume that interested tourists arrive at the harbor according to a Poisson process with rate $lambda$, but will not wait in line and leave immediately if the guide is not free. Assume further that the Poisson process, the negotiation time, the duration of the tour and whether the tourist and the guide achieve an agreement are independent.
// + Compute the long-run mean proportion of time that the guide is free.
// + You arrive at the harbor and see that the guide is currently negotating with a potential customer. Determine the expected time you would need to wait until the guide is free.
// + Determine the long-run proportion of the $lambda$ tourists that arrive per time unit that will go on a sightseeing tour.
// ]
// #solution()[
//   + Assume we have three different states: $0$ (guide is free), $1$ (guide is negotiating) and $2$ (guide is on a tour). In this case, the transition diagram is
//     #transition-figure()[
//       #transition-diagram(
//         ($0$, $1$, $2$),
//         (
//           (0, $lambda$, 0),
//           ($alpha mu_1$, 0, $(1-alpha) mu_1$),
//           ($mu_2$, 0, 0),
//         ),
//         // positions: ((0, 0), (2, 0), (4, 0)),
//         // loop-angles: (180deg, 90deg, 90deg, 0deg),
//       )
//     ]
//     The limiting distribution is the solution of
//     $
//       lambda pi_0 &= alpha mu_1 pi_1 + mu_2 pi_2, \
//       mu_1 pi_1 &= lambda pi_0, \
//     mu_2 pi_2 &= (1-alpha) mu_1 pi_1, \
//       pi_0 + pi_1 + pi_2 &= 1.
//     $
//     As $pi_1 = lambda pi_0 \/mu_1$ and $pi_2 = (1-alpha) mu_1 pi_1 \/mu_2$, we therefore have
//     $
//       pi_0 + lambda/mu_1 pi_0 + ((1-alpha) lambda)/mu_2 pi_0 = 1.
//     $
//     The proportion of time that the guide is free is therefore
//     $
//       pi_0 = (mu_1 mu_2) / (mu_1 mu_2 + lambda mu_2 + (1-alpha) lambda mu_1).
//     $
//   + If the guide is currently negotiating, they either do not reach an agreement and the guide is free afterwards, or they reach an agreement ant the guide go on a tour afterwards. We know the mean waiting time in state $1$ is $mu_1^(-1)$. If they go on a tour, the mean waiting time is $mu_2^(-1)$. The expected time until the guide is free is therefore
//     $
//       1/mu_1 + alpha dot 0 + (1-alpha) dot 1/mu_2 = 1/mu_1 + (1-alpha)/mu_2.
//     $
//   + The long-run probability that the guide if free is $pi_0$. Therefore, this is also the long-run proportion of tourists that will stop to negotiate. The probability that they end up going on the tour is $1-alpha$. Therefore, the long-run proportion of tourists that go on the sightseeing tour is $(1-alpha)pi_0$.
// ]

// #pagebreak()
// #problem()[
// Biathlon commonly refers to the winter sport that combines cross-country skiing and rifle shooting. The inhabitants of Oslo want to improve their Biathlon skills, and go to a popular skiing area to train. There is a stadium with three public shooting stands available. Skiers arrive at the shooting stands according to a Poisson process with rate $5$ skiers per minute, i.e., $lambda = 1\/12$ skier per second. If a shooting stand is free, an entering skier immediately starts to shoot and then immediately leaves the stadium when finished. If all stands are occupied, the skier waits in line and then goes to the first free shooting stand that becomes available. The time a skier spends at either of the shooting stands is independent of the other skiers and exponentially distributed with mean $30$ seconds, i.e., with rate $mu = 1\/30$ per second. Let $X(t)$ denote the number of skiers in the stadium at time $t$, i.e., skiers who are either shooting or waiting in line until a shooting stand becomes free. We assume that $X(0) = 0$.
// + Explain briefly why ${X(t) : t >= 0}$ is a birth-death process and give all birth and death rates.
// + If $X(t) = 3$, what is the expected time until all the three skiers who are currently shooting have finished shooting. 
// + Starting at time $0$, what is the expected time until $X(t) = 3$ for the first time.
// ]
// #solution()[
//   + The number of skiers in the stadium either increase with one (birth) or decrease with one (death). All times until the next arrival (birth) and termination by shooting (death) are independent and exponentially distributed. The birth rates are given by
//     $
//       lambda_i = lambda, quad n = 1, 2, dots,
//     $
//     while the death rates are given by
//     $
//     mu_1 = mu, quad mu_2 = 2 mu, quad mu_3 = 3 mu, quad mu_i = 3 mu, quad i = 4, 5, dots.
//     $
//   + If $X(t) = 3$, the expected time until all three skiers have finished shooting is the time it takes for a pure-death to reach state $0$. We know that if there are three skiers shooting, the expected time until one of them finishes is
//     $
//       min {T_1, T_2, T_3} tilde.op "Exp"(3 mu) ==> EE[min {T_1, T_2, T_3}] = 1/(3 mu),
//     $
//     and the same argument applies for the remaining two skiers and the last skier. Therefore, the expected time until all three skiers have finished shooting is
//     $
// EE[W] = 1/(3 mu) + 1/(2 mu) + 1/mu approx 55 "seconds".
//     $
//   + Let $t_(i,j)$ denote the expected time it takes before there are $j$ skiers in the stadium, given that we started with $i$ skiers in the stadium. A first step analysis gives that the expected time for going from $i$ to $i+1$ skiers equals
//     $
//       t_(i, i+1) = 1/(lambda_i + mu_i) + mu_i/(lambda_i + mu_i) t_(i-1, i+1).
//     $
//     To go from $i-1$ to $i+1$ skiers, we have $t_(i-1,i+1) = t_(i-1, i) + t_(i, i+1)$. Inserting this into the previous equation gives
//     $
//     t_(i, i+1) = 1/(lambda_i + mu_i) + mu_i/(lambda_i + mu_i) (t_(i-1, i) + t_(i, i+1)) 
//     quad ==> quad 
//     t_(i, i+1) = 1/lambda_i + mu_i/lambda_i t_(i-1, i).
//     $
//     Starting with $t_(0, 1) = 1/lambda_0 = 1/lambda = 12$, we can recursively compute
//     $
//       t_(1, 2) &= 1/lambda_1 + mu_1/lambda_1 t_(0, 1) = 16.8 \
//       t_(2, 3) &= 1/lambda_2 + mu_2/lambda_2 t_(1, 2) = 24.44,
//     $
//     giving
//     $
//       t_(0, 3) = t_(0, 1) + t_(1, 2) + t_(2, 3) = 12 + 16.8 + 24.44 approx 54.24 "seconds".
//     $
//
//
// ]

#pagebreak()
#problem()[
  Customers arrive in a store according to a Poisson process with rate $lambda=60$ customers per hour. The store has one server, and all customers in the service area are either in service or waiting in a queue. An arrival begins service immediately if the server is idle. If the server is busy, the customer joins the queue with probability $1$ when there are at most two customers in the service area. With three or more, the customer joins the queue with probability $0<p<1$, or leaves immediately with probability $1-p$. Joining decisions are independent across customers. Service times are i.i.d. exponential with mean $1\/mu=6$ minutes and are independent of the arrival process. Whenever service is completed, the customer at the front of the queue immediately begins service.

  Let $X(t)$ denote the number of customers either queuing or receiving service at time $t$.
  + Assume that time is measured in hours, and determine the birth rates and the death rates as functions of $p$. Draw the transition diagram.
  + Let $p=0.1$, and assume that there are currently three customers queuing or receiving service.
    - Calculate the probability that exactly two customers finish their service times before the next customer joins the queue.
    - Calculate the expected time until the next customer joins the queue.
  + Derive the limiting probabilities $pi_i = lim_(t -> oo) P(X(t) = i)$ for $i = 0, 1, dots$ as functions of $p$.
  + What is the necessary condition on $p$ for ${X(t): t>=0}$ to have a limiting distribution? Give an intuitive explanation for the condition.
]
#solution()[
+ The birth rates are
  $
    lambda_0 = lambda_1 = lambda_2 = lambda = 60, quad lambda_i = 60 p, quad i >= 3,
  $
  while the death rates converted to hours are $mu = 10$.
+ 
  - We need jumps $3 -> 2 -> 1 ->2$ for *exactly* two customers finish before a new customer joins. Computing using the jump probabilities, we have
    $
      P(3 -> 2 -> 1 -> 2) &= P(3 -> 2) P(2 -> 1) P(1 -> 2) \ 
  &= (mu_3/(lambda_3 + mu_3)) (mu_2/(lambda_2 + mu_2)) (lambda_1/(lambda_1 + mu_1)) \
  &= (10/(6 + 10)) (10/(60 + 10)) (60/(60 + 10)) approx 0.0765.
    $
  - Let
    $
      v_i = EE["minimum time until next customer joins queue" | X(0) = i], quad i = 0, 1, dots.
    $
    Clearly, $v_0 = v_1 = v_2 = 1\/lambda = 1\/60$. We are interested in $v_3$. A first step analysis gives
    $
  v_3 &= EE[S_3] + P(3 -> 2) v_2 + P(3 -> 4) dot 0 \
  &= 1/(lambda_3 + mu_3) + (mu_3/(lambda_3 + mu_3)) dot v_2 \
  &= 1/(6 + 10) + 10/(6 + 10) dot 1/60  approx 0.0729.
    $

+ From the formulas we have
  $
    theta_k = cases(
    1 quad &k = 0, 
    (lambda_0 dots.c lambda_(k-1))/(mu_1 dots.c mu_k) quad &k >= 1
  )
  quad "and" quad
    pi_k = cases(
    1/(sum_(i=0)^(oo)theta_i) quad &k = 0, 
    pi_0 theta_k quad &k >= 1
  ).
  $
  We see
  $
    theta_k = cases(
    (lambda / mu)^(k) quad &k <= 2, 
    (lambda / mu)^(3) ((lambda p) / mu)^(k-3) quad &k >= 3
  ).
  $
  Considering the sum of $theta_k$, we have
  $
    sum_(k=0)^(oo) theta_k &= sum_(k=0)^(2) (lambda / mu)^k + (lambda / mu)^3 sum_(k=0)^(oo) ((lambda p) / mu)^(k) \
  &= cases(
    oo quad &p >= mu / lambda,
    1 + (lambda / mu) + (lambda / mu)^2 + (lambda / mu)^3 mu/(mu - lambda p) quad &p < mu / lambda
  ),
  $
  so
  $
    pi_0 = cases(
    0 quad &p >= mu / lambda,
    (1 + (lambda / mu) + (lambda / mu)^2 + (lambda / mu)^3 mu/(mu - lambda p))^(-1) quad &p < mu / lambda
  ).
  $
+ See that if $p >= mu\/lambda$, the $pi_0 =0$ and therefore also $pi_k = theta_k pi_0 = 0$. This means that the limiting distribution does not exist. For $p < mu \/ lambda = 10 \/ 60 = 1\/6$, the limiting distribution exists. The intuition is that we have to be able to process customers faster than they arrive, which can be expressed as the death rate being larger than the birth rate $mu > lambda p$.
]


#pagebreak()
#problem()[
  Consider a CTMC
  #transition-figure()[
    #transition-diagram(
      ($0$, $1$, $2$, $3$),
      (
        (0, 1, 0, 0),
        (3, 0, 2, 0),
        (0, 4, 0, 2),
        (0, 0, 4, 0),
      ),
      positions: ((0, 0), (2, 0), (4, 0), (6, 0)),
    )
  ]
  Let $X(0) = 1$, compute the probability that we reach state $3$ before state $0$.
]
#solution()[
  First we make states $0$ and $3$ absorbing, giving
  #transition-figure()[
    #transition-diagram(
      ($0$, $1$, $2$, $3$),
      (
        (0, 0, 0, 0),
        (3, 0, 2, 0),
        (0, 4, 0, 2),
        (0, 0, 0, 0),
      ),
      positions: ((0, 0), (2, 0), (4, 0), (6, 0)),
    )
  ]
  Moving form a CTMC to a DTMC ${Y_n: n = 0, 1, dots}$ with transition probability matrix $bf(P)$. By @thm:absorption-probabilities-birth-and-death-process, we have
  $
    bf(P) = mat(
      0, 1, 0, 0;
      3/5, 0, 2/5, 0;
      0, 4/6, 0, 2/6;
      0, 0, 0, 1
    ).
  $
  and the diagram
  #transition-figure()[
    #transition-diagram(
      ($0$, $1$, $2$, $3$),
      (
        (1, 0, 0, 0),
        ($3\/5$, 0, $2\/5$, 0),
        (0, $4\/6$, 0, $2\/6$),
        (0, 0, 0, 1),
      ),
      positions: ((0, 0), (2, 0), (4, 0), (6, 0)),
      loop-angles: (180deg, 90deg, 90deg, 0deg),
    )
  ]

  Letting
  $
    u_i = P{"absorption in 3" | Y_0 = i}, quad i = 0, 1, 2, 3,
  $
  we by first-step analysis see
  $
    u_0 & = 0, \
    u_3 & = 1, \
    u_1 & = P_(1, 0) u_0 + P_(1, 2) u_2 = 2/5 u_2, \
    u_2 & = P_(2, 1) u_1 + P_(2, 3) u_3 = 2/3 u_1 + 1/3.
  $
  Solving this system we find $u_1 = 2\/11$ (and $u_2 = 5\/11$).
]

