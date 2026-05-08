FROM python:3.11-slim AS builder

WORKDIR /app
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

RUN apt-get update
RUN apt-get install -y --no-install-recommends wget curl gnupg unzip git chromium chromium-driver 


# Stage 2: Runtime
FROM builder AS runtime
WORKDIR /app

RUN pip install git+https://github.com/yoori/flare-bypasser.git

COPY . .
ENV DISPLAY=:99

EXPOSE 8080

CMD ["flare_bypass_server"]
