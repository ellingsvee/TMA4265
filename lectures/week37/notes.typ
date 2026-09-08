#import "../templates/tma4265-notes.typ": *
#import "@preview/muchpdf:0.1.2": muchpdf

#import "@preview/lemmify:0.1.7": default-theorems, new-theorems, thm-numbering-heading
#show figure.where(kind: "solution-group"): set block(breakable: true)

#import "@preview/fletcher:0.5.8" as fletcher: diagram, edge, node

#import "../utils.typ": transition-diagram, transition-figure

#show link: set text(fill: blue)


#show: icml.with(
  title: [
    Week 37: More on long Run Behavior of Markov Chains
  ],

  authors: (
    (
      name: "Elling Svee (elling.svee@ntnu.no)",
    ),
  ),
  n_columns: 1,
  paper-size: "a4",
  bibliography: bibliography("../refs.bib"),
)

#show figure.where(kind: "solution-group"): set block(breakable: true)

#let bf(x) = math.bold(math.upright(x))


_These notes are written by myself, and errors may and will occur. When in doubt, trust the book and Gunnars lectures!_


= Theory

Last week we focused a lot on _regularity_ of Markov chains, and saw that this property is useful for proving convergence. However, regularity can fail due to things like periodicity, reducibility and transient states. We also want to extent regularity to infinite state spaces.



#definition(name: [Communication])[
  Let ${X_t: t = 0, 1, dots}$ be a Markov chain with transition probability matrix $bf(P)$.
  - State $j$ is _accessible_ from state $i$ if there exists an integer $n >= 0$ such that $P_(i,j)^((n)) > 0$.
  - If states $i$ and $j$ are accessible from each other, they _communicate_. We write this as $i tilde.op j$.
]

#example()[
  In the first scenario, $"B"$ is accessible from $"A"$, but $"A"$ is not accessible from $"B"$. Therefore $"A" tilde.not "B"$. In the second scenario, $"A"$ and $"B"$ are accessible from each other, so $"A" tilde.op "B"$.

  #subpar.grid(
    figure(
      transition-diagram(
        ($"A"$, $"B"$),
        (
          ($1\/2$, $1\/2$),
          (0, 1),
        ),
      ),
    ),
    figure(
      transition-diagram(
        ($"A"$, $"B"$),
        (
          ($1\/2$, $1\/2$),
          ($1\/2$, $1\/2$),
        ),
      ),
    ),

    columns: (auto, auto),
    kind: "transition-diagram",
    supplement: [Figure],
  )
]

#theorem(name: [Communication is an equivalence relation])[
  Communication is an equivalence relation:
  - Reflexivity: $i tilde.op i$ for every state $i$.
    - This is since $P_(i,j)^((0)) = delta_(i,j)$.
  - Symmetry: if $i tilde.op j$, then $j tilde.op i$.
  - Transitivity: if $i tilde.op j$ and $j tilde.op k$, then $i tilde.op k$.
    - This is since if $P_(i,j)^((n)) > 0$ and $P_(j,k)^((m)) > 0$, then $P_(i,k)^((n+m)) = sum_(l=0)^(oo) P_(i,l)^((n)) P_(l,k)^((m)) >= P_(i,j)^((n)) P_(j,k)^((m)) > 0$.

  It therefore partitions the state space into _equivalence classes_ of communicating states.
]

#example()[
  Consider the Markov chain with transition probability matrix
  $
    bf(A) = mat(
      0, 1, 0, 0;
      1, 0, 0, 0;
      0, 0, 1\/2, 1\/2;
      0, 0, 1\/2, 1\/2;
    )
    quad "and" quad
    bf(B) = mat(
      0, 1, 0, 0;
      1\/2, 0, 1\/2, 0;
      0, 0, 1\/2, 1\/2;
      0, 0, 1\/2, 1\/2;
    )
  $
  The equivalence classes for both $bf(A)$ and $bf(B)$ are ${0, 1}$ and ${2, 3}$.
]

#definition(name: [Irreducibility])[
  A Markov chain is _irreducible_ if it has exactly one communication class, meaning that all states communicate. Otherwise, the chain is _reducible_.
]

#definition(name: [Periodicity])[
  The _period_ of state $i$, denoted by $d(i)$, is
  $
    d(i) = gcd{n >= 1: P_(i,i)^((n)) > 0}.
  $
  If $P_(i,i)^((n)) = 0$ for every $n >= 1$, we define $d(i)=0$. A state with $d(i)=1$ is called _aperiodic_. See that $d(i) = 1$ if $P_(i, i)>0$.
]

