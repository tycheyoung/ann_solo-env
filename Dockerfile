FROM nvidia/cuda:10.2-devel-ubuntu18.04

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8
ENV PATH /opt/conda/bin:$PATH

RUN apt-get update --fix-missing && \
    apt-get install -y wget bzip2 ca-certificates curl git vim default-jre libbz2-dev zlib1g-dev libgd-dev

RUN wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-py37_4.10.3-Linux-x86_64.sh -O ~/miniconda.sh && \
    /bin/bash ~/miniconda.sh -b -p /opt/conda && \
    rm ~/miniconda.sh && \
    /opt/conda/bin/conda clean -tipsy && \
    ln -s /opt/conda/etc/profile.d/conda.sh /etc/profile.d/conda.sh && \
    echo ". /opt/conda/etc/profile.d/conda.sh" >> ~/.bashrc && \
    echo "conda activate base" >> ~/.bashrc

RUN conda install -y faiss-gpu=1.6.5 cudatoolkit=10.2 -c pytorch  # 1.7.1 with 11.0 causes OOM issue
RUN conda install -y rdkit -c rdkit
RUN pip install ann-solo matplotlib-venn Levenshtein seaborn

RUN apt-get clean && apt-get autoremove && rm -rf /var/lib/apt/lists/*
