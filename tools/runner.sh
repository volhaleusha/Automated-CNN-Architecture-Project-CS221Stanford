#!/bin/bash
for elem in $@; do
	python3 paramRunner.py EvolutionaryAlgorithmParametrizedFit2.ipynb $elem
	git add results/*
	git commit -s -m "${elem}"
	git pull --rebase
	git push
done
sudo poweroff