#example()[
  Consider the following Markov chain.
  #transition-figure(transition-diagram(($"A"$, $"B"$), ((0, $1$), ($1$, 0))))
  Here we can see that
  $
    P_(i,i)^((n)) =
    cases(
      1 & "if" n "is even" \
      0 & "if" n "is odd"
    ).
  $
  Hence, $d(i) = gcd {2, 4, 6, dots} = 2$ .

]


#theorem()[
  If $i tilde.op j$, then $d(i)=d(j)$. Thus, periodicity is a property of a communication class. In particular, for an irreducible chain it makes sense to call the entire chain periodic or aperiodic.
]<thm-periodicity-is-class-property>

#theorem(name: [Regularity for finite chains])[
  A finite-state Markov chain is regular if and only if it is irreducible and aperiodic.

  We will sketch a proof of this theorem in @problem-aperiodic-irreducible-implies-regular-recurrent.
]<thm-regularity-for-finite-chains>



#definition(name: [First-return probabilities])[
  The first-return probabilities are defined as
  $
    f_(i,i)^((n)) = P(X_n=i, X_nu != i " for " nu=1,2,dots,n-1 | X_0=i), quad n>=1,
  $
  and we set $f_(i,i)^((0))=0$.

  Notes:
  - This is the probability of stating from state $i$, and the first return to state $i$ occurs at the $n$-th step.
  - The probability of ever returning to state $i$ is $f_(i,i) = sum_(n=1)^oo f_(i,i)^((n))$.
  - Clearly, $f_(i,i)^((0)) = P_(i,i)$, and $f_(i,i)^((n))$ may be calculated recursively as $P_(i,i)^((n)) = sum_(k=0)^(oo)f_(i,i)^((k)) P_(i,i)^((n-k))$.
]

#definition(name: [Recurrent and transient states])[
  State $i$ is _recurrent_ if $f_(i,i)=1$. It is _transient_ if $f_(i,i)<1$.

  Intuition:
  - If a state is recurrent, it is expected to be visited infinitely many times. If it is transient, it is expected to be visited only finitely many times.
  - If a state is recurrent, the probability of returning to it after some finite length of time is $1$. If it is transient, the probability of returning to it after some finite length of time is less than $1$.
]

#theorem()[
  A state $i$ is recurrent if and only if
  $
    sum_(n=0)^oo P_(i,i)^((n)) = oo.
  $
  Equivalently, it is transient if and only $sum_(n=0)^oo P_(i,i)^((n)) < oo$.

  Intuition:
  - If a state is recurrent, it is expected to be visited infinitely many times. If it is transient, it is expected to be visited only finitely many times.
]

#theorem()[
  Recurrence and transience are class properties. If $i tilde.op j$ and $i$ is recurrent, then $j$ is recurrent.
]<thm-recurrence-is-class-property>

#definition(name: [Mean recurrence time])[
  The _mean recurrence time_ of state $i$ is $m_i = sum_(n=1)^oo n f_(i,i)^((n))$, and can be interpreted as the mean duration of time between visits to state $i$.
]

#definition(name: [Positive and null recurrent])[
  A recurrent state $i$ is _positive recurrent_ if $m_i<oo$ and _null recurrent_ if $m_i=oo$.
]

#definition(name: [Stationary distribution])[
  A probability vector $bold(pi) = (pi_0, pi_1, dots)^top$ is a
  stationary distribution if
  $
    sum_i pi_i = 1 quad "and" quad pi_j = sum_(i=1)^(oo) pi_i P_(i,j), quad j = 0, 1, dots.
  $

  Equivalently, for finite state spaces, $bold(pi) = bf(P)^top bold(pi)$ and $bold(1)^top bold(pi) = 1$.
]

#theorem(name: [Existence and uniqueness of stationary distributions])[
  An irreducible Markov chain has a stationary distribution if and only if it is positive recurrent. When it exists, the stationary distribution is unique and satisfies $pi_i = 1 \/ m_i$.
]<thm-stationary-distribution-and-recurrence>

==

#theorem(name: [When stationary distribution is limiting])[
  If an irreducible positive recurrent Markov chain is also aperiodic, then the unique stationary distribution is also the limiting distribution


  $
    lim_(n -> oo) P_(j,i)^((n)) = pi_i = 1 \/ m_i quad "for all states" i,j.
  $
]

