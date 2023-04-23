# -------------
# FileName     : plot_boxplot_with_signif
# Author       : EastsunW eastsunw@foxmail.com
# Create at    : 2023-04-23 21:25
# Last Modified: 2023-04-23 23:39
# Modified By  : EastsunW
# -------------
# Description  : 画多种分类比较的boxplot，并添加组件比较的显著性标注
# -------------

# 需要的数据有三列，分别是：组名，组内分类，数值
# 例如：
# Group_Name Group_category Expression
# ACC Tumor 1
# ACC Normal 2
# ACC Tumor 0.5
# BRCA  Tumor 1
# BRCA  Tumor 1.1
# BRCA  Normal 2
# 组名会被用来分块，组内的分类会被用来分组画箱线图

compare_boxplot <- function(
  df,
  xlab = NULL,
  ylab = "Gene Expression",
  add_count = FALSE,
  log_transform = FALSE,
  ...
) {
  suppressPackageStartupMessages(library(tidyverse))
  suppressPackageStartupMessages(library(ggpubr))
  source("https://gitee.com/eastsunw/personal_code_notebook/raw/master/plot_tools/wdy_theme.r")

  if (ncol(df) > 3) {
    warning("Dataframe has >3 cols, will ignore the extra columns.")
    df <- df %>% select(seq_len(3))
  }
  df <- df %>%
    data.table::setnames(c("Group_Name", "Group_category", "Value"))

  if (log_transform) {
    df <- df %>%
      mutate_at(vars(3), ~ log2(. + 1))
    ylab <- paste0(ylab, "\n(Log2 Transformed)")
  }

  if (add_count) {
    df <- df %>%
      group_by(Group_Name, Group_category) %>%
      mutate(sample_size = n()) %>%
      mutate(xText = paste0(
        Group_category,
        "\n(n=",
        sample_size,
        ")"
      )) %>%
      select(-sample_size) %>%
      ungroup()
  } else {
    df <- df %>%
      mutate(xText = Group_category)
  }

  max_value <- df %>%
    group_by(Group_Name) %>%
    summarise(min = min(Value), max = max(Value)) %>%
    ungroup() %>%
    mutate_if(
      is.character,
      .funs = function(col) {
        return(factor(col, levels = unique(col)))
      }
    )

  anno_df <- compare_means(
    data = df,
    Value ~ xText,
    group.by = "Group_Name"
  ) %>%
    mutate(y.position = max(max_value$max) + 0.5)

  ggplot(
    df,
    aes(
      x = xText,
      y = Value,
      color = Group_category
    )
  ) +
    geom_boxplot(
      width = 0.5,
      linewidth = 1,
      fill = NA
    ) +
    stat_boxplot(
      geom = "errorbar",
      width = 0.5,
      linewidth = 1
    ) +
    geom_point(
      size = 1,
      position = position_jitter(width = 0.1, seed = 2023)
    ) +
    ggpubr::stat_pvalue_manual(
      data = anno_df,
      label = "p.adj",
      label.size = 12 / .pt,
      bracket.size = 1,
      vjust = -0.25
    ) +
    facet_wrap(~ Group_Name, scales = "free_x", nrow = 1) +
    labs(
      x = xlab,
      y = ylab
    ) +
    wdy_theme(
      legend.position = "none",
      axis.line.x = element_blank(),
      axis.line.y = element_blank(),
      axis.text.x = element_text(
        hjust = 0.5,
      ),
      panel.spacing.x = unit(0, "pt"),
      strip.background = element_rect(fill = "gray90", linewidth = 1),
      ...
    ) +
    scale_y_continuous(
      expand = expansion(
        mult = c(0.05, 0.05),
        add = c(0, 0.25)
      )
    )
}
