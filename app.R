library(dash)
library(dashHtmlComponents)
library(readr)
library(plotly)
library(ggplot2)
library(broom)
library(geojsonio)
library(dplyr)

# Input data
df <- read_csv("data/processed_trees.csv")
url_geojson <- "https://raw.githubusercontent.com/UBC-MDS/cherry_blossom_tracker/main/data/vancouver.geojson"
#geojson <- rjson::fromJSON(file=url_geojson)
geojson <- geojson_read(url_geojson, what = "sp")
geojson2 <- tidy(geojson, region = "name")

app = Dash$new(external_stylesheets = "https://codepen.io/chriddyp/pen/bWLwgP.css")

# Big Street Map
# https://plotly.com/r/mapbox-layers/
fig <- df %>%
  plot_ly(
    lat = ~lat,
    lon = ~lon,
    marker = list(color = "fuchsia"),
    type = 'scattermapbox'
  )

fig <- fig %>%
  layout(
    mapbox = list(
      style = 'open-street-map',
      zoom = 10,
      center = list(lat=49.24, lon =-123.11)
    )
  )

# Choropleth
# fig_cho <- plot_ly()
# fig_cho <- fig_cho %>%
#   add_trace(
#     type="choropleth",
#     geojson=geojson,
#     locations=df$NEIGHBOURHOOD_NAME,
#     z=df$TREE_ID,
#     transforms = list(
#       type = 'aggregate',
#       groups = df$NEIGHBOURHOOD_NAME,
#       aggregations = list(
#         list(
#           target = 'z', func = 'count', enabled = T
#         )
#       )
#     )
#   )

# aggregate

geojson2 <- geojson2 %>%
  left_join(df %>% count(NEIGHBOURHOOD_NAME),
            by = c("id" = "NEIGHBOURHOOD_NAME"))

fig_cho <- ggplot() +
  geom_polygon(data = geojson2, 
               aes(x = long, y = lat, group = group, fill = n)) +
  coord_map()

#dccGraph(figure=fig),
#dccGraph(figure=fig_cho)

app %>% set_layout(
  div(
    dccGraph(figure=fig)
  ),
  div(
    dccGraph(figure=ggplotly(fig_cho))
  )
)

app$run_server(host = '0.0.0.0')
#app$run_server(debug = T)

