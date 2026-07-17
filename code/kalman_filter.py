"""Simple 2D Kalman-filter localization example.

A boat moves in a local East/North coordinate system. Its GPS position
measurements are noisy. A constant-velocity Kalman filter estimates
position and velocity from the noisy measurements.
"""

import numpy as np
import matplotlib.pyplot as plt

rng = np.random.default_rng(7)

dt = 1.0
n_steps = 100

# State vector: [x, y, vx, vy]
F = np.array(
    [
        [1, 0, dt, 0],
        [0, 1, 0, dt],
        [0, 0, 1, 0],
        [0, 0, 0, 1],
    ],
    dtype=float,
)

# Measurement vector: GPS observes [x, y]
H = np.array(
    [
        [1, 0, 0, 0],
        [0, 1, 0, 0],
    ],
    dtype=float,
)

# Process noise: unknown acceleration from wind and ocean current
acceleration_std = 0.12
G = np.array(
    [
        [0.5 * dt**2, 0],
        [0, 0.5 * dt**2],
        [dt, 0],
        [0, dt],
    ]
)
Q = (acceleration_std**2) * (G @ G.T)

# GPS measurement covariance
gps_std = 3.0
R = (gps_std**2) * np.eye(2)

# ----- Simulate true boat motion -----
true_states = np.zeros((n_steps, 4))
true_states[0] = [0, 0, 1.2, 0.5]

for k in range(1, n_steps):
    acceleration = np.array(
        [
            0.04 * np.sin(k / 12),
            0.035 * np.cos(k / 15),
        ]
    )
    true_states[k] = F @ true_states[k - 1] + G @ acceleration

# Noisy GPS position fixes
gps_measurements = true_states[:, :2] + rng.normal(0, gps_std, size=(n_steps, 2))

# ----- Kalman filter -----
x_est = np.array([gps_measurements[0, 0], gps_measurements[0, 1], 0, 0])
P = np.diag([gps_std**2, gps_std**2, 4.0, 4.0])
I = np.eye(4)

estimates = np.zeros((n_steps, 4))
estimates[0] = x_est

for k in range(1, n_steps):
    # Predict
    x_pred = F @ x_est
    P_pred = F @ P @ F.T + Q

    # Correct using the new GPS observation
    z = gps_measurements[k]
    innovation = z - H @ x_pred
    S = H @ P_pred @ H.T + R
    K = P_pred @ H.T @ np.linalg.inv(S)

    x_est = x_pred + K @ innovation
    P = (I - K @ H) @ P_pred
    estimates[k] = x_est

# ----- Evaluation -----
gps_error = np.linalg.norm(gps_measurements - true_states[:, :2], axis=1)
kf_error = np.linalg.norm(estimates[:, :2] - true_states[:, :2], axis=1)

print(f"GPS position RMSE:    {np.sqrt(np.mean(gps_error**2)):.2f} m")
print(f"Kalman position RMSE: {np.sqrt(np.mean(kf_error**2)):.2f} m")

# ----- Plots -----
plt.figure(figsize=(9, 6))
plt.plot(true_states[:, 0], true_states[:, 1], linewidth=2, label="True boat path")
plt.scatter(
    gps_measurements[:, 0], gps_measurements[:, 1], s=18, alpha=0.45, label="Noisy GPS"
)
plt.plot(estimates[:, 0], estimates[:, 1], linewidth=2, label="Kalman estimate")
plt.xlabel("East position (m)")
plt.ylabel("North position (m)")
plt.title("Boat localization with a Kalman filter")
plt.legend()
plt.grid(alpha=0.3)
plt.tight_layout()
plt.show()

plt.figure(figsize=(9, 4.5))
plt.plot(gps_error, alpha=0.75, label="GPS error")
plt.plot(kf_error, linewidth=2, label="Kalman-filter error")
plt.xlabel("Time step")
plt.ylabel("Position error (m)")
plt.title("Position error over time")
plt.legend()
plt.grid(alpha=0.3)
plt.tight_layout()
plt.show()
