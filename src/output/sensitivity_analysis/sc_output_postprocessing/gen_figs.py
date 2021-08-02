import os

import matplotlib.pyplot as plt
import numpy as np
from scipy.io import loadmat


DATA_PATH = 'SF_tsim-1000_tIinj-0-1000_A-5_noise-1_T-6.3_k-0-5'
K_LIST = np.linspace(0, 5, 50)
SCP_LIST = [3, 5, 7, 9]
CV_LIST = [5, 10, 20]


def plotting_config(ncols=1, nrows=1, font_size=10):
    plt.rcParams.update({
        'text.usetex': True,
        'font.family': 'serif',
        'font.size': font_size,
        'figure.figsize': (4.774 * ncols, 2.950 * nrows),
        'axes.labelsize': font_size,
        'axes.titlesize': font_size,
        'grid.linewidth': 0.5,
        'legend.fontsize': font_size,
        'xtick.labelsize': font_size,
        'ytick.labelsize': font_size,
    })


def load_data(ci, sc):
    mean_mat = loadmat(os.path.join(DATA_PATH, f'MEAN_CI{ci}_SC_{sc}.mat'))
    var_mat = loadmat(os.path.join(DATA_PATH, f'VAR_CI{ci}_SC_{sc}.mat'))
    skew_mat = loadmat(os.path.join(DATA_PATH, f'SKEW_CI{ci}_SC_{sc}.mat'))
    kurt_mat = loadmat(os.path.join(DATA_PATH, f'KURT_CI{ci}_SC_{sc}.mat'))
    return (mean_mat, var_mat, skew_mat, kurt_mat)


def singleview(showfig=True, savefig=False):
    plotting_config(font_size=14.4)
    sc = 5
    for cv in CV_LIST:
        data = load_data(cv, sc)
        mean_SF = data[0]['M'].ravel()
        var_SF = data[1]['V'].ravel()
        lb = mean_SF - 2 * np.sqrt(var_SF)
        ub = mean_SF + 2 * np.sqrt(var_SF)
        fig, ax = plt.subplots()
        ax.set(xticks=[0.0, 1.0, 2.0, 3.0, 4.0, 5.0])
        ax.plot(K_LIST, mean_SF, color='black', label=f'SF $(k)$')
        ax.fill_between(K_LIST, lb, ub, color='lightgray', label=f'$95$\% CI, CV = ${cv}$\%')
        ax.set_xlabel('$k$')
        ax.set_ylabel('SF $(k)$ [Hz]')
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
            ax[cv_idx, sc_idx].plot(K_LIST, mean_mISI, color='black', label=f'$\\langle$SF$\\rangle$, ${sc}$ SC points%')
            ax[cv_idx, sc_idx].fill_between(K_LIST, lb, ub, color='lightgray', label=f'$95$% CI, CV = ${cv}$')
            if cv_idx == nrows-1:
                ax[cv_idx, sc_idx].set_xlabel('$k$')
            if sc_idx == 0:
                ax[cv_idx, sc_idx].set_ylabel('$SF (k)$')
            ax[cv_idx, sc_idx].legend(loc='best')
    plt.tight_layout()
    if showfig:
        plt.show()
    if savefig:
        fig.savefig(fname=os.path.join('figures', f'{DATA_PATH}_multiview.eps'), format='eps', bbox_inches='tight')


def sc_convergence(showfig=True, savefig=False):
    figmarks = ['ko-', 'ks-', 'k^:', 'kv:']
    nfigs = len(CV_LIST)
    plotting_config(nfigs, 2, font_size=16)
    fig, ax = plt.subplots(2, nfigs, sharex=True, squeeze=True)
    ax[-1, 0].set(xticks=[0.0, 1.0, 2.0, 3.0, 4.0, 5.0])
    for cv_idx, cv in enumerate(CV_LIST):
        for sc_idx, sc in enumerate(SCP_LIST):
            data = load_data(cv, sc)
            mean_SF = data[0]['M'].ravel()
            var_SF = data[1]['V'].ravel()
            ax[0, cv_idx].plot(K_LIST, mean_SF, figmarks[sc_idx], markevery=2, label=f'${sc}$ SC points')
            ax[0, cv_idx].set_title(f'CV = ${cv}$\%')
            ax[1, cv_idx].plot(K_LIST, var_SF, figmarks[sc_idx], markevery=2, label=f'${sc}$ SC points')
            ax[1, cv_idx].set_xlabel('$k$')
            if cv_idx == 0:
                ax[0, cv_idx].set_ylabel('$\\langle$SF$\\rangle(k)$')
                ax[1, cv_idx].set_ylabel('$Var($SF$)(k)$')
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
    plotting_config(nfigs, 2, font_size=16)
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
    ax[0, -1].legend(['$S_1(\\bar{g}_\\mathrm{Na})$', '$S_1(\\bar{g}_\\mathrm{K})$', '$S_1(\\bar{g}_{L})$', '$S_2(\\bar{g}_\\mathrm{Na}, \\bar{g}_\\mathrm{K})$', '$S_2(\\bar{g}_\\mathrm{Na}, \\bar{g}_{L})$', '$S_2(\\bar{g}_\\mathrm{K}, \\bar{g}_{L})$'], loc='center right', bbox_to_anchor=(1.6, 0.5))
    ax[1, -1].legend(['$S_t(\\bar{g}_\\mathrm{Na})$', '$S_t(\\bar{g}_\\mathrm{K})$', '$S_t(\\bar{g}_{L})$'], loc='center right', bbox_to_anchor=(1.5, 0.5))
    plt.tight_layout()
    if showfig:
        plt.show()
    if savefig:
        fig.savefig(fname=os.path.join('figures', f'{DATA_PATH}_anova_SC_{sc}.eps'), format='eps', bbox_inches='tight')


if __name__ == "__main__":
    showfig = False
    savefig = True
    # singleview(showfig, savefig)
    # multiview(showfig, savefig)
    # sc_convergence(showfig, savefig)
    anova(showfig, savefig)
