# Stochastic analysis of the influence of electromagnetic radiation on action potential of a neuron considering uncertainty in conductivity of ion channels

## Overview
The effect of electromagnetic radiation by means of electromagnetic induction on action potential dynamics using the Hodgkin-Huxley neuron model is assessed. Additionaly, the sensitivity analysis considering uncertainty in conductivity of sodium, pottasium and leakage ion channel is performed.
The fluctuation or changes in neuron dynamics are well-known response to magnetic field whose external source is, most often, the transcranial magnetic stimulation (TMS) device which operates at extremely high magnetic flux density and is used in therapeutic purposes (treatment of neurophysiological disorders and other neural degenerations).
Once the magnetic field penetrates the cell cortex, according to Maxwell’s electromagnetic induction theorem, the electric field is generated, which further causes the electrovital current flow through a neuron's axon.
Since additional current is now applied, ion pumps are amplified (or weakened) and the membrane potential is changed -- action potential dynamics is changed, which will lead to a change in neuronal activity or, in the big picture, to a change of the complete brain metabolism.
Also, the effect of temperature on neuronal activity is observed given simple analytical formula.

## Relevant references
* Lv, Mi et al. Model of electrical activity in a neuron under magnetic flow effect, Nonlinear Dynamics 85, 2016. [[doi](https://doi.org/10.1007/s11071-016-2773-6)]
* Lv, Mi; Ma, Jun. Multiple modes of electrical activities in a new neuron model under electromagnetic radiation, Neurocomputing 205, 2016. [[doi](https://doi.org/10.1016/j.neucom.2016.05.004)]
* Wu, Fuqiang et al. Dynamical responses in a new neuron model subjected to electromagnetic induction and phase noise, Physica A: Statistical Mechanics and its Applications 469. 2017. [[doi](https://doi.org/10.1016/j.physa.2016.11.056)]
* Lu, Lulu et al. Mixed stimuls-induced mode selection in neural activity driven by high and low frequency current under electromagnetic radiation, Complexity. 2017. [[doi](https://doi.org/10.1155/2017/7628537)]
* Lu, Lulu et al. Effects of temperature and electromagnetic induction on action potential of Hodgkin–Huxley model, The European Physical Journal Special Topics volume 227, 2018. [[doi](https://doi.org/10.1140/epjst/e2018-700140-1)]
* Yang, Yumei et al. Energy dependence on discharge mode of Izhikevich neuron driven by external stimulus under electromagnetic induction, Cognitive Neurodynamics 6, 2020. [[doi](https://doi.org/10.1007/s11571-020-09596-4)]

## Run the experiments
Go to `src` directory using MATLAB (version R2020a/b recommended, prereqs include Machine Learning Toolbox and Signal Processing Toolbox).
Set Hodgkin-Huxley neuron model electrical constants, its initial conditions and additional induction parameters considering external magnetic field source in `set_input.m` script.
Furthermore, set the simulation time and stimulation current shape and period.
`generate_dataset.m` should not be changed and is used only for data generation.
Run any script that is titled `run_X.m` where X is one of the following:
* `main` - calculate and visualize the membrane potential dynamics, gating variables dynamics and limit cycles of a neuron stimulated with a constant injected current
* `multiple` - calculate and visualize the membrane potential dynamics for different scenarios (different temperatures with/without electromagnetic induction)
* `isi` - bifurcation analysis, interspike interval (ISI) for a different scenarios considering multiple values of induction coefficient and several temperatures
* `isi_ci` - generate data for sensitivity analysis regarding dynamics of ISI for different values of ion channel conductance

Directory `output` contains two subsequent directories:
* `deterministic_model`, which holds sintetic data and figures generated out of deterministic Hodgkin-Huxley model
* `sensitivity_analysis`, which holds data obtained via stochastic collocation method where ion channel conductances are taken as random variables

## Author
[Ante Lojic Kapetanovic](http://adria.fesb.hr/~alojic00/)

## License
[MIT](https://github.com/antelk/hodgkin-huxley-model/blob/main/LICENSE)