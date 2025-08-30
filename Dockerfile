FROM jetbrains/teamcity-agent

# Switch to root for installing dependencies
USER root
# Install base build dependencies + Rust/Flutter prerequisites + C/C++ toolchain + Qt6
RUN apt-get update && apt-get install -y \
		sudo \
		curl \
		git \
		unzip \
		xz-utils \
		libglu1-mesa \
		wget \
		ca-certificates \
		build-essential \
		cmake \
		ninja-build \
		clang \
		lldb \
		lld \
		libc++-dev \
		libc++abi-dev \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/*

# Install Qt6 in a dedicated layer (improves cache reuse when non-Qt deps change)
RUN apt-get update && apt-get install -y \
		qt6-base-dev \
		qt6-base-dev-tools \
		qt6-tools-dev-tools \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/*

# Set Clang as default (optional override at build time)
ENV CC=clang \
		CXX=clang++

# Install Rust (Cargo)
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"
ENV PLATFORM_LINUX=1
# Install Flutter
ARG FLUTTER_VERSION=3.22.1
RUN wget https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_${FLUTTER_VERSION}-stable.tar.xz \
	&& tar xf flutter_linux_${FLUTTER_VERSION}-stable.tar.xz -C /opt \
	&& rm flutter_linux_${FLUTTER_VERSION}-stable.tar.xz
ENV PATH="/opt/flutter/bin:${PATH}"
# Pre-cache Flutter dependencies (optional, speeds up first use)
RUN flutter --version

# Toolchain versions (diagnostic layer)
RUN set -e; \
	echo "-- versions --"; \
	cmake --version || true; \
	ninja --version || true; \
	clang --version || true; \
	qmake6 -version || true; \
	rustc --version || true; \
	cargo --version || true; \
	flutter --version || true

# (Optional) switch back to the default TeamCity build user if required
# USER buildagent
