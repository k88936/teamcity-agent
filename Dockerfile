FROM jetbrains/teamcity-agent

USER root

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
		iptables \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/*

# Force iptables legacy (for Dind)
RUN update-alternatives --set iptables /usr/sbin/iptables-legacy \
	&& update-alternatives --set ip6tables /usr/sbin/ip6tables-legacy

# Install Qt6
RUN apt-get update && apt-get install -y \
		qt6-base-dev \
		qt6-base-dev-tools \
		qt6-tools-dev-tools \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/*

# # Install Rust (Cargo)
# RUN curl https://sh.rustup.rs -sSf | sh -s -- -y
# ENV PATH="/root/.cargo/bin:${PATH}"
# ENV PLATFORM_LINUX=1
# Install Flutter
# ARG FLUTTER_VERSION=3.22.1
# RUN wget https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_${FLUTTER_VERSION}-stable.tar.xz \
# 	&& tar xf flutter_linux_${FLUTTER_VERSION}-stable.tar.xz -C /opt \
# 	&& rm flutter_linux_${FLUTTER_VERSION}-stable.tar.xz
# ENV PATH="/opt/flutter/bin:${PATH}"
# # Pre-cache Flutter dependencies (optional, speeds up first use)
# RUN flutter --version
