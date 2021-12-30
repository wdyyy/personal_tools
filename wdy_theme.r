wdy_theme <- function(title = 14, text = 12, line = 1, border = TRUE, legend = "none") {
    if (border) {
        axis_line = element_blank()
    } else {
        axis_line = element_line(
            color = "black",
            size  = line / .pt
        )
    }
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
        axis.line = axis_line,
        axis.ticks = element_line(
            color = "black",
            size  = line / .pt
        ),
        # 图例
        legend.position = legend,
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
        )
    )
}