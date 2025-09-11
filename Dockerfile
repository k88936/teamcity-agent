

FROM jetbrains/teamcity-agent

USER root

RUN apt-get update 

RUN apt-get install -y \
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
		pkg-config \
		libssl-dev \
		iptables

# Force iptables legacy (for Dind)
RUN update-alternatives --set iptables /usr/sbin/iptables-legacy \
	&& update-alternatives --set ip6tables /usr/sbin/ip6tables-legacy

# Install Qt6
RUN apt-get install -y \
		qt6-base-dev \
		qt6-base-dev-tools \
		qt6-tools-dev-tools \
	&& apt-get clean \
	&& rm -rf /var/lib/apt/lists/*

# Install Rust (Cargo)
RUN curl https://sh.rustup.rs -sSf | sh -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"
ENV PLATFORM_LINUX=1

# Install GitHub CLI
RUN type -p curl >/dev/null || apt-get update && apt-get install -y curl \
	&& curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg \
	&& chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg \
	&& echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
	&& apt-get install -y gh


# Install OpenJDK 8, 11, and 17
RUN apt-get install -y \
		openjdk-8-jdk \
		openjdk-11-jdk \
		openjdk-17-jdk \
		openjdk-21-jdk 

ENV JDK_8_0="/usr/lib/jvm/java-8-openjdk-amd64"
ENV JDK_11_0="/usr/lib/jvm/java-11-openjdk-amd64"
ENV JDK_17_0="/usr/lib/jvm/java-17-openjdk-amd64"
ENV JDK_21_0="/usr/lib/jvm/java-21-openjdk-amd64"

# Install vcpkg
RUN git clone https://github.com/microsoft/vcpkg.git /opt/vcpkg \
	&& /opt/vcpkg/bootstrap-vcpkg.sh \
	&& ln -s /opt/vcpkg/vcpkg /usr/local/bin/vcpkg


RUN apt-get clean \
	&& rm -rf /var/lib/apt/lists/*