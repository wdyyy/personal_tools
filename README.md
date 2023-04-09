# personal_code_notebook

<div align="center">

[![license](https://img.shields.io/badge/lisense-GPL--3.0-brightgreen??style=flat-square)](https://gitee.com/eastsunw/personal_code_notebook/blob/master/LICENSE)&nbsp;&nbsp;![Language](https://img.shields.io/badge/Language-gray)[![R](https://img.shields.io/badge/R-green)](https://cran.r-project.org/)[![Python](https://img.shields.io/badge/Python-blue)](https://www.python.org/)[![Bash](https://img.shields.io/badge/Bash-orange)](https://www.gnu.org/software/bash/)

[![中文](https://img.shields.io/badge/中文-blue?style=for-the-badge)](https://gitee.com/eastsunw/personal_code_notebook/blob/master/README.md)&nbsp;&nbsp;&nbsp;&nbsp;[![英文](https://img.shields.io/badge/English-blue?style=for-the-badge)](https://gitee.com/eastsunw/personal_code_notebook/blob/master/README.en.md)

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

![双向条形图](https://gitee.com/eastsunw/personal_code_notebook/raw/master/assets/bi_bar_example.png)

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

![热饼图](https://gitee.com/eastsunw/personal_code_notebook/raw/master/assets/pie_heatmap_example.png)

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

### 一个画图主题-`wdy_theme.r`

一个我自己常用的ggplot主题，需要配合`theme_bw()`一起使用，可以指定的图例的位置、标题文字的大小和普通文字的大小

```r
source('https://gitee.com/eastsunw/personal_code_notebook/raw/master/wdy_theme.r')
ggplot(...) + wdy_theme(legend.position = 'bottom', title.size = 12, text.size = 10)
```

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
