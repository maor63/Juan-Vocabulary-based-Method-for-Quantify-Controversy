from pathlib import Path

from scipy import spatial
import numpy as nx
import sys
from math import *

from sklearn.metrics import roc_auc_score
from sklearn.preprocessing import LabelEncoder
from tqdm.auto import tqdm
from scipy.spatial import distance
import pandas as pd


def is_number(a):
    # will be True also for 'NaN'
    try:
        number = float(a)
        return True
    except ValueError:
        return False


def has_nostrings(a):
    return (len([s for s in a if is_number(s)]) == len(a))


def nlp_polarization_score(file2):
    with open(file2 + "-C1-vec.txt", "r", encoding="ISO-8859-1")as f:
        distances = list()
        a = 0
        for x in f:
            preEmb = x.split(' ')
            emb = preEmb[(len(preEmb) - 201):(len(preEmb) - 1)]
            if has_nostrings(emb):
                if a == 0:
                    tweetsc1 = nx.array([emb]).astype(nx.float)
                    a = 1
                if len(preEmb) > 200:
                    tweetsc1 = nx.vstack((tweetsc1, nx.array(emb).astype(nx.float)))
    with open(file2 + "-C2-vec.txt", "r", encoding="ISO-8859-1") as f:
        distances = list()
        a = 0
        for x in f:
            preEmb = x.split(' ')
            emb = preEmb[(len(preEmb) - 201):(len(preEmb) - 1)]
            if has_nostrings(emb):
                if a == 0:
                    tweetsc2 = nx.array([emb]).astype(nx.float)
                    a = 1
                if (len(preEmb) > 200):
                    tweetsc2 = nx.vstack((tweetsc2, nx.array(emb).astype(nx.float)))
    X = nx.concatenate((tweetsc1, tweetsc2), axis=0)
    # divide 2 clusters
    c1 = tweetsc1
    c2 = tweetsc2
    # calculate centroids
    cent1 = c1.mean(axis=0)
    cent2 = c2.mean(axis=0)
    cent0 = X.mean(axis=0)
    v = nx.cov(X.T)
    SS0 = 0
    for row in X:
        # SS0 = SS0 + distance.mahalanobis(row,cent0,v)
        SS0 = SS0 + distance.cosine(row, cent0)
        # SS0 = SS0 + distance.euclidean(row,cent0)
        # SS0 = SS0 + distance.cityblock(row,cent0)
    v = nx.cov(c1.T)
    SS1 = 0
    for row in c1:
        # SS1 = SS1 + distance.mahalanobis(row,cent1,v)
        SS1 = SS1 + distance.cosine(row, cent1)
        # SS1 = SS1 + distance.euclidean(row,cent1)
        # SS1 = SS1 + distance.cityblock(row,cent1)
    v = nx.cov(c2.T)
    SS2 = 0
    for row in c2:
        # SS2 = SS2 + distance.mahalanobis(row,cent2,v)
        SS2 = SS2 + distance.cosine(row, cent2)
        # SS2 = SS2 + distance.euclidean(row,cent2)
        # SS2 = SS2 + distance.cityblock(row,cent2)
    # Controversy index
    polarization_score = (SS1 + SS2) / SS0
    return polarization_score


def main():
    # embeding_type = 'bert'  # bert, fasttext
    embeding_type = 'fasttext'  # bert, fasttext
    # graph_path = Path('datasets/fasttext_sentence_embeddings/')
    graph_path = Path(f'datasets/{embeding_type}_sentence_embeddings/')

    rows = []
    data_output_path = Path(f'nlp_{embeding_type}_graph_polarization_score.csv')

    for graph_data_file in tqdm(graph_path.iterdir(), desc='run graphs', total=len(list(graph_path.iterdir()))):
        if graph_data_file.name.endswith('-C1-vec.txt'):
            graph_name = graph_data_file.name.replace('-C1-vec.txt', '')
            score = nlp_polarization_score(str(graph_path / graph_name))
            rows.append((graph_name, score))
            print(graph_name, score)
    data_df = pd.DataFrame(rows, columns=['topic', 'score'])
    data_df.to_csv(data_output_path, index=False)

    label_df = pd.read_csv('labels.csv')

    merge_df = pd.merge(data_df, label_df, how='inner', on='topic')
    lb = LabelEncoder()
    # print(lb.classes_)
    y_true = lb.fit_transform(merge_df['label'])
    y_pred = merge_df['score'].fillna(0)

    if list(lb.classes_)[1] == 'controversial':
        y_true = 1 - y_true
    print(roc_auc_score(y_true, y_pred), roc_auc_score(1 - y_true, y_pred))


if __name__ == "__main__":
    main()
