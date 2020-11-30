from itertools import cycle
import os

import matplotlib.pyplot as plt
import numpy as np
from scipy.io import loadmat


DATA_PATH = 'tsim-300_tIinjstop-300_T-15_k-0-2'
K_LIST = np.linspace(0, 2, 50)
SCP_LIST = [3, 5, 7, 9]
VAR_LIST = [5, 10, 20, 50]


def plotting_config(nrows=1, ncols=1):
    plt.style.use('seaborn-paper')
    plt.rcParams.update({
        'text.usetex': False,
        'font.family': 'serif',
        'font.size': 10,
        'axes.labelsize': 10,
        'grid.linewidth': 0.7,
        'legend.fontsize': 8,
        'xtick.labelsize': 8,
        'ytick.labelsize': 8,
        'figure.figsize': [4.774*nrows, 2.950*ncols],
        'figure.max_open_warning': 120,
    })


def load_data(ci, sc):
    mean_mat = loadmat(os.path.join(DATA_PATH, f'MEAN_CI{ci}_SC_{sc}.mat'))
    var_mat = loadmat(os.path.join(DATA_PATH, f'VAR_CI{ci}_SC_{sc}.mat'))
    return mean_mat, var_mat


def multiview(savefig=False):
    nrows = len(VAR_LIST)
    ncols = len(SCP_LIST)
    plotting_config(nrows, ncols)
    fig, ax = plt.subplots(nrows, ncols, sharex=True, sharey=True,
        squeeze=True)
    for ci_idx, ci in enumerate(VAR_LIST):
        for sc_idx, sc in enumerate(SCP_LIST):
            data = load_data(ci, sc) 
            mean_mISI = data[0]['M'].ravel()
            var_mISI = data[1]['V'].ravel()
            lb = mean_mISI - np.sqrt(var_mISI)
            ub = mean_mISI + np.sqrt(var_mISI)
            ax[ci_idx, sc_idx].plot(K_LIST, mean_mISI, color='black',
                label=f'$\\langle mISI \\rangle$, {sc} SC points')
            ax[ci_idx, sc_idx].fill_between(K_LIST, lb, ub, color='lightgray',
                label=f'{ci}% CI')
            if ci_idx == nrows-1:
                ax[ci_idx, sc_idx].set_xlabel('$k$')
            if sc_idx == 0:
                ax[ci_idx, sc_idx].set_ylabel('$mISI (k)$ [ms]')
            ax[ci_idx, sc_idx].legend(loc='best')
    plt.tight_layout()
    plt.show()
    if savefig:
        fig.savefig(fname=os.path.join('figures', f'{DATA_PATH}_multiview.eps'),
            format='eps', bbox_inches='tight')


def sc_convergence(savefig=False):
    figmarks = ['ko-', 'ks-', 'k^:', 'kv:']
    nfigs = len(VAR_LIST)
    plotting_config(nfigs, 2)
    fig, ax = plt.subplots(2, nfigs, sharex=True, squeeze=True)
    for ci_idx, ci in enumerate(VAR_LIST):
        for sc_idx, sc in enumerate(SCP_LIST):
            data = load_data(ci, sc) 
            mean_mISI = data[0]['M'].ravel()
            var_mISI = data[1]['V'].ravel()
            ax[0, ci_idx].plot(K_LIST, mean_mISI, figmarks[sc_idx], markevery=5,
                label=f'$\\langle mISI \\rangle$, {sc} SC points')
            ax[1, ci_idx].plot(K_LIST, var_mISI, figmarks[sc_idx], markevery=5,
                label=f'$Var(mISI)$, {sc} SC pts')
            ax[1, ci_idx].set_xlabel('$k$')
            if ci_idx == 0:
                ax[0, ci_idx].set_ylabel('$mISI (k)$ [ms]')
                ax[1, ci_idx].set_ylabel('$Var(mISI)(k)$ [ms]')
            ax[0, ci_idx].legend(loc='best')
            ax[1, ci_idx].legend(loc='best')           
    plt.tight_layout()
    plt.show()
    if savefig:
        fig.savefig(fname=os.path.join('figures', f'{DATA_PATH}_convergence.eps'),
            format='eps', bbox_inches='tight')


def anova(savefig=False):
    from cycler import cycler
    plt.rcParams.update({
        'axes.prop_cycle': cycler('linestyle', ['-', '--', ':'])})
    nfigs = len(VAR_LIST)
    plotting_config(nfigs, 3)
    fig, ax = plt.subplots(3, nfigs, sharex=True, sharey=True, squeeze=True)
    sc = 5
    for ci_idx, ci in enumerate(VAR_LIST):
        data = loadmat(os.path.join(DATA_PATH, 
            f'SA_ANOVA_indices_CI{ci}_SC_{sc}.mat'))['SS']
        ax[0, ci_idx].plot(K_LIST, data[:, :3], markevery=5)
        ax[0, ci_idx].legend(['$g_{Na}$', '$g_{K}$', '$g_{L}$'])
        ax[1, ci_idx].plot(K_LIST, data[:, 3:6], markevery=5)
        ax[1, ci_idx].legend(['$g_{Na}$ $g_{K}$', '$g_{Na}$ $g_{L}$',
            '$g_{K}$ $g_{L}$'])
        ax[2, ci_idx].plot(K_LIST, data[:, 6:], markevery=5)
        ax[2, ci_idx].set_xlabel('$k$')
        ax[2, ci_idx].legend(['$g_{Na}$', '$g_{K}$', '$g_{L}$'], loc='lower right')
        if ci_idx == 0:
            ax[0, ci_idx].set_ylabel('$1^{st}$ order sensitivity')
            ax[1, ci_idx].set_ylabel('$2^{nd}$ order sensitivity')
            ax[2, ci_idx].set_ylabel('total effect sensitivity')
    plt.tight_layout()
    plt.show()
    if savefig:
        fig.savefig(fname=os.path.join('figures', f'{DATA_PATH}_anova.eps'),
            format='eps', bbox_inches='tight')


if __name__ == "__main__":
    savefig = True
    multiview(savefig)
    sc_convergence(savefig)
    anova(savefig)