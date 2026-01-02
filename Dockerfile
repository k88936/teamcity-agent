FROM jetbrains/teamcity-agent

USER root

RUN apt-get update && \
	apt-get install -y \
		sudo \
		curl \
		git \
		unzip \
		jq \
		xz-utils \
		wget \
		p7zip-full \
		tar \
		ca-certificates \
		build-essential \
		pkg-config \
		iptables

# Install GitHub CLI
RUN type -p curl >/dev/null || apt-get update && apt-get install -y curl \
	&& curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg \
	&& chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg \
	&& echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
	&& apt-get install -y gh
ENV GH_CLI=true

RUN apt-get clean \
	&& rm -rf /var/lib/apt/lists/*

ENV PLATFORM_LINUX=true
