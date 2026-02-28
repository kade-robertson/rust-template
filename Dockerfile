ARG PACKAGE=rust-template

FROM lukemathwalker/cargo-chef:latest-rust-slim-bookworm@sha256:6b4d370f21456d851cddabe7b81675727a90ba34447757195a0aec91cf41aa4b AS chef
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