# personal_code_notebook

My own code notebook, where commonly used scripts, usually functions or classes, are stored and imported directly.

## Tips

1. For R functions, use `source()` directly, the parameter is the raw address of the script, and then use the script directly
2. For functions or classes of the Python language, download the script to the same directory, and then use `import` to import, and I don't know how to import the script directly from the network.

---

## Plotting tools

### Bidirectional bar chart-`plot_bi_directional_bar.r`

#### Description

Use this script to draw a contrast bar chart in the left and right directions, when drawing using the traditional method, the coordinate axis can only be from negative to positive, this script solves the problem of the axis value display, the coordinates around the 0 tick mark are set to positive numbers. The result of a drawing is shown as follows:


![Bidirectional bar chart](https://gitee.com/eastsunw/personal_code_notebook/raw/master/assets/bi_bar_example.png)

#### How to use

The accepted data has three columns, which are **category name**, **left data** and **right data**, the data in the first column will be used as the category name, the data in the second and third columns will be used as the left and right data, it should be noted that the data in both columns must not be negative, the function has the following parameters:

```r
plot_bar <- function(df, ylab = "Cluster", xlab = "Count", group = "Type", ...)
```

- `df`: The data frame must have three columns, which are the category name, the left data, and the right data
- `ylab`: The label for the y-axis, defaults to `Cluster`
- `xlab`: The label for the x-axis, defaults to `Count`
- `group`: The column name of the category name, which defaults to `Type`
- `...`: Other parameters, you can pass in the `ggplot2::theme` parameter, which is used to modify the theme of the graph

### Heat pie chart-`plot_PieHeatmap.py`

#### Description

This tool is based on Python's Matplotlib for pie chart heat map, which replaces each cell of the heat map with a pie chart, the principle is similar to scatterPie, and the result of a drawing is shown as follows:

![Heat pie chart](https://gitee.com/eastsunw/personal_code_notebook/raw/master/assets/pie_heatmap_example.png)

#### How to use

1. Download the script to the same directory
2. Used as an import package:
   ```python
   from plot_PieHeatmap import PieHeatmapPlot
   ph = PieHeatmapPlot(data)
   ph.plot(
      title='Pie Heatmap Plot',
      xTitle=None,
      yTitle=None,
      cmap=None,
      savePath='output.png'
   )
   ```
3. Run the script directly:
   ```bash
   python plot_PieHeatmap.py -d './data.txt' -t 'Pie Heatmap Plot' -x 'X' -y 'Y' -o './output.png'
   ```

### a ggplot theme-`wdy_theme.r`

A ggplot theme that I use frequently, which needs to be used with `theme_bw()`, can specify the position of the legend, the size of the title text, and the size of the normal text


```r
source('https://gitee.com/eastsunw/personal_code_notebook/raw/master/wdy_theme.r')
ggplot(...) + wdy_theme(legend.position = 'bottom', title.size = 12, text.size = 10)
```

## Other tools

### JSON sorting-`json_sorter.py`

The small tool I use to sort JSON files is to set JSON sorting for VScode. The method of use is as follows:

```bash
python json_sorter.py -i ./settings.json -o ./settings_sorted.json
```

### MongoDB数据上传工具-`mongo_upload.py`

The tool I used to upload files to MongoDB, this script specifies the uploaded file and MongoDB connection information through a configuration file, the configuration file format is as follows:

```json
{
    "mongo": {
        "host": "localhost",
        "port": 27017,
        "db": "test",
        "collection": "test"
    },
    "file": {
        "path": "./data.json",
        "encoding": "utf-8"
    }
}
```

The specific usage can be viewed using `python mongo_uploader.py --help`


### Configuration scripts for Linux-`linux_init.sh`

The script used to configure the Linux system with one click currently only supports Ubuntu, and the functions added so far are:

- Set up apt image source
- Git account configuration
- Install Zsh and OMZ
- Install and configure conda
