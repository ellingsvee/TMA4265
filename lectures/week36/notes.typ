#import "../templates/tma4265-notes.typ": *
#import "@preview/muchpdf:0.1.2": muchpdf

#import "@preview/lemmify:0.1.7": default-theorems, new-theorems, thm-numbering-heading
#show figure.where(kind: "solution-group"): set block(breakable: true)

#import "@preview/fletcher:0.5.8" as fletcher: diagram, edge, node

#import "../utils.typ": transition-diagram, transition-figure

#show link: set text(fill: blue)


#show: icml.with(
  title: [
    Week 36: Long Run Behavior of Markov Chains (Part 1)
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

  Written more mathematically, we have $bf(P) "regular" <==> exists k > 0 "s.t." P_(i, j)^((k)) > 0 "for all" i, j in S$.
]

// #example()[
//   See that
//   $
//     bf(P) = mat(
//       1\/2, 1\/2, 0;
//       1\/2, 0, 1\/2;
//       0, 1\/2, 1\/2;
//     )
//     quad "and" quad
//     bf(P)^(2) = mat(
//       ast, ast, ast;
//       ast, ast, ast;
//       ast, ast, ast;
//     ),
//   $
//   meaning that $bf(P)$ is regular.
// ]<example-regular-markov-chain>

#definition(name: [Limiting distribution])[
  Consider a DT-MC ${X_t}$. We call $bold(pi) = (pi_0, pi_1, dots)^top$ the _limiting distribution_ if the following two conditions are satisfied:
  + The limits $pi_j = lim_(t->oo) P_(i, j)^((t))$ exist for $j = 0, 1, dots$ and do not depend on $i$.
  + $sum_(j=0)^oo pi_j = 1$.

  Notes:
  - $1. ==> 2.$ for finite state spaces ${0, 1, dots, N}$, but not necessarily for infinite state spaces.
  - $pi_j$ can be interpreted as the probability of being in state $j$ after many transitions.
  - I let $bold(pi)$ be a column vector, but some authors let it be a row vector. The two conventions are equivalent, but resulting matrix equations look different.
]



#definition(name: [Stationary distribution])[
  A probability distribution $bold(pi) = (pi_0, pi_1, dots)^top$ is called a _stationary distribution_ if
  $
    pi_j = sum_(i=0)^oo pi_i P_(i,j), quad j = 0, 1, dots,
  $
  or, equivalently, $bold(pi) = bf(P)^top bold(pi) <==> (bf(P)^top - bf(I))bold(pi) = bold(0)$.

  An important property of stationary distributions is that if $X_0 tilde.op bold(pi)$, then $X_t tilde.op bold(pi)$ for every $t >= 0$.

]<def-stationary-distribution>


#theorem()[
  Let ${X_t}$ be a regular DT-MC with finite state space ${0, 1, dots, N}$ and transition probability matrix $bf(P)$. Then the limiting distribution $bold(pi)$:
  + Exists and for any initial state $i$ satisfies $pi_j = lim_(t->oo) P_(i, j)^((t)) > 0$ for all $j = 0, 1, dots, N$.
  // + Is the unique non-negative solution of $pi_j = sum_(k=0)^(N) pi_k P_(k, j)$ for $j = 0, 1, dots, N$ and $sum_(j=0)^(N) pi_j = 1$.
  + Is the unique non-negative solution of $bold(pi) = bf(P)bold(pi)$ and $bold(1)^top bold(pi) = 1$.

  An important consequence is $"Limiting distribution" ==> "Stationary distribution"$ (but not the other way around).

]<thm-limiting-distribution>

#definition(name: [Doubly stochastic])[
  The transition probability matrix $bf(P)$ is called _doubly stochastic_ if
  $
    sum_(k=0)^(N) P_(i, k) = sum_(k=0)^(N) P_(k, j) = 1
  $
  for all states $i$ and $j$.
]

#example()[
  The $bf(C)$ from @problem-regularity is doubly stochastic. Not every transition probability matrix is doubly stochastic, its rows always sum to one, but its columns need not.
]


#theorem()[
  Let the Markov chain ${X_t : t = 0, 1, dots}$ be regular with finite state space ${0, 1, dots, N}$. If the transition probability matrix $bf(P)$ is doubly stochastic, then the limiting distribution is uniform
  $
    bf(pi) = (1/(N+1), 1/(N+1), dots, 1/(N+1)).
  $
]<thm-doubly-stochastic>


#example(name: [Doubly stochastic matrices])[
  Consider the transition probability matrix used in @problem-limiting-and-stationary-distributions
  $
    bf(P) = mat(
      p, q, 0;
      0, p, q;
      q, 0, p;
    ),
  $
  and assume that $0 < p, q < 1$ and $p + q = 1$ to avoid the edge-cases. We already showed that this Markov chain is regular. It is doubly stochastic because the rows and columns sum to one. Hence, the limiting distribution is uniform $bold(pi) = (1\/3, 1\/3, 1\/3)^top$.
]




