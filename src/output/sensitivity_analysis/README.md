`sc_input` directory constains `mat` files containing multiple combinations of conductivities of ion channels generated using stochastic collocation where conductivities are taken as random variables with 5, 10, 20 and 50 percent variability, respectively.

`sc_output` directory contains `mat` files with the Hodgkin-Huxley model output for different sodium, potassium and leakage ion channel conductivities. Due to the number and the size of files, they are not available on GitHub. However, they are available [on demand](mailto:alojic00@fesb.hr).

`sc_output_postprocessing` directory contains processed data from `sc_output` specific experiment and visualizations (`eps` format) of processed data. `gen_figs.py` script is used in order to obtain visualizations.

The code used for stochastic analysis is in-house code by Anna Susnjara, but is not available on GitHub nor is open-source anywhere else. It is available on demand either through [me](mailto:alojic00@fesb.hr) or directly through [Anna](mailto:ansusnja@fesb.hr).