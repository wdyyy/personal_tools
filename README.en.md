# personal_code_notebook

<div align="center">

[![license](https://img.shields.io/badge/lisense-GPL--3.0-brightgreen??style=flat-square)](https://gitee.com/eastsunw/personal_code_notebook/blob/master/LICENSE)&nbsp;&nbsp;![Language](https://img.shields.io/badge/Language-gray)[![R](https://img.shields.io/badge/R-green)](https://cran.r-project.org/)[![Python](https://img.shields.io/badge/Python-blue)](https://www.python.org/)[![Bash](https://img.shields.io/badge/Bash-orange)](https://www.gnu.org/software/bash/)

[![中文](https://img.shields.io/badge/中文-blue?style=for-the-badge)](https://gitee.com/eastsunw/personal_code_notebook/blob/master/README.md)&nbsp;&nbsp;&nbsp;&nbsp;[![英文](https://img.shields.io/badge/English-blue?style=for-the-badge)](https://gitee.com/eastsunw/personal_code_notebook/blob/master/README.en.md)

</div>

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
ggplot(...) + wdy_theme(base_size = 12, base_line_size = 1, ...)
```

- `base_size`: The size of normal text, the default is 12
- `base_line_size`: The thickness of the line, which defaults to 1
- `...`: Other parameters, you can pass in the `ggplot2::theme` parameter, which is used to modify the theme of the graph

### Multiple sets of comparison boxplots-`plot_boxplot_with_signif.r`

#### Description

This script is mainly used to draw boxplots of multiple groups of contrasts, and perform significance tests between groups, and the results of one plot are displayed as follows:

![Multiple sets of comparison boxplots](https://gitee.com/eastsunw/personal_code_notebook/raw/master/assets/mult-group_boxplot.png)

#### How to use

The accepted data has three columns, the first two columns are character types, the third column is the numeric type, respectively **Category Name**, **Group Name** and **Value**, the data in the first column will be used as the category name to divide the panel, the data of the second column will be used as the group name, grouped when drawing the boxplot, and the data of the third column as the data function of the boxplot has the following parameters:

```r
compare_boxplot <- function(
  df,
  xlab = NULL,
  ylab = "Gene Expression",
  add_count = FALSE,
  log_transform = FALSE,
  ...
)
```

- `df`: Data frame, the type of data described above
- `xlab`: The label for the x-axis, which is empty by default
- `ylab`: The label of the y-axis, which defaults to `Gene Expression`
- `add_count`: Whether to add sample size for the X-axis, add `\n(n=xxx)` after the added label, default is `FALSE`
- `log_transform`: Whether to perform logarithmic transformation of the data, default is `FALSE`
- `...`: 其他参数，可以传入`ggplot2::theme`的参数，用于修改图形的主题

### Heatmap with statistical bar chart-`heatmap_with_stat.r`

#### Description

A heat map, rows and columns have a two-way bar chart to count the number of cut-off points, is designed to show differential expression or survival results, and the color of the heat map represents Log2FC, and the attached bar chart represents the number of high and low differences, and the results of a drawing are shown as follows:

![热图统计图](https://gitee.com/eastsunw/personal_code_notebook/raw/master/assets/heatmap_with_stat.png)

#### How to use

The accepted data is a matrix-style data table, and the data in the first column is used as the row name, so **cannot be repeated**, and the first row defaults to the column name:

```r
Rscript heatmap_with_stat.r \
    -i data.txt \
    -o ./output.pdf \
    --type expression
```

- `-i`: The data used to draw the picture cannot be missing
- `-o`: The output chart file must be in PDF format, the default is `./output.pdf`
- `--type`: Decide the type of painting, you can choose 'expression' and 'survival', the default is 'expression', this option will affect the color range (-2~2 for the expression data, 0~2 for the survival data), the title of the legend and the label name of the legend, and the classification standard of the data (0 as the cut-off point for the expression and 1 for the survival data)

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
