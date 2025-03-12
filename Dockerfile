# Use the official Ubuntu 18.04 image
FROM ubuntu:18.04

# Set the maintainer
LABEL maintainer="jason.nguyentronghieu@gmail.com"

# Prevent interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Update package list and install basic dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    gcc \
    build-essential \
    wget \
    curl \
    git \
    bzip2 \
    ca-certificates \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install Miniconda
RUN wget https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O /tmp/miniconda.sh && \
    bash /tmp/miniconda.sh -b -p /opt/conda && \
    rm /tmp/miniconda.sh

# Add Conda to PATH
ENV PATH="/opt/conda/bin:$PATH"

# Create a Conda environment with Python 3.7
RUN conda create -n spinup python=3.7 -y && \
    conda clean -afy

# Copy the requirements file before installation
COPY requirements.txt /tmp/requirements.txt

# Activate the environment and install PyTorch 1.5+ and pythonocc-core
RUN /bin/bash -c "source activate spinup && \
    # conda install pytorch torchvision torchaudio cpuonly -c pytorch -y && \
    conda install -c conda-forge mpich && \
    conda install -c conda-forge mpi4py && \
    conda install pytorch torchvision torchaudio pytorch-cuda=11.8 -c pytorch -c nvidia -y && \
    conda clean -afy"

# Install Python dependencies
RUN /bin/bash -c "source activate spinup && pip install --no-cache-dir -r /tmp/requirements.txt"

# Set the default command to activate the Conda environment
CMD ["/bin/bash", "-c", "source activate spinup && bash"]
