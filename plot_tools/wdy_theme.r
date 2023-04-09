wdy_theme <- function(title = 12, text = 10, line = 1, ...) {
    ggplot2::theme_bw() +
    ggplot2::theme(
        # 边框
        panel.border = element_rect(
            fill  = NULL,
            color = "black",
            size  = 2.5 * line / .pt
        ),
        # 坐标轴
        axis.title = element_text(
            color = "black",
            size  = title
        ),
        axis.text = element_text(
            color = "black",
            size  = text
        ),
        axis.line = element_line(
            color = "black",
            size = line / .pt
        ),
        axis.ticks = element_line(
            color = "black",
            size  = line / .pt
        ),
        # 图例
        legend.title = element_text(
            color = "black",
            size  = title
        ),
        legend.text = element_text(
            color = "black",
            size  = text
        ),
        # 分面
        strip.text = element_text(
            color = "black",
            size  = text
        ),
        ...
    )
}