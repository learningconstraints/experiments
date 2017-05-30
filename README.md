# Machine learning for specializing configurable systems 

Experiments of our methods (replicable studies, reusable tools) 


Tested with : 

Python version : 3.5.3
Jupyter client version : 5.0
pandas = 0.20.1
scikit-learn==0.18.1
R version 3.3.3


## Heatmaps

Launch Jupyter to open the folder in a browser
```
jupyter notebook
```

With the browser, go to "heatmaps" folder

Clic on file processData.ipynb

This notebook is composed of 4 cells:
 - Params cell, setting folder containing datasets, folder storing results data, and machine learning settings
 - Cell containing machine learning function
 - Cell using the machine learning function according to the settings in the first cell
 - Cell using the R script creating heatmaps with results data from the machine learning function

At first use, all cells must be run in the given order. Then not modified cells does not have to be run again.

To apply this to other dataset, change the filename in the params cell. Some datasets are supplied (Apache, BerkeleyC, BerkeleyJ ...) but you can use other csv files.

Heatmaps represents the measures of the classifications (accuracy, precision, specificity...) considering training set size on the X-axis and the percentage of acceptable configurations on the Y-axis

## Metrics view

Launch Jupyter to open the folder in a browser (no need to relaunch if already open)
```
jupyter notebook
```

With the browser, go to "metric_view" folder

Clic on file processData.ipynb

This notebook has the same structure as the Heatmaps one

In the first cell, note the oracle field where to specify the thresholds values to use

The third cell will run the function of the second cell, that will create a folder in {dataPath} for each value in oracle and place data from machine learning in its respective folder

The forth cell calls the R script that will plot the false negative ratio and false positive ratio for each csv file created by machine learning part


Another type of view is available in the plotMetrics.ipynb file

Running the notebook will read all csv files (previously created with machine learning function in processData.ipynb) and wil create a graph for each value in oracle and each metrics(Accuracy, FNR, FPR, NRV, Precision, Recall, Specificity). Each line on the graph represent the metric for a file.
