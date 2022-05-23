FROM nvidia/cuda:11.3.1-devel-ubuntu20.04

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8
ENV PATH /opt/conda/bin:$PATH
ENV TERM xterm-256color
# Set timezone
ENV TZ=America/Los_Angeles
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get update --fix-missing && \
    apt-get install -y wget bzip2 ca-certificates curl git vim default-jre libbz2-dev zlib1g-dev libgd-dev

RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-py38_4.12.0-Linux-x86_64.sh -O ~/miniconda.sh && \
    /bin/bash ~/miniconda.sh -b -p /opt/conda && \
    rm ~/miniconda.sh && \
    /opt/conda/bin/conda clean -tipsy && \
    ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
    echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc && \
    echo "conda activate base" >> ~/.bashrc

RUN conda install -y faiss-gpu=1.7.2 cudatoolkit=11.3 -c pytorch  # 1.7.1 with 11.0 causes OOM issue
#RUN conda install -y rdkit -c rdkit
RUN pip install matplotlib-venn Levenshtein seaborn
RUN conda install -y numpy==1.21.5 
RUN pip install Cython==0.29.24
RUN git clone https://github.com/bittremieux/ANN-SoLo && cd ANN-SoLo/src && git checkout v0.3.3 && python setup.py install

RUN apt-get clean && apt-get autoremove && rm -rf /var/lib/apt/lists/*
