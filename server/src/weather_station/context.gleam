import sqlight

pub type Context {
  Context(db: sqlight.Connection, static_directory: String)
}
