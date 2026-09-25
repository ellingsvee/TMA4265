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


= Theory

#theorem()[
  For a birth-and-death process without absorbing states,
  $
    pi_j = lim_(t->oo) P_(i, j)(t), quad j = 0, 1, dots,
  $
  exists and are not dependent on $i$.

  Remark:
  - $pi_j = 0$ for $j = 0, 1, dots$ is possible.
  - If $sum_(j = 0)^(oo) pi_j = 1$, the $bold(pi) = (pi_0, pi_1, dots)^top$is called the limiting distribution.
  - If the limiting distribution exists, it is a stationary distribution. We can see this since
    $
      pi_j = lim_(s->oo) P_(i, j)(s+t) = lim_(s->oo) sum_(k = 0)^(oo) P_(i, k)(s) P_(k, j)(t) = sum_(k = 0)^(oo) pi_k P_(k, j)(t), quad j = 0, 1, dots, quad t>=0.
    $
]
#theorem()[
  When the limiting distribution $bold(pi)$ exists, it is the unique solution to
  $
             lambda_0 pi_0 & = mu_1 pi_1, \
    (lambda_j + mu_j) pi_j & = lambda_(j-1) pi_(j-1) + mu_(j+1) pi_(j+1), quad j >= 1, \
     sum_(j = 0)^(oo) pi_j & = 1.
  $

  Remark: This is quite intuitive, as "Rate in = Rate out" with "Rate" being the number of events per unit time.
  - "Rate in" $= pi_(i-1) lambda_(i-1) + pi_(i+1)mu_(i+1)$. Here $pi_(i-1)$ is the proportion of time in state $i-1$, and $lambda(i-1)$ is the rate of leaving state $i-1$ to state $i$.
]

#theorem()[
  For a birth-and-death process without absorbing states, we have
  $
    pi_i = theta_i / (sum_(k = 0)^(oo) theta_k), quad i = 0, 1, dots,
  $
  where $theta_0 = 1$ and
  $
    theta_i = lambda_0 / mu_1 dot lambda_1 / mu_2 dot dots dot lambda_(i-1) / mu_i, quad i = 1, 2, dots.
  $
]

#example()[
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
    pi_0 & = theta_0 / (sum_(k = 0)^(2) theta_k) = 4 / 9, \
    pi_1 & = theta_1 / (sum_(k = 0)^(2) theta_k) = 1/4 dot 4/9 = 1/9, \
    pi_2 & = theta_2 / (sum_(k = 0)^(2) theta_k) = 1 dot 4/9 = 4/9.
  $
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
]

#theorem()[
  For a birth-and-death process ${X(t): t >= 0}$ with state space $cal(S)$, let $A subset cal(S)$ and let
  $
    v_i = EE[min {t >= 0: X(t) in A} | X(0) = i], quad i in cal(S).
  $
  If there are no absorbing states outside $A$ (i.e. in $cal(S)\\A$), the expected times can be found by solving
  $
    v_i = 0, quad i in A, \
    v_i = EE[S_i] + sum_(j != i) P(i -> j) v_j = 1/(lambda_i + mu_i) + sum_(j != i) P(i -> j) v_j, quad i in.not A.
  $

  Remark:
  - Similarly, for DTMC we had $v_i = 1 + sum_(j in cal(S)) P_(i,k) v_k$ for $i in.not A$. Do not mix these two equations!
]



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
    where the initial conditions are $P_0 (0) = 1$ and $P_n (0) = 0$ for $n = 1, 2, 3$. For state $0$, we have the general solution $P_0 (t) = C e^(-lambda_0 t)$, and using the initial condition gives $P_0 (t) = e^(-t)$. For state $1$, we have
    $
      P_1^' (t) + lambda_1 P_1 (t) = lambda_0 P_0 (t) = e^(-t).
    $
    We can solve this using an integrating factor. In this case, the integrating factor is $e^(integral_0^t lambda_1 dif tau) = e^(lambda_1 t)$, and we have
    $
      e^(lambda_1 t) (dif/(dif t) P_1 (t) + lambda_1 P_1 (t)) &= dif/(dif t) (e^(lambda_1 t) P_1 (t)) = e^(lambda_1 t) e^(-t) = e^((lambda_1 - 1) t) \
      ==> e^(lambda_1 t) P_1 (t) &= integral_0^t e^((lambda_1 - 1) tau) dif tau = 1/(lambda_1 - 1) (e^((lambda_1 - 1) t) - 1) \
      ==> P_1 (t) &= 1/(lambda_1 - 1) (e^(-t) - e^(-lambda_1 t)) = 1/2 (e^(-t) - e^(-3 t)).
    $
    Applying the same method to the remaining equations gives
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

