FROM tensorflow/tensorflow:2.15.0-gpu

WORKDIR /app

RUN sudo apt-get update \
    && sudo apt-get install -y nvidia-container-toolkit

COPY ../requirements.txt /app/requirements.txt
RUN pip install --upgrade pip \
    && pip install -r /app/requirements.txt

EXPOSE 8888 6006

# Keep the Container alive for IDE Connection
CMD ["tail", "-f", "/dev/null"]