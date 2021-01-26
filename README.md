Code for the paper:

# Stochastic Sensitivity Analysis of the Effect of Electromagnetic Induction on a Cortex Neuron's Electrophysiology

## Abstract
This paper examines the effect of electromagnetic induction on the electrophysiology of a single cortex neuron through two different modes associated with the nature of the external neuronal stimulus.
By using the recently extended induction-based variant of the well-known and biologically plausible Hodgkin-Huxley neuron model, bifurcation analysis is performed.
In order to determine true influence of the variability of ion channels conductivity, the stochastic sensitivity analysis is performed *post hoc*.
Additionally, numerical simulations are enriched with uncertainty quantification, observing values of ion channels conductivity as random variables.
The aim of the study is to computationally determine the sensitivity of the action potential dynamics with respect to the changes in conductivity of each ion channel so that the future experimental procedures, most often medical treatments, may be adapted to different individuals in various environmental conditions.

## Run the experiments
Go to `src` directory using MATLAB (version R2020a/b recommended, prereqs include Machine Learning Toolbox and Signal Processing Toolbox).
Set Hodgkin-Huxley neuron model electrical constants, its initial conditions and additional induction parameters considering external magnetic field source in `set_input.m` script.
Furthermore, set the simulation time and stimulation current shape and period.
`generate_dataset.m` should not be changed and is used only for data generation.
Run any script that is titled `run_`<`x`>`.m` where `x` is one of the following:
* `main` - calculate and visualize the membrane potential dynamics, gating variables dynamics and limit cycles of a neuron stimulated with a constant injected current
* `multiple` - calculate and visualize the membrane potential dynamics for different scenarios (different temperatures with/without electromagnetic induction)
* `isi` - bifurcation analysis, interspike interval (ISI) for a different scenarios considering multiple values of induction coefficient and several temperatures
* `isi_ci` - generate data for sensitivity analysis regarding dynamics of ISI for different values of ion channel conductance
* `entropy` - calculate entropy from ISI probability mass function for cases with noisy periodic and constant dc stimulus, respectively

`output` directory holds two subsequent directories:
* `deterministic_model`, which holds sintetic data and figures generated out of deterministic Hodgkin-Huxley model, more details in `README` file in the directory;
* `sensitivity_analysis`, which holds data obtained via the stochastic collocation method where ion channel conductance values are taken as random variables, more details in `README` file in the directory.

## Citation
To appear.

## Author
[Ante Lojic Kapetanovic](http://adria.fesb.hr/~alojic00/)

## License
[MIT](https://github.com/antelk/hodgkin-huxley-model/blob/main/LICENSE)