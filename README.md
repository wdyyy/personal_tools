# personal_tools

<div align="center">

[![license](https://img.shields.io/badge/lisense-GPL--3.0-brightgreen??style=flat-square)](https://github.com/wdyyy/personal_tools/blob/master/LICENSE)&nbsp;&nbsp;![Language](https://img.shields.io/badge/Language-gray)[![R](https://img.shields.io/badge/R-green)](https://cran.r-project.org/)[![Python](https://img.shields.io/badge/Python-blue)](https://www.python.org/)[![Bash](https://img.shields.io/badge/Bash-orange)](https://www.gnu.org/software/bash/)

[![中文](https://img.shields.io/badge/中文-blue?style=for-the-badge)](https://github.com/wdyyy/personal_tools/blob/master/README.md)&nbsp;&nbsp;&nbsp;&nbsp;[![英文](https://img.shields.io/badge/English-blue?style=for-the-badge)](https://github.com/wdyyy/personal_tools/blob/master/README.en.md)

</div>

我自己的代码笔记本，这里保存着常用的脚本，通常为函数或者类，直接导入使用。

## 温馨提示

1.  对于R语言的函数，直接使用`source()`，参数为脚本的raw地址，然后直接使用脚本即可
2.  对于Python语言的函数或者类，下载该脚本到同一目录，然后使用`import`导入就行了，暂时还不知道从网络直接导入脚本的办法。

---

## 画图工具

### 双向条形图-`plot_bi_directional_bar.r`

#### 描述

使用此脚本可以画出左右两个方向的对比条形图，使用传统方法绘制的时候，坐标轴只能是从负数到正数，此脚本解决了坐标轴数值显示的问题，将0刻度线左右的坐标都设置为了正数。一个画图的结果展示如下：

![双向条形图](https://github.com/wdyyy/personal_tools/raw/master/assets/bi_bar_example.png)

#### 使用方法

接受的数据有三列，分别是**分类名**、**左侧数据**和**右侧数据**，第一列的数据会作为分类名，第二列和第三列的数据会作为左右两侧的数据，需要注意的是两列数据必须都不能为负数，函数有以下参数：

```r
plot_bar <- function(df, ylab = "Cluster", xlab = "Count", group = "Type", ...)
```

- `df`: 数据框，必须有三列，分别是分类名、左侧数据和右侧数据
- `ylab`: y轴的标签，默认为`Cluster`
- `xlab`: x轴的标签，默认为`Count`
- `group`: 分类名的列名，默认为`Type`
- `...`: 其他参数，可以传入`ggplot2::theme`的参数，用于修改图形的主题

### 热力饼图-`plot_PieHeatmap.py`

#### 描述

这个工具基于Python的Matplotlib，用于绘制饼图热力图，这种图是把热力图的每一个格子替换成饼图，原理类似scatterPie，一个画图的结果展示如下：

![热饼图](https://github.com/wdyyy/personal_tools/raw/master/assets/pie_heatmap_example.png)

#### 使用方法

1. 下载该脚本到同一目录
2. 以导入包的形式使用：
   ```python
   # 导入
   from plot_PieHeatmap import PieHeatmapPlot
   # 构建一个类对象
   ph = PieHeatmapPlot(data)
   ph.plot(
      title='Pie Heatmap Plot',
      xTitle=None,
      yTitle=None,
      cmap=None,
      savePath='output.png'
   )
   ```
3. 直接运行脚本：
   ```bash
   python plot_PieHeatmap.py -d './data.txt' -t 'Pie Heatmap Plot' -x 'X' -y 'Y' -o './output.png'
   ```

### 带统计条形图的热图

#### 描述

一个热图，行和列都有双向的条形图来针对一个分界点进行数量的统计，被设计用来展示差异表达或者生存结果，对与差异表达，热图的颜色表示Log2FC，附带的条形图表示差异高表达和差异低表达的数量，一个画图的结果展示如下：

![热图统计图](https://github.com/wdyyy/personal_tools/raw/master/assets/heatmap_with_stat.png)

#### 使用方法

接受的数据是一个矩阵样式的数据表，第一列的数据会被用作行名，因此**不能重复**，第一行默认为列名：

```r
Rscript heatmap_with_stat.r \
    -i data.txt \
    -o ./output.pdf \
    --type expression \
    --cluster_row \
    --cluster_col
```

- `-i`: 用来画图的数据，不能缺少
- `-o`: 输出的图表文件，必须为PDF格式，默认为 `./output.pdf`
- `--type`: 决定画图的类型，可选 `expression` 和 `survival`，默认为`expression`，这个选项会影响颜色范围（表达数据为-2~2，生存数据为0~2）、图例的标题和图例的标签名、数据的分类标准（对表达量以0作为分界点，对生存数据用1作为分界点）
- `--cluster_row`: 是否对行进行聚类，默认为`FALSE`
- `--cluster_col`: 是否对列进行聚类，默认为`FALSE`

### 一个画图主题-`wdy_theme.r`

一个我自己常用的ggplot主题，需要配合`theme_bw()`一起使用，可以指定的图例的位置、标题文字的大小和普通文字的大小

```r
source('https://raw.githubusercontent.com/wdyyy/personal_tools/refs/heads/master/plot_tools/wdy_theme.r')
ggplot(...) + wdy_theme(base_size = 12, base_line_size = 1, ...)
```

- `base_size`: 普通文字的大小，默认为12
- `base_line_size`: 线条的粗细，默认为1
- `...`: 其他参数，可以传入`ggplot2::theme`的参数，用于修改图形的主题

### 多组对比箱线图-`plot_boxplot_with_signif.r`

#### 描述

此脚本主要用于绘制多组对比的箱线图，并且在组间进行显著性检验，一个画图的结果展示如下：

![多组箱线图](https://github.com/wdyyy/personal_tools/raw/master/assets/mult-group_boxplot.png)

#### 使用方法

接受的数据有三列，前两列为字符类型，第三列是数值类型，分别是**分类名**、**分组名**和**数值**，第一列的数据会作为分类名，用来进行面板的分割，第二列的数据作为分组名，在绘制箱线图的时候进行分组，第三列的数据作为箱线图的数据函数有以下参数：

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

- `df`: 数据框，数据的类型如上所述
- `xlab`: x轴的标签，默认为空
- `ylab`: y轴的标签，默认为`Gene Expression`
- `add_count`: 是否为X轴添加样本量，添加后的标签在原标签后面添加`\n(n=xxx)`，默认为`FALSE`
- `log_transform`: 是否对数据进行对数变换，默认为`FALSE`
- `...`: 其他参数，可以传入`ggplot2::theme`的参数，用于修改图形的主题

## 其他工具

### JSON排序小工具-`json_sorter.py`

我用来给JSON文件排序的小工具，用途是给VScode的设置JSON排序，使用方法如下：

```bash
python json_sorter.py -i ./settings.json -o ./settings_sorted.json
```

### MongoDB数据上传工具-`mongo_upload.py`

我用来将文件上传到MongoDB的工具，这个脚本通过一个配置文件来指定上传的文件和MongoDB的连接信息，配置文件的格式如下：

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

具体使用方法可以通过`python mongo_uploader.py --help`查看

### Linux的配置脚本-`linux_init.sh`

用来一键配置Linux系统的脚本，目前只支持Ubuntu，目前添加的功能有：

- 设置apt镜像源
- Git账户配置
- 安装Zsh和OMZ
- 安装和配置conda