#theorem(name: [Long-run fraction of time])[
  In a regular Markov chain ${X_t: t = 0, 1, dots}$, the limiting distribution $bold(pi) = (pi_0, pi_1, dots, pi_N)^top$ gives the long-run fraction of time spent in each state. I.e.,
  $
    pi_j = lim_(n->oo) EE [1/n sum_(k=0)^(n-1) bb(1){X_k = j} | X_0=i]
  $
  for any state $i$

]<thm-long-run-fraction-of-time>





#pagebreak()
#problem()[
  Are
  $
    bf(A) = mat(
      1, 0;
      0, 1
    ),
    quad bf(B) = mat(
      0, 1;
      1, 0
    )
    quad "and/or" quad
    bf(C) = mat(
      1\/2, 1\/2, 0;
      1\/2, 0, 1\/2;
      0, 1\/2, 1\/2;
    )
  $
  regular?
]<problem-regularity>
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
  so $bf(B)$ is not regular either. For $bf(C)$, we have
  $
    bf(C)^2 = mat(
      ast, ast, ast;
      ast, ast, ast;
      ast, ast, ast;
    ),
  $
  meaning that $bf(C)$ is regular.

]








#pagebreak()
#problem(name: [Limiting and stationary distributions])[
  Consider the transition probability matrix
  $
    bf(P) = mat(
      p, q, 0;
      0, p, q;
      q, 0, p;
    ),
  $
  where $p, q >= 0$ and $p + q = 1$. Consider the cases
  - $0 < p < 1$ and $q = 1 - p > 0$
  - $p = 1$ and $q = 0$.
  - $p = 0$ and $q = 1$
  For each case, determine whether the limiting distribution exists and/or whether the stationary distribution exists. Compute the $bold(pi) = (pi_0, pi_1, pi_2)^top$ as a function of $p$ and $q$.
]<problem-limiting-and-stationary-distributions>
#solution()[
  - For $0 < p < 1$ and $q = 1 - p > 0$, we see
    $
      bf(P)^2 = mat(
        p^2, p q, q;
        q, p^2, p q;
        p q, q, p^2;
      ) = mat(
        ast, ast, ast;
        ast, ast, ast;
        ast, ast, ast;
      ),
    $
    meaning the chain is regular and the limiting and stationary distributions exist. We set up a system of equations so that $(bf(P)^top - bf(I)) bold(pi) = bold(0)$ and $bold(1)^top bold(pi) = 1$. As we have four equations and three unknowns, we can drop one of the equations. This gives
    $
      mat(
        p-1, 0, q;
        q, p-1, 0;
        1, 1, 1;
      ) mat(
        pi_1;
        pi_2;
        pi_3;
      ) = mat(
        0;
        0;
        1;
      ).
    $
    Since $1 - p = q$, this simplifies to
    $
      mat(
        -q, 0, q;
        q, -q, 0;
        1, 1, 1;
      ) mat(
        pi_1;
        pi_2;
        pi_3;
      ) = mat(
        0;
        0;
        1;
      )
      quad ==> quad
      mat(
        -1, 0, 1;
        1, -1, 0;
        1, 1, 1;
      ) mat(
        pi_1;
        pi_2;
        pi_3;
      ) = mat(
        0;
        0;
        1;
      ),
    $
    meaning the limiting probabilities are independent of $p$ and $q$. Solving the system using Gauss elimination, we find $pi_0 = pi_1 = pi_2 = 1 \/ 3$.

  - Here we have $bf(P) = bf(I)$. Clearly, $bold(pi) = bf(I)bold(pi)$ for any probability distribution $bold(pi)$, so every probability distribution is stationary. However, the limiting distribution does not exist because the distribution never changes and therefore depends on the initial state.
  - Here we have
    $
      bf(P) = mat(
        0, 1, 0;
        0, 0, 1;
        1, 0, 0;
      ),
      quad
      bf(P)^2 = mat(
        0, 0, 1;
        1, 0, 0;
        0, 1, 0;
      ),
      quad
      bf(P)^3 = bf(I), quad
      bf(P)^4 = bf(P),
    $
    meaning that the chain moves deterministically through the three states. The entries of $bf(P)^n$ oscillate, so no limiting distribution exists. However, we can check that the uniform distribution $bold(pi) = (1\/3, 1\/3, 1\/3)^top$ is stationary
    $
      bf(P)^top bold(pi) = mat(
        0, 0, 1;
        1, 0, 1;
        0, 1, 0;
      ) mat(
        1\/3;
        1\/3;
        1\/3;
      ) = mat(
        1\/3;
        1\/3;
        1\/3;
      ) = bold(pi).
    $


]





