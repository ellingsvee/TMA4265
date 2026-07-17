"""Simple Black-Scholes illustration using geometric Brownian motion.

The Black-Scholes model assumes that a stock price follows

    dS_t = mu*S_t*dt + sigma*S_t*dW_t.

This script:
1. Simulates many stock-price paths.
2. Shows the lognormal terminal-price distribution.
3. Prices a European call using both Monte Carlo simulation and the
   closed-form Black-Scholes formula.
"""

import numpy as np
import matplotlib.pyplot as plt
from math import erf, exp, log, sqrt

rng = np.random.default_rng(12)

S0 = 100.0
mu = 0.08
sigma = 0.25
T = 1.0
n_steps = 252
n_paths = 1000

dt = T / n_steps
times = np.linspace(0, T, n_steps + 1)

# Exact discretization of geometric Brownian motion
Z = rng.standard_normal((n_paths, n_steps))
increments = (mu - 0.5 * sigma**2) * dt + sigma * np.sqrt(dt) * Z

prices = np.empty((n_paths, n_steps + 1))
prices[:, 0] = S0
prices[:, 1:] = S0 * np.exp(np.cumsum(increments, axis=1))

sample_mean = prices.mean(axis=0)
theoretical_mean = S0 * np.exp(mu * times)

# Simulated paths
plt.figure(figsize=(9, 6))
for i in range(25):
    plt.plot(times, prices[i], alpha=0.45, linewidth=1)

plt.plot(times, sample_mean, linewidth=2.5, label="Monte Carlo mean")
plt.plot(
    times,
    theoretical_mean,
    linestyle="--",
    linewidth=2,
    label=r"Theoretical mean $S_0e^{\mu t}$",
)
plt.xlabel("Time (years)")
plt.ylabel("Stock price")
plt.title("Stock-price paths under geometric Brownian motion")
plt.legend()
plt.grid(alpha=0.3)
plt.tight_layout()
plt.show()

# Terminal-price distribution
terminal_prices = prices[:, -1]

plt.figure(figsize=(9, 5))
plt.hist(terminal_prices, bins=45, density=True, alpha=0.7)
plt.axvline(S0, linestyle="--", linewidth=2, label="Initial price")
plt.axvline(terminal_prices.mean(), linewidth=2, label="Simulated terminal mean")
plt.xlabel("Stock price after one year")
plt.ylabel("Density")
plt.title("Lognormal distribution of the terminal stock price")
plt.legend()
plt.grid(alpha=0.3)
plt.tight_layout()
plt.show()

# ----- European call option extension -----
K = 105.0
r = 0.03


def normal_cdf(x):
    return 0.5 * (1.0 + erf(x / sqrt(2.0)))


def black_scholes_call(S0, K, r, sigma, T):
    d1 = (log(S0 / K) + (r + 0.5 * sigma**2) * T) / (sigma * sqrt(T))
    d2 = d1 - sigma * sqrt(T)
    return S0 * normal_cdf(d1) - K * exp(-r * T) * normal_cdf(d2)


# Risk-neutral simulation uses r instead of mu
Z_rn = rng.standard_normal((n_paths, n_steps))
rn_increments = (r - 0.5 * sigma**2) * dt + sigma * np.sqrt(dt) * Z_rn
rn_terminal = S0 * np.exp(np.sum(rn_increments, axis=1))

discounted_payoff = np.exp(-r * T) * np.maximum(rn_terminal - K, 0.0)

mc_call_price = discounted_payoff.mean()
bs_call_price = black_scholes_call(S0, K, r, sigma, T)

print(f"Mean simulated terminal stock price: {terminal_prices.mean():.2f}")
print(f"Theoretical terminal mean:           {S0 * np.exp(mu * T):.2f}")
print(f"Monte Carlo call price:              {mc_call_price:.2f}")
print(f"Black-Scholes call price:            {bs_call_price:.2f}")
