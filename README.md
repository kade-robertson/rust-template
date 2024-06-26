# rust-template

A basic Rust template for quickly creating async services and CLI applications, with Docker builds, automatic release versioning, Dependabot, and CI already configured.

## Usage

Copy the files in this repo, except for the `Cargo.lock` and `CHANGELOG.md` files, or use the GitHub template tool, or use `cargo-generate`. In all cases, you will still need to find and replace all instances of `rust-template` and replace them with the name of your project.

### `cargo-generate`

Support for `cargo-generate` is in early stages. Currently, the options provided in the prompts will only configure things related to the Dockerfiles and Github Actions workflows. Once set up, you will still have to go replace the remaining instances of `rust-template` with your package name, as currently `cargo-generate` isn't suitable for replacing these instances in a way that keeps this repo intact and runnable locally.

## Structure

### Rust Project

The project is already configured with a few dependencies:

- `dotenvy` and `envy`, which provide structured environment variable loading and support for `.env` files during local development (and `serde` for the base environment struct)
- `anyhow` and `thiserror` for error handling, as I tend to always need/want at least one of them
- `tokio` as an async runtime
- `tracing` and `tracing-subscriber` for logging

The base-level project doesn't do a whole lot -- it's just a "Hello, World" project. The only exception is the environment loading and logging configuration. The repo is set up to automatically load `.env` files and environment variables, and is already aware of two:

- `LOG_LEVEL`, which defaults to `info` if unspecified. This is just directly passed to `EnvFilter`, so this more or less serves the same purpose as the built-in `RUST_LOG` variable `tracing-subscriber` can use.
- `LOG_FORMAT`, which defaults to `full` if a TTY is detected, and otherwise is set to `json` if unspecified. It can be set to `full`, `compact`, `pretty` and `json` to override the behaviour.

The release profiles have been tweaked slightly for my personal use cases.

- `release` maintains its normal optimization level, but has additional tweaks to reduce binary size.
- `release-small` sacrifices optimization level for further size improvements.

### Docker

Two pre-configured Dockerfiles are available, one using Debian Bookworm Slim, and the other using Alpine 3.18. They are otherwise identical. Both rely on `cargo-chef` to improve caching behaviour.

### GitHub Actions

Firstly, a pre-configured `dependabot.yml` configuration file is added with my preferred defaults.

There are three workflows defined:

- `automerge.yml` handles queuing Dependabot PRs automatically once CI passes, specifically for patch releases. This can easily be tweaked if you want this to queue pull requests to auto-merge on minor or even major releases assuming CI passes.
- `test.yml` runs `cargo build --release` and `cargo test`, and provides caching via `sccache`. This runs on every PR and on every push to `master` to make sure the cache is adequately hydrated for subsequent runs, since caches created on pull requests aren't shared to other pull requests.
- `release-please.yml` handles the entire release flow. This includes the normal release-please configuration to create pull requests, but also includes the steps followed after a release is created -- it will create release builds and attach them to the release in GitHub, and publish a new Docker image to the GitHub Container Registry with appropriate labels.

### Renovate

If you would like to use Renovate instead of Dependabot for dependency management, a default `renovate.json` is provided in the `configs` directory.
