import os

for r, d, f in os.walk("test_case"):
    for file in f:
        print(file)
        os.system('./mini-lisp < test_case/' + file)