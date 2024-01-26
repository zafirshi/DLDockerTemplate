FROM nvidia/cuda:11.4.3-cudnn8-devel-ubuntu20.04

# Add maintainer environment variable
ENV MAINTAINER zafirshi

# Define timezone
ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone


# Replace Aliyun source with Ubuntu's software source
# RUN sed -i 's/archive.ubuntu.com/mirrors.aliyun.com/g' /etc/apt/sources.list && \
#     sed -i 's/security.ubuntu.com/mirrors.aliyun.com/g' /etc/apt/sources.list
# Replace Zhejiang University source with Ubuntu's software source
RUN sed -i 's|http://archive.ubuntu.com/ubuntu/|https://mirrors.zju.edu.cn/ubuntu/|g' /etc/apt/sources.list && \
    sed -i 's|http://security.ubuntu.com/ubuntu/|https://mirrors.zju.edu.cn/ubuntu/|g' /etc/apt/sources.list


# Install dependencies
RUN apt-get update && apt-get install -y \
    build-essential \
    cmake \
    git \
    wget \
    curl \
    vim \
    nano \
    tmux \
    htop \
    pkg-config \
    python3-dev \
    python3-numpy \
    libtbb2 \
    libtbb-dev \
    libdc1394-dev && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /opt

# Install Miniconda
ENV MINICONDA_VERSION=py39_4.12.0
ENV CONDA_DIR=/opt/conda
RUN apt-get update && \
    # wget https://repo.anaconda.com/miniconda/Miniconda3-${MINICONDA_VERSION}-Linux-x86_64.sh && \
    wget https://mirrors.tuna.tsinghua.edu.cn/anaconda/miniconda/Miniconda3-${MINICONDA_VERSION}-Linux-x86_64.sh && \
    bash Miniconda3-${MINICONDA_VERSION}-Linux-x86_64.sh -b -p ${CONDA_DIR} && \
    rm Miniconda3-${MINICONDA_VERSION}-Linux-x86_64.sh


# Add conda command to the environment variable (but do not activate any environments)
ENV PATH=${CONDA_DIR}/bin:${PATH}

# Initialize Conda
RUN conda init bash

# Clean up apt cache to reduce image size
RUN apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Create a new user and switch to that user
RUN useradd -m -s /bin/bash $MAINTAINER
USER $MAINTAINER

# Set default working directory (optional)
WORKDIR /home/$MAINTAINER

# Set default container command
CMD [ "/bin/bash" ]
