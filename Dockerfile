ARG PACKAGE=rust-template

FROM lukemathwalker/cargo-chef:latest-rust-slim-bookworm AS chef
WORKDIR /prod

FROM chef as planner
COPY . .
RUN cargo chef prepare --recipe-path recipe.json

FROM chef as builder
COPY --from=planner /prod/recipe.json recipe.json
RUN cargo chef cook --release --recipe-path recipe.json
COPY . .
RUN cargo build --release --bin ${PACKAGE}

FROM debian:bookworm-slim AS runner
COPY --from=builder /prod/target/release/${PACKAGE} /bin
CMD ["/bin/${PACKAGE}"]