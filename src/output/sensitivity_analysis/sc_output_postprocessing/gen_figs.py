import os

import matplotlib.pyplot as plt
import numpy as np
from scipy.io import loadmat


DATA_PATH = 'mean_ISI_tsim-300_tIinj-0-300_A-10_noise-0_T-15_k-0-2'
K_LIST = np.linspace(0, 2, 50)
SCP_LIST = [3, 5, 7, 9]
CV_LIST = [5, 10, 20]


def plotting_config(ncols=1, nrows=1):
    plt.rcParams.update({
        'text.usetex': True,
        'font.family': 'serif',
        'font.size': 10,
        'figure.figsize': (4.774 * ncols, 2.950 * nrows),
        'axes.labelsize': 10,
        'axes.titlesize': 10,
        'grid.linewidth': 0.5,
        'legend.fontsize': 10,
        'xtick.labelsize': 10,
        'ytick.labelsize': 10,
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
        var_mISI = data[1]['V'].ravel()
        lb = mean_mISI - 2 * np.sqrt(var_mISI)
        ub = mean_mISI + 2 * np.sqrt(var_mISI)
        fig, ax = plt.subplots()
        #ax.set(xticks=[0.0, 1.0, 2.0, 3.0, 4.0, 5.0])
        ax.plot(K_LIST, mean_mISI, color='black', label=f'$\\langle$mISI$\\rangle$')
        ax.fill_between(K_LIST, lb, ub, color='lightgray', label=f'$95$\% CI, CV = ${cv}$\%')
        ax.set_xlabel('$k$')
        ax.set_ylabel('mISI $(k)$ [ms]')
        ax.legend(loc='best')
        #plt.tight_layout()
        if showfig:
            plt.show()
        if savefig:
            fig.savefig(fname=os.path.join('figures', f'{DATA_PATH}_singleview_CI{cv}_SC_{sc}.eps'), format='eps', bbox_inches='tight')


def multiview(showfig=True, savefig=False):
    nrows = len(CV_LIST)
    ncols = len(SCP_LIST)
    plotting_config(nrows, ncols)
    fig, ax = plt.subplots(nrows, ncols, sharex=True, sharey=True, squeeze=True)
    for cv_idx, cv in enumerate(CV_LIST):
        for sc_idx, sc in enumerate(SCP_LIST):
            data = load_data(cv, sc) 
            mean_mISI = data[0]['M'].ravel()
            var_mISI = data[1]['V'].ravel()
            lb = mean_mISI - 2 * np.sqrt(var_mISI)
            ub = mean_mISI + 2 * np.sqrt(var_mISI)
            ax[cv_idx, sc_idx].plot(K_LIST, mean_mISI, color='black', label=f'$\\langle mISI \\rangle$, ${sc}$ SC points%')
            ax[cv_idx, sc_idx].fill_between(K_LIST, lb, ub, color='lightgray', label=f'$95$% CI, CV = ${cv}$')
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
    #ax[-1, 0].set(xticks=[0.0, 1.0, 2.0, 3.0, 4.0, 5.0])
    for cv_idx, cv in enumerate(CV_LIST):
        for sc_idx, sc in enumerate(SCP_LIST):
            data = load_data(cv, sc)
            mean_mISI = data[0]['M'].ravel()
            var_mISI = data[1]['V'].ravel()
            # skew_mISI = data[2]['S'].ravel()
            # kurt_mISI = data[3]['K'].ravel()
            ax[0, cv_idx].plot(K_LIST, mean_mISI, figmarks[sc_idx], markevery=2, label=f'${sc}$ SC points')
            ax[0, cv_idx].set_title(f'CV = ${cv}$\%')
            ax[1, cv_idx].plot(K_LIST, var_mISI, figmarks[sc_idx], markevery=2, label=f'${sc}$ SC points')
            # ax[2, cv_idx].plot(K_LIST, skew_mISI, figmarks[sc_idx], markevery=2, label=f'$Skew(mISI)$, ${sc}$ SC points')
            # ax[3, cv_idx].plot(K_LIST, kurt_mISI, figmarks[sc_idx], markevery=2, label=f'$Kurt(mISI)$, ${sc}$ SC points')
            ax[1, cv_idx].set_xlabel('$k$')
            if cv_idx == 0:
                ax[0, cv_idx].set_ylabel('$\\langle$mISI$\\rangle(k)$ [ms]')
                ax[1, cv_idx].set_ylabel('$Var($mISI$)(k)$ [ms]')
                # ax[2, cv_idx].set_ylabel('$Skew(mISI)(k)$ [ms]')
                # ax[3, cv_idx].set_ylabel('$Kurt(mISI)(k)$ [ms]')
    handles, labels = [l for l in ax[0, cv_idx].get_legend_handles_labels()]
    fig.legend(handles, labels, bbox_to_anchor=(0.815, 1.025), ncol=4)
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
        ax[0, cv_idx].set_title(f'CV = ${cv}$\%')
        ax[1, cv_idx].plot(K_LIST, data[:, 6:])
        ax[1, cv_idx].set_xlabel('$k$')
        if cv_idx == 0:
            ax[0, cv_idx].set_ylabel('$1^{st}$ and $2^{nd}$ order')
            ax[1, cv_idx].set_ylabel('total effect')
    ax[-1, 0].set(xticks=[0.0, 1.0, 2.0, 3.0, 4.0, 5.0])
    ax[0, -1].legend(['$S_1(g_{Na})$', '$S_1(g_{K})$', '$S_1(g_{L})$', '$S_2(g_{Na}, g_{K})$', '$S_2(g_{Na}, g_{L})$', '$S_2(g_{K}, g_{L})$'], loc='center right', bbox_to_anchor=(1.6, 0.5))
    ax[1, -1].legend(['$S_t(g_{Na})$', '$S_t(g_{K})$', '$S_t(g_{L})$'], loc='center right', bbox_to_anchor=(1.5, 0.5))
    plt.tight_layout()
    if showfig:
        plt.show()
    if savefig:
        fig.savefig(fname=os.path.join('figures', f'{DATA_PATH}_anova_SC_{sc}.eps'), format='eps', bbox_inches='tight')


if __name__ == "__main__":
    showfig = False
    savefig = True
    singleview(showfig, savefig)
    # multiview(showfig, savefig)
    # sc_convergence(showfig, savefig)
    # anova(showfig, savefig)