#pagebreak()
#problem(name: [Exam 2025, Problem 3])[
  A student at a lecture is at any time either focusing on the lecture or not. Assume that the expected length of the focused periods is $5$ minutes and that the expected length of the unfocused periods is $1$ minute.
  -
    + Explain that a (simplified) model of the student is as a two-state continuous time Markov chain X with state space ${0, 1}$.
    + Determine the infinitesimal matrix $A$ of $X$.
    + Assume the student is focused at the start of the lecture. What is the probability of the student being focused $10$ minutes later?
  Assume that a group of $n = 40$ students is modeled identically as above by $X_1, dots, X_n$ independent two-state continuous Markov chains.
  -
    + Prove that $Z = X_1 + dots + X_n$ is a Markov chain.
    + Determine a differential equation for the probability distribution of $Z$.
    + Assume all students are focused at the beginning of the lecture. What is the expected number of focused students $10$ minutes later?
]
#solution()[
  -
    + The student is either focused ($1$) or unfocused ($0$). We model the focused and unfocused periods as independent exponential sojourn times with means $5$ and $1$ minutes, respectively. With this modeling assumption, the future evolution depends only on the current state, so $X$ is a two-state CTMC.
    + As $EE[S_1] = 5 = 1\/mu_1$ and $EE[S_0] = 1 = 1\/lambda_0$, we have $mu_1 = 1\/5$ and $lambda_0 = 1$. Therefore,
      $
        A = mat(
          -lambda_0, lambda_0;
          mu_1, -mu_1
        ) = mat(
          -1, 1;
          1\/5, -1\/5
        ).
      $
    + We are interested in $P_(1, 1)(10)$. Denote $p(t) = P_(1, 1)(t)$. By the forward Kolmogorov differential equations and using $P_(1,0)(t) = 1-p(t)$, we have
      $
        p^' (t) = lambda_0 (1 - p(t)) - mu_1 p(t) = 1 - p(t) - 1/5 p(t) = 1 - 6/5 p(t)
      $
      with initial condition $p(0) = 1$. Solving this differential equation and inserting $t=10$ gives
      $
        P_(1, 1)(10) = 1/6 e^(-12) + 5/6 approx 0.8333.
      $
  -
    + Since the individual chains are independent, their joint process is a CTMC. When $Z=k$, exactly $k$ students can lose focus, each at rate $1\/5$, and $n-k$ students can gain focus, each at rate $1$. Thus, the transition rates depend on the joint state only through $Z$. It follows that $Z$ is a birth-and-death CTMC on ${0, dots, n}$, with birth rates $lambda_k=n-k$ and death rates $mu_k=k\/5$.
    + Let $q_k(t)=P(Z(t)=k)$. For $k=0,dots,40$, the forward equations are
      $
        q_k^'(t) = (41-k)q_(k-1)(t) - (40-k+k/5)q_k(t) + (k+1)/5 q_(k+1)(t),
      $
      where terms with indices outside ${0,dots,40}$ are omitted. If all students are initially focused, $q_40(0)=1$ and $q_k(0)=0$ for $k != 40$.
    + We are interested in $EE[Z(10) | X_i(0) = 1, i=1,dots,40] = sum_(i=1)^40 EE[X_i(10)| X_i(0) = 1]$ by linearity of expectation. As $X_i(t) in {0, 1}$, we have
      $
        EE[X_i (10) | X_i (0) = 1] = P(X_i (10) = 1 | X_i (0) = 1) = P_(1, 1)(10) = 1/6 e^(-12) + 5/6.
      $
      Therefore
      $
        EE[Z(10) | X_i(0) = 1, i=1,dots,40] = 40 (1/6 e^(-12) + 5/6) approx 33.33.
      $

]

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
  Moving form a CTMC to a DTMC ${Y_n: n = 0, 1, dots}$ with transition probability matrix $bf(Q)$, we see
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
  we have
  $
    u_0 & = 0 \
    u_1 & = Q_(1, 0) u_0 + Q_(1, 2) u_2 = 2/5 u_2 \
    u_2 & = Q_(2, 1) u_1 + Q_(2, 3) u_3 = 2/3 u_1 + 1/3 \
    u_3 & = 1.
  $
  Solving this system we find $u_1 = 2\/11$ (and $u_2 = 5\/11$).
]


#pagebreak()
#problem()[
  Consider a CTMC
  #transition-figure()[
    #transition-diagram(
      ($0$, $1$, $2$),
      (
        (0, 1, 0),
        (2, 0, 1),
        (0, 2, 0),
      ),
      positions: ((0, 0), (2, 0), (4, 0)),
    )
  ]
  For $X(0) = 0$, compute the expected time to reach state $2$.
]
#solution()[
  For the birth-and-death process ${X(t): t>=0}$, we have
  $
    v_i = EE[min {t >= 0: X(t) = 2} | X(0) = 0], quad i = 0, 1, 2.
  $
  We have
  $
    v_2 & = 0, \
    v_1 & = 1/(lambda_1 + mu_1) + lambda_1/(lambda_1 + mu_1) v_2 + mu_1/(lambda_1 + mu_1) v_0 \
        & = 1/3 + 2/3 v_0, \
  v_0 & = 1/lambda_0 + v_1 = 1 + v_1.
  $
  Solving this system we find
  $
    v_0 = 1 + v_1 = 1 + 1/3 + 2/3 v_0 
  quad ==> quad v_0 = 4.
  $
]