#corollary(name: [Finite irreducible chains])[
  Every finite irreducible Markov chain is positive recurrent. Hence it has a unique stationary distribution. If it is also aperiodic, then this stationary distribution is also the limiting distribution $lim_(n -> oo) P_(j,i)^((n)) = pi_i$.
]

#pagebreak()
#problem()[
  Consider two Markov chain with the transition probability matrices
  $
    bf(A) = mat(
      1\/3, 1\/3, 1\/3, 0;
      1\/3, 1\/3, 0, 1\/3;
      0, 0, 1\/2, 1\/2;
      0, 0, 1\/2, 1\/2;
    )
    quad "and" quad
    bf(B) = mat(
      0, 1, 0;
      0, 0, 1;
      1, 0, 0;
    )
  $
  Determine for each Markov chain how many equivalence classes it has and whether it is irreducible or reducible.
]<problem-equivalence-classes-and-reducibility>
#solution()[


  Drawing the transition diagram, we see
  // #transition-figure()[
  //   #transition-diagram(
  //     ($"0"$, $"1"$, $"2"$, $"3"$),
  //     (
  //       ($1\/3$, $1\/3$, $1\/3$, 0),
  //       ($1\/3$, $1\/3$, 0, $1\/3$),
  //       (0, 0, $1\/3$, $1\/3$),
  //       (0, 0, $1\/3$, $1\/3$),
  //     ),
  //   )]

  #subpar.grid(
    figure(
      transition-diagram(
        ($"0"$, $"1"$, $"2"$, $"3"$),
        (
          ($1\/3$, $1\/3$, $1\/3$, 0),
          ($1\/3$, $1\/3$, 0, $1\/3$),
          (0, 0, $1\/2$, $1\/2$),
          (0, 0, $1\/2$, $1\/2$),
        ),
      ),
      caption: [Probability transition diagram for $bf(A)$],
    ),
    figure(
      transition-diagram(
        ($"0"$, $"1"$, $"2"$),
        (
          (0, $1$, 0),
          (0, 0, $1$),
          ($1$, 0, 0),
        ),
      ),
      caption: [Probability transition diagram for $bf(B)$],
    ),

    columns: (auto, auto),
    kind: "transition-diagram",
    supplement: [Figure],
  )

  For $bf(A)$, it is clear that $0 tilde.op 1$ and $2 tilde.op 3$, but $0$ and $1$ do not communicate with $2$ and $3$. Therefore, there are two equivalence classes: ${0, 1}$ and ${2, 3}$. As we have more than one equivalence class, the Markov chain is reducible.

  For $bf(B)$, we have $0 tilde.op 1$, $1 tilde.op 2$, and $2 tilde.op 0$. Therefore, all states communicate with each other, and there is only one equivalence class ${0, 1, 2}$ and the Markov chain is irreducible.
]

#pagebreak()
#problem()[
  Consider the Markov chains specified by the transition probability matrices
  $
    bf(A) = mat(
      1, 0, , dots.c, 0;
      0, 1, 0, dots.c, 0;
      dots.v, , dots.down, , dots.v;
      0, , dots.c, 0, 1;
    ), quad
    bf(B) = mat(
      0, 1, 0, dots.c, 0;
      0, 0, 1, dots.c, 0;
      dots.v, , dots.down, , dots.v;
      1, 0, 0, dots.c, 0;
    )
    quad "and" quad
    bf(C) = mat(
      0, 1, 0, 0;
      0, 0, 1, 0;
      0, 0, 0, 1;
      1\/2, 0, 1\/2, 0;
    ).
  $
  Assume $bf(A)$ and $bf(B)$ are $n times n$.

  For each chain do the following:
  - Is the Markov chain reducible or irreducible? If it is reducible, specify its equivalence classes.
  - Calculate the period of each state.
]
#solution()[
  - For $bf(A)$, we have $i tilde.op i$ for all states $i$, but no other states communicate. Therefore the equivalence classes are ${0}$, ${1}$, ${2}$, dots, ${n-1}$ and the Markov chain is reducible. We have $d(i) = 1$ for all states $i$ since $P_(i,i) = 1$.
  - For $bf(B)$, we have $0 tilde.op 1$, $1 tilde.op 2$, dots, ${n-2} tilde.op {n-1}$, and ${n-1} tilde.op 0$. Therefore all states communicate with each other, and there is only one equivalence class ${0, 1, dots, n-1}$ and the Markov chain is irreducible. We have $d(i) = n$ for all states $i$ since we can only return to state $i$ after $n$ steps
  - For $bf(C)$, we can see that all states communicate with each other, and there is only one equivalence class ${0, 1, 2, 3}$ and the Markov chain is irreducible. Considering state $0$, the set of integers $n >= 1$ where $P_(0,0)^((n)) > 0$ is ${4, 6, 8, dots}$, and therefore $d(0) = 2$. By @thm-periodicity-is-class-property, we have $d(i) = 2$ for all states $i$.
]


