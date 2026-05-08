FROM python:3.11-slim AS builder

WORKDIR /app
ENV PYTHONDONTWRITEBYTECODE 1
ENV PYTHONUNBUFFERED 1

RUN apt-get update
RUN apt-get install -y --no-install-recommends wget curl gnupg unzip git chromium chromium-driver 

RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -
RUN echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google-chrome.list
RUN apt-get update && apt-get install -y --no-install-recommends \
    google-chrome-stable=134.0.6998.165-1 \
    xvfb \
    && rm -rf /var/lib/apt/lists/*

# Stage 2: Runtime
FROM builder AS runtime
WORKDIR /app

RUN pip install git+https://github.com/yoori/flare-bypasser.git

COPY . .
ENV DISPLAY=:99

EXPOSE 8080

CMD ["flare_bypass_server"]
