use serde::Deserialize;

use crate::env_logger::LogFormat;

fn log_level_default() -> String {
    "info".to_string()
}

#[derive(Deserialize, Debug)]
pub struct Environment {
    #[serde(default = "log_level_default")]
    pub log_level: String,
    #[serde(default, alias = "json_log")]
    pub log_format: LogFormat,
}
