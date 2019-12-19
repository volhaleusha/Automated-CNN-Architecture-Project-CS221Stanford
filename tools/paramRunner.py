import json
import os
import papermill as pm
import sys

basep = os.path.realpath(os.path.dirname(__file__))
# The config path is the first argument
config_path = os.path.join(basep, sys.argv[2])
# The outbook is the second argument
notebook_base = sys.argv[1]
notebook_path = os.path.join(basep, notebook_base)

if not os.path.exists(config_path):
  raise Exception('Please specify a valid param config.')

with open(config_path, 'r') as f:
  config = json.load(f)

for param in ['experiment_name', 'sample_strategy']:
  if param not in config:
    raise Exception ('Need to specify a %s.' % param)

outpath = '%s.%s.%s.ipynb' % (notebook_base.split('.ipynb')[0], config['experiment_name'],
                              config['sample_strategy'])
full_outpath = os.path.join(basep, 'results', outpath)

print('Will generate output notebook %s stored at %s' % (outpath, full_outpath))


pm.execute_notebook(
   notebook_path,
   full_outpath,
   parameters=config
)
