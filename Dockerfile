FROM jetbrains/teamcity-agent

# Switch to root for installing dependencies
USER root
# Install dependencies for Rust and Flutter
RUN apt-get update && apt-get install -y \
	curl \
	git \
	unzip \
	xz-utils \
	libglu1-mesa \
	wget \
	ca-certificates \
	build-essential

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