#pagebreak()
#problem()[
  Let ${X_n : n = 0, 1, dots}$ be a Markov chain with finite state space ${0, 1, dots, N}$. Show that if the Markov chain is aperiodic and irreducible, then it is regular and recurrent.
]<problem-aperiodic-irreducible-implies-regular-recurrent>
#solution()[
  As all states communicate, there is only one equivalence class. Furthermore, as we have a finite state space, all states are expected to be visited infinitely many times, so they are recurrent.

  Proving that Irreducibility and aperiodicity implies regularity means that we prove @thm-regularity-for-finite-chains. A regular Markov chain is one where there exists a positive integer $n$ such that $P^n$ has strictly positive entries. Observe that:
  - Since the chain is irreducible, all states communicate and for each pair of states $i$ and $j$ there exists a positive integer $n_(i,j)$ such that $P_(i,j)^((n_(i,j))) > 0$.
  - Since the chain is aperiodic, there for each state $i$ exists a positive integer $m_i$ such that $P_(i,i)^((m)) > 0$ for all $m >= m_i$.
  Therefore we have that $P_(i, j)^((n_(i,j) + m)) >= P_(i,j)^((n_(i,j))) P_(j,j)^((m)) > 0$ for all $m >= m_j$. Choosing $n = max_(i,j){n_(i,j) + m_j}$, we have that $P^n$ has strictly positive entries, and the chain is regular.
]

// #pagebreak()
// #problem()[
//   Consider the Markov chain ${X_n : n = 0, 1, dots}$ with transition probability matrix
//   $
//     bf(P) = mat(
//       0.50, 0.50, 0, 0, 0, 0;
//       0.25, 0.75, 0, 0, 0, 0;
//       0.25, 0.25, 0.25, 0.25, 0, 0;
//       0.25, 0, 0.25, 0.25, 0, 0.25;
//       0, 0, 0, 0, 0.50, 0.50;
//       0, 0, 0, 0, 0.50, 0.50;
//     ).
//   $
//   Do the following:
//   - Is the Markov chain reducible or irreducible? If it is reducible, specify its equivalence classes.
//   - Calculate the period of each state.
//   - Which states are transient and which states are recurrent? Are there any absorbing states?
// ]
// #solution()[
//   - See that $0 tilde.op 1$, $2 tilde.op 3$ and $4 tilde.op 5$, but $0 tilde.not 2$, $0 tilde.not 4$ and $2 tilde.not 4$. We therefore have equivalence classes ${0, 1}$ ${2, 3}$ and ${4, 5}$. The chain is reducible.
//   - Only strictly positive values on the diagonal, meaning $d(i) = 1$ for every state $i$. Therefore, all states are aperiodic.
//   - See that
//     - ${0, 1}$: Finite size and not possible to leave the equivalence class. We are expected to visit each state infinitely many times, so they are *recurrent*.
//     - ${2, 3}$: Finite size, and a strictly positive probability of leaving and never returning. Therefore, they are *transient*.
//     - ${4, 5}$: Same as for ${0, 1}$, so they are *recurrent*.
//     A state is absorbing if it is impossible to leave it. There are no such states in this Markov chain.
//
// ]


#pagebreak()
#problem()[
  A two-state Markov chain has the transition probability matrix
  $
    bf(P) = mat(
      1-a, a;
      b, 1-b;
    ).
  $
  Determine the first-return distribution
  $
    f_(0,0)^((n)) = P(X_n=0, X_nu != 0 " for " nu=1,2,dots,n-1 | X_0=0), quad n>=1,
  $
]
#solution()[
  We have
  $
    f_(0,0)^((1)) = P(X_1=0 | X_0=0) = 1-a.
  $
  For $n>=2$, to return to $0$ for the first time at step $n$, the chain must follow
  $
    0 -> 1 -> 1 -> dots -> 1 -> 0.
  $
  We can write this using the Markov property and Bayes theorem as
  $
    f_(0,0)^((n)) = P(X_n=0 | X_(n-1)=1) dot product_(nu=1)^(n-1) P(X_nu=1 | X_(nu-1)=1) dot P(X_1=1 | X_0=0) = b (1-b)^(n-2) a.
  $
]

#pagebreak()
#problem()[
  We throw a fair coin repeatedly, and denote each outcome by $"H"$ (heads) or $"T"$ (tails). Let $n$ denote the $n$-th throw in a sequence, and define a stochastic process ${X_n : n = 0, 1, dots}$ by
  $
    X_n = "The number of consecutive throws of H, including throw" n, quad n = 0, 1, dots .
  $
  Do the following:
  - Explain why this is a Markov process. Specify the state space, and find the transition probabilities.
  - Is this Markov chain irreducible?
  - For each state, calculate its period.
  - Show that the states are recurrent.
  - Calculate the long run proportion of time that the sequence of throws ends in three or more heads.
]
#solution()[
  - Each throw is independent of the previous throws. Only the previous state affects the probability of transitioning to a new state. The transition probabilities are
    $
      P_(i,0) = 1\/2, quad P_(i,i+1) = 1\/2, quad i = 0, 1, dots,
    $
    and the state space is ${0, 1, dots}$.
  - We can reach $0$ from any state, and we can reach any state from $0$ by repeatedly getting heads. Therefore, all states communicate, and the Markov chain is irreducible.
  - Here it is easy to make a mistake and think that $d(i) = i+1$ for all states $i$. I provide two explanations below, with and without the use of @thm-periodicity-is-class-property:
    - From @thm-periodicity-is-class-property we know that all states have the same period since they communicate. Clearly $d(0) = 1$ since we can throw tails and return to $0$ in one step. Therefore, $d(i) = 1$ for all states $i$.
    - We know $d(0) = 1$, but now consider some state $i$ > 0. One way to return to $i$ is in $i + 1$ steps by throwing a tail and then $i$ heads. However, we can also throw two tails and then $i$ heads, which takes $i + 2$ steps. Therefore, $d(i) = gcd(i + 1, i + 2) = 1$.

    For both explanations, we conclude that all states are aperiodic.
  - As all states communicate, they are either all recurrent or all transient by @thm-recurrence-is-class-property. We consider state $0$, where
    $
      f_(0,0)^((n)) = 1\/2^n, quad n = 1, 2, dots
    $
    and therefore
    $
      f_(0,0) = sum_(n=1)^oo 1\/2^n = 1
    $
    by the geometric series. Since $0$ is recurrent, all states are recurrent.
  - Can also show positive recurrence. The mean recurrence time of state $0$ is
    $
      m_0 = sum_(n=1)^oo n f_(0,0)^((n)) = sum_(n=1)^oo n 1/2^n = sum_(n=1)^oo 1/2^(n-1) = 1/(1-1\/2)= 2 < oo.
    $
    As positive recurrence is a class property, all states are positive recurrent. As we previously showed that the chain is irreducible, we can use @thm-stationary-distribution-and-recurrence to find the stationary distribution. Let $pi_0$ denote the stationary distribution of state $0$, then
    $
      p_0 = 1\/m_0 = 1\/2.
    $
    To find the stationary distribution for the other states, we see
    $
      pi_1 & = sum_(k = 0)^(oo) pi_k P_(k,1) = pi_0 P_(0,1) = 1\/4, \
      pi_2 & = sum_(k = 0)^(oo) pi_k P_(k,2) = pi_1 P_(1,2) = 1\/8, \
    $
    and so on. The long run proportion of time that the sequence of throws ends in three or more heads is therefore
    $
      sum_(k = 3)^(oo) pi_k = 1 - pi_0 - pi_1 - pi_2 = 1\/8.
    $
]

// = Markov Chain Monte Carlo (MCMC)
//
// A surprisingly hard problem is to estimate the expected value of a function $g(X)$ of a random variable $X$ with probability distribution function $p$
// $
//   EE[g(X)] = integral_RR g(x) p(x) dif x.
// $
// If we can generate samples $X_1, dots, X_N$ from $X tilde.op p$, Monte Carlo methods allow us to estimate
// $
//   EE[g(X)] approx 1/N sum_(i=1)^N g(X_i).
// $
// However, sampling from $p$ can be difficult, as we do not always have a closed form expression.
//




