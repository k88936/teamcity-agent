

FROM jetbrains/teamcity-agent

USER root

RUN apt-get update 

RUN apt-get install -y \
		sudo \
		curl \
		git \
		unzip \
		xz-utils \
		wget \
		ca-certificates \
		build-essential \
		pkg-config \
		iptables

# Force iptables legacy (for Dind)
RUN update-alternatives --set iptables /usr/sbin/iptables-legacy \
	&& update-alternatives --set ip6tables /usr/sbin/ip6tables-legacy

# Install GitHub CLI
RUN type -p curl >/dev/null || apt-get update && apt-get install -y curl \
	&& curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg \
	&& chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg \
	&& echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
	&& apt-get install -y gh

RUN apt-get clean \
	&& rm -rf /var/lib/apt/lists/*