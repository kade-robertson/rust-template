ARG PACKAGE=rust-template

FROM lukemathwalker/cargo-chef:latest-rust-slim-bookworm@sha256:4356ad4a89cc603dd8925b9dca2075654479065ad42b019d0cc536d1ef2032e5 AS chef
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

FROM debian:bookworm-slim@sha256:7ff6ba31527b9e336162fa061746c366c4b2032f4d2cff2078bea43f78efe3f8 AS runner
ARG PACKAGE
COPY --from=builder /prod/target/release/${PACKAGE} /bin/my-app
CMD ["/bin/my-app"]