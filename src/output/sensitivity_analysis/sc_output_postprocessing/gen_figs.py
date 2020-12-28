import os

import matplotlib.pyplot as plt
import numpy as np
from scipy.io import loadmat


DATA_PATH = 'mean_ISI_tsim-300_tIinj-0-300_A-10_noise-0_T-15_k-0-2'
K_LIST = np.linspace(0, 2, 50)
SCP_LIST = [3, 5, 7, 9]
CV_LIST = [5, 10, 20]


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
    })


def load_data(ci, sc):
    mean_mat = loadmat(os.path.join(DATA_PATH, f'MEAN_CI{ci}_SC_{sc}.mat'))
    var_mat = loadmat(os.path.join(DATA_PATH, f'VAR_CI{ci}_SC_{sc}.mat'))
    skew_mat = loadmat(os.path.join(DATA_PATH, f'SKEW_CI{ci}_SC_{sc}.mat'))
    kurt_mat = loadmat(os.path.join(DATA_PATH, f'KURT_CI{ci}_SC_{sc}.mat'))
    return (mean_mat, var_mat, skew_mat, kurt_mat)


def singleview(showfig=True, savefig=False):
    plotting_config()
    sc = 5
    for cv in CV_LIST:
        data = load_data(cv, sc)
        mean_mISI = data[0]['M'].ravel()
        var_mISI = data [1]['V'].ravel()
        lb = mean_mISI - np.sqrt(var_mISI)
        ub = mean_mISI + np.sqrt(var_mISI)
        fig, ax = plt.subplots()
        ax.plot(K_LIST, mean_mISI, color='black', label=f'$\\langle mISI \\rangle$, ${sc}$ SC points, $\\alpha = {cv}$%')
        ax.fill_between(K_LIST, lb, ub, color='lightgray', label='95% CI')
        ax.set_xlabel('$k$')
        ax.set_ylabel('$mISI (k)$ [ms]')
        ax.legend(loc='best')
        plt.tight_layout()
        if showfig:
            plt.show()
        if savefig:
            fig.savefig(fname=os.path.join('figures', f'{DATA_PATH}_singleview_CI{cv}_SC_{sc}.eps'), format='eps', bbox_inches='tight')

            
def multiview(showfig=True, savefig=False):
    nrows = len(CV_LIST)
    ncols = len(SCP_LIST)
    plotting_config(nrows, ncols)
    fig, ax = plt.subplots(nrows, ncols, sharex=True, sharey=True,
        squeeze=True)
    for cv_idx, cv in enumerate(CV_LIST):
        for sc_idx, sc in enumerate(SCP_LIST):
            data = load_data(cv, sc) 
            mean_mISI = data[0]['M'].ravel()
            var_mISI = data[1]['V'].ravel()
            lb = mean_mISI - np.sqrt(var_mISI)
            ub = mean_mISI + np.sqrt(var_mISI)
            ax[cv_idx, sc_idx].plot(K_LIST, mean_mISI, color='black', label=f'$\\langle mISI \\rangle$, ${sc}$ SC points, $\\alpha = {cv}$%')
            ax[cv_idx, sc_idx].fill_between(K_LIST, lb, ub, color='lightgray', label='95% CI')
            if cv_idx == nrows-1:
                ax[cv_idx, sc_idx].set_xlabel('$k$')
            if sc_idx == 0:
                ax[cv_idx, sc_idx].set_ylabel('$mISI (k)$ [ms]')
            ax[cv_idx, sc_idx].legend(loc='best')
    plt.tight_layout()
    if showfig:
        plt.show()
    if savefig:
        fig.savefig(fname=os.path.join('figures', f'{DATA_PATH}_multiview.eps'), format='eps', bbox_inches='tight')


def sc_convergence(showfig=True, savefig=False):
    figmarks = ['ko-', 'ks-', 'k^:', 'kv:']
    nfigs = len(CV_LIST)
    plotting_config(nfigs, 2)
    fig, ax = plt.subplots(2, nfigs, sharex=True, squeeze=True)
    for cv_idx, cv in enumerate(CV_LIST):
        for sc_idx, sc in enumerate(SCP_LIST):
            data = load_data(cv, sc) 
            mean_mISI = data[0]['M'].ravel()
            var_mISI = data[1]['V'].ravel()
            # skew_mISI = data[2]['S'].ravel()
            # kurt_mISI = data[3]['K'].ravel()
            ax[0, cv_idx].plot(K_LIST, mean_mISI, figmarks[sc_idx], markevery=2, label=f'$\\langle mISI \\rangle$, ${sc}$ SC points')
            ax[0, cv_idx].set_title(f'$\\alpha = {cv}$%')
            ax[1, cv_idx].plot(K_LIST, var_mISI, figmarks[sc_idx], markevery=2, label=f'$Var(mISI)$, ${sc}$ SC points')
            # ax[2, cv_idx].plot(K_LIST, skew_mISI, figmarks[sc_idx], markevery=2, label=f'$Skew(mISI)$, ${sc}$ SC points')
            # ax[3, cv_idx].plot(K_LIST, kurt_mISI, figmarks[sc_idx], markevery=2, label=f'$Kurt(mISI)$, ${sc}$ SC points')
            ax[1, cv_idx].set_xlabel('$k$')
            if cv_idx == 0:
                ax[0, cv_idx].set_ylabel('$mISI (k)$ [ms]')
                ax[1, cv_idx].set_ylabel('$Var(mISI)(k)$ [ms]')
                # ax[2, cv_idx].set_ylabel('$Skew(mISI)(k)$ [ms]')
                # ax[3, cv_idx].set_ylabel('$Kurt(mISI)(k)$ [ms]')
            ax[0, cv_idx].legend(loc='best')
            ax[1, cv_idx].legend(loc='best')  
            # ax[2, cv_idx].legend(loc='best')
            # ax[3, cv_idx].legend(loc='best')           
    plt.tight_layout()
    if showfig:
        plt.show()
    if savefig:
        fig.savefig(fname=os.path.join('figures', f'{DATA_PATH}_convergence.eps'), format='eps', bbox_inches='tight')


def anova(showfig=True, savefig=False):
    from cycler import cycler
    plt.rcParams.update({'axes.prop_cycle': cycler('linestyle', ['-', ':', '--'])})
    nfigs = len(CV_LIST)
    plotting_config(nfigs, 2)
    sc = 5
    fig, ax = plt.subplots(2, nfigs, sharex=True, sharey=True, squeeze=True)
    for cv_idx, cv in enumerate(CV_LIST):
        data = loadmat(os.path.join(DATA_PATH, f'SA_ANOVA_indices_CI{cv}_SC_{sc}.mat'))['SS']
        ax[0, cv_idx].plot(K_LIST, data[:, :3], color='black', linewidth=2)
        ax[0, cv_idx].plot(K_LIST, data[:, 3:6], color='gray', linewidth=1)
        ax[0, cv_idx].legend(['$g_{Na}$', '$g_{K}$', '$g_{L}$', '$g_{Na}$ $g_{K}$', '$g_{Na}$ $g_{L}$', '$g_{K}$ $g_{L}$'])
        ax[0, cv_idx].set_title(f'${sc}$ SC points, $\\alpha = {cv}$%')
        ax[1, cv_idx].plot(K_LIST, data[:, 6:])
        ax[1, cv_idx].set_xlabel('$k$')
        ax[1, cv_idx].legend(['$g_{Na}$', '$g_{K}$', '$g_{L}$'], loc='lower right')
        if cv_idx == 0:
            ax[0, cv_idx].set_ylabel('$1^{st}$ and $2^{nd}$ order sensitivity')
            ax[1, cv_idx].set_ylabel('total effect sensitivity')
    plt.tight_layout()
    if showfig:
        plt.show()
    if savefig:
        fig.savefig(fname=os.path.join('figures', f'{DATA_PATH}_anova_SC_{sc}.eps'), format='eps', bbox_inches='tight')


if __name__ == "__main__":
    showfig = False
    savefig = True
    singleview(showfig, savefig)
    multiview(showfig, savefig)
    sc_convergence(showfig, savefig)
    anova(showfig, savefig)