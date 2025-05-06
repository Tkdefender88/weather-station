import lustre/attribute.{attribute, class, id}
import lustre/element.{type Element}
import lustre/element/html
import lustre/element/svg
import messages/msgs.{type Msg}

pub fn footer() -> Element(Msg) {
  html.footer([attribute.class("mt-auto py-6 bg-gray-200")], [
    html.div([attribute.class("container mx-auto text-center text-gray-600")], [
      html.p([], [html.text("Simple Weather Station Dashboard")]),
    ]),
  ])
}

pub fn top_bar() -> Element(Msg) {
  html.nav([class("bg-blue-600 text-white p-4 shadow-md")], [
    html.div([class("container mx-auto flex justify-between items-center")], [
      html.div([class("flex items-center")], [
        svg.svg(
          [
            attribute("xmlns", "http://www.w3.org/2000/svg"),
            attribute("viewBox", "0 0 24 24"),
            attribute("stroke", "currentColor"),
            attribute("fill", "none"),
            class("h-8 w-8 mr-2"),
          ],
          [
            svg.path([
              attribute(
                "d",
                "M3 15a4 4 0 004 4h9a5 5 0 10-.1-9.999 5.002 5.002 0 10-9.78 2.096A4.001 4.001 0 003 15z",
              ),
              attribute("stroke-width", "2"),
              attribute("stroke-linejoin", "round"),
              attribute("stroke-linecap", "round"),
            ]),
          ],
        ),
        html.h1([class("text-2xl font-bold")], [html.text("Weather Station")]),
      ]),
      html.div([class("text-lg font-medium"), id("current-date")], [
        html.text("May 6, 2025"),
      ]),
    ]),
  ])
}