#pagebreak()
#problem(name: [Exam August 2025])[
  On any given day Maria is either cheerful ($"C"$), so-so ($"S"$), or glum ($"G"$). If she is cheerful today, then she will be $"C"$, $"S"$, or $"G"$ tomorrow with respective probabilities $0.5$, $0.4$, $0.1$. If Maria is feeling so-so today, then she will be $"C"$, $"S"$, or $"G"$ tomorrow with probabilities $0.3$, $0.4$, $0.3$. If she is glum today, then she will be $"C"$, $"S"$, or $"G"$ tomorrow with probabilities $0.2$, $0.3$, $0.5$. Let $X_n$ denote Maria’s mood on day $n$.
  +
    - Explain that Maria’s mood is a three-state Markov chain.
    - Illustrate with a transition probability graph, and determine the transition probability matrix $bf(P)$.
  + Assume that Maria’s mood at day $27$ has a uniform probability distribution. What is the probability that Maria is glum at day $28$.
  +
    - Explain that the Markov chain has a unique stationary distribution.
    - How often, on average, is Maria glum?
    - Is it possible that the distribution of $X_1$ equals the distribution of $X_n$ for all $n$?
  + Assume in the following that Maria is cheerful at day $1$. Are $X_1$ and $X_2$ independent random variables?
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
  + As mood at day $27$ is uniformly distributed, we have
    $
      P(X_27 = "C") = P(X_27 = "S") = P(X_27 = "G") = 1\/3.
    $
    The probability that Maria is glum at day $28$ is therefore
    $
      P(X_28 = "G") & = sum_(k in {"C", "S", "G"}) P(X_28 = "G" | X_27 = k) P(X_27 = k) \
                    & = 0.1 * 1\/3 + 0.3 * 1\/3 + 0.5 * 1\/3 \
                    & = 0.3.
    $
  + The Markov chain is regular since $P_(i,j) > 0$ and the state space is finite. By @thm-limiting-distribution, it has a unique stationary distribution $bold(pi) = bf(P)^top bold(pi)$.

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
  + The key thing to note here is the implication of $X_1 = "C"$ being a constant. $X_1$ and $X_2$ are independent if
    $
      P(X_1 = x_1, X_2 = x_2) = P(X_1 = x_1) P(X_2 = x_2).
    $
    However, we have as $P(X_1 = "C") = 1$  and zero otherwise, it is easy to show that this holds for all choices of $x_1$ and $x_2$. Hence, $X_1$ and $X_2$ are independent.
]


#pagebreak()
#problem()[
  A Markov chain ${X_t : t = 0,1,...}$ has transition probability matrix
  $
    bf(P) = mat(
      1\/2, 1\/2, 0, 0;
      1\/2, 0, 1\/2, 0;
      0, 1\/2, 0, 1\/2;
      0, 0, 1\/2, 1\/2;
    ).
  $
  What is its limiting distribution? What fraction of time, in the long run, does the chain spend in state 0?
]
#solution()[
  Using the fact that the chain is doubly stochastic, we can from @thm-doubly-stochastic immediately conclude that the limiting distribution is uniform $bold(pi) = (1\/4, 1\/4, 1\/4, 1\/4)^top$. Furthermore, by @thm-long-run-fraction-of-time, the long-run fraction of time spent in state 0 is $pi_0 = 1\/4$.
]


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

  From page $i$, the surfer chooses uniformly among its outgoing links. If a page has no outgoing links, it is called a _dangling page_. Its row would contain only zeros, so we replace it by a uniform distribution
  $
    S_(i,j) = cases(
      P_(i,j) & "if" d_i > 0,
      1 \/ n & "if" d_i = 0.
    )
  $
  This makes $bf(S)$ a transition probability matrix, but does not necessarily make the chain regular. PageRank therefore adds _teleportation_. Let $alpha in (0,1)$ be the probability of following a link, and let $bold(v)$ be a probability distribution with $v_j>0$ for all $j$. The PageRank transition matrix is
  $
    G_(i,j) = alpha S_(i,j) + (1 - alpha) v_j.
  $
  A common choice is $alpha=0.85$ and $v_j=1\/n$. Since $G_(i,j) >= (1-alpha)v_j>0$, $bf(G)$ is regular. It therefore has a unique stationary and limiting distribution $bold(pi)$, which is the PageRank vector. It satisfies $bold(pi) = bf(G)^top bold(pi)$ and $bold(1)^top bold(pi)=1$, and we may compute it from any initial distribution $bold(pi)^((0)) = (1\/n, dots, 1\/n)^top$ by iterating
  $
    bold(pi)^((t+1)) = bf(G)^top bold(pi)^((t)).
  $
  It describes the long-run fraction of time spent on each page, meaning we want to rank pages based on this ordering.

  Boom, now you have a gazillion dollar business idea! See the `lecures/week36/code/pagerank.py` for an implementation of this algorithm.



]
