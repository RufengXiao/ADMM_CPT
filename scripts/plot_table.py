#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Sat Jul 30 14:17:12 2022

@author: yanyifan
"""

import numpy as np
import matplotlib.pyplot as plt
import pandas as pd
import h5py
import scipy.io as scio
import os
import sys

current_file_path = os.path.abspath(__file__)
current_dir_path = os.path.dirname(current_file_path)
parent_dir_path = os.path.dirname(current_dir_path)
os.chdir(parent_dir_path)
sys.path.append(parent_dir_path)

suffix = 'daily'
figpath = f'./results/{suffix}_pic/'

ret_df = pd.read_csv('./data/daily_used.csv')
mean_df = pd.DataFrame(ret_df.iloc[250:, 1:49].mean(axis=1))
mean_df.columns = ['mean']
mean_df.reset_index(drop=True) 
ret_df = ret_df/100
dates = ret_df['date'].iloc[250:]
dates = dates[:1000]
dates = list(dates)
dates = [str(d) for d in dates]
    

def read_data(name):
    data = h5py.File(name,'r')
    keys = list(data.keys())
    res = {}
    for k in keys:
        res[k] = np.array(data[k]).T
    return res

data1 = scio.loadmat(f'./results/Empirical_benchmark_{suffix}.mat')
data2 = scio.loadmat(f'./results/Empirical_riskfree_reference_point_{suffix}.mat')
data3 = scio.loadmat(f'./results/Empirical_large_reference_point_{suffix}.mat')
data4 = scio.loadmat(f'./results/Empirical_no_risk_aversion_and_risk_seeking_{suffix}.mat')
data5 = scio.loadmat(f'./results/Empirical_no_loss_aversion_{suffix}.mat')
data6 = scio.loadmat(f'./results/Empirical_no_probability_distortion_{suffix}.mat')

# plot figure 1
cum_rtns_data = {
    'equal':mean_df['mean'].values.reshape(-1).cumsum()/100,
    'benchmark':data1['rtns'].reshape(-1).cumsum(),
    'risk-free reference point':data2['rtns'].reshape(-1).cumsum(), 
    'large reference point':data3['rtns'].reshape(-1).cumsum(),
    'no risk aversion and risk seeking':data4['rtns'].reshape(-1).cumsum(),
    'no loss aversion':data5['rtns'].reshape(-1).cumsum(),
    'no probability distortion':data6['rtns'].reshape(-1).cumsum(),
    }

cum_rtns_df = pd.DataFrame(cum_rtns_data)
cum_rtns_df.index = dates
plt.figure(figsize=(15,6),dpi =200)
# ax= fig.add_subplot(1,1,1)
# cum_rtns_df.plot(ax = ax)
plt.plot(dates,1+cum_rtns_data['benchmark'],label = 'benchmark',marker = 'o',markevery=10)
plt.plot(dates,1+cum_rtns_data['risk-free reference point'],linestyle='--',label = 'risk-free reference point',marker = 's',markevery=10)
plt.plot(dates,1+cum_rtns_data['large reference point'],linestyle='--',label = 'large reference point',marker = 's',markevery=10)
plt.plot(dates,1+cum_rtns_data['no risk aversion and risk seeking'],linestyle='-.',label = 'no risk aversion and risk seeking',marker = 'v',markevery=10)
plt.plot(dates,1+cum_rtns_data['no loss aversion'],linestyle=':',label = 'no loss aversion',marker = '*',markevery=10)
plt.plot(dates,1+cum_rtns_data['no probability distortion'],linestyle=(0, (3, 1, 1, 1, 1, 1)),label = 'no probability distortion',marker = '+',markevery=10)
plt.plot(dates,1+cum_rtns_data['equal'],linestyle=(0, (3, 5, 1, 5, 1, 5)),label = r'equally weighted',marker = 'P',markevery=10)

plt.xlabel('Investment Dates')
plt.ylabel('Net Value')
plt.xticks(dates[::int(len(dates) / 6)])
plt.legend()
plt.title("Cumulative Return Sum")
plt.savefig(figpath+f"CumulativeReturnSum{suffix}.eps")
plt.show()


# plot figure 2
def top_five_average(xopt):
    one = []
    two = []
    three = []
    four = []
    five = []
    for i in range(xopt.shape[1]):
        xx = xopt[:,i].copy()
        xx.sort()
        one.append(xx[-1])
        two.append(xx[-2])
        three.append(xx[-3])
        four.append(xx[-4])
        five.append(xx[-5])
    res = [np.mean(one),np.mean(two),np.mean(three),np.mean(four),np.mean(five)]
    
    other = 1 - np.sum(res)
    res.append(other)
    return res

Labels = ['Top1','Top2','Top3','Top4','Top5','Others']

dist1 = top_five_average(data1['xopt_array'])
plt.figure(figsize=(6,5),dpi =300)
plt.pie(x=dist1,labels = Labels,autopct = '%1.2f%%',explode = [0,0,0,0.2,0.4,0])
plt.title(r'Top 5 Average Weights for "benchmark"')
plt.savefig(figpath+f'Top5AverageWeightsforbenchmark{suffix}.eps')
plt.show()

dist2 = top_five_average(data2['xopt_array'])
plt.figure(figsize=(6,5),dpi =300)
plt.pie(x=dist2,labels = Labels,autopct = '%1.2f%%',explode = [0,0,0,0.1,0.3,0])
plt.title(r'Top 5 Average Weights for "risk-free reference point"')
plt.savefig(figpath+f'Top5AverageWeightsforriskfreereferencepoint{suffix}.eps')
plt.show()

dist3 = top_five_average(data3['xopt_array'])
plt.figure(figsize=(6,5),dpi =300)
plt.pie(x=dist3,labels = Labels,autopct = '%1.2f%%',explode = [0,0,0,0.1,0.3,0])
plt.title(r'Top 5 Average Weights for "large reference point"')
plt.savefig(figpath+f'Top5AverageWeightsforlargereferencepoint{suffix}.eps')
plt.show()

dist4 = top_five_average(data4['xopt_array'])
plt.figure(figsize=(6,5),dpi =300)
plt.pie(x=dist3,labels = Labels,autopct = '%1.2f%%',explode = [0,0,0,0.2,0.4,0])
plt.title('Top 5 Average Weights for "no risk aversion and risk seeking"')
plt.savefig(figpath+f'Top5AverageWeightsfornoriskaversionandriskseeking{suffix}.eps')
plt.show()


dist5 = top_five_average(data5['xopt_array'])
plt.figure(figsize=(6,5),dpi =300)
plt.pie(x=dist4,labels = Labels,autopct = '%1.2f%%',explode = [0,0,0,0.2,0.4,0])
plt.title(r'Top 5 Average Weights for "no loss aversion"')
plt.savefig(figpath+f'Top5AverageWeightsfornolossaversion{suffix}.eps')
plt.show()

dist6 = top_five_average(data6['xopt_array'])
plt.figure(figsize=(6,5),dpi =300)
plt.pie(x=dist5,labels = Labels,autopct = '%1.2f%%',explode = [0,0,0,0.2,0.3,0])
plt.title(r'Top 5 Average Weights for "no probability distortion"')
plt.savefig(figpath+f'Top5AverageWeightsfornoprobabilitydistortion{suffix}.eps')
plt.show()

# plot figure 3
def average_std2(ret_df):
    cur = ret_df.iloc[:,1:-1]
    coef = 1
    std_array = cur.rolling(250,axis = 0).std().values[250:,:]*np.sqrt(252/coef)
    var_array = np.mean(std_array**2,axis = 1)
    return var_array

def covariance_matrix_gen(ret_df):
    cur = ret_df.iloc[:,1:-1]
    res = {}
    coef = 1
        
    total = 1000
    for i in range(total):
        a = cur.values[i:i+250,:]
        cov = np.cov(a,rowvar = False)*(252/coef)
        res[i] = cov
    return res

def portfolio_var(cov_dict,data):
    weight = data['xopt_array']
    total = 1000
    res = np.zeros((total,))
    for i in range(total):
        w = weight[:,i].T
        v = w.T @ cov_dict[i] @ w
        res[i] = v
    return res
        
var_array = average_std2(ret_df)
cov_matrix_dict = covariance_matrix_gen(ret_df)

portfolio_vars = {}
for i in range(1,7):
    portfolio_vars[i] = eval(f'portfolio_var(cov_matrix_dict,data{i})')
    
def SSPW_calc(data):
    weight = data['xopt_array']
    total = 1000
    res = np.zeros((total,))
    
    for i in range(total):
        w = weight[:,i]
        cur = 0
        for j in range(48):
            cur += (w[j] - 1/48)**2
        res[i] = cur
    return res
        
portfolio_sspws = {}
for i in range(1,7):
    portfolio_sspws[i] = eval(f'SSPW_calc(data{i})')

def SSPW_plot(i):
    if i == 2:
        name = 'risk-free reference point'
    elif i == 3:
        name = 'large reference point'
    elif i == 4:
        name = 'no risk aversion and risk seeking'
    elif i == 5:
        name = 'no loss aversion'
    elif i==6:
        name = 'no probability distortion'
    
    cpt_sspw = portfolio_sspws[1]
    vs_sspw = portfolio_sspws[i]
    
    plt.figure(figsize=(4,5),dpi=1000)
    plt.boxplot([cpt_sspw,vs_sspw],labels = ['benchmark',name],positions=[0,1.3])
    
    frequency = 'Daily'
    plt.title(f'{frequency} investment SSPW boxplot')
    plt.savefig(figpath+f'SSPW{i}{suffix}.eps')
    plt.show()
    

for i in range(2,7):
    SSPW_plot(i)

# generate table
def cal_maxdd(array):
    drawdowns = []
    max_so_far = array[0]
    for i in range(len(array)):
        if array[i] > max_so_far:
            drawdown = 0
            drawdowns.append(drawdown)
            max_so_far = array[i]
        else:
            drawdown = max_so_far - array[i]
            drawdowns.append(drawdown)
    return max(drawdowns)

def cal_sharpe(array):
    coef = 1
    return np.sqrt(252/coef)*np.mean(array)/np.std(array)

def cal_mean(array):
    coef = 1
    return (252/coef)*np.mean(array)

def cal_std(array):
    coef = 1
    return np.sqrt(252/coef)*np.std(array)

full_rtns_data = {
    'equal':mean_df['mean']/100,
    'benchmark':data1['rtns'].reshape(-1),
    'risk-free reference point':data2['rtns'].reshape(-1),
    'large reference point':data3['rtns'].reshape(-1),
    'no risk aversion and risk seeking':data4['rtns'].reshape(-1),
    'no loss aversion':data5['rtns'].reshape(-1),
    'no probability distortion':data6['rtns'].reshape(-1),
    
    }
full_rtns_df = pd.DataFrame(full_rtns_data)

maxdd = {
    'benchmark':cal_maxdd(cum_rtns_data['benchmark']),
    'risk-free reference point':cal_maxdd(cum_rtns_data['risk-free reference point']),
    'large reference point':cal_maxdd(cum_rtns_data['large reference point']),
    'no risk aversion and risk seeking':cal_maxdd(cum_rtns_data['no risk aversion and risk seeking']),
    'no loss aversion':cal_maxdd(cum_rtns_data['no loss aversion']),
    'no probability distortion':cal_maxdd(cum_rtns_data['no probability distortion']),
    'equal':cal_maxdd(cum_rtns_data['equal']),
    }

sharpe = {
    'benchmark':cal_sharpe(full_rtns_data['benchmark']),
    'risk-free reference point':cal_sharpe(full_rtns_data['risk-free reference point']),
    'large reference point':cal_sharpe(full_rtns_data['large reference point']),
    'no risk aversion and risk seeking':cal_sharpe(full_rtns_data['no risk aversion and risk seeking']),
    'no loss aversion':cal_sharpe(full_rtns_data['no loss aversion']),
    'no probability distortion':cal_sharpe(full_rtns_data['no probability distortion']),
    'equal':cal_sharpe(full_rtns_data['equal']),
    }

mean = {
    'benchmark':cal_mean(full_rtns_data['benchmark']),
    'risk-free reference point':cal_mean(full_rtns_data['risk-free reference point']),
    'large reference point':cal_mean(full_rtns_data['large reference point']),
    'no risk aversion and risk seeking':cal_mean(full_rtns_data['no risk aversion and risk seeking']),
    'no loss aversion':cal_mean(full_rtns_data['no loss aversion']),
    'no probability distortion':cal_mean(full_rtns_data['no probability distortion']),
    'equal':cal_mean(full_rtns_data['equal']),
    }

std = {
    'benchmark':cal_std(full_rtns_data['benchmark']),
    'risk-free reference point':cal_std(full_rtns_data['risk-free reference point']),
    'large reference point':cal_std(full_rtns_data['large reference point']),
    'no risk aversion and risk seeking':cal_std(full_rtns_data['no risk aversion and risk seeking']),
    'no loss aversion':cal_std(full_rtns_data['no loss aversion']),
    'no probability distortion':cal_std(full_rtns_data['no probability distortion']),
    'equal':cal_std(full_rtns_data['equal']),
    }


stats = pd.DataFrame([maxdd,sharpe,mean,std],index = ['max drawdown','sharpe','mean','std'])
stats.to_excel(figpath+f'stats_{suffix}.xlsx')

print(f' &benchmark& {round(stats["benchmark"]["mean"],4)} &{round(stats["benchmark"]["std"],4)}&{round(stats["benchmark"]["sharpe"],4)} &{round(stats["benchmark"]["max drawdown"],4)}   \\\\')
print(f' &risk-free reference point& {round(stats["risk-free reference point"]["mean"],4)} &{round(stats["risk-free reference point"]["std"],4)}&{round(stats["risk-free reference point"]["sharpe"],4)} &{round(stats["risk-free reference point"]["max drawdown"],4)}   \\\\')
print(f' &large reference point& {round(stats["large reference point"]["mean"],4)} &{round(stats["large reference point"]["std"],4)}&{round(stats["large reference point"]["sharpe"],4)} &{round(stats["large reference point"]["max drawdown"],4)}   \\\\')
print(f' &no risk aversion and risk seeking& {round(stats["no risk aversion and risk seeking"]["mean"],4)} &{round(stats["no risk aversion and risk seeking"]["std"],4)}&{round(stats["no risk aversion and risk seeking"]["sharpe"],4)} &{round(stats["no risk aversion and risk seeking"]["max drawdown"],4)}   \\\\')
print(f' &no loss aversion& {round(stats["no loss aversion"]["mean"],4)} &{round(stats["no loss aversion"]["std"],4)}&{round(stats["no loss aversion"]["sharpe"],4)} &{round(stats["no loss aversion"]["max drawdown"],4)}   \\\\')
print(f' &no probability distortion& {round(stats["no probability distortion"]["mean"],4)} &{round(stats["no probability distortion"]["std"],4)}&{round(stats["no probability distortion"]["sharpe"],4)} &{round(stats["no probability distortion"]["max drawdown"],4)}   \\\\')
print(f' &equal& {round(stats["equal"]["mean"],4)} &{round(stats["equal"]["std"],4)}&{round(stats["equal"]["sharpe"],4)} &{round(stats["equal"]["max drawdown"],4)}   \\\\')
