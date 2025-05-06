import gleam/json

pub type WeatherReport {
  WeatherReport(temperature: Float, humidity: Float)
}

pub fn serialize_weather_report(report: WeatherReport) -> String {
  json.object([
    #("temperature", json.float(report.temperature)),
    #("humidity", json.float(report.humidity)),
  ])
  |> json.to_string
}
