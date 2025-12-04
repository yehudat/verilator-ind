## ------------------------------------------------------------
## Stage 1: Build Verilator from source on Debian 13 (trixie-slim)
## ------------------------------------------------------------
#FROM debian:trixie-slim AS build

#ENV DEBIAN_FRONTEND=noninteractive

## Basic tooling + build dependencies
#RUN apt-get update && \
    #apt-get install -y --no-install-recommends \
        #git \
        #ca-certificates \
        #wget \
        ## Build essentials
        #make \
        #autoconf \
        #g++ \
        #flex \
        #bison \
        #ccache \
        #perl \
        #python3 \
        ## Verilator deps
        #libgoogle-perftools-dev \
        #numactl \
        #perl-doc \
        #libfl2 \
        #libfl-dev \
        #zlib1g \
        #zlib1g-dev \
        #help2man \
    #&& rm -rf /var/lib/apt/lists/*

#WORKDIR /tmp/build

## Clone and build Verilator (stable branch for reproducibility-ish)
#RUN git clone --depth 1 https://github.com/verilator/verilator.git && \
    #cd verilator && \
    #git checkout stable && \
    #autoconf && \
    #./configure && \
    #make -j"$(nproc)" && \
    #make install

# ------------------------------------------------------------
# Stage 2: Runtime image (lighter) with Verilator + GTKWave
# ------------------------------------------------------------
#FROM debian:trixie-slim
FROM verilator/verilator:latest

ENV DEBIAN_FRONTEND=noninteractive

# Runtime dependencies only (no compilers, no dev headers)
RUN \
    apt-get update && \
    apt-get install -y --no-install-recommends \
        zsh \
        perl \
        python3 \
        libgoogle-perftools-dev \
        numactl \
        libfl2 \
        zlib1g \
        help2man \
        gtkwave \
        ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Copy Verilator install from build stage
# (binaries, libs, share files, manpages)
#COPY --from=build /usr/local/ /usr/local/

# Environment
ENV VERILATOR_ROOT=/usr/local/share/verilator
ENV PATH="/usr/local/bin:${PATH}"

# Optional: sanity check during build (can be removed if you care about size)
RUN \
    echo "=== Verilator Version ===" && \
    verilator --version && \
    echo "=== GTKWave Version ===" && \
    gtkwave --version 2>&1 | head -1 || echo "GTKWave installed"

# Create arbitrary (1100) fixed devuser/group in image. MacOS always
# assigns your MacOS $GID & $UID, regardless of container's user parameters
RUN \
    groupadd -g 1100 devuser && \
    useradd -m -u 1100 -g devuser -s /usr/bin/zsh devuser
USER devuser
WORKDIR /home/devuser

CMD ["/bin/zsh"]
