import os

import matplotlib.pyplot as plt
import numpy as np
from scipy.io import loadmat


MAT_PATH = 'entropy_tsim-1500_tIinj-0-1500_isPeriodic-0_T-6.3_k-0.1'


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


def load_data(mat_path, mat_variable):
    mat = loadmat(mat_path)
    return mat[mat_variable].ravel()


def main(showfig, savefig):
    t = load_data(MAT_PATH, 't')
    V = load_data(MAT_PATH, 'V')
    I = load_data(MAT_PATH, 'I')
    isi = load_data(MAT_PATH, 'isi')
    iqr = np.percentile(isi, 75) - np.percentile(isi, 25)
    n_bins = (isi.max() - isi.min()) / (2 * iqr * np.power(isi.size, -1/3))
    hist, edges = np.histogram(isi, bins=int(n_bins))
    bins = edges[:-1] + (edges[1] - edges[0]) / 2
    p = hist / np.sum(hist)
    entropy = - np.sum(p[np.where(p != 0)] * np.log(p[np.where(p != 0)]))

    plotting_config(1.5, 1.5)
    fig = plt.figure()
    ax1 = plt.subplot2grid((3, 3), (0, 0), colspan=2, rowspan=2)
    ax1.plot(t, V , color='k')
    ax1.grid()
    ax1.set_ylabel('$V_m$ [mV]')
    ax2 = plt.subplot2grid((3, 3), (2, 0), colspan=2, sharex=ax1)
    ax2.plot(t, I, color='k')
    ax2.grid()
    ax2.set_xlabel('t [ms]')
    ax2.set_ylabel('$I_{ext}$ [$\\mu$A/cm$^2$]')
    ax3 = plt.subplot2grid((3, 3), (0, 2), rowspan=3)
    ax3.bar(bins, p, 40.0/n_bins, color='black')
    ax3.set_xlabel('ISI [ms]')
    ax3.set_ylabel('PMF')
    ax3.set_title(f'$H = {round(entropy, 4)}$')
    plt.tight_layout()
    if showfig:
        plt.show()
    if savefig:
        fig.savefig(fname=f'{MAT_PATH}.eps', format='eps', bbox_inches='tight')

if __name__ == "__main__":
    showfig = False
    savefig = True
    main(showfig, savefig)