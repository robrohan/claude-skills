FROM debian:trixie-slim

RUN apt-get update && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
	ca-certificates \
	curl git jq \
	ripgrep \
	python3 python3-venv \
	build-essential \
	clang lld llvm \
	golang-go \
	sqlite3 file tree less unzip wget bc \
	xz-utils \
	libpixman-1-0 libgcrypt20 libsdl2-2.0-0 libslirp0 \
	cppcheck cbmc picocom \
	libclang-rt-19-dev \
	&& rm -rf /var/lib/apt/lists/*

ENV CONDA_DIR=/opt/conda
RUN curl -fsSL -o /tmp/mf.sh \
	https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-Linux-$(uname -m).sh \
	&& bash /tmp/mf.sh -b -p $CONDA_DIR && rm /tmp/mf.sh
ENV PATH=$CONDA_DIR/bin:$PATH

ARG XT_VER=15.2.0_20251204
RUN mkdir -p /opt/chestnut-tools
RUN cd /opt/chestnut-tools && curl -fsSL https://github.com/espressif/crosstool-NG/releases/download/esp-${XT_VER}/xtensa-esp-elf-${XT_VER}-aarch64-linux-gnu.tar.xz | tar -xJ
RUN cd /opt/chestnut-tools && curl -fsSL https://github.com/espressif/qemu/releases/download/esp-develop-9.2.2-20260417/qemu-xtensa-softmmu-esp_develop_9.2.2_20260417-aarch64-linux-gnu.tar.xz | tar -xJ

# Debian's clang-format 19 rejects `Language: C` in .clang-format (needs 21+).
RUN python3 -m venv /opt/chestnut-tools/clang-format \
    && /opt/chestnut-tools/clang-format/bin/pip install --no-cache-dir clang-format==22.1.8 \
    && python3 -m venv /opt/chestnut-tools/esptool \
    && /opt/chestnut-tools/esptool/bin/pip install --no-cache-dir esptool

ENV PATH=/opt/chestnut-tools/clang-format/bin:/opt/chestnut-tools/esptool/bin:$PATH \
    TOOLS=/opt/chestnut-tools/xtensa-esp-elf/bin \
    QEMU_BIN=/opt/chestnut-tools/qemu/bin

RUN curl -fsSL https://claude.ai/install.sh | bash
ENV PATH="/root/.local/bin:${PATH}"

# RUN npm install -g @anthropic-ai/claude-code
WORKDIR /workspace
ENTRYPOINT ["claude"]