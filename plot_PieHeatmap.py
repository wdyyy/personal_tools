# -*- coding: UTF-8 -*-

# FileName     : plot_PieHeatmap
# Author       : EastsunW eastsunw@foxmail.com
# Create at    : 2023-04-05 17:37
# Last Modified: 2023-04-05 17:37
# Modified By  : EastsunW
# -------------
# Description  :
# -------------

from typing import Union
from io import TextIOWrapper
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt
import matplotlib.colors as mcolors

class PieHeatmapPlot:
    def __init__(self, data:Union[pd.DataFrame, np.ndarray, TextIOWrapper, str]="./data.txt", output:str="."):
        self.data = self.__parseData(data)

    def __parseData(self, data:Union[pd.DataFrame, np.ndarray, TextIOWrapper, str]):
        """
        Parses data into a pandas DataFrame
        :param data: pandas DataFrame, file object, or string
        :return: pandas DataFrame
        """
        if isinstance(data, pd.DataFrame):
            return data
        elif isinstance(data, np.ndarray):
            return data
        elif isinstance(data, TextIOWrapper):
            return pd.read_csv(data, sep="\t")
        elif isinstance(data, str):
            return pd.read_csv(data, sep="\t")
        else:
            raise TypeError("data must be a pandas DataFrame, a file object, or a string")

    def __hex_to_rgb(self, value):
        """
        Converts hex to rgb colours
        :param value: string of hex code
        :return: tuple of RGB values
        """
        value = value.strip("#") # removes hash symbol if present
        lv = len(value)
        return tuple(int(value[i:i + lv // 3], 16) for i in range(0, lv, lv // 3))

    def __rgb_to_dec(self, value):
        """
        Converts rgb to decimal colours
        :param value: tuple of RGB values
        :return: tuple of decimal values
        """
        return [v/256 for v in value]

    def __get_continuous_cmap(self, hex_list, float_list=None):
        """
        Creates a continuous colour map from a list of hex colours
        :params hex_list: list of hex colours
        :params float_list: list of floats between 0 and 1
        :return: matplotlib colour map
        """
        rgb_list = [self.__rgb_to_dec(self.__hex_to_rgb(i)) for i in hex_list]
        if float_list:
            pass
        else:
            float_list = list(np.linspace(0,1,len(rgb_list)))
        cdict = dict()
        for num, col in enumerate(['red', 'green', 'blue']):
            col_list = [[float_list[i], rgb_list[i][num], rgb_list[i][num]] for i in range(len(float_list))]
            cdict[col] = col_list
        cmp = mcolors.LinearSegmentedColormap('my_cmp', segmentdata=cdict, N=256)
        return cmp

    def plot(
        self,
        xLabels:Union[str, int]='x', xTitle:str='x',
        yLabels:Union[str, int]='y', yTitle:str='y'
    ):
        """
        Plots a heatmap with pie charts
        :param pieCols: list of columns to plot as pie charts
        :param xLabels: column to use as x labels
        :param xTitle: title for x axis
        :param yLabels: column to use as y labels
        :param yTitle: title for y axis
        """
        data_array=np.random.rand(3,4)
        xLabels=['Column1', 'Column2', 'Column3', 'Column4']
        yLabels=['Row1', 'Row2', 'Row3']

        colors = plt.get_cmap('Blues')(np.linspace(0.2, 0.7, 3))

        fig, ax = plt.subplots(figsize=(len(yLabels), len(xLabels)))
        ax.set_aspect(1)

        for row_index, row in enumerate(yLabels,0):
            for column_index, column in enumerate(xLabels,0):
                ax.pie(
                    x=[20, 10, 15],
                    radius=0.4,
                    center=(column_index, row_index),
                    colors=colors,
                    wedgeprops={"linewidth": 1, "edgecolor": "white"},
                    frame=True
                )

        ax.imshow(data_array, cmap=self.__get_continuous_cmap(["#ffffff", "#ffffff"]))

        ax.set_xticks(np.arange(data_array.shape[1]), labels=xLabels)
        ax.set_yticks(np.arange(data_array.shape[0]), labels=yLabels)
        ax.tick_params(top=True, bottom=False, labeltop=True, labelbottom=False)

        plt.setp(ax.get_xticklabels(), rotation=30, ha="left", rotation_mode="anchor")

        # ax.spines[:].set_visible(True)

        ax.set_xticks(np.arange(data_array.shape[1]+1)-.5, minor=True)
        ax.set_yticks(np.arange(data_array.shape[0]+1)-.5, minor=True)

        ax.grid(which="major", color="none", linestyle='-', linewidth=1)
        ax.grid(which="minor", color="black", linestyle='-', linewidth=1)
        ax.tick_params(which="major", top=False, bottom=False, left=False, right=False)
        ax.tick_params(which="minor", top=True, bottom=False, left=True, right=False)

        plt.legend(['high', 'middle', 'low'], loc=[1.05, 0.5])
        fig.suptitle("Throwing success", size=12)
        ax.set_xlabel(xTitle)
        ax.set_ylabel(yTitle)
        plt.style.use('_mpl-gallery')
        plt.show()

if __name__ == "__main__":
    plot = PieHeatmapPlot(np.random.rand(3,4))
    plot.plot()
