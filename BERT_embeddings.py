import pandas as pd
import pickle

from bert_serving.client import BertClient

import sys

# name of the file containing the dataset
# name_file  = sys.argv[1]
name_file = 'area51'

# load data
df = pd.read_csv(name_file + 'BERT.tsv', sep='\t', header=None, names=['community', 'sentence'])

bc = BertClient()
# encode data using the Client (the sentences are in column "sentence" of df)
vec = bc.encode(list(df["sentence"].values))
df['vec'] = vec
df.to_csv(name_file + 'BERT_vecs.csv', index=False)
# save encoded data in a pickle file
# pickle.dump(vec, open(name_file + '_encoded.pkl', 'wb'))
