ARG PACKAGE=rust-template

FROM lukemathwalker/cargo-chef:latest-rust-slim-bookworm@sha256:a4b044fe3f1e96845dc5513b8aa3d9d1923da90513b5ad7553b7273f257144d4 AS chef
WORKDIR /prod

FROM chef as planner
ARG PACKAGE
COPY . .
RUN cargo chef prepare --bin ${PACKAGE} --recipe-path recipe.json

FROM chef as builder
ARG PACKAGE
COPY --from=planner /prod/recipe.json recipe.json
RUN cargo chef cook --release --bin ${PACKAGE} --recipe-path recipe.json
COPY . .
RUN cargo build --release --bin ${PACKAGE}

FROM debian:bookworm-slim@sha256:74d56e3931e0d5a1dd51f8c8a2466d21de84a271cd3b5a733b803aa91abf4421 AS runner
ARG PACKAGE
COPY --from=builder /prod/target/release/${PACKAGE} /bin/my-app
CMD ["/bin/my-app"]