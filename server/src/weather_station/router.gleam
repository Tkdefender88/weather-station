import gleam/dynamic/decode
import gleam/http
import gleam/int
import sqlight
import weather_report.{type WeatherReport}
import weather_station/context
import wisp.{type Request, type Response}

pub fn handle_request(req: Request, ctx: context.Context) -> Response {
  case req.method, wisp.path_segments(req) {
    http.Get, [] -> wisp.ok()
    http.Post, ["api", "weather_report"] -> handle_post_report(req, ctx)
    _, _ -> wisp.not_found()
  }
}

pub fn handle_post_report(req: Request, ctx: context.Context) -> Response {
  use body <- wisp.require_json(req)
  case decode.run(body, weather_report.weather_report_decoder()) {
    Ok(report) -> {
      case save_weather_report(report, ctx.db) {
        Ok(_) -> wisp.created()
        Error(error) -> {
          echo error
          wisp.internal_server_error()
          |> wisp.string_body(
            sqlight.error_code_to_int(error.code) |> int.to_string,
          )
        }
      }
    }
    Error(error) -> {
      echo error
      wisp.bad_request()
    }
  }
}

pub fn save_weather_report(report: WeatherReport, db: sqlight.Connection) {
  let query =
    "INSERT INTO weather_report (temperature, humidity) VALUES ( ?, ? )"
  sqlight.query(
    query,
    db,
    [sqlight.float(report.temperature), sqlight.float(report.humidity)],
    weather_report.weather_report_decoder(),
  )
}
