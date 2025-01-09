FROM ubuntu:jammy
LABEL org.opencontainers.image.source=https://github.com/peterclemenko/sd-webui-forge-docker
WORKDIR /app
RUN apt update && apt upgrade -y
RUN apt install -y wget git python3 python3-venv libgl1 libglib2.0-0 apt-transport-https libgoogle-perftools-dev bc python3-pip
COPY run.sh /app/run.sh
RUN chmod +x /app/run.sh


RUN wget https://developer.download.nvidia.com/compute/cuda/repos/wsl-ubuntu/x86_64/cuda-wsl-ubuntu.pin
RUN  mv cuda-wsl-ubuntu.pin /etc/apt/preferences.d/cuda-repository-pin-600
RUN wget https://developer.download.nvidia.com/compute/cuda/12.6.3/local_installers/cuda-repo-wsl-ubuntu-12-6-local_12.6.3-1_amd64.deb
RUN  dpkg -i cuda-repo-wsl-ubuntu-12-6-local_12.6.3-1_amd64.deb
RUN  cp /var/cuda-repo-wsl-ubuntu-12-6-local/cuda-*-keyring.gpg /usr/share/keyrings/
RUN  apt-get update
RUN  apt-get -y install cuda-toolkit

RUN mkdir /app/sd-webui
RUN git clone https://github.com/lllyasviel/stable-diffusion-webui-forge.git /app/sd-webui

RUN useradd -m webui
RUN chown -R webui:webui /app
USER webui

ENTRYPOINT ["/app/run.sh"]
