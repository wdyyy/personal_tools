#' A function to draw a bi-directional bar-plot with your data
#'
#' @param df A data frame with three columns, first is the class, and the other two is your two groups. The first group (2nd column) will be set to negative.
#' @param ylab The title of the y-axis.
#' @param xlab The title of the x-axis.
#' @param group The title of the legend.
#'
#' @return A ggplot object
#' @export
#'
#' @examples
plot_bar <- function(df, ylab = "Cluster", xlab = "Count", group = "Type", sort = TRUE, ...) {
    source("https://gitee.com/eastsunw/personal_code_notebook/raw/master/plot_tools/plot_bi_directional_bar.r")
    if(sort) {
        data <- df %>%
            arrange(desc(.[[2]] + .[[3]]), desc(.[[1]]), desc(.[[2]])) %>%
            mutate_at(1, ~ factor(., levels = rev(.))) %>%
            mutate_at(2, ~ -.) %>%
            pivot_longer(-1, names_to = "Group", values_to = "Value") %>%
            mutate_at(2, ~ factor(., levels = colnames(df)[-1]))
    } else {
        data <- df %>%
            mutate_at(1, ~ factor(., levels = rev(.))) %>%
            mutate_at(2, ~ -.) %>%
            pivot_longer(-1, names_to = "Group", values_to = "Value") %>%
            mutate_at(2, ~ factor(., levels = colnames(df)[-1]))
    }
    preplot <- ggplot(
        data = data,
        mapping = aes(
            y = .data[[colnames(df)[1]]],
            x = Value
        )
    ) +
        geom_bar(
            aes(
                group = Group,
                fill = Group
            ),
            stat = "identity",
            width = 0.6,
            color = "black"
        ) +
        labs(
            xlab = xlab,
            ylab = ylab,
            fill = group
        ) +
        wdy_theme(
            ...
        )
    plot <- preplot + scale_x_continuous(
        labels = abs(ggplot_build(preplot)$layout[["panel_params"]][[1]][["x.sec"]][["breaks"]])
    )
    return(plot)
}
