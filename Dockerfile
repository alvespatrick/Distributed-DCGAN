FROM ubuntu:20.04
RUN apt update && apt install -y python-is-python3 python3 python3-pip
RUN python -m pip install torch torchvision lmdb wget requests tqdm
