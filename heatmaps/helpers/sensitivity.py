#!/usr/bin/python3
import sys
import pandas as pd
from sklearn import tree

'''
This script allows to compute most of the data used for our experiments (both
heatmap data and sensitivity graphs).

Syntax: ./sensitivity.py <dataset> <perf> (<thresh>) <srm> <srM> <srs> <dest>
-  dataset     path to the studied system's dataset
-  perf        name of the studied performance ("perf" in most cases,
               exceptions being x264 and SaC)
-  thresh      optional parameter to set a threshold for a sensitivity analysis
               on sampling size only. Takes values between 0 and 1 being the
               wanted representation of class 0
-  srm         minimum sampling size
-  srM         maximum sampling size
-  srs         sampling step between two iterations
-  dest        path to save results

To compute sensitivity wrt oracle's threshold, you must fix a sampling size n
and give for the three sampling parameters resp. n, n+1 and 1.
'''

NBINS = 40 # Number of vertical bins for threshold
NSUBS = 10 # Number of training sets to average on

if not len(sys.argv) in (7,8):
	print("syntax: sensitivity.py <dataset> <perf> (<thresh>) <srm> <srM> <srs> <dest>")
	exit(1)

perf_x264 = ['Watt', 'Energy', 'SSIM', 'PSNR', 'Speed', 'Size', 'Time']
perf_sac = ['compile-exit', 'compile-real', 'compile-user', 'compile-ioin', 'compile-ioout',
            'compile-maxmem', 'compile-cpu', 'compile-size', 'run-exit',
            'run-real', 'run-user', 'run-maxmem', 'run-cpu']
perf = sys.argv[2] # Get the performance we want to compute on (for multi-dim cases)
d = pd.read_csv(sys.argv[1]) # Open dataset
d = d.sort_values(by=perf) # Sort it by perf to get threshold values
thresholds = [d[perf].iloc[i * d.shape[0]//NBINS] for i in range(1, NBINS)]
fix = 0
if len(sys.argv) == 8: # In case of one more arg to specify an explicit threshold value
	thresholds = [d[perf].iloc[int(float(sys.argv[3]) * d.shape[0])]]
	fix = 1
res = {"sr":[],"t":[],"TN":[],"TP":[],"FN":[],"FP":[]}

# Computation
for sr in range(int(sys.argv[3+fix]),int(sys.argv[4+fix]),int(sys.argv[5+fix])):
	for t in thresholds:
		print("Computing for sr=%d and t=%.3f..." % (sr, t))
		d["label"] = 0
		d.loc[d[perf] > t, "label"] = 1 # Label with the (current) oracle
		clean = d.drop(perf_sac+perf_x264+["perf"],axis=1,errors="ignore")
		subs = [clean.sample(sr) for i in range(NSUBS)] # Subsample trainsets
		TN = TP = FN = FP = 0 # Counters for classification results
		d["pred"] = 0
		for s in subs: # We cumulate results for each experiment and average later
			# MACHINE LEARNING PART
			# Settings are chosen to be the closest to J48 algorithm
		    c = tree.DecisionTreeClassifier(criterion="entropy", min_samples_leaf=2)
		    c.fit(s.drop(["label"],axis=1), s.label)
		    # END OF LEARNING
		    d["pred"] = c.predict(clean.drop(["label"], axis=1)) # Get model's prediction
		    TN += d[(d.label == 0) & (d.pred == 0)].shape[0]
		    TP += d[(d.label == 1) & (d.pred == 1)].shape[0]
		    FN += d[(d.label == 1) & (d.pred == 0)].shape[0]
		    FP += d[(d.label == 0) & (d.pred == 1)].shape[0]
		del d["pred"] # Reset
		# Push the results
		res["sr"].append(sr)
		res["t"].append(t)
		res["TN"].append(TN/NSUBS)
		res["TP"].append(TP/NSUBS)
		res["FN"].append(FN/NSUBS)
		res["FP"].append(FP/NSUBS)
# Save the result as csv
pd.DataFrame(res).to_csv(sys.argv[6+fix], index=False)
