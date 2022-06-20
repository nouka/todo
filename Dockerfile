# ビルド用イメージ
FROM rust:1.61 AS builder

WORKDIR /todo

# 依存クレートのビルド
COPY Cargo.toml Cargo.toml

RUN mkdir src
RUN echo "fn main(){}" > src/main.rs

RUN cargo build --release

# アプリケーションのビルド
COPY ./src ./src
COPY ./templates ./templates

RUN rm -f target/release/deps/todo*

RUN cargo build --release

# リリース用イメージ
FROM debian:11.3

# アプリケーション実行
COPY --from=builder /todo/target/release/todo /usr/local/bin/todo
CMD ["todo"]
