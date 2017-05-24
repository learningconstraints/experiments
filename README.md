# Machine learning for specializing configurable systems 

Experiments of our methods (replicable studies, reusable tools) 



Run command "jupyter notebook" to launch Jupyter, it opens the folder in a browser

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

Python version : 3.5.3
Jupyter client version : 5.0
pandas = 0.20.1
scikit-learn==0.18.1
R version 3.3.3
