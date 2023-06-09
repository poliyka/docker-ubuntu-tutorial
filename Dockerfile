FROM python:3.10.6-buster
ENV PYTHONUNBUFFERED 1
ENV PYTHONDONTWRITEBYTECODE 1
ENV PIP_DISABLE_PIP_VERSION_CHECK 1
ENV PIP_NO_CACHE_DIR 1
ENV PATH="/home/appuser/.local/bin:$PATH"

RUN addgroup --gid 1024 dev
RUN useradd -m -g dev appuser && echo "appuser:root" | chpasswd && adduser appuser sudo

RUN apt-get update -y && \
    apt-get install build-essential -y --no-install-recommends && \
    apt-get install sudo git curl make vim -y

USER appuser
RUN mkdir -p /home/appuser/app
WORKDIR /home/appuser/app

RUN git clone https://github.com/poliyka/ubuntu-initialize-script.git
RUN sed -i 's/OE_USER="poliyka"/OE_USER="appuser"/g' ubuntu-initialize-script/install.sh
RUN echo "root" | sudo -S ubuntu-initialize-script/install.sh

COPY ./entrypoint.sh /home/appuser/app/
