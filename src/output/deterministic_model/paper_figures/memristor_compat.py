"""Comparison between I-V curves obtained by using the smooth nonlinear
memristance approximation function introduced in the study by Bao, B.
C.; Liu, Z. and Xu, J. P.: Steady periodic memristor oscillator with
transient chaotic behaviours, Electronic Letters, doi:
10.1049/el.2010.3114, and by using the formulation that outlines the
actual physical memristive device, introduced in the study by Joglekar,
Y. N. and Wolf S.: The elusive memristor: properties of basic
electrical circuits, European Journal of Physics 30, doi:
10.1088/0143-0807/30/4/001. Parameters in the memristance formulation
by Joglekar et al. are fitted using the ideal memristance defined in
the formulation by Bao et al.
Author: Ante Lojic Kapetanovic
"""

import matplotlib.pyplot as plt
import numpy as np
from scipy.optimize import minimize


def plotting_config(nrows=1, ncols=1):
    """Setup configuration for paper quality figures.

    Parameters
    ----------
    nrows : int
        Number of subplots row-wise.
    ncols : int
        Number of subplots column-wise.

    Returns
    -------
    None
    """
    plt.rcParams.update({
        'text.usetex': True,
        'font.family': 'serif',
        'font.size': 16,
        'figure.figsize': (4.774 * ncols, 2.950 * nrows),
        'axes.labelsize': 16,
        'axes.titlesize': 16,
        'grid.linewidth': 0.5,
        'legend.fontsize': 16,
        'xtick.labelsize': 16,
        'ytick.labelsize': 16,
    })


def mse(true, fit):
    """Return mean square error between true and fit data.

    Parameters
    ----------
    true : float or numpy.ndarray
        measured data
    fit : float or numpy.ndarray
        fitted data

    Returns
    -------
    float
        mean square error between true and fit data
    """
    return np.mean(np.power(true - fit, 2))


def mae(true, fit):
    """Return mean absolute error between true and fit data.

    Parameters
    ----------
    true : float or numpy.ndarray
        measured data
    fit : float or numpy.ndarray
        fitted data

    Returns
    -------
    float
        mean absolute error between true and fit data
    """
    return np.mean(np.abs(true - fit))


def W(phi, a, b):
    """Return memductance, W(phi), obtained as dq(phi)/dphi.
    This function is introduced as smooth continuous squared
    monotone-increasing nonlinear approximation function for the actual
    memductance of a physical memristive device or system.

    Parameters
    ----------
    phi : float
        flux-linkage
    a : float
        function constant
    b : float
        function constant
    Returns
    -------
    float
        the slope of flux-linkage
    """
    return a + 3 * b * phi ** 2


def generate_memristance(phi, D, u_d, R_on):
    """Return memristance of a physical memrsitive device or system as
    a function of time assuming the device is phi-controlled.

    Parameters
    ----------
    phi : numpy.ndarray
        flux time series, [Vs] or [Wb]
    D : float
        memristor's length, [m]
    u_d : float
        the mobility of dopants, [m^2/Vs]
    R_on : float
        resistance of the fully doped memristor, [Ohm]
    R_off : float
        resistance of the memristor if it is undoped, [Ohm]

    Returns
    -------
    numpy.ndarray
        effective resistance of the memristor over time, [Ohm]
    """
    w_0 = D / 5  # init length of the doped region, [m]
    R_off = 20 * R_on  # resistance of the fully undoped memristor, [Ohm]
    R_d = R_off - R_on  # resistance difference between regions, [Ohm]
    R_0 = R_on * (w_0 / D) + R_off * (1 - w_0 / D)  # init resistance, [Ohm]
    Q_0 = D ** 2 / (u_d * R_on)  # initial charge of dopant, [Coulomb]
    return R_0 * np.sqrt(1 + 2 * R_d * phi / (Q_0 * R_0 ** 2))


def loss(params, memristance, phi):
    """Return loss as l-2 norm between the theoretical memristance
    obtained via nonlinear approximation function and the memristance
    of an observed physical device or system.

    Parameters
    ----------
    params : tuple
        free parameters of the `generate_memristance` function that are
        fitted
    memristance : numpy.ndarray
        theoretical memristance values
    phi : numpy.ndarray
        flux time series
    Returns
    -------
    float
        loss function value for a given iteration
    """
    return mse(memristance, generate_memristance(phi, *params))


def main(showfig, savefig):
    # configure simulation time
    tau = 0.01
    t = np.arange(0, 100, step=tau)

    # generate sinusodial voltage and flux linkage
    omega = 1
    V_0 = 1
    v = V_0 * np.sin(omega * t)
    phi = V_0 / omega * (1 - np.cos(omega * t))

    # theoretical memristance approximation
    a = 0.4
    b = 0.02
    M = 1 / W(phi, a, b)

    # unbounded minimization procedure
    res = minimize(fun=loss,
                   x0=(10e-8, 1e-14, 10),
                   args=(M, phi),
                   method='Nelder-Mead',
                   options={'xtol': 1e-8})
    opt_params = res.x
    print('Flux controled memristive device configuration:',
          f'\n D    = {opt_params[0]:3e} Ohm',
          f'\n u_d  = {opt_params[1]:3e} m^2/Vs',
          f'\n R_on = {opt_params[2]:3e} Ohm')
    M_fit = generate_memristance(phi, *opt_params)

    # visualization of iv curves
    i = v / M
    i_fit = v / M_fit

    plotting_config(nrows=1.5, ncols=1.5)
    fig, ax = plt.subplots()
    ax.plot(v, i, '-', color='gray', linewidth=2.5,
            label='polynomial approximation\nBao, Liu and Xu 2010')
    ax.plot(v, i_fit, c='black', linewidth=4, dashes=[3, 100],
            label='physical realization\nJoglekar and Wolf 2009')
    ax.set_xlabel('$v$ [V]')
    ax.set_ylabel('$i$ [A]')
    ax.legend(loc='best')
    ax.grid()
    if showfig:
        plt.show()
    if savefig:
        plt.tight_layout()
        fig.savefig(fname='memristor_compat.eps', format='eps')


if __name__ == "__main__":
    showfig = False
    savefig = True
    main(showfig, savefig)
