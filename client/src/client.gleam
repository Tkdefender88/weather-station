import gleam/io
import gleam/option.{type Option}
import lustre
import lustre/attribute.{class}
import lustre/effect.{type Effect}
import lustre/element.{type Element}
import lustre/element/html
import weather_report.{type WeatherReport, WeatherReport}

type Model {
  Model(report: WeatherReport, error: Option(String))
}

type Msg

pub fn main() -> Nil {
  let flags = get_initial_state()

  let app = lustre.application(init, update, view)
  let assert Ok(_) = lustre.start(app, "#app", flags)
  io.println("Hello from app!")

  Nil
}

fn get_initial_state() -> WeatherReport {
  WeatherReport(32.0, 10.0)
}

fn init(report: WeatherReport) -> #(Model, Effect(Msg)) {
  let model = Model(report: report, error: option.None)

  #(model, effect.none())
}

fn update(model: Model, _msg: Msg) -> #(Model, Effect(Msg)) {
  #(model, effect.none())
}

fn view(_model: Model) -> Element(Msg) {
  html.div([class("p-4 bg-red-500 text-white")], [
    html.h1([class("w-full mx-auto max-w-screen-xl text-4xl font-bold")], [
      html.text("Weather Station"),
    ]),
  ])
}
