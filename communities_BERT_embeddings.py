import pandas as pd
import numpy as np
import sys
import pickle
from pathlib import Path
from bert_serving.client import BertClient


def set_labels(text):
    return text[-2]


name_file = sys.argv[1]

# name_file = 'bigil'

dataset_path = Path('datasets/')
output_path = dataset_path / 'bert_sentence_embeddings/'
input_path = dataset_path / 'fasttext_train_predict_files/'
df = pd.read_csv(input_path / f'{name_file}-train.txt', header=None, names=['label', 'sentence'])

bc = BertClient(check_length=False)
# encode data using the Client (the sentences are in column "sentence" of df)
df["sentence"] = df["sentence"].str.strip()
df = df[df["sentence"].astype(bool)]

labels = df['label'].apply(set_labels)
vec = bc.encode(list(df["sentence"].values))
c1_vecs = vec[labels == '1']
c2_vecs = vec[labels == '2']
pd.DataFrame(c1_vecs).to_csv(output_path / f'{name_file}-C1-vec.txt', index=False, sep=' ', header=None)
pd.DataFrame(c2_vecs).to_csv(output_path / f'{name_file}-C2-vec.txt', index=False, sep=' ', header=None)
# df[0] = ' '
# df[2] = np.nan
# df[[0, 1, 2, 3]].to_csv(name_file + 'BERT.tsv', sep='\t', header=None, index=None)
