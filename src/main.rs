use tracing::*;

use crate::env::Environment;

mod env;
mod env_logger;

#[tokio::main]
async fn main() -> anyhow::Result<()> {
    let _ = dotenvy::dotenv();
    let env = envy::from_env::<Environment>()?;
    env.init_logger();

    info!("Hello, world, from {}!", env!("CARGO_PKG_NAME"));

    Ok(())
}
