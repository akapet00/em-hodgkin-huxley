`data` directory holds multiple simulated datasets generated using `generate_dataset.m` script.
Automatic data storing is enabled by adjusting `save_data` variable in `set_input.m` script as follows:
```matlab
save_data = true;
```

`figures` directory contains visualizations (`eps` and `fig` format) generated using various scripts in `src` directory.
Automatic figure storing is enabled by adjusting `save_figures` variable in `set_input.m` script as follows:
```matlab
save_figures = true;
```

`paper_figures` directory holds data and visualizations (`eps` format) for specific model configuration.
`paper_figures/entropy.py` script is used in order to obtain visualizations of deterministic models.
`paper_figures/memristor_compat.py` script is used to create a visual representation of the *iv* characteristic compatibility between the non-linear polynomial approximaton of the memrisotr and the physical realization of the memristor.
