wdy_theme <- function(base_size = 12, base_line_size = 1, ...) {
    default <- ggplot2::theme_bw() +
        ggplot2::theme(
            # 边框
            panel.border = element_rect(
                fill  = NULL,
                color = "black",
                size  = 2.5 * base_line_size / .pt
            ),
            # 坐标轴
            axis.title = element_text(
                color = "black",
                size  = base_size,
                face  = "bold"
            ),
            axis.text = element_text(
                color = "black",
                size  = base_size
            ),
            axis.line = element_line(
                color = "black",
                size = base_line_size / .pt
            ),
            axis.ticks = element_line(
                color = "black",
                size  = base_line_size / .pt
            ),
            # 图例
            legend.title = element_text(
                color = "black",
                size  = base_size,
                face  = "bold"
            ),
            legend.text = element_text(
                color = "black",
                size  = base_size
            ),
            # 分面
            strip.text = element_text(
                color = "black",
                size  = base_size
            ),
            strip.background = element_rect(
                color = "black",
                fill = "gray90",
                linewidth = 1
            ),
            panel.spacing.x = unit(0, 'pt'),
        )
    return(list_modify(default, ...))
}
