import fasttext
from pathlib import Path
import pandas as pd
import sys

filename = sys.argv[1];
# print(filename)
#filename = "area51"

base_path = Path('datasets/fasttext_train_predict_files/')

model = fasttext.train_supervised(str(base_path / f'{filename}-train.txt'), epoch=20, dim=200, wordNgrams=2, ws=5)

model_path = base_path / f"{filename}_fasttext_model.bin"
# if model_path.exists():
#     model = fasttext.load_model(str(model_path))
# else:
#     model.save_model(str(model_path))

texts = []
count = 0
with open(base_path / f'{filename}-to-predict.txt', 'r') as file1:
  # Strips the newline character
  for line in file1.readlines():
      count += 1
      texts.append(line.strip())
print(count)
      

#data = pd.read_csv(str(base_path / f'{filename}-to-predict.txt'), header=None, names=['txt'])
rows = []
for txt in texts:
    pred = model.predict(txt)
    rows.append((pred[0][0], pred[1][0])) # (label, prob)
pd.DataFrame(rows, columns=['X1', 'X2']).to_csv(base_path / f'{filename}.csv', index=False, header=None)
pass
