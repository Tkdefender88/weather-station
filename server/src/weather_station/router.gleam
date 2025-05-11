import gleam/dynamic/decode
import gleam/http
import gleam/int
import gleam/json
import gleam/list
import sqlight
import weather_report.{type WeatherReport}
import weather_station/context
import wisp.{type Request, type Response}

pub fn handle_request(req: Request, ctx: context.Context) -> Response {
  case req.method, wisp.path_segments(req) {
    http.Get, ["api", "weather_report"] -> handle_get_report(ctx)
    http.Post, ["api", "weather_report"] -> handle_post_report(req, ctx)
    http.Get, [] -> wisp.ok()
    _, _ -> wisp.not_found()
  }
}

pub fn handle_get_report(ctx: context.Context) -> Response {
  case fetch_latest_weather_report(ctx.db) {
    Ok(reports) -> {
      // Can use assert here because the fetch latest weather report has a limit 1
      let assert Ok(report) = list.first(reports)
      wisp.ok()
      |> wisp.json_body(
        weather_report.encode_weather_report(report)
        |> json.to_string_tree(),
      )
    }
    Error(err) -> {
      echo err
      wisp.internal_server_error()
    }
  }
}

fn fetch_latest_weather_report(db: sqlight.Connection) {
  let query =
    "SELECT temperature, humidity FROM weather_report ORDER BY created_at DESC LIMIT 1"
  sqlight.query(query, db, [], weather_report.weather_report_db_decoder())
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
