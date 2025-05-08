import gleam/http
import sqlight
import weather_station/context
import wisp.{type Request, type Response}

pub fn handle_request(req: Request, ctx: context.Context) -> Response {
  case req.method, wisp.path_segments(req) {
    http.Get, [] -> wisp.ok()
    http.Post, ["api", "weather_report"] -> save_weather_report(req, ctx)
    _, _ -> wisp.not_found()
  }
}

pub fn save_weather_report(_req: Request, ctx: context.Context) {
  let db = ctx.db
  "SELECT * FROM weather_report ORDER BY created_at DESC LIMIT 1;"
  |> sqlight.query(db, )
}
