use serde::Deserialize;
use std::io::{stdin, IsTerminal};
use tracing::*;
use tracing_subscriber::prelude::*;

fn json_log_default() -> bool {
    !stdin().is_terminal()
}

#[derive(Deserialize, Debug)]
struct Environment {
    #[serde(default = "json_log_default")]
    json_log: bool,
}

#[tokio::main]
async fn main() -> anyhow::Result<()> {
    let _ = dotenvy::dotenv();
    let env = envy::from_env::<Environment>()?;

    let logger = tracing_subscriber::registry().with(tracing_subscriber::EnvFilter::new("INFO"));
    if env.json_log {
        logger.with(tracing_subscriber::fmt::layer().json()).init();
    } else {
        logger.with(tracing_subscriber::fmt::layer()).init();
    }

    info!("Hello, world, from {}!", env!("CARGO_PKG_NAME"));

    Ok(())
}
