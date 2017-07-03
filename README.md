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

## Configuration Tree Performance

Launch Jupyter to open the folder in a browser (no need to relaunch if already open)
```
jupyter notebook
```

With the browser, go to "configuration_tree_performance" folder

Here are severals notebooks.

The notebooks processData and processDataClustered and almost the same as the ones in heatmaps and metrics view, enhanced with a versionning system and the ability to change the machine learning tree configuration.

The notebook createHeatmaps uses data created by the processData notebook, and needs a file containing min and max between file compared (creating in cell #3, no worry). With this data, for each configuration, a set of heatmaps are created, with a shared scale for each metric, as an easier way to compare results.

Still, this way of comparing using heatmaps does not allow to compare configurations face to face. This is what the notebook createTables tries to solve. It drops the threshold dimensions by getting a mean value. The table processed will have a configuration by row and still get the number of configuration by column, like the heatmaps previously created. By coloring metrics value and sorting by configuration parameter, it is possible to determine visually best parameters for each metric.

The last notebook, createPlots, allows to create plots the same way as in "metrics_view", based on data created by processDataClustered.
For a same threshold and metric, results of several configurations are represented. The notebook also have a function to create the same plot, but each configuration will be calculated minus a base configuration.


## Regression

This folder is about comparing performances between classification tree, the only one which as been used here for now, and regression tree.

Still in notebook, there are two ways to compare offered, a set of heatmaps and a plot.

For each system, four heatmaps are drawn. The two first are the heatmaps from the first folder, one considering classification and the other one regression, the third represents the difference of performance between both, and the fourth the normalized difference (red means classification is better, yellow the regression is better).
These heatmaps can be created using the processData notebook, which uses the helper 2.calculateMetrics.R to display the heatmaps.

The plots represent mean metrics by number of configuration in the training set. Two curves are drawn, one for regression, one for classification.
Data for this is processed by processDataForMeanMetrics notbook, which can be then used by plotMeanMetrics notebook to created the plots.