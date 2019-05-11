library(colorway)
library(ggplot2)
fig_dir <- "man/figures"

blue_palette <- build_palette("dodgerblue")

ggsave(file.path(fig_dir,"palette_plot.png"),
       blue_palette$palette_plot +
         theme_bw(base_size = 4),
       width = 4,
       height = 1)

ggsave(file.path(fig_dir,"colorset_plot.png"),
       blue_palette$colorset_plot +
         theme_bw(base_size = 4),
       width = 4,
       height = 2)

ggsave(file.path(fig_dir,"weave_plot.png"),
       blue_palette$weave +
         theme_bw(base_size = 4),
       width = 1,
       height = 1)

varied_colors <- varibow(10)

ggsave(file.path(fig_dir,"varibow_plot.png"),
                 weave_plot(varied_colors) +
         theme_bw(base_size = 4),
       width = 1, height = 1)

varibow_50 <- varibow(50)
rainbow_50 <- rainbow(50)

varibow_weave <- weave_plot(varibow_50)
rainbow_weave <- weave_plot(rainbow_50)

ggsave(file.path(fig_dir,"varibow_50_weave.png"),
       varibow_weave +
         theme_bw(base_size = 4),
       width = 2, height = 2)

ggsave(file.path(fig_dir,"rainbow_50_weave.png"),
       rainbow_weave +
         theme_bw(base_size = 4),
       width = 2, height = 2)

rainbow_colorspace <- colorspace_plot(rainbow_50)
varibow_colorspace <- colorspace_plot(varibow_50)

ggsave(file.path(fig_dir,"varibow_colorspace.png"),
       varibow_colorspace +
         theme_bw(base_size = 4),
       width = 2, height = 2)

ggsave(file.path(fig_dir,"rainbow_colorspace.png"),
       rainbow_colorspace +
         theme_bw(base_size = 4),
       width = 2, height = 2)

values <- c(1,4,10,17,20,35,42,60)
colors <- values_to_colors(values)

p1 <- ggplot() +
  geom_tile(aes(x = 1:8, y = 1,
                fill = colors)) +
  scale_fill_identity()

ggsave(file.path(fig_dir,"v2c_plot1.png"),
       p1 +
         theme_bw(base_size = 4),
       width = 4, height = 1)

colors <- values_to_colors(values,
                           colorset = c("magenta","black","yellow"))

p2 <- ggplot() +
  geom_tile(aes(x = 1:8, y = 1,
                fill = colors)) +
  scale_fill_identity()

ggsave(file.path(fig_dir,"v2c_plot2.png"),
       p2 +
         theme_bw(base_size = 4),
       width = 4, height = 1)


colors <- values_to_colors(values,
                           colorset = c("magenta","black","yellow"),
                           min_val = 10,
                           max_val = 80)

p3 <- ggplot() +
  geom_tile(aes(x = 1:8, y = 1,
                fill = colors)) +
  scale_fill_identity()


ggsave(file.path(fig_dir,"v2c_plot3.png"),
       p3 +
         theme_bw(base_size = 4),
       width = 4, height = 1)
