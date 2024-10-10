FROM condaforge/mambaforge:latest

# For opencontainers label definitions, see:
#    https://github.com/opencontainers/image-spec/blob/master/annotations.md
LABEL org.opencontainers.image.title="HyP3 wetlands"
LABEL org.opencontainers.image.description="HyP3 plugin for Classification of Wetland Inundation Extent with NISAR data"
LABEL org.opencontainers.image.vendor="Alaska Satellite Facility"
LABEL org.opencontainers.image.authors="jhkennedy <me@jhkennedy.org>"
LABEL org.opencontainers.image.url="https://github.com/jhkennedy/wetlands_notebook"
LABEL org.opencontainers.image.source="https://github.com/jhkennedy/wetlands_notebook"
LABEL org.opencontainers.image.documentation="https://hyp3-docs.asf.alaska.edu"

# Dynamic labels to define at build time via `docker build --label`
# LABEL org.opencontainers.image.created=""
# LABEL org.opencontainers.image.version=""
# LABEL org.opencontainers.image.revision=""

ARG DEBIAN_FRONTEND=noninteractive
ENV PYTHONDONTWRITEBYTECODE=true

RUN apt-get update && apt-get install -y --no-install-recommends unzip vim && \
    apt-get clean && rm -rf /var/lib/apt/lists/*

ARG CONDA_UID=1000
ARG CONDA_GID=1000

RUN groupadd -g "${CONDA_GID}" --system conda && \
    useradd -l -u "${CONDA_UID}" -g "${CONDA_GID}" --system -d /home/conda -m  -s /bin/bash conda && \
    chown -R conda:conda /opt && \
    echo ". /opt/conda/etc/profile.d/conda.sh" >> /home/conda/.profile && \
    echo "conda activate base" >> /home/conda/.profile


USER ${CONDA_UID}
SHELL ["/bin/bash", "-l", "-c"]
WORKDIR /home/conda/

COPY --chown=${CONDA_UID}:${CONDA_GID} . /wetlands_notebook/

RUN mamba env create -f /wetlands_notebook/environment.yml && \
    conda clean -afy && \
    conda activate NISAR_EA_Workshop_2024_10 && \
    sed -i 's/conda activate base/conda activate NISAR_EA_Workshop_2024_10/g' /home/conda/.profile && \
    python -m pip install --no-cache-dir /wetlands_notebook

ENTRYPOINT ["/wetlands_notebook/src/hyp3_wetlands/etc/entrypoint.sh"]
CMD ["-h"]
