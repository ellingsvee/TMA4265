#import "../templates/tma4265-notes.typ": *
#import "@preview/muchpdf:0.1.2": muchpdf

#import "@preview/lemmify:0.1.7": default-theorems, new-theorems, thm-numbering-heading
#show figure.where(kind: "solution-group"): set block(breakable: true)

#import "@preview/fletcher:0.5.8" as fletcher: diagram, edge, node

#import "../utils.typ": transition-diagram, transition-figure

#show link: set text(fill: blue)


#show: icml.with(
  title: [
    Week 36: Long Run Behavior of Markov Chains
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

We are now interested in exploring the long-term behavior of Markov chains, meaning determining the limit
$
  lim_(t -> oo) P_(i, j)^((t)) = lim_(t -> oo) P(X_t = j | X_0 = i).
$
For this we have to introduce some additional terminology and definitions.

#definition(name: [Regular Markov chain])[
  Consider a DT-MC ${X_t}$ with finite state space ${0, 1, dots, N}$ and transition probability matrix $bf(P)$. If there exists a positive integer $k>0$ so that all elements of $bf(P)^k$ are strictly positive, we call $bf(P)$ and ${X_t}$ _regular_.

  Written more mathematically, we have
  $
    bf(P) "regular" <==> exists k > 0 "s.t." P_(i, j)^((k)) > 0 "for all" i, j in S.
  $
]

#example()[
  See that
  $
    bf(P) = mat(
      1\/2, 1\/2, 0;
      1\/2, 0, 1\/2;
      0, 1\/2, 1\/2;
    )
    quad "and" quad
    bf(P)^(2) = mat(
      ast, ast, ast;
      ast, ast, ast;
      ast, ast, ast;
    ),
  $
  meaning that $bf(P)$ is regular. While a trivial example of a non-regular transition matrix is the identity $bf(P) = bf(I)$.
]<example-regular-markov-chain>

#definition(name: [Limiting distribution])[
  Consider a DT-MC ${X_t}$. We call $bold(pi) = (pi_0, pi_1, dots)$ the _limiting distribution_ is the following two conditions are satisfied:
  + $pi_j = lim_(t->oo) P_(i, j)^((t))$ for $j = 0, 1, dots$ all exist and do not depend on $i$.
  + $sum_(j=0)^oo pi_j = 1$.

  Notes:
  - $1. ==> 2.$ for finite state spaces ${0, 1, dots, N}$, but not necessarily for infinite state spaces.
  - $pi_j$ can be interpreted as the probability of being in state $j$ after many transitions.
]

#theorem()[
  Let ${X_t}$ be a regular DT-MC with state space ${0, 1, dots, N}$ and transition probability matrix $P$. Then the limiting distribution $bold(pi)$:
  + Exists and for any initial state $i$ satisfies $pi_j = lim_(t->oo) P_(i, j)^((t)) > 0$ for all $j = 0, 1, dots, N$.
  + Is the unique non-negative solution of $pi_j = sum_(k=0)^(N) pi_k P_(k, j)$ for $j = 0, 1, dots, N$ and $sum_(j=0)^(N) pi_j = 1$.
  Notes:
  - Regularity implies existence and uniqueness of the limiting distribution.
  - $bold(pi)^top = bold(pi)^top bf(P) <==> bold(pi) = bf(P)^top bold(pi) <==> (bf(I) - bf(P)) bold(pi) = bold(0)$ .
]<thm-limiting-distribution>

#definition(name: [Doubly stochastic])[
  The transition probability matrix $bf(P)$ is called _doubly stochastic_ if
  $
    sum_(k=0)^(N) P_(i, k) = sum_(k=0)^(N) P_(k, j) = 1
  $
  for all states $i$ and $j$.
]

#example()[
  The $bf(P)$ from @example-regular-markov-chain is doubly stochastic, while the one from @problem-equivalence-classes-and-reducibility is not.
]

#theorem()[
  Let the Markov chain ${X_t : t = 0, 1, dots}$ be regular with finite state space ${0, 1, dots, N}$. Is the transition probability matrix $bf(P)$ doubly stochastic, then the limiting distribution is uniform
  $
    bf(pi) = (1/(N+1), 1/(N+1), dots, 1/(N+1)).
  $
]

#theorem(name: [Long-run mean fraction of time])[
  In a regular Markov chain ${X_t: t = 0, 1, dots}$, the limiting distribution $bold(pi) = (pi_0, pi_1, dots, pi_N)$ gives the long-run mean fraction of time spent in each state
  $
    pi_j = lim_(n->oo) EE [
      1/n sum_(k=0)^(n-1) bb(1){X_k = j} | X_0 = i
    ]
  $
  for any state $i$.
]

An important thing to be aware of is that regularity is a sufficient condition for the existence of a limiting distribution, but not a necessary one. There are Markov chains that are not regular, but still have a limiting distribution. To explore this we need some additional definitions.

#definition(name: [Communication])[
  Let ${X_t: t = 0, 1, dots}$ be a Markov chain with state space ${0, 1, dots}$ and transition probability matrix $P$.
  - State $j$ is _accessible_ from state $i$ if there exists a positive integer $n >= 0$ so that $P_(i, j)^((t)) > 0$.
  - If states $i$ and $j$ are accessible from each other, they are said to _communicate_ and we write $i tilde.op j$.
]

#example()[
  In the first scenario, we have that $"B"$ is accessible from $"A"$, but $"A"$ is not accessible from $"B"$. Therefore $"A" tilde.not "B"$. In the second scenario, $"A"$ and $"B"$ are accessible from each other, so $"A" tilde.op "B"$.

  #subpar.grid(
    figure(
      transition-diagram(
        ($"A"$, $"B"$),
        (
          ($1\/2$, $1\/2$),
          (0, 1),
        ),
      ),
      // caption: [Scenario 1],
    ),
    figure(
      transition-diagram(
        ($"A"$, $"B"$),
        (
          ($1\/2$, $1\/2$),
          ($1\/2$, $1\/2$),
        ),
      ),
      // caption: [Scenario 2],
    ),

    columns: (auto, auto),
    kind: "transition-diagram",
    supplement: [Figure],
  )

]

#theorem(name: [Communication is an equivalence relation])[
  We have
  - Reflexivity: $i tilde.op i$ for all states $i$.
  - Symmetry: If $i tilde.op j ==> j tilde.op i$.
  - Transitivity: If $i tilde.op j$ and $j tilde.op k$, then $i tilde.op k$.

  The equivalence relation induces _equivalence classes_ consisting of sets of states that communicate.
]

#definition(name: [Irreducibility])[
  A Markov chain is _irreducible_ if the communication equivalence relation induces exactly one equivalence class, meaning that all states communicate with each other. If not, the Markov chain is _reducible_.
]

#definition(name: [Periodicity])[
  The _period_ of a state $i$, written $d(i)$, is
  $
    d(i) = gcd{t >= 1: P_(i, i)^((t)) > 0}.
  $
  If $P_(i, i)^((n)) = 0$ for all $n >= 1$, we define $d(i) = 0$. If $d(i) = 1$, we say that state $i$ is _aperiodic_.
]

#theorem()[
  If $i tilde.op j$, then $d(i) = d(j)$.

  Note that this means that periodicity is a property of the equivalence class.
]

Introducing some notation, we write
$
  f_(i,i)^((t)) = P(X_t = i, X_nu != i, nu = 1, 2, dots, t-1 | X_0 = i), quad t>0,
$
and define $f_(i, i)^((0)) = 0$. The probability of ever returning to state $i$ is then
$
  f_(i, i) = sum_(k=1)^oo f_(i, i)^((k)) = lim_(t->oo) sum_(k=1)^t f_(i, i)^((k)).
$
Note that a $f_(i,i) < 1$ there is a non-zero probability of never returning to state $i$.

#definition(name: [Recurrent and transient states])[
  State $i$ is _recurrent_ if the probability of returning to state $i$ in a finite number of time steps is one, i.e., $f_(i,i) = 1$. A state that is not recurrent, i.e., $f_(i,i) < 1$, is called _transient_.
]

#theorem()[
  A state $i$ is recurrent if and only if $sum_(t=0)^oo P_(i, i)^((t)) = oo$. Equivalently, a state $i$ is transient if and only if $sum_(t=0)^oo P_(i, i)^((t)) < oo$.

  We interpret this as the expected number of returns is finite for transient states and infinite for recurrent states.
]




#pagebreak()
#problem()[
  Are
  $
    bf(A) = mat(
      1, 0;
      0, 1
    )
    quad "and" quad
    bf(B) = mat(
      0, 1;
      1, 0
    )
  $
  regular?
]
#solution()[
  For $bf(A)$, we have $bf(A)^k = bf(A)$ for all $k$, and therefore $bf(A)$ is not regular. For $bf(B)$, we have
  $
    bf(B)^2 = mat(
      1, 0;
      0, 1
    )
    quad "and" quad
    bf(B)^3 = mat(
      0, 1;
      1, 0
    ),
  $
  so $bf(B)$ is not regular either.
]





#pagebreak()

#problem()[
  Consider the Markov chain with transition probability matrix
  $
    bf(P) = mat(
      1\/3, 1\/3, 1\/3, 0;
      1\/3, 1\/3, 0, 1\/3;
      0, 0, 1\/2, 1\/2;
      0, 0, 1\/2, 1\/2;
    ).
  $
  - How many equivalence classes does this Markov chain have?
  - Is the Markov chain irreducible or reducible?
]<problem-equivalence-classes-and-reducibility>
#solution()[
  Drawing the transition diagram, we see
  #transition-figure()[
    #transition-diagram(
      ($"0"$, $"1"$, $"2"$, $"3"$),
      (
        ($1\/3$, $1\/3$, $1\/3$, 0),
        ($1\/3$, $1\/3$, 0, $1\/3$),
        (0, 0, $1\/3$, $1\/3$),
        (0, 0, $1\/3$, $1\/3$),
      ),
    )]
  It is clear that $0 tilde.op 1$ and $2 tilde.op 3$, but $0$ and $1$ do not communicate with $2$ and $3$. Therefore, there are two equivalence classes: ${0, 1}$ and ${2, 3}$. As we have more than one equivalence class, the Markov chain is reducible.
]


#pagebreak()

#problem(name: [Exam August 2025, Marias Mood])[
  On any given day Maria is either cheerful ($"C"$), so-so ($"S"$), or glum ($"G"$). If she is cheerful today, then she will be $"C"$, $"S"$, or $"G"$ tomorrow with respective probabilities $0.5$, $0.4$, $0.1$. If Maria is feeling so-so today, then she will be $"C"$, $"S"$, or $"G"$ tomorrow with probabilities $0.3$, $0.4$, $0.3$. If she is glum today, then she will be $"C"$, $"S"$, or $"G"$ tomorrow with probabilities $0.2$, $0.3$, $0.5$. Let $X_n$ denote Maria’s mood on day $n$.
  +
    - Explain that Maria’s mood is a three-state Markov chain.
    - Illustrate with a transition probability graph, and determine the transition probability matrix $bf(P)$.
  +
    - Assume that Maria’s mood at day $27$ has a uniform probability distribution. What is the probability that Maria is glum at day $28$.
    - Is the Markov chain irreducible? Are all states communicating with each other?
  +
    - Explain that the Markov chain has a unique stationary distribution.
    - How often, on average, is Maria glum?
    - Is it possible that the distribution of $X_1$ equals the distribution of $X_n$ for all $n$?
  + Assume in the following that Maria is cheerful at day $1$.
    - What is the probability that Maria is cheerful at day $3$?
    - Are $X_1$ and $X_2$ independent random variables?
    - What is the mathematical definition of a stochastic process $X$? Use $X_1, X_2, dots$ to define a stochastic process $X$. What is the probability distribution of $X$ in this particular case?
]<problem-marias-mood>
#solution()[
  +
    - Three states $"C"$, $"S"$, and $"G"$. The Markov property holds since the probability of Maria’s mood tomorrow only depends on her mood today.
    - The transition probability matrix is
      $
        bf(P) = mat(
          0.5, 0.4, 0.1;
          0.3, 0.4, 0.3;
          0.2, 0.3, 0.5;
        ),
      $
      and the transition probability graph is
      #transition-figure()[
        #transition-diagram(
          ($"C"$, $"S"$, $"G"$),
          (
            (0.5, 0.4, 0.1),
            (0.3, 0.4, 0.3),
            (0.2, 0.3, 0.5),
          ),
        )]
  +
    - As mood at day $27$ is uniformly distributed, we have
      $
        P(X_27 = "C") = P(X_27 = "S") = P(X_27 = "G") = 1\/3.
      $
      The probability that Maria is glum at day $28$ is therefore
      $
        P(X_28 = "G") & = sum_(k in {"C", "S", "G"}) P(X_28 = "G" | X_27 = k) P(X_27 = k) \
                      & = 0.1 * 1\/3 + 0.3 * 1\/3 + 0.5 * 1\/3 \
                      & = 0.3.
      $
    - All states communicate with each other since every $P_(i,j) > 0$. The Markov chain is therefore irreducible.
  +

    - The Markov chain is is regular since $P_(i,j) > 0$ and the state space is finite. By @thm-limiting-distribution, it has a unique stationary distribution $bold(pi) = bold(pi)bf(P)$.

    - We have the system of equations
      $
                    pi_"C" + pi_"S" + pi_"G" & = 1, \
        0.5 pi_"C" + 0.3 pi_"S" + 0.2 pi_"G" & = pi_"C", \
        0.4 pi_"C" + 0.4 pi_"S" + 0.3 pi_"G" & = pi_"S", \
        0.1 pi_"C" + 0.3 pi_"S" + 0.5 pi_"G" & = pi_"G",
      $
      where we have four equations and three unknowns. Dropping the last equation, we can solve the system
      $
        mat(
          1, 1, 1;
          -0.5, 0.3, 0.2;
          0.4, -0.6, 0.3;
        ) mat(
          pi_"C";
          pi_"S";
          pi_"G";
        ) = mat(
          1;
          0;
          0;
        )
        quad ==> quad
        mat(
          pi_"C";
          pi_"S";
          pi_"G";
        ) = mat(
          21\/62;
          23\/62;
          18\/62;
        ).
      $
      Hence, on average, Maria is glum $pi_"G" = 18\/62 approx 29\%$ of the time.
    - Yes, this is possible if the initial distribution is the stationary distribution $bold(pi)$.
  +
    - Assuming Maria is cheerful at day $1$, we have
      $
        P(X_3 = "C") & = sum_(k in {"C", "S", "G"}) P(X_3 = "C" | X_2 = k) P(X_2 = k | X_1 = "C") \
                     & = 0.5 * 0.5 + 0.4 * 0.3 + 0.1 * 0.2 \
                     & = 0.39.
      $
      Alternatively, we can see that
      $
        bf(P)^2 = mat(
          0.39, 0.39, 0.22;
          0.33, 0.37, 0.30;
          0.29, 0.35, 0.36;
        )
        quad "and" quad
        mat(1, 0, 0;) dot bf(P)^2 = mat(0.39, 0.39, 0.22;),
      $
      meaning that $P(X_3 = "C") = 0.39$.
    - The key thing to note here is the implication of $X_1 = "C"$ being a constant. $X_1$ and $X_2$ are independent if
      $
        P(X_1 = x_1, X_2 = x_2) = P(X_1 = x_1) P(X_2 = x_2).
      $
      However, we have as $P(X_1 = "C") = 1$  and zero otherwise, it is easy to show that this holds for all choices of $x_1$ and $x_2$. Hence, $X_1$ and $X_2$ are independent.

]


