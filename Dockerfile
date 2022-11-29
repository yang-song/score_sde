# base nvidia CUDA image
FROM nvidia/cuda:11.8.0-devel-ubuntu20.04

# initialize directories
ARG HOME_DIR=/workspace
ARG LOG_DIR=${HOME_DIR}/logs
ARG TMP_DIR=${HOME_DIR}/tmp
RUN mkdir ${HOME_DIR}
RUN mkdir ${LOG_DIR}
RUN mkdir ${TMP_DIR}

WORKDIR ${HOME_DIR}
COPY . .

# install important dependencies
ARG DEBIAN_FRONTEND=noninteractive
RUN apt update && apt -y upgrade && \
	apt install software-properties-common -y && \
	add-apt-repository ppa:deadsnakes/ppa -y && \
	apt update && apt install python3.8 -y && \
	apt install -y python-is-python3 && apt install -y python3-pip

RUN apt-get update && apt-get install -y build-essential \
	curl \
	vim \
	libcudnn8

RUN pip install -r requirements.txt

# so jax can detect GPUs
RUN pip install -U jaxlib==0.1.60+cuda111 -f https://storage.googleapis.com/jax-releases/jax_cuda_releases.html

# symlink
RUN ln -s /usr/local/cuda/lib64/libcusolver.so.11 /usr/local/cuda/lib64/libcusolver.so.10
ENV LD_LIBRARY_PATH="${LD_LIBRARY_PATH}:/usr/local/cuda/lib64"

# CMD ["python]