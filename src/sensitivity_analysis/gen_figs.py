from itertools import cycle
import os

import matplotlib.pyplot as plt
import numpy as np
from scipy.io import loadmat


DATA_PATH = os.path.join('sc_output',
    'sc_processed_tsim-300_tIinjstop-300_T-15_k-0-2')
FIG_PATH = os.path.join('figures',
    'sc_processed_tsim-300_tIinjstop-300_T-15_k-0-2')
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
        'figure.figsize': (4.774*nrows, 2.950*ncols),
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
            ax[ci_idx, sc_idx].plot(K_LIST, mean_mISI, label='<$mISI$>')
            ax[ci_idx, sc_idx].fill_between(K_LIST, lb, ub, alpha=0.2,
                label=f'{ci}% CI')
            if ci_idx == nrows-1:
                ax[ci_idx, sc_idx].set_xlabel('$k$')
            if sc_idx == 0:
                ax[ci_idx, sc_idx].set_ylabel('$mISI(k)$ [ms]')
            ax[ci_idx, sc_idx].legend(loc='best')
    plt.tight_layout()
    plt.show()
    if savefig:
        fig.savefig(fname=os.path.join(FIG_PATH, 'multiview.png'),
                format='png', bbox_inches='tight')


def sc_convergence(savefig=False):
    nfigs = len(VAR_LIST)
    plotting_config(nfigs, 2)
    fig, ax = plt.subplots(2, nfigs, squeeze=True)
    for ci_idx, ci in enumerate(VAR_LIST):
        for sc in SCP_LIST:
            data = load_data(ci, sc) 
            mean_mISI = data[0]['M'].ravel()
            var_mISI = data[1]['V'].ravel()
            ax[0, ci_idx].plot(K_LIST, mean_mISI, label=f'<$mISI$>, {sc} SC pts')
            ax[1, ci_idx].plot(K_LIST, var_mISI, label=f'$Var(mISI)$, {sc} SC pts')
            ax[1, ci_idx].set_xlabel('$k$')
            if ci_idx == 0:
                ax[0, ci_idx].set_ylabel('$mISI(k)$ [ms]')
                ax[1, ci_idx].set_ylabel('$Var(mISI)(k)$ [ms]')
            ax[0, ci_idx].legend(loc='best')
            ax[1, ci_idx].legend(loc='best')           
    plt.tight_layout()
    plt.show()
    if savefig:
        fig.savefig(fname=os.path.join(FIG_PATH, 'sc_convergence.png'),
                format='png', bbox_inches='tight')


def anova(savefig=False):
    nfigs = len(VAR_LIST)
    plotting_config(nfigs, 3)
    fig, ax = plt.subplots(3, nfigs, squeeze=True)
    sc = 5
    for ci_idx, ci in enumerate(VAR_LIST):
        data = loadmat(os.path.join(DATA_PATH, 
            f'SA_ANOVA_indices_CI{ci}_SC_{sc}.mat'))['SS']
        ax[0, ci_idx].plot(K_LIST, data[:, :3])
        ax[0, ci_idx].legend(['$g_{Na}$', '$g_{K}$', '$g_{L}$'])
        ax[1, ci_idx].plot(K_LIST, data[:, 3:6])
        ax[1, ci_idx].legend(['$g_{Na}$ $g_{K}$', '$g_{Na}$ $g_{L}$',
            '$g_{K}$ $g_{L}$'])
        ax[2, ci_idx].plot(K_LIST, data[:, 6:])
        ax[2, ci_idx].set_xlabel('$k$')
        ax[2, ci_idx].legend(['$g_{Na}$', '$g_{K}$', '$g_{L}$'], loc='lower right')
        if ci_idx == 0:
            ax[0, ci_idx].set_ylabel('$1^{st}$ order sensitivity')
            ax[1, ci_idx].set_ylabel('$2^{nd}$ order sensitivity')
            ax[2, ci_idx].set_ylabel('total effect sensitivity')
    plt.show()
    if savefig:
        fig.savefig(fname=os.path.join(FIG_PATH, 'anova.png'),
                format='png', bbox_inches='tight')


if __name__ == "__main__":
    savefig = True
    multiview(savefig)
    sc_convergence(savefig)
    anova(savefig)
