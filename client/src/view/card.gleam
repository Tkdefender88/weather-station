import lustre/attribute.{class}
import lustre/element.{type Element}
import lustre/element/html
import messages/msgs.{type Msg}

pub fn view_card(
  data: String,
  label: String,
  icon: Element(Msg),
) -> Element(Msg) {
  html.div(
    [class("bg-white rounded-lg shadow-md p-6 flex flex-col items-center")],
    [
      icon,
      html.h2([class("text-gray-700 text-lg font-semibold mb-2")], [
        html.text(label),
      ]),
      html.p([class("text-4xl font-bold text-gray-800")], [
        html.text(data <> "°F"),
      ]),
      html.p([class("text-sm text-gray-500 mt-2")], [html.text(data <> "°C")]),
    ],
  )
}
