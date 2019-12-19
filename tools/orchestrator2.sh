#!/bin/bash

id=$1

shift

runs=$@

# Dummy is to make 0 indexing in arrays work properly as gpu instance
# names are not 0 indexed
STRATEGIES=('dummy'
            'tournament'
            'gibbs'
            'gibbs_epsilon'
            'random'
            'tournament_epsilon'
            'tournament_epsilon_fit2'
            'tournament_gibbs_epsilon_fit2'
            'tournament_gibbs_fit2'
            'tournament_gibbs')


gcloud compute instances start gpu-test"${id}"

# Let the instance fully boot up.
sleep 180

for run in $runs; do

  sfile="${run}".${STRATEGIES[${id}]}.json

  echo $sfile

  cmd=("pushd /home/coconutruben/cs221/ParametrizedExperiments;"
       "git pull --rebase;"
       "git add results/*;"
       "git commit -s -m $sfile;"
       "git push;")

  echo ${cmd[*]}

  gcloud compute ssh gpu-test"${id}" --command "${cmd[*]}"
done

gcloud compute instances stop gpu-test"${id}"
