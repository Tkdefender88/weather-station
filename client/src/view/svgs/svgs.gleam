import lustre/attribute.{attribute}
import lustre/element.{type Element}
import lustre/element/html
import lustre/element/svg
import messages/msgs.{type Msg}

pub fn svg_windspeed_icon() -> Element(Msg) {
  html.div([attribute.class("bg-blue-100 p-3 rounded-full mb-4")], [
    svg.svg(
      [
        attribute("xmlns", "http://www.w3.org/2000/svg"),
        attribute("viewBox", "0 0 24 24"),
        attribute("stroke", "currentColor"),
        attribute("fill", "none"),
        attribute.class("h-8 w-8 text-blue-500"),
      ],
      [
        svg.path([
          attribute(
            "d",
            "M9.75 17L9 20l-1 1h8l-1-1-.75-3M3 13h18M5 17h14a2 2 0 002-2V5a2 2 0 00-2-2H5a2 2 0 00-2 2v10a2 2 0 002 2z",
          ),
          attribute("stroke-width", "2"),
          attribute("stroke-linejoin", "round"),
          attribute("stroke-linecap", "round"),
        ]),
      ],
    ),
  ])
}

pub fn svg_humidity_icon() -> Element(Msg) {
  html.div([attribute.class("bg-green-100 p-3 rounded-full mb-4")], [
    svg.svg(
      [
        attribute("xmlns", "http://www.w3.org/2000/svg"),
        attribute("fill", "none"),
        attribute("viewBox", "0 0 24 24"),
        attribute.class("h-8 w-8 text-green-500"),
      ],
      [
        svg.path([
          attribute("fill", "none"),
          attribute("stroke-linejoin", "round"),
          attribute("stroke-linecap", "round"),
          attribute("stroke-width", "2"),
          attribute("stroke", "currentColor"),
          attribute("d", "M12 2.69l5.66 5.66a8 8 0 1 1-11.31 0z"),
        ]),
        svg.circle([
          attribute("fill", "currentColor"),
          attribute("r", "1"),
          attribute("cy", "9"),
          attribute("cx", "9"),
        ]),
        svg.circle([
          attribute("fill", "currentColor"),
          attribute("r", "1"),
          attribute("cy", "15"),
          attribute("cx", "15"),
        ]),
        svg.line([
          attribute("stroke-linecap", "round"),
          attribute("stroke-width", "1.5"),
          attribute("stroke", "currentColor"),
          attribute("y2", "16"),
          attribute("x2", "8"),
          attribute("y1", "8"),
          attribute("x1", "16"),
        ]),
      ],
    ),
  ])
}

pub fn svg_temperature_icon() -> Element(Msg) {
  html.div([attribute.class("bg-red-100 p-3 rounded-full mb-4")], [
    svg.svg(
      [
        attribute("xmlns", "http://www.w3.org/2000/svg"),
        attribute("viewBox", "0 0 24 24"),
        attribute("stroke", "currentColor"),
        attribute("fill", "none"),
        attribute.class("h-8 w-8 text-red-500"),
      ],
      [
        svg.path([
          attribute(
            "d",
            "M9 19v-6a2 2 0 00-2-2H5a2 2 0 00-2 2v6a2 2 0 002 2h2a2 2 0 002-2zm0 0V9a2 2 0 012-2h2a2 2 0 012 2v10m-6 0a2 2 0 002 2h2a2 2 0 002-2m0 0V5a2 2 0 012-2h2a2 2 0 012 2v14a2 2 0 01-2 2h-2a2 2 0 01-2-2z",
          ),
          attribute("stroke-width", "2"),
          attribute("stroke-linejoin", "round"),
          attribute("stroke-linecap", "round"),
        ]),
      ],
    ),
  ])
}
