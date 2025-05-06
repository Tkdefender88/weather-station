import gleam/bytes_tree
import gleam/erlang/process
import gleam/http.{Get, Post}
import gleam/http/request.{type Request}
import gleam/http/response.{type Response}
import gleam/result
import mist.{type Connection, type ResponseData}
import sqlight

pub fn main() -> Nil {
  let assert Ok(db) = setup_database()

  let handler = fn(req: Request(Connection)) -> Response(ResponseData) {
    let path = request.path_segments(req)
    case req.method, path {
      Post, ["api", "weather_report"] -> handle_save_weather_report(req, db)
      Get, [] ->
        response.new(200)
        |> response.set_body(mist.Bytes(bytes_tree.from_string("Hello")))
      _, _ ->
        response.new(404) |> response.set_body(mist.Bytes(bytes_tree.new()))
    }
  }

  let assert Ok(_) = mist.new(handler) |> mist.port(3000) |> mist.start_http
  process.sleep_forever()
}

pub fn handle_save_weather_report(
  _req: Request(Connection),
  _db: sqlight.Connection,
) -> Response(ResponseData) {
  response.new(201) |> response.set_body(mist.Bytes(bytes_tree.new()))
}

pub fn setup_database() -> Result(sqlight.Connection, sqlight.Error) {
  use db <- result.try(sqlight.open("weather_station.db"))

  let create_table =
    "
  CREATE TABLE IF NOT EXISTS weather_station (
    name TEXT PRIMARY KEY
  )
  "

  let create_sensor_data_table =
    "
  CREATE TABLE IF NOT EXISTS weather_report (
    weather_station TEXT,
    temperature FLOAT,
    humidity FLOAT,
    created_at datetime default current_timestamp,
    station_name TEXT NOT NULL,
    FOREIGN KEY (station_name)
      REFERENCES weather_station (name)
  )
  "

  use _ <- result.try(sqlight.exec(create_table, db))
  use _ <- result.try(sqlight.exec(create_sensor_data_table, db))

  Ok(db)
}
