# personal_code_notebook

#### 介绍
我自己的代码笔记本，这里保存着常用的脚本，通常为函数或者类，直接导入使用。

#### 使用说明

1.  对于R语言的函数，直接使用`source()`，参数为脚本的网址，然后直接使用脚本即可
2.  对于Python语言的函数或者类，下载该脚本到同一目录，然后使用`import`导入就行了，暂时还不知道从网络直接导入脚本的办法。

#### 脚本说明
- `plot_bi_directional_bar.r`: 画出左右两个方向的对比条形图，接受的数据有三列，分别是类名、左侧的数据和右侧的数据，需要注意的是所有数据必须为正数，一个例子如下：
    ![示例](https://gitee.com/eastsunw/personal_code_notebook/blob/master/assets/motif_top20_disrupt_gain_and_loss.png)

- `wdy_theme.r`: 一个我自己常用的ggplot主题，需要配合`theme_bw()`一起使用，可以指定的图例的位置、标题文字的大小和普通文字的大小
