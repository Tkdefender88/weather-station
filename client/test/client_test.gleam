import client.{Model}
import gleam/float
import gleam/option
import gleeunit
import gleeunit/should
import lustre/attribute.{class}
import lustre/element/html
import weather_report

pub fn main() -> Nil {
  gleeunit.main()
}

pub fn view_test() {
  let model = Model(weather_report.WeatherReport(32.0, 10.5), option.None)
  client.view(model)
  |> should.equal(
    html.div([], [
      html.div([class("p-4 bg-red-500 text-white")], [
        html.h1([class("w-full mx-auto max-w-screen-xl text-4xl font-bold")], [
          html.text("Weather Station"),
        ]),
      ]),
      html.div([], [html.text(float.to_string(32.0))]),
    ]),
  )
}

pub fn top_bar_test() {
  client.top_bar()
  |> should.equal(
    html.div([class("p-4 bg-red-500 text-white")], [
      html.h1([class("w-full mx-auto max-w-screen-xl text-4xl font-bold")], [
        html.text("Weather Station"),
      ]),
    ]),
  )
}
