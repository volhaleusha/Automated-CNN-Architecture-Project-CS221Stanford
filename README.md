# Project Description

In this project we present a method that automatically searches for a promising Convolutional Neural Network (CNN) architecture for image classification task. Additionally we research into possibility to minimize training and prediction compute without significant impact on prediction accuracy. Our approach is based on Evolutionary Algorithm described in [1] and [2] with multiple modifications on our side. Specifically we introduce new combined methods to select networks from population for crossover, and compare performance of this methods to binary tournament and random selection. Moreover, we try to speed up the architecture search by adding prediction time to the fitness function.
Due to computational constraints we use relatively small dataset and restrict the model to six convolutional and two dense layers. However, the method is applicable for any dataset and is easily extendable to more layers by only adjusting two parameters in the code. 
Performance of the search method presented in this project proves to be comparable with well known benchmarks. It achieves similar to Google AutoML prediction accuracy with significant reduction in search time from 24h to 2h. Moreover, by adding prediction time into the fitness function the search time is decreased approximately by a factor of two compared to the algorithm presented in [1] with only slight drop in accuracy. For more details refer to 'final report'.

# Overview

This project is built using jupyter notebooks, some parameterization provided
through the papermill module, and backed by keras with tensorflow. Please
see below how to setup the project, run experiments, and other tid bits.

This tarball contains select experiment results, the base jupyter notebook to
run experiments, and some tools to facilitate running automated and structured
experiments on a cluster of cloud VMs.

# Folder structure

- Fitness function test: contains experiment result for fitness functions
- Performance and Stability Test: contains experiment results for performance
  and stability tests
- tools: contains tools to run experiments, and a sample parametrized config
- Result Log.xlsx: a summary of all experiments ran, and the outcomes

# Packages required

We recommend running this with conda or any other package manager.
The following is a list of packages required to run our model(s).
- jupyter
- pydot
- scikit-learn
- tqdm
- matplotlib
- pandas
- tensorflow-gpu // for GPU backed acceleration
- papermill // for parametrized running

# How to run:

## Notebook

As our system is written as a jupyter notebook, for interactive running and
playing one can just run it as

`jupyter-notebook EvolutionaryAlgorithmParametrizedFit2.ipynb`

To change the parameters or try different things, open that notebook, and
at the bottom, change the cell that has the parameters. You can tune
- experiment\_name // all experiments with the same first 4 characters share an initial population, to allow for comparative sub-experiments
- population size
- sample strategy // how to pick subsequent samples for the population
- train/test sample size
- batch size
- epochs
- iterations
- weights for the fitness functions


There are two special flags:
- dry-run: this only initializes the population but does not run any models
- only-time-bound: only run largest and smallest model to get a time bound

## commandline approach

To automate the process, we created a parametrized command line runner and
a config file system. The idea is simple: the same parameters specified above
can also be specified by a .json config file. In that case, all one needs
to do is tell the paramRunner which notebook to run, and which config file to
use.

`python3 paramRunner.py [notebook] [config].json`

The most comprehensive notebook with the most features available is
EvolutionaryAlgorithmParametrizedFit2.ipynb

Most features here means that it supports multiple fitness functions, and
supports printing only time-bounds.

Running through the command line, the output are result files but also another
output notebook that contains the same code as the input notebook, but where
the output per cell is also saved, to jump right into it and keep iterating.

### Naming convetion.

The parametrization is done as follows

[experiment-name].[strategy].json

For experiment-name:

the first four characters are the base experiment and the remaining characters
specify the individual experiment. This is so that some experiments can
share the same initial population for comparative reasons. For example

1. s5\_32.tournament\_epsilon.json
2. s5\_31.tournament\_epsilon.json // shares the same initial population as (1)
3. s5\_21.tournament\_epsilon.json // has a different initial population

## outputs

Both command line and interactive notebook will output (in the results folder)
- a [experiment-name].[strategy].svg // graph showing accuracy over iterations
- a [experiment-name].[strategy].h5 // storing the best model
- a [experiment-name].[strategy]\_summary.txt // summary of the run
- a [experiment-name].[strategy]\_results.csv // csv of results of the run

The command line approach will also output a results notebook: the same notebook
as was used to run the experiment, but with the output of cells populated as
the experiment went along.

strategy:

one of the known strategies

## run helpers

As cloud resources are expensive, and experiments should run and then exit, we
created two main mechanisms to aid with this approach.


util contains orchestrator.sh. This utility essentially statically maps a test
to a gpu-test[x] named instance to run, gather results, and turn off the
instance. This code is very specialized to our cloud setup, and might not be
helpful for anybody trying to setup their own, but the basic idea might be
a good template.


runner.sh does the same thing: run a list of config files passed into it, bundle
up all the results, and then push them to github before turning off the instance.
This code, run inside screen/tmux on a cloud vm instance is more generalizable
and guarantees that the instance will be shut down at the end. Pushing the results
to GitHub generally works as long as there are no conflicts i.e. no other instance
pushed results with the same name.

# References 
[1] Yanan Sun., Bing Xie, Mengjie Zhang, Gary G. Yen.  Automatically Designing CNN Architectures Using Genetic Algorithm for Image Classification, 2019
[2] Petra Vidnerova, Roman Neruda. Evolution Strategies for Deep Neural Network Models Design, 2017
