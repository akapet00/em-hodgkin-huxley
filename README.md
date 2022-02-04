Code for the paper:

# Stochastic analysis of the electromagnetic induction effect on a neuron's action potential dynamics

## Authors
[Ante Lojic Kapetanovic](http://adria.fesb.hr/~alojic00/), Anna Susnjara, Dragan Poljak

## Abstract
The presence of time-varying electromagnetic fields across a neuron cell may cause changes in its electrical characteristics, most notably, in the action potential dynamics. This phenomenon is examined by simulating electrophysiology of a single cortex neuron. Magnetic flux is captured by using a polynomial approximation of a memristor embedded into Hodgkin–Huxley model, equivalent electrical circuit of a neuron cell. Bifurcation analysis is carried out for two different electrical modes associated with the nature of the external neuronal stimulus. Aiming to determine the true influence of the variability of ion channels conductivity, the stochastic sensitivity analysis is undertaken post hoc. Additionally, numerical simulations are enriched with uncertainty quantification, observing values of ion channel conductivity as random variables. The aim of the study is to computationally determine the sensitivity of the action potential dynamics with respect to changes in conductivity of each ion channel so that the future experimental procedures, most often medical treatments, may be adapted to different individuals in various environmental conditions.

## Citation
The article is freely available online: https://link.springer.com/article/10.1007%2Fs11071-021-06762-z

To cite, please use the following:

    Lojić Kapetanović, A., Šušnjara, A. & Poljak, D. Stochastic analysis of the electromagnetic induction effect on a neuron’s action potential dynamics. Nonlinear Dyn 105, 3585–3602 (2021). https://doi.org/10.1007/s11071-021-06762-z

or in bibtex format:
```
@article{Kapetanovic2021Stochastic,
    author={Loji{\'{c}} Kapetanovi{\'{c}}, Ante
    and {\v{S}}u{\v{s}}njara, Anna
    and Poljak, Dragan},
    title={Stochastic analysis of the electromagnetic induction effect on a neuron's action potential dynamics},
    journal={Nonlinear Dynamics},
    volume={105},
    issue={4},
    year={2021},
    pages={3585-3602},
    issn={1573-269X},
    doi={10.1007/s11071-021-06762-z},
    url={https://doi.org/10.1007/s11071-021-06762-z}
}
```

## Reproduce the results
Go to `src` directory using MATLAB (version R2020a/b recommended, prerequisites include Machine Learning Toolbox and Signal Processing Toolbox).

Set Hodgkin-Huxley neuron model electrical constants, its initial conditions and additional induction parameters considering external magnetic field source in `set_input.m` script.
Furthermore, set the simulation time and stimulation current shape and period.

`generate_dataset.m` should not be changed and is used only for data generation.

Run any script that is titled `run_`<`x`>`.m` where `x` is one of the following:
* `main` - calculate and visualize the membrane potential dynamics, gating variables and limit cycles of a neuron stimulated with a constant injected current;
* `multiple` - compute and visualize the membrane potential dynamics for different scenarios (different temperatures with or without electromagnetic induction taken into account);
* `isi` - bifurcation analysis, interspike interval (ISI) for a different scenarios considering multiple values of induction coefficient and several temperatures
* `isi_ci` - generate data for sensitivity analysis regarding dynamics of either ISI or spike frequency (added after the first reviews of the article) for different values of ion channel conductance;
* `entropy` - calculate entropy from ISI probability mass (and density) function for cases with noisy periodic and constant dc stimulus, respectively;
* `activity_modes` - neuronal dynamics in two exposure scenarios (no magnetic fields vs. strong magnetic field). In the both cases considered in this script, the input current is not sufficiently strong to cause spiking on its own - neuron's threshold is not reached.

Generated data and figures are stored into `output` directory, which holds two subsequent directories:
* `deterministic_model`, the data and figures generated from the deterministic Hodgkin-Huxley model, more details in `README` file in the directory;
* and `sensitivity_analysis`, the data obtained via the stochastic collocation method where ion channel conductance values are taken as random variables, more details in `README` file in the directory.

## Contact
[Ante Lojic Kapetanovic](http://adria.fesb.hr/~alojic00/) via alojic00@fesb.hr.

## License
[MIT](https://github.com/antelk/em-hodgkin-huxley/blob/main/LICENSE)
