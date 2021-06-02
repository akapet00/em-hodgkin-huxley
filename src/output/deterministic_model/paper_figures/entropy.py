import os

import matplotlib.pyplot as plt
from matplotlib.ticker import FormatStrFormatter
import numpy as np
from scipy.io import loadmat


MAT_PATH = 'entropy_tsim-1000_tIinj-0-1000_isPeriodic-0_T-6.3_k-0.1'


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


def load_data(mat_path, mat_variable):
    mat_path = os.path.join(os.pardir, 'data', mat_path)
    mat = loadmat(mat_path)
    return mat[mat_variable].ravel()


def main(showfig, savefig):
    t = load_data(MAT_PATH, 't')
    V = load_data(MAT_PATH, 'V')
    I = load_data(MAT_PATH, 'I')
    isi = load_data(MAT_PATH, 'isi')
    iqr = np.subtract(*np.percentile(isi, [75, 25]))
    bin_width = (2 * iqr) / np.power(isi.size, 1/3)
    isi_range = isi.max() - isi.min()
    n_bins = int((isi_range / bin_width) + 1)
    bin_step = isi_range / n_bins
    bins = np.arange(isi.min(), isi.max() + bin_step, bin_step)
    counts, _ = np.histogram(isi, bins=bins)
    p = counts / np.sum(counts)
    entropy = - np.sum(p[np.where(p > 0)] * np.log2(p[np.where(p > 0)]))
    print(f'{entropy = :.4f}')

    plotting_config(2, 2)
    fig = plt.figure()
    ax1 = plt.subplot2grid((3, 3), (0, 0), colspan=2, rowspan=2)
    ax1.plot(t, V, color='k')
    ax1.grid()
    ax1.set_ylabel('$V_m$ [mV]')
    ax2 = plt.subplot2grid((3, 3), (2, 0), colspan=2, sharex=ax1)
    ax2.plot(t, I, color='k')
    ax2.grid()
    ax2.set_xlabel('t [ms]')
    ax2.set_ylabel('$I_{ext}$ [$\\mu$A/cm$^2$]')
    ax3 = plt.subplot2grid((3, 3), (0, 2), rowspan=3)
    ax3.xaxis.set_major_formatter(FormatStrFormatter('%.2f'))
    counts, edges, _ = ax3.hist(isi, 'sqrt', color='k', edgecolor='w')
    ax3.set_xticks(edges[::3])
    ax3.set_xlabel('ISI [ms]')
    ax3.set_ylabel('count')
    ax3.set_title(f'$H = {entropy:.4f}$')
    plt.tight_layout()
    if showfig:
        plt.show()
    if savefig:
        fig.savefig(fname=f'{MAT_PATH}.eps', format='eps', bbox_inches='tight')


if __name__ == "__main__":
    showfig = True
    savefig = False
    main(showfig, savefig)
