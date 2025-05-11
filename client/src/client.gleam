import gleam/float
import gleam/io
import gleam/json
import gleam/option.{type Option}
import gleam/result
import lustre
import lustre/attribute.{class}
import lustre/effect.{type Effect}
import lustre/element.{type Element}
import lustre/element/html
import messages/msgs.{type Msg}
import plinth/browser/document
import plinth/browser/element as plinth_element
import view/card
import view/svgs/svgs
import view/view
import weather_report.{type WeatherReport}

pub type Model {
  Model(report: WeatherReport, error: Option(String))
}

pub fn main() -> Nil {
  let flags = get_initial_state()

  let app = lustre.application(init, update, view)
  let assert Ok(_) = lustre.start(app, "#app", flags)

  Nil
}

fn get_initial_state() -> WeatherReport {
  document.query_selector("#model")
  |> result.map(plinth_element.inner_text)
  |> result.then(fn(json) {
    json.parse(json, weather_report.weather_report_decoder())
    |> result.replace_error(Nil)
  })
  |> result.unwrap(weather_report.WeatherReport(32.0, 10.0))
}

pub fn init(report: WeatherReport) -> #(Model, Effect(Msg)) {
  let model = Model(report: report, error: option.None)

  #(model, effect.none())
}

pub fn update(model: Model, _msg: Msg) -> #(Model, Effect(Msg)) {
  #(model, effect.none())
}

pub fn view(model: Model) -> Element(Msg) {
  html.body([class("bg-gray-100 min-h-screen flex flex-col")], [
    view.top_bar(),
    main_content(model),
    view.footer(),
  ])
}

pub fn main_content(model: Model) -> Element(Msg) {
  html.main([class("container mx-auto p-4 mt-6 flex-grow")], [
    html.div([class("grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-6")], [
      card.view_card(
        float.to_string(model.report.temperature),
        "Temperature",
        svgs.svg_temperature_icon(),
      ),
      card.view_card(
        float.to_string(model.report.humidity),
        "Humidity",
        svgs.svg_humidity_icon(),
      ),
    ]),
  ])
}
