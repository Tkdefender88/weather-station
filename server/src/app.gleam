import gleam/erlang/process
import gleam/result
import mist
import sqlight
import weather_station/context
import weather_station/router
import wisp
import wisp/wisp_mist

pub fn main() {
  let assert Ok(db) = setup_database()

  wisp.configure_logger()
  let secret_key_base = wisp.random_string(64)
  let ctx = context.Context(db)

  let handler = router.handle_request(_, ctx)

  let assert Ok(_) =
    wisp_mist.handler(handler, secret_key_base)
    |> mist.new
    |> mist.port(8000)
    |> mist.start_http

  process.sleep_forever()
}

pub fn setup_database() -> Result(sqlight.Connection, sqlight.Error) {
  use db <- result.try(sqlight.open("weather_station.db"))

  let create_sensor_data_table =
    "
  CREATE TABLE IF NOT EXISTS weather_report (
    temperature FLOAT,
    humidity FLOAT,
    created_at datetime default current_timestamp
  )
  "

  use _ <- result.try(sqlight.exec(create_sensor_data_table, db))

  Ok(db)
}
