import os

import matplotlib.pyplot as plt
from matplotlib.ticker import FormatStrFormatter
import numpy as np
from scipy.io import loadmat


MAT_PATH = 'k1k2_influence_tsim-1000_tIinj-0-1000_isPeriodic-0_T-6.3_k-0.3.mat'


def plotting_config(nrows=1, ncols=1):
    plt.rcParams.update({
        'text.usetex': True,
        'font.family': 'serif',
        'font.size': 14,
        'figure.figsize': (4.774 * ncols, 2.950 * nrows),
        'lines.linewidth': 1,
        'axes.labelsize': 14,
        'axes.titlesize': 14,
        'grid.linewidth': 0.5,
        'legend.fontsize': 14,
        'xtick.labelsize': 14,
        'ytick.labelsize': 14,
    })


def load_data(mat_path):
    mat_path = os.path.join(os.pardir, 'data', mat_path)
    mat = loadmat(mat_path)
    return mat


def main(showfig, savefig):
    data = load_data(MAT_PATH)
    k1s = data['k1s'].ravel()
    k2s = data['k2s'].ravel()
    K1, K2 = np.meshgrid(k1s, k2s)
    mean_isis = data['mean_isis']
    mean_sfs = data['mean_sfs']

    plotting_config(1.5, 1.5)
    fig = plt.figure()
    ax = fig.add_subplot()
    c = ax.contourf(K1, K2, mean_sfs, 20, origin='lower')
    ax.set_xlabel('$k_1$')
    ax.set_ylabel('$k_2$')
    ax.xaxis.set_major_formatter(FormatStrFormatter('%.3f'))
    ax.yaxis.set_major_formatter(FormatStrFormatter('%.2f'))
    cbar = fig.colorbar(c)
    cbar.ax.set_ylabel('mSF [s]')
    plt.tight_layout()
    if showfig:
        plt.show()
    if savefig:
        fig.savefig(fname=f'{MAT_PATH}.eps', format='eps', bbox_inches='tight')


if __name__ == "__main__":
    showfig = False
    savefig = True
    main(showfig, savefig)
