use tracing::*;
use tracing_subscriber::prelude::*;

#[tokio::main]
async fn main() -> anyhow::Result<()> {
    let logger = tracing_subscriber::registry()
        .with(tracing_subscriber::EnvFilter::new("INFO"))
        .with(tracing_subscriber::fmt::layer());
    logger.init();

    info!("Hello, world, from {}!", env!("CARGO_PKG_NAME"));

    Ok(())
}
