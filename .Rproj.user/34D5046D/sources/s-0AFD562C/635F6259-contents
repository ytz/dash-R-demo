library(dash)
library(dashHtmlComponents)
library(readr)
library(plotly)

df = read_csv("data/processed_trees.csv")

app = Dash$new(external_stylesheets = "https://codepen.io/chriddyp/pen/bWLwgP.css")

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


app$layout(

    dccGraph(figure=fig)
  
)

app$run_server(debug = T)

