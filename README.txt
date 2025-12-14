# data/ contains all ml programs / INPUT files..
# ..at the time of previous regression

# baseline/ contains the OUTPUT files from previous regression

# updates each program category (data/{bookmarks,interpreter,parser}/)..
# .., evaluates all programs using server (expected to be running)..
# ..and then saves the results in baseline/
./run_regression.sh
