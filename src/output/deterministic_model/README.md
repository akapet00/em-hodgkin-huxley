* `data` directory holds multiple simulated datasets generated using `generate_dataset.m` script (not available on GitHub due to the number and the size of files). Automatic data storing is enabled by adjusting `save_data` variable in `set_input.m` script as follows:
    ```matlab
    save_data = true;
    ```

* `figures` directory contains visualizations (`eps` and `fig` format) generated using various scripts in `src` directory. Automatic figure storing is enabled by adjusting `save_figures` variable in `set_input.m` script as follows:
    ```matlab
    save_figures = true;
    ```

* `paper_figures` directory holds data and visualizations (`eps` format) for specific model configuration. `paper_figures/entropy.py` script is used to visualize the entropy from ISI probability mass (and density) function for cases with noisy periodic and constant dc stimulus.
`paper_figures/memristor_compat.py` script is used to create a visual representation of the *iv* characteristic compatibility between the non-linear polynomial approximaton of the memristor and the physical realization of the memristor. Finally, `paper_figures/k1k2_2d_bifur.py` generates visualization of the distribution of mean spike frequency for different values of parameters that control the membrane potential-induced flux changes and the flux leakage, respectively.
