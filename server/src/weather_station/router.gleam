import gleam/dynamic/decode
import gleam/http
import gleam/int
import gleam/json
import gleam/list
import lustre/attribute.{attribute}
import lustre/element
import lustre/element/html
import sqlight
import weather_report.{type WeatherReport}
import weather_station/context
import wisp.{type Request, type Response}

fn app_middleware(
  req: Request,
  static_directory: String,
  next: fn(Request) -> Response,
) {
  use <- wisp.log_request(req)
  use <- wisp.rescue_crashes
  use req <- wisp.handle_head(req)
  use <- wisp.serve_static(req, under: "/static", from: static_directory)
  next(req)
}

pub fn handle_request(req: Request, ctx: context.Context) -> Response {
  use req <- app_middleware(req, ctx.static_directory)
  case req.method, wisp.path_segments(req) {
    http.Post, ["api", "weather_report"] -> handle_post_report(req, ctx)
    http.Get, ["api", "weather_report"] -> handle_get_report(ctx)
    http.Get, _ -> serve_index(ctx)
    _, _ -> wisp.not_found()
  }
}

pub fn serve_index(ctx: context.Context) -> Response {
  let report = case fetch_latest_weather_report(ctx.db) {
    Ok(reports) ->
      case list.first(reports) {
        Ok(report) -> report
        Error(_) -> weather_report.WeatherReport(32.0, 0.0)
      }
    Error(_) -> weather_report.WeatherReport(32.0, 0.0)
  }

  let html =
    html.html([attribute("lang", "en")], [
      html.head([], [
        html.meta([attribute("charset", "UTF-8")]),
        html.meta([
          attribute("content", "width=device-width, initial-scale=1.0"),
          attribute.name("viewport"),
        ]),
        html.link([
          attribute.href("/static/client.min.css"),
          attribute.type_("text/css"),
          attribute.rel("stylesheet"),
        ]),
        html.title([], "Weather Station"),
        html.script(
          [attribute.id("model"), attribute.type_("application/json")],
          json.to_string(weather_report.encode_weather_report(report)),
        ),
        html.script(
          [attribute.src("/static/client.min.mjs"), attribute.type_("module")],
          "",
        ),
      ]),
      html.body([], [html.div([attribute.id("app")], [])]),
    ])

  html
  |> element.to_document_string_tree
  |> wisp.html_response(200)
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
