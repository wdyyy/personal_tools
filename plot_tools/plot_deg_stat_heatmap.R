suppressPackageStartupMessages(library(tidyverse))
suppressPackageStartupMessages(library(data.table))
suppressPackageStartupMessages(library(ComplexHeatmap))
source("https://gitee.com/eastsunw/personal_code_notebook/raw/master/plot_tools/plot_bi_directional_bar.r")

# 准备一个测试数据，假设这是一个差异表达的log2FC矩阵
data_matrix = matrix(
    data = runif(25, -1, 1),
    nrow = 5,
    ncol = 5,
    dimnames = list(
        row = paste0("gene", 1:5),
        col = paste0("cancer", 1:5)
    )
)
row_stat = as.data.frame(do.call(rbind, apply(
    data_matrix,
    1,
    function(row) {
        list(
            down = length(which(row < 0)),
            up = length(which(row > 0))
        )
    }
))) %>% rownames_to_column("name")
col_stat = as.data.frame(do.call(rbind, apply(
    data_matrix,
    2,
    function(row) {
        list(
            down = length(which(row < 0)),
            up = length(which(row > 0))
        )
    }
))) %>% rownames_to_column("name")


# 首先画热图并聚类
heatmap_plot = draw(Heatmap(
    matrix = data_matrix
))

# 构建行的统计（右边）
row_order = row_order(heatmap_plot)
row_anno_data = data.frame(
    gene = unname(unlist(row_stat[["name"]][row_order])),
    down = unname(unlist(row_stat[["down"]][row_order])),
    up = unname(unlist(row_stat[["up"]][row_order]))
)

# 构建列的统计（下边）
col_order = column_order(heatmap_plot)
col_anno_data = data.frame(
    gene = unname(unlist(col_stat[["name"]][col_order])),
    down = unname(unlist(col_stat[["down"]][col_order])),
    up = unname(unlist(col_stat[["up"]][col_order]))
)
png()
plot_bar(row_anno_data)
dev.off()
