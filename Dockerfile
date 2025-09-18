# Dockerfile - Wisecow app (simple)
FROM ubuntu:24.04

LABEL maintainer="pranuashdeepu@example.com"
ENV PORT=4499

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y \
    python3 python3-pip fortune-mod cowsay && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

WORKDIR /app
COPY app /app

EXPOSE ${PORT}

CMD ["python3", "/app/server.py"]
