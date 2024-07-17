import numpy as np
import os
import sys

current_file_path = os.path.abspath(__file__)
current_dir_path = os.path.dirname(current_file_path)
parent_dir_path = os.path.dirname(current_dir_path)
os.chdir(parent_dir_path)
sys.path.append(parent_dir_path)

from cptopt.optimizer import MinorizationMaximizationOptimizer, ConvexConcaveOptimizer, \
    MeanVarianceFrontierOptimizer, GradientOptimizer
from cptopt.utility import CPTUtility
import scipy.io as scio

# Define utility function
utility = CPTUtility(
    gamma_pos=8.4, gamma_neg=11.4,
    delta_pos=.77, delta_neg=.79
)

import time
class Logger(object):
    def __init__(self, fileN="Default.log"):
        self.terminal = sys.stdout
        self.log = open(fileN, "w")
 
    def write(self, message):
        self.terminal.write(message)
        self.log.write(message)
 
    def flush(self):
        pass
    

for dataname in ["daily_used", "SP500_2"]: #"rand", "daily_used", "SP500_2"
    if dataname == "daily_used":
        periods = [50,100,150,200,250,300]
    elif dataname == "SP500_2":
        periods = [300,400,500,600,700,800,900,1000]
    else:
        periods = [100]
    
    log_dir = "./log/"
    os.makedirs(log_dir, exist_ok=True)
    logname = log_dir+dataname+".txt"
    sys.stdout = Logger(logname)
    print("==============      "+dataname+"      ==============")
    
    mmob_list = []
    mmtime_list = []
    ccob_list = []
    cctime_list = []
    gaob_list = []
    gatime_list = []
    dataname_pre = dataname

    for period in periods:
        # load returns
        dataname = dataname_pre + "_" + str(period)
        filename = "./data/R_data/" + dataname + ".mat"
        weightname = "./results/res_w/w_"+dataname + ".mat"
        data = scio.loadmat(filename)
        r = np.array(data['R']) 
        data = scio.loadmat(weightname)
        weight = np.array(data['xopt']).reshape(-1)
        print(f"========      period={period}      ========")
    
        admm_ob, _, _ = utility.evaluate(weight, r)
        print(
            f"{admm_ob=:.6f}"
        )
        
        d = r.shape[1]
        initial_weights = 1/d * np.ones(d)
        # Optimize
        # mv = MeanVarianceFrontierOptimizer(utility)
        # mv.optimize(r, verbose=True)
        # mv_ob, _, _ = utility.evaluate(mv._weights, r)
        # print(
        #     f"{mv_ob=:.6f}"
        # )
        try:
            mm = MinorizationMaximizationOptimizer(utility)
            time_start = time.time()
            mm.optimize(r, initial_weights=initial_weights, verbose=True)
            mm_time = time.time() - time_start
            mm_ob, _, _ = utility.evaluate(mm._weights, r)
            mmob_list.append(mm_ob)
            mmtime_list.append(mm_time)
            print(
                f"{mm_ob=:.6f}  {mm_time=:.6f}"
            )
        except:
            mmob_list.append(-10000)
            mmtime_list.append(-1)
            print(
                "The mm method failed!"
            )
        
        try:
            cc = ConvexConcaveOptimizer(utility)
            time_start = time.time()
            cc.optimize(r, initial_weights=initial_weights, verbose=True)
            cc_time = time.time() - time_start
            cc_ob, _, _ = utility.evaluate(cc._weights, r)
            ccob_list.append(cc_ob)
            cctime_list.append(cc_time)
            print(
                f"{cc_ob=:.6f}  {cc_time=:.6f}"
            )
        except:
            ccob_list.append(-10000)
            cctime_list.append(-1)
            print(
                "The cc method failed!"
            )
        
        try:
            ga = GradientOptimizer(utility)
            time_start = time.time()
            ga.optimize(r, initial_weights=initial_weights, verbose=True)
            ga_time = time.time() - time_start
            ga_ob, _, _ = utility.evaluate(ga._weights, r)
            gaob_list.append(ga_ob)
            gatime_list.append(ga_time)
            print(
                f"{ga_ob=:.6f}  {ga_time=:.6f}"
            )
        except:
            gaob_list.append(-10000)
            gatime_list.append(-1)
            print(
                "The ga method failed!"
            )
        
    # Convert ob_list and time_list to numpy arrays
    mmob_array = np.array(mmob_list)
    mmtime_array = np.array(mmtime_list)
    ccob_array = np.array(ccob_list)
    cctime_array = np.array(cctime_list)
    gaob_array = np.array(gaob_list)
    gatime_array = np.array(gatime_list)

    # Create a dictionary to store the arrays
    data_dict = {
        'mmob': mmob_array,
        'mmtime': mmtime_array,
        'ccob': ccob_array,
        'cctime': cctime_array,
        'gaob': gaob_array,
        'gatime': gatime_array
    }

    # Save the dictionary as a MATLAB file
    output_filename = "./results/" + dataname + "_cptopt_results.mat"
    scio.savemat(output_filename, data_dict)