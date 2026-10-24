FROM debian:trixie-slim

RUN apt-get update && apt-get install -y --no-install-recommends \
	ca-certificates \
	curl \
	git \
	jq \
	ripgrep \
	python3 \
	build-essential \
	clang lld llvm \
	golang-go \
	sqlite3 file tree less unzip wget bc \
	&& rm -rf /var/lib/apt/lists/*

ENV CONDA_DIR=/opt/conda
RUN curl -fsSL -o /tmp/mf.sh \
	https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-Linux-$(uname -m).sh \
	&& bash /tmp/mf.sh -b -p $CONDA_DIR && rm /tmp/mf.sh
ENV PATH=$CONDA_DIR/bin:$PATH

RUN curl -fsSL https://claude.ai/install.sh | bash
ENV PATH="/root/.local/bin:${PATH}"

# RUN npm install -g @anthropic-ai/claude-code
WORKDIR /workspace
ENTRYPOINT ["claude"]