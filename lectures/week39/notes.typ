#import "../templates/tma4265-notes.typ": *
#import "@preview/muchpdf:0.1.2": muchpdf

#import "@preview/lemmify:0.1.7": default-theorems, new-theorems, thm-numbering-heading
#show figure.where(kind: "solution-group"): set block(breakable: true)

#import "../utils.typ": transition-diagram, transition-figure


#show link: set text(fill: blue)


#show: icml.with(
  title: [
    Week 39: Continuous-time Markov Chains
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

Recall that we previously have worked with discrete-time Markov chains, where the stochastic process is indexed by discrete time steps $t = 0, 1, dots$. We can generalize this to continuous time, meaning the time $t$ can take any value in $[0, oo)$. Note that we still have a discrete state space $cal(S)$.

#definition(name: [Continuous-time Markov Chain])[
  A continuous-time Markov Chain (CTMC) is a stochastic process ${X(t): t >= 0}$ with discrete state space $cal(S)$ that satisfies the Markov property.

  Remarks: For all $s >= 0$, $t > 0$, and $i,j in cal(S)$, we have
  - Markov property:
    $
      P(X(s+t) = j | X(s) = i, X(u) = x(u), 0 <= u < s) = P(X(t+s) = j | X(s) = i).
    $
  - Stationary transition probabilities: $ P(X(s+t) = j | X(s) = i) = P(X(t) = j | X(0) = i). $
  // - In this course, we assume CTMC $=$ "Stationary" $+$ $cal(S) = {0, 1, 2, dots}$ unless otherwise stated.
]


#definition(name: [Transition probability functions])[
  Let ${X(t): t>=0}$ be a CTMC with state space $cal(S)$. We call
  $
    P_(i,j)(t) = P(X(t) = j | X(0) = i), quad t >= 0, quad i,j in cal(S)
  $
  the transition probability functions.
]


#theorem(name: [Chapman-Kolmogorov])[
  For a CTMC,
  $
    P_(i,j)(s+t) = sum_(k=0)^(oo) P_(i,k)(s) P_(k,j)(t)
  $
  for all $t,s>=0$ and $i,j = 0, 1, dots$.
]
#proof()[
  By the law of total probability
  $
    P_(i,j)(s+t) & = P(X(s+t) = j | X(0) = i) \
                 & = sum_(k = 0)^(oo) P(X(s) = k | X(0) = i) P(X(s+t) = j | X(s) = k, X(0) = i) \
                 & = sum_(k = 0)^(oo) P_(i,k)(s) P_(k,j)(t)
  $
]

// #example()[
//   Derive $P_(i,j)(t)$ for a Poisson process ${X(t): t>=0}$ with rate $lambda$.
// ]
// #solution()[
//   See that
//   $
//     P_(i,j)(t) & = P(X(t) = j | X(0) = i) \
//                & = P(X(t) - X(0) = j-i) \
//                & = cases(
//                    (lambda t)^(j-i) / (j-i)! e^(-lambda t) quad & j >= i,
//                    0 quad & "otherwise"
//                  )
//   $
// ]



#definition(name: [Birth-and-death process])[
  Let ${X(t): t>=0}$ be a CTMC with state space $cal(S) = {0, 1, 2, dots}$. Then ${X(t): t>=0}$ is called a birth-and-death with birth rates $lambda_i$ and death rates $mu_i$ if $P_(i,j)(t)$ satisfies
  + $P_(i, i+1)(h) = lambda_i h + "o"(h)$ as $h -> 0^+$ for $i>=0$.
  + $P_(i, i-1)(h) = mu_i h + "o"(h)$ as $h -> 0^+$ for $i>=1$.
  + $P_(i, i)(h) = 1 - (lambda_i + mu_i)h + "o"(h)$ as $h -> 0^+$ for $i>=0$.
  + $P_(i, i)(0) = delta_(i, j)$.
  + $mu_0 = 0$, $lambda_0 > 0$, and $lambda_i, mu_i > 0$ for $i>=1$.

  Remarks:
  - At most two possible jumps: $i -> i+1$ and $i -> i-1$.
  - Birth and death rates are called transition rates.
  - The definition of the little-$o$ notation: We write $f(x) = o(g(x))$ is for every $c>0$, there exists a value $k > 0$ such that
    $
      |f(x)| < c|g(x)|, quad "for all" x >= k.
    $
]

// #definition(name: [Infinitesimal generator matrix])[
//   For a birth-and-death process with birth rates $lambda_i$ and death rates $mu_i$, the infinitesimal generator matrix $bf(A)$ is defined as
//   $
//     bf(A) = mat(
//       -lambda_0, lambda_0, 0, 0, dots.c;
//       mu_1, -(lambda_1 + mu_1), lambda_1, 0, dots.c;
//       0, mu_2, -(lambda_2 + mu_2), lambda_2, dots.c;
//       0, 0, mu_3, -(lambda_3 + mu_3), dots.c;
//       dots.v, dots.v, dots.v, dots.v, ;
//     ).
//   $
// ]

#definition(name: [Pure birth and pure death processes])[
  - Pure birth process: $mu_i = 0$ for all $i>=0$.
  - Pure death process: $lambda_i = 0$ for all $i>=1$.
]




// Informally, recall that the sojourn time $S_i$ in state $i$ is the time spent in state $i$ before jumping to another state.

// #theorem(name: [Exponentially distributed sojourn times])[
//   - In a pure birth process with $lambda_i>0$ for all $i>=0$, the sojourn times are independent and $S_i tilde.op "Exp"(lambda_i)$.
//   - In a pure death process with starting state $N$ and where $mu_i > 0$ for $i = 1, dots, N$, the sojourn times are independent and $S_i tilde.op "Exp"(mu_i)$ for $i = 1, dots, N$.
// ]




#theorem()[
  In a birth-and-death process with birth rates $lambda_i$ and death rates $mu_i$, the following holds:
  - Independent sojourn times.
  - $S_i tilde.op "Exp"(lambda_i + mu_i)$ for $i>=0$.
  - Jump probabilities in state $i$ are
    $
      P(i -> i-1) = mu_i / (lambda_i + mu_i) quad "and" quad P(i -> i+1) = lambda_i / (lambda_i + mu_i).
    $

  // Remark:
  // - This is also valid for a finite state space $cal(S) = {0, 1, dots, N}$ and $lambda_N = 0$.
  - Here we use the term jump probability from state $i$ to state $j$ to denote the probability that the next transition in state $i$ will be to state $j$.
]


#definition(name: [Alternative definition of birth-and-death processes])[
  The birth and death process with birth rates $lambda_i$ and death rates $mu_i$ can be constructed in the following way.

  In each state $i$, there are two independent competing processes
  - $T_1 = "Time until birth" tilde.op "Exp"(lambda_i)$
  - $T_2 = "Time until death" tilde.op "Exp"(mu_i)$



  If $T_1 < T_2$ then $i -> i+1$ (birth), else $i -> i-1$ (death), meaning
  - Sojourn time $S_i = min{T_1, T_2} tilde.op "Exp"(lambda_i + mu_i)$

  // Remark: $P(T_1 < T_2) = lambda_i\/(lambda_i + mu_i)$ and $S_i = min{T_1, T_2} tilde.op "Exp"(lambda_i + mu_i)$.
]

#theorem()[
  If $T_i tilde.op "Exp"(alpha_i)$ for $i = 1, dots, n$, and $T_1, dots, T_n$ are independent, then
  $
    min(T_1, dots, T_n) tilde.op "Exp"(sum_(i=1)^n alpha_i).
  $
]<thm:min_of_exponentials>

#theorem()[
  $T tilde.op "Exp"(lambda)$ is memoryless, meaning $P(T > s+t | T > s) = P(T > t)$ for all $s,t >= 0$.
]


#example()[
  Consider a pure birth process with $lambda_0 != lambda_i$. Derive $P_(0, 1)(t)$
]
#solution()[
  Using Chapman-Kolmogorov, we have
  $
    P_(0, 1)(t+h) & = P_(0, 0)(t) P_(0, 1)(h) + P_(0, 1)(t) P_(1, 1)(h) \
                  & = P_(0, 0)(t) [lambda_0 h + "o"(h)] + P_(0, 1)(t) [1 - lambda_1 h + "o"(h)] \
  $
  Now, rearranging and dividing by $h$ gives
  $
    P_(0, 1)^' (t) & = lim_(h -> 0^+) (P_(0, 1)(t+h) - P_(0, 1)(t)) / h \
                   & = lim_(h -> 0^+) (P_(0, 0)(t) [lambda_0 + o(1)] + P_(0, 1)(t)[-lambda_1 + o(1)]) \
                   & = lambda_0 P_(0, 0)(t) - lambda_1 P_(0, 1)(t), quad t >= 0.
  $
  We know that $P_(0,1)(0) = 0$, and due to exponential sojourn times that $P_(0,0)(t) = e^(-lambda_0 t)$. Therefore have the differential equation
  $
    P_(0, 1)^' (t) + lambda_1 P_(0, 1)(t) & = lambda_0 e^(-lambda_0 t), quad t >= 0, \
                              P_(0, 1)(0) & = 0.
  $
  We can solve using an integrating factor. Recall that for a general
  $
    (dif y)/(dif x) + P(x) y = Q(x)
  $
  we multiply each side by $mu(x) = exp(integral P(x) dif x)$ and use the product rule. In our case we have the integrating factor $e^(lambda_1 t)$, and find
  $
    e^(lambda_1 t) (dif/(dif t) P_(0, 1)(t) + lambda_1 P_(0, 1)(t)) & = lambda_0 e^(lambda_1 t) e^(-lambda_0 t) \
    ==> dif/(dif t) (e^(lambda_1 t) P_(0, 1)(t)) & = lambda_0 e^((lambda_1 - lambda_0) t) \
    ==> e^(lambda_1 t) P_(0, 1)(t) & = integral_0^t lambda_0 e^((lambda_1 - lambda_0) tau) dif tau + C=lambda_0 / (lambda_1 - lambda_0) (e^((lambda_1 - lambda_0) t) - 1) + C \
    ==> P_(0, 1)(t) & = lambda_0 / (lambda_1 - lambda_0) (e^(-lambda_0 t) - e^(-lambda_1 t)) + C e^(-lambda_1 t).
  $
  Using the initial condition $P_(0, 1)(0) = 0$ gives $C = 0$.

]

#theorem(name: [Forward Kolmogorov differential equations])[
  // Under suitable regularity conditions
  $
    P_(i,0)^' (t) &= -lambda_0 P_(i,0)(t) + mu_1 P_(i,1)(t), quad t >= 0 \
    P_(i,j)^' (t) &= lambda_(j-1) P_(i,j-1)(t) - (lambda_j + mu_j) P_(i,j)(t) + mu_(j+1) P_(i,j+1)(t), quad t >= 0, quad j >= 1,
  $
  with initial conditions $P_(i,j)(0) = delta_(i,j)$.

]

Recall:
- $y^' (x) = a y(x) ==> y(x) = C e^(a x)$. - From this we can also derive $y^' (x) = a y(x) + b ==> y(x) = C e^(a x) - b\/a$.
- It might also be useful to remember that for a two-state CTMC with rates $(alpha, beta)$, then letting ...


#pagebreak()
#problem()[
  Show that the Poisson process ${X(t): t>=0}$ with rate $lambda$ satisfies the Markov property.
]
#solution()[
  The Poisson process has a discrete state space $cal(S) = {0, 1, 2, dots}$. For all $s>=0$, $t>0$ and $i,j in cal(S)$, see
  $
    P(X(s+t) = j | X(s) = i, X(u) = x(u), 0 <= u < s) & = P(X(s+t) - X(s) = j-i) \
                                                      & = P(X(s + t) = j | X(s) = i).
  $

]


#pagebreak()
#problem()[
  Consider the birth-and-death process with $cal(S) = {0, 1, 2}$, birth rates $lambda_0 = 5$, $lambda_1 = 4$ and $lambda_2 = 0$, and death rates $mu_1 = 3$ and $mu_2 = 7$.
  + Draw the transition diagram.
  + Calculate expected sojourn times.
  + Calculate the probability that state $2$ follows state $1$.
  + Assume $X(0) = 0$. Calculate the probability that two consecutive births occur.
]
#solution()[
  + The transition diagram is
    #transition-figure()[
      #transition-diagram(
        ($0$, $0$, $2$),
        (
          (0, 5, 0),
          (3, 0, 4),
          (0, 7, 0),
        ),
        positions: ((0, 0), (2, 0), (4, 0)),
        loop-angles: (180deg, 90deg, 0deg),
      )
    ]
  + We use that the sojourn times are exponentially distributed with rate $lambda_i + mu_i$. Thus
    $
      EE[S_0] & = 1\/lambda_0 = 1\/5, \
      EE[S_1] & = 1\/(lambda_1 + mu_1) = 1\/(4 + 3) = 1\/7, \
      EE[S_2] & = 1\/mu_2 = 1\/7.
    $
  + By the jump probabilities, we have
    $
      P(1 -> 2) = lambda_1 / (lambda_1 + mu_1) = 4/7.
    $
  + Using the Markov property, we have
    $
      P(0 -> 1 -> 2) = P(0 -> 1) P(1 -> 2) = lambda_0 / (lambda_0 + mu_0) dot lambda_1 / (lambda_1 + mu_1) = 5/5 dot 4/7 = 4/7.
    $
]



#pagebreak()
#problem(name: [Problem 2, Exercise 6])[
  A parking garage opens at 08:00 and closes at 16:00. We model the arrival of cars to the parking garage during opening hours as a Poisson process with rate $lambda = 0.5 "cars"\/"min"$. For now, assume that the garage has room for infinitely many cars.
  +
    - Calculate the probability that no car has arrived at 08:05.
    - Compute the expected number of cars that will arrive during the first 15 minutes of opening hours.
    - Given that two cars will arrive during the first 10 minutes, compute the probability that no cars arrive during the first 5 minutes.
  + Customers spend on average 100 kr for parking, independently of each other, with standard deviation of 10 kr.
    - Calculate the expected value of the total income at the garage during one day.
    - Calculate the variance of the total income at the garage during one day.
  Assume additionally that cars, independently of each other and their arrival times, spend a stochastic time in the parking garage, which follows an exponential distribution with expectation $1\/mu = 30 "minutes"$. After the time has passed, the car immediately exists the parking garage. Further, the parking garage has a maximum capacity of $N_max = 20 "cars"$, and cars that arrive when the garage is full will drive past the garage without forming a queue. Under these assumptions, the number of cars $X(t)$ in the garage at time t is a birth-and-death process.
  +
    - Determine the birth and death rates of the process.
    - Draw a transition diagram for the process.
    - Two cars are in the parking garage at 16:00, and no new cars may enter. The two cars will leave according to the rates described above. Let T be the time until the parking garage is empty, and determine the probability density, $f_T (t)$.
  + Ignore the opening hours and assume that the parking garage is always open. There are currently 16 cars in the parking garage.
    - Determine the distribution of the time until the number of cars in the garage changes.
    - Calculate the probability that the next time the number of cars in the garage changes, it will be a car that leaves.
]
#solution()[
  +
    - Let $N(t)$ denote the number of cars that have arrived at the parking garage by time $t$. We see
      $
        P(N(5) = 0) = e^(-0.5 dot 5) (0.5 dot 5)^0 / 0! = e^(-5\/2).
      $
    - Using the properties of a Poisson process, we have
      $
        EE[N(15)] = 0.5 dot 15 = 7.5.
      $
    -
      $
        P(N(5) = 0 | N(10) = 2) & = (P(N(10) = 2 | N(5) = 0) P(N(5) = 0)) / P(N(10) = 2) \
                                & = (P(N(10) - N(5) = 2) P(N(5) = 0)) / P(N(10) = 2) \
                                & = 0.25.
      $
  +
    - Let $C_i$ be the amount of money spent by the $i$-th customer, and $X$ be the total amount paid by all $N(t)$ customers. I.e.
      $
        X(t) = sum_(i=1)^(N(t)) C_i.
      $
      For the entire day ($8$ hours), the time in minutes is $t = 8 dot 60 = 480$ minutes. Using the law of total expectation, we see $EE[X] = EE[EE[X | N(480)]]$. We have
    $
      EE[X|N] = EE[C_1 + dots + C_(N)] = N dot EE[C_i] = 100 N,
    $
    and inserting numbers we see
    $
      EE[X] = E[100 N(480)] = 100 dot 480 dot lambda = 24 000.
    $
  - By the law of total variance
    $
      "Var"[X] = EE["Var"[X|N]] + "Var"[EE[X|N]].
    $
    As previously, $"Var"[X|N] = N dot"Var"[C_i] = 10^(2) N$, so
    $
      EE["Var"[X|N]] = 100 EE[N] = 100 dot 480 dot 0.5 = 24000.
    $
    Since $EE[X|N] = 100 N$, we get
    $
      "Var"[EE[X|N]] = 100^(2) "Var"[N] = 10000 dot 480 dot 0.5 = 2 400 000.
    $
    This gives the total variance $"Var"[X] = 2424000 "kr"^(2)$.


  We now move on to assuming the stochastic parking time
  +
    - We can model the arrivals as a Poisson process with intensity $lambda_i = lambda$ for $i = 0, dots, N_max$. The departures are also run by the Poisson process, but the death rate will depend on the number of cars currently in the garage. We are informed that the sojourn times for each individual car is $U_i tilde.op"Exp"(mu)$. When there are $k$ cars in the garage, the combined sojourn time until a car leaves is
      $
        min(U_1, dots, U_k) tilde.op "Exp"(sum_(i=1)^(k) mu) = "Exp"(k mu).
      $
      Thus, the birth and death rates are $lambda$ and $mu_k = k mu$ for $k = 1, dots, N_max$.
  // - $T$ describes the waiting time until the last car leaves. F.ex. when there are $2$ cars in the garage, we have
  //   $
  //     T = T_1 + T_2, quad T_i tilde.op^("iid") "Exp"(i mu).
  //   $
  //   For this we use a convolution formula. We do not provide a proof, but can be derived by formulating $F_T (t) = P(T_1 + T_2 < t)$ as an integral and differentiating. We havve
  //   $
  //     f_T (t) & = integral_0^t f_(T_1)(x) f_(T_2)(t-x) dif x \
  //             & = integral_0^t mu e^(-mu x) 2 mu e^(-2 mu (t-x)) dif x \
  //             & = 2 mu (e^(-mu t) - e^(-2 mu t))
  //   $
  +
    - For a birth-and-death process, the sojourn time in state $i$ is $"Exp"(lambda_i + mu_i)$. Given that there are $16$ cars in the garage, the time until the number of cars changes is then an exponentially distributed
    $
      S_16 tilde.op "Exp"(lambda_16 + mu_16) = "Exp"(0.5 + 16/30) = "Exp"(0.91).
    $
    - Using the formula for the jump probabilities, we have
      $
        P(16 -> 15) = mu_16 / (lambda_16 + mu_16) = (16\/30) / (0.5 + 16\/30).
      $
]


#pagebreak()
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
    P_(1, 1)(t) + mu P_(1, 1)(t) = lambda [1 - P_(1, 1)(t)]
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
    We can solve this using an integrating factor. In this case, the integrating factor is $e^(integral_0^t lambda_1 dif tau) = e^(lambda_t t)$, and we have
    $
      e^(lambda_1 t) (dif/(dif t) P_1 (t) + lambda_1 P_1 (t)) &= dif/(dif t) (e^(lambda_1 t) P_1 (t)) = e^(lambda_1 t) e^(-t) = e^((lambda_1 - 1) t) \
      ==> e^(lambda_1 t) P_1 (t) &= integral_0^t e^((lambda_1 - 1) tau) dif tau = 1/(lambda_1 - 1) (e^((lambda_1 - 1) t) - 1) \
      ==> P_1 (t) &= 1/(lambda_1 - 1) (e^(-t) - e^(-lambda_1 t)) = 1/2 (e^(-t) - e^(-3 t)).
    $
    Similar calculations can be used to find $P_2 (t)$ and $P_3 (t)$, or we can utilize Equation (6.5) in the book.
  + Letting $S_0$, $S_1$ and $S_2$ be the sojourn times, we want to estimate $W_3 = S_0 + S_1 + S_2$. As $S_i tilde.op "Exp"(lambda_i)$ and using the linearity of the expectation
    $
      EE[W_3] = sum_(i = 0)^(2) EE[S_i] = 1/lambda_0 + 1/lambda_1 + 1/lambda_2 = 1 + 1/3 + 1/2 = 11/6.
    $
  + Since the variables are independent, we have
    $
      "Var"[W_3] = sum_(i=0)^(2) "Var"[S_i] = 1/lambda_0^2 + 1/lambda_1^2 + 1/lambda_2^2 = 1 + 1/9 + 1/4.
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
    + The student is either focused $1$ or unfocused $0$. To stay in a state or to jump depends on the current state, and sojourn times are exponentially distributed with means $5$ and $1$ minutes, respectively.
    // + As $EE[S_1] = 5 = 1\/mu_0$ and $EE[S_0] = 1 = 1\/lambda_0$, we have $mu_0 = 1\/5$ and $lambda_0 = 1$. Using the definition of $bf(A)$ gives
    //   $
    //     A = mat(
    //       -lambda_0, lambda_0;
    //       mu_1, - mu_1
    //     ) = mat(
    //       -1, 1;
    //       1\/5, -1\/5
    //     )
    //   $
    + We are interested in $P_(1, 1)(10)$. Dentote $p(t) = P_(1, 1)(t)$. By the forward Kolmogorov differential equations and using $P_(1,0)(t) = 1-p(t)$, we have
      $
        p^' (t) = lambda_0 (1 - p(t)) - mu_1 p(t) = 1 - p(t) - 1/5 p(t) = 1 - 6/5 p(t)
      $
      with initial condition $p(0) = 1$. Solving this differential equation and inserting $t=10$ gives
      $
        P_(1, 1)(10) = 1/6 e^(-12) + 5/6 approx 0.8333.
      $
  -
    + With $40$ independent copies, the next jump time is the minimum of independent exponentials, which we know from @thm:min_of_exponentials is also exponentially distributed. When $Z = k$, we have the jumps $k -> k-1$ (a student loses focus) and $k -> k+1$ (a student gains focus). $Z$ is a birth-and-death CTMC on ${0, dots, n}$, with birth rates $lambda_k = (n-k)$ and death rates $mu_k = k\/5$.
    + Assuming $k$ students are focused, we have
      $
        P_(k,k)^' (t) & = lambda_(k-1) P_(k,k-1)(t) - (lambda_k + mu_k) P_(k,k)(t) + mu_(k+1) P_(k,k+1)(t) \
                      & = (41 - k) P_(k,k-1)(t) - (40-k + k/5) P_(k,k)(t) + ((k+1)/5) P_(k,k+1)(t).
      $
    + We are interested in $EE[Z((10)) | X_i (0) = 1, i=1,dots,40] = sum_(i=1)^40 EE[X_i (10)| X_i (0) = 1]$ by the linearity of the expectation and independence. As $X_i (t) in {0, 1}$, we have that
      $
        EE[X_i (10) | X_i (0) = 1] = P(X_i (10) = 1 | X_i (0) = 1) = P_(1, 1)(10) = 1/6 e^(-12) + 5/6.
      $
      Therefore
      $
        EE[Z((10)) | X_i (0) = 1, i=1,dots,40] = 40 (1/6 e^(-12) + 5/6) approx 33.33.
      $

]
