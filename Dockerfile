ARG PACKAGE=rust-template

FROM lukemathwalker/cargo-chef:latest-rust-slim-bookworm@sha256:b7682346f538fd1470a119a2a814a3600e34cae1aab7635abc82172bcf0e067f AS chef
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

FROM debian:bookworm-slim@sha256:78d2f66e0fec9e5a39fb2c72ea5e052b548df75602b5215ed01a17171529f706 AS runner
ARG PACKAGE
COPY --from=builder /prod/target/release/${PACKAGE} /bin/my-app
CMD ["/bin/my-app"]