use tokio::task::JoinSet;
use tracing::*;

use crate::env::Environment;

mod env;
mod env_logger;

async fn run(_env: Environment) -> anyhow::Result<()> {
    info!("Hello, world, from {}!", env!("CARGO_PKG_NAME"));
    Ok(())
}

async fn handle_ctrlc() -> anyhow::Result<()> {
    tokio::signal::ctrl_c().await?;
    Ok(())
}

#[tokio::main]
async fn main() -> anyhow::Result<()> {
    let _ = dotenvy::dotenv();
    let env = envy::from_env::<Environment>()?;
    env.init_logger();

    let mut set = JoinSet::<anyhow::Result<()>>::new();

    set.spawn(handle_ctrlc());
    set.spawn(run(env));

    if let Some(res) = set.join_next().await {
        res??
    }
    set.shutdown().await;

    Ok(())
}
