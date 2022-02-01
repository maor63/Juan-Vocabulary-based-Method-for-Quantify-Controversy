import os
from pathlib import Path

# base_path = Path('datasets/Rdata files/')
base_path = Path('datasets/juan_original_rdata/')
graph_path = Path('datasets/graphs/')

graph_names = [graph_data_file.name.replace('_r.gml', '') for graph_data_file in graph_path.iterdir() if graph_data_file.name.endswith('_r.gml')]
print(graph_names)
print(' '.join(graph_names))
rdata_names = []
for r_data_file in base_path.iterdir():
        name = r_data_file.name.replace('.RData', '')
        if name not in graph_names:
            print(name)
            rdata_names.append(name)
print('Missing graphs', len(rdata_names))
print(' '.join(rdata_names))
    # if r_data_file.name.endswith(' .RData'):
        # new_file_name = r_data_file.parent / r_data_file.name.strip().replace(' .RData', '.RData')
        # print(r_data_file.name, new_file_name)
        # os.rename(r_data_file, new_file_name)


# import subprocess
#
# bashCommand = "./calcular nepal"
# process = subprocess.Popen(bashCommand.split(), stdout=subprocess.PIPE)
# output, error = process.communicate()