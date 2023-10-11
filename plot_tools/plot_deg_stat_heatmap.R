suppressPackageStartupMessages(library(tidyverse))
suppressPackageStartupMessages(library(data.table))
suppressPackageStartupMessages(library(ComplexHeatmap))
source("https://gitee.com/eastsunw/personal_code_notebook/raw/master/plot_tools/plot_bi_directional_bar.r")

suppressPackageStartupMessages(library("optparse"))
suppressMessages({
    suppressWarnings({
        get_options <- function() {
            usage <- "usage: Rscript %prog [options] <arguments>"
            description <- "description"
            option_list <- list(
                make_option(
                    c("-i", "--input"),
                    type    = "character",
                    dest    = "input",
                    metavar = "<path>",
                    default = FALSE,
                    action  = "store",
                    help    = "Path to your input data, it should be a matrix with rownames and colnames, the first column will be used as rownames, the first row will be used as colnames"
                ),
                make_option(
                    c("--type"),
                    type    = "character",
                    dest    = "type",
                    metavar = "<expression|survival>",
                    default = "expression",
                    action  = "store",
                    help    = "Analysis type, default is 'Expression', in which case the heatmap cell represents the expression level of genes (log2FC), with a stat to count the over-expressed genes and under-expressed genes in each row and column. If you want to plot other type of data, you can specify this argument to other name, currently, only 'expression' and 'survival' is supported."
                ),
                make_option(
                    c("--cluster_row"),
                    type    = "logical",
                    dest    = "cluster_row",
                    metavar = "<FALSE|TRUE>",
                    default = FALSE,
                    action  = "store_true",
                    help    = "whether to cluster rows, default FALSE."
                ),
                make_option(
                    c("--cluster_col"),
                    type    = "logical",
                    dest    = "cluster_col",
                    metavar = "<FALSE|TRUE>",
                    default = FALSE,
                    action  = "store_true",
                    help    = "whether to cluster columns, default FALSE."
                ),
                make_option(
                    c("-o", "--output"),
                    type    = "character",
                    dest    = "output",
                    metavar = "<path>",
                    default = "heatmap.pdf",
                    action  = "store",
                    help    = "Path to the output pdf, default is 'heatmap.pdf'"
                )
            )
            opt_obj <- OptionParser(
                usage           = usage,
                description     = description,
                add_help_option = TRUE,
                option_list     = option_list
            )
            opts <- optparse::parse_args(opt_obj)
            if (length(commandArgs(TRUE)) == 0) {
                optparse::print_help(opt_obj)
                if (interactive()) {
                    stop("help requested")
                } else {
                    quit(status = 0)
                }
            } else {
                return(opts)
            }
        }

        options <- get_options()
        if (any(unlist(options) == "")) {
            optparse::print_help(opt_obj)
            stop(
                paste0(
                    "These argument are not specified:\n\t --",
                    paste0(
                        names(unlist(options)[unlist(options) == ""]),
                        collapse = "\n\t --"
                    )
                )
            )
        }


        arguments <- list(
            "expression" = list(
                colors = circlize::colorRamp2(c(-2, 0, 2), c("blue", "white", "red")),
                legend_heatmap = "Log2FC",
                legend_stat = "Expression",
                cutpoint = 0,
                category = c("down", "up")
            ),
            "survival" = list(
                colors = circlize::colorRamp2(c(0, 1, 2), c("blue", "white", "red")),
                legend_heatmap = "Hazard Ratio",
                legend_stat = "Survival",
                cutpoint = 1,
                category = c("protective", "harmfull")
            )
        )

        data_matrix <- fread(options[["input"]]) %>%
            column_to_rownames(colnames(.)[1])

        if ("compartment" %in% colnames(data_matrix)) {
            data_matrix <- data_matrix %>%
                dplyr::select(-compartment) %>%
                as.matrix()
        } else {
            data_matrix <- data_matrix %>%
                as.matrix()
        }

        row_stat <- as.data.frame(do.call(rbind, apply(
            data_matrix,
            1,
            function(row) {
                list(
                    down = length(which(row < arguments[[options[["type"]]]][["cutpoint"]])),
                    up = length(which(row > arguments[[options[["type"]]]][["cutpoint"]]))
                )
            }
        ))) %>%
            rownames_to_column("name") %>%
            mutate_at(
                2:3,
                as.numeric
            )
        col_stat <- as.data.frame(do.call(rbind, apply(
            data_matrix,
            2,
            function(row) {
                list(
                    down = length(which(row < arguments[[options[["type"]]]][["cutpoint"]])),
                    up = length(which(row > arguments[[options[["type"]]]][["cutpoint"]]))
                )
            }
        ))) %>%
            rownames_to_column("name") %>%
            mutate_at(
                2:3,
                as.numeric
            )

        # 画图

        pdf(
            file = options[["output"]],
            width = ncol(data_matrix) / 2.54 + 3,
            height = nrow(data_matrix) / 2.54 + 2.5,
            onefile = TRUE
        )

        # 首先画热图并聚类
        heatmap_plot <- draw(
            Heatmap(
                name = arguments[[options[["type"]]]][["legend_heatmap"]],
                matrix = data_matrix,
                width = unit(ncol(data_matrix), "cm"),
                height = unit(nrow(data_matrix), "cm"),
                cluster_rows = options[["cluster_row"]],
                cluster_columns = options[["cluster_col"]],
                col = arguments[[options[["type"]]]][["colors"]],
                border_gp = gpar(col = "black", lwd = 1),
                rect_gp = gpar(col = "white", lwd = 1),
                row_names_gp = gpar(fontsize = 10),
                column_names_gp = gpar(fontsize = 10),
                show_column_names = FALSE,
                show_row_names = FALSE,
                show_heatmap_legend = FALSE,
                right_annotation = rowAnnotation(
                    rowname = anno_text(row_stat$name),
                    ggplot_row = anno_empty(width = unit(3, "cm")),
                    gp = gpar(
                        col = "black",
                        lty = 2,
                        lwd = 1,
                        fontsize = 10
                    )
                ),
                bottom_annotation = HeatmapAnnotation(
                    colname = anno_text(col_stat$name),
                    ggplot_col = anno_empty(height = unit(3, "cm")),
                    gp = gpar(
                        col = "black",
                        lty = 2,
                        lwd = 1,
                        fontsize = 10
                    )
                )
            )
        )

        # 构建行的统计（右边）
        row_order <- row_order(heatmap_plot)
        row_anno_data <- data.frame(
            gene = row_stat$name[row_order],
            down = row_stat$down[row_order],
            up = row_stat$up[row_order]
        )
        row_anno_plot <- plot_bar(row_anno_data, sort = FALSE) +
            scale_y_discrete(
                expand = expansion(mult = 0, add = 0.5)
            ) +
            scale_x_continuous(
                expand = expansion(mult = 0.4, add = 0.5)
            ) +
            scale_fill_manual(
                values = c("down" = "blue", "up" = "red")
            ) +
            geom_text(
                aes(
                    label = after_stat(ifelse(x == 0, NA, abs(x))),
                    hjust = after_stat(ifelse(x <= 0, 1.3, -0.3))
                ),
                size = 10 / .pt,
                vjust = 0.5
            ) +
            theme_void() +
            theme(
                plot.margin = unit(c(0, 0, 0, 0), "cm"),
                panel.grid = element_blank(),
                legend.position = "none"
            )

        # 构建列的统计（下边）
        col_order <- column_order(heatmap_plot)
        col_anno_data <- data.frame(
            gene = rev(unname(unlist(col_stat[["name"]][col_order]))),
            down = rev(unname(unlist(col_stat[["down"]][col_order]))),
            up = rev(unname(unlist(col_stat[["up"]][col_order])))
        )
        col_anno_plot <- plot_bar(col_anno_data, sort = FALSE) +
            scale_y_discrete(
                expand = expansion(mult = 0, add = 0.5)
            ) +
            scale_x_continuous(
                expand = expansion(mult = 0.4, add = 0.5)
            ) +
            scale_fill_manual(
                values = c("down" = "blue", "up" = "red")
            ) +
            geom_text(
                aes(
                    label = after_stat(ifelse(x == 0, NA, abs(x))),
                    vjust = after_stat(ifelse(x <= 0, 1.3, -0.3))
                ),
                size = 10 / .pt,
                hjust = 0.5
            ) +
            coord_flip() +
            theme_void() +
            theme(
                plot.margin = unit(c(0, 0, 0, 0), "cm"),
                panel.grid = element_blank(),
                legend.position = "none"
            )

        legend_updown <- Legend(
            type = "grid",
            title = arguments[[snakemake@params[["plot_type"]]]][["legend_stat"]],
            title_gp = gpar(fontsize = 10, fontface = "bold"),
            labels = arguments[[snakemake@params[["plot_type"]]]][["category"]],
            labels_gp = gpar(fontsize = 10),
            border = "black",
            legend_gp = gpar(fill = c("blue", "red"))
        )
        legend_fc <- Legend(
            at = c(seq(-2, 2, 1)),
            labels_gp = gpar(fontsize = 10),
            col_fun = arguments[[snakemake@params[["plot_type"]]]][["colors"]],
            title = arguments[[snakemake@params[["plot_type"]]]][["legend_heatmap"]],
            title_gp = gpar(fontsize = 10, fontface = "bold"),
            direction = "horizontal"
        )

        legend_list <- packLegend(
            legend_fc, legend_updown,
            direction = "vertical"
        )

        draw(
            legend_list,
            x = unit(ncol(data_matrix) + 2.5, "cm"),
            y = unit(1.5, "cm"),
            just = c("left", "bottom")
        )

        decorate_annotation("ggplot_row", {
            vp <- current.viewport()$name
            print(row_anno_plot, vp = vp)
        })

        decorate_annotation("ggplot_col", {
            vp <- current.viewport()$name
            print(col_anno_plot, vp = vp)
        })

        a <- dev.off()
        rm(a)
    })
})
