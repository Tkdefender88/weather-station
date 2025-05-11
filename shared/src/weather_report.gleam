import gleam/dynamic/decode
import gleam/json

pub type WeatherReport {
  WeatherReport(temperature: Float, humidity: Float)
}

pub fn weather_report_decoder() -> decode.Decoder(WeatherReport) {
  use temperature <- decode.field("temperature", decode.float)
  use humidity <- decode.field("humidity", decode.float)
  decode.success(WeatherReport(temperature:, humidity:))
}

pub fn weather_report_db_decoder() -> decode.Decoder(WeatherReport) {
  use temperature <- decode.field(0, decode.float)
  use humidity <- decode.field(1, decode.float)
  decode.success(WeatherReport(temperature:, humidity:))
}

pub fn encode_weather_report(weather_report: WeatherReport) -> json.Json {
  let WeatherReport(temperature:, humidity:) = weather_report
  json.object([
    #("temperature", json.float(temperature)),
    #("humidity", json.float(humidity)),
  ])
}