#pagebreak()
#pagebreak()

#example(name: [PageRank])[
  A search engine should not only check whether a page contains a search term, but also whether the page is _important_. PageRank assigns a score to each page using the link structure of the web. The key idea is to model a random web surfer. At each step, the surfer either follows a hyperlink or jumps to another page. Pages that are visited often in the long run get a high PageRank score. This idea was introduced in the early Google search engine #tc(<brin_anatomy_1998>).


  Suppose there are $n$ pages. Each page is a state in a Markov chain. If page $i$ has $d_i$ outgoing links, then the hyperlink transition matrix is

  $
    P_(i,j) = cases(
      1 \/ d_i & "if page" i "links to page" j,
      0 & "otherwise".
    )
  $

  So from page $i$, the surfer chooses uniformly among its outgoing links. If a page has no outgoing links, it is called a _dangling page_. In that case, we replace its row by a uniform distribution
  $
    S_(i,j) = cases(
      P_(i,j) & "if" d_i > 0,
      1 \/ n & "if" d_i = 0.
    )
  $
  To make the chain ergodic, PageRank adds _teleportation_. Let $alpha in (0,1)$ be the probability of following a link, and let $v$ be a probability distribution on the pages. The PageRank transition matrix is
  $
    G_(i,j) = alpha S_(i,j) + (1 - alpha) v_j.
  $
  Usually, $alpha = 0.85$ and $v_j = 1 \/ n$.



  The PageRank vector $pi$ is the stationary distribution $bold(pi)$ of this Markov chain. Here, $bold(pi) = bold(pi)bf(G)$ and $sum_(j=1)^n pi_j = 1$. We can compute $bold(pi)$ by starting from an initial distribution $bold(pi)^(0)$ and computing $bold(pi)^(t+1) = bold(pi)^(t)bf(G)$ until convergence.

]
