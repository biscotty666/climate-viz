library(tidyverse)
library(glue)

temps <- read_csv("data/GLB.Ts+dSST.csv", skip = 1, na = "***") %>%
  select(year = Year, all_of(month.abb)) %>%
  pivot_longer(-year, names_to = "month", values_to = "t_diff") %>%
  drop_na()

# last_dec <- temps %>%
#   filter(month == "Dec") %>%
#   mutate(
#     year = year + 1,
#     month = "last_Dec"
#   )
#
next_Jan <- temps %>%
  filter(month == "Jan") %>%
  mutate(
    year = year - 1,
    month = "next_Jan"
  )

t_data <-
  bind_rows(temps, next_Jan) %>%
  mutate(
    month = factor(month, levels = c(month.abb, "next_Jan")),
    month_number = as.numeric(month)
  )

annotation <- t_data %>%
  slice_max(year) %>%
  slice_max(month_number)

temp_lines <- tibble(
  x = 12,
  y = c(1.5, 2.0),
  labels = c("1.5\u00B0C", "2.0\u00B0C")
)

month_labels <- tibble(
  x = 1:12,
  y = 2.7,
  labels = month.abb
)

month_labels
t_data %>%
  ggplot(aes(
    x = month_number, y = t_diff,
    group = year, color = year
  )) +
  # Create the back background with "dummy" pie charts
  geom_col(
    data = month_labels,
    aes(x = x + 0.5, y = 2.4), fill = "black",
    width = 1,
    inherit.aes = F
  ) +
  geom_col(
    data = month_labels,
    aes(x = x + 0.5, y = -2), fill = "black",
    width = 1,
    inherit.aes = F
  ) +
  geom_line() +
  geom_hline(yintercept = c(1.5, 2.0), color = "red") +
  geom_point(data = annotation,
             aes(x = month_number, y = t_diff, color = year),
             size = 2, inherit.aes = F) +
  geom_label(
    data = temp_lines, aes(
      x = x,
      y = y,
      label = labels
    ),
    color = "red", fill = "black", label.size = 0,
    inherit.aes = FALSE
  ) +
  geom_text(
    data = month_labels,
    aes(x = x, y = y, label = labels),
    inherit.aes = F,
    color = "white",
    angle = seq(360 - 360 / 12, 0, length.out = 12)
  ) +
  geom_text(aes(x = 1, y = -1.3, label = max(temps$year))) +
  scale_x_continuous(
    breaks = 1:12,
    labels = month.abb, expand = c(0,0),
    sec.axis = dup_axis(name = NULL, labels = NULL)
  ) + # for ticks at top
  scale_y_continuous(
    breaks = seq(-2, 2, 0.2),
    limits = c(-2, 2.7), expand = c(0,-0.7),
    sec.axis = dup_axis(name = NULL, labels = NULL)
  ) +
  scale_color_viridis_c(
    breaks = seq(1880, 2024, 20),
    guide = "none"
  ) +
  #  coord_cartesian(xlim = c(1, 12)) +
  coord_polar(start = 2*pi/12) +
  labs(
    x = NULL,
    y = NULL,
    title = glue("Global temperature change ({min(temps$year)}-{max(temps$year)})")
  ) +
  theme(
    plot.background = element_rect(
      fill = "#333333",
      color = "#333333"
    ),
    panel.background = element_rect(
      fill = "#333333",
      linewidth = 1
    ),
    panel.grid = element_blank(),
    axis.text = element_blank(),
    axis.ticks = element_blank(),
    axis.title = element_blank(),
    plot.title = element_text(color = "white", size = 15, hjust = 0.5)
  )

ggsave("figures/climate_sprial.png", width = 8, height = 4.5)
