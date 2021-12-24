FROM hseeberger/scala-sbt:11.0.13_1.5.8_2.13.7 as builder
COPY . /root/

WORKDIR /root
RUN sbt compile
RUN sbt dist
RUN mkdir build

WORKDIR /root/build
RUN unzip ../target/universal/play-test-1.0-SNAPSHOT.zip

FROM openjdk:11-jre-slim
COPY --from=builder /root/build/play-test-1.0-SNAPSHOT /root

RUN addgroup nonroot --gid 1100 && \
  adduser nonroot --ingroup nonroot --uid 1100 --disabled-password && \
  chown -R nonroot:nonroot /root

USER nonroot
WORKDIR /root

CMD ["/root/bin/play-test"]
