FROM local/centos-systemd

ENV REFRESHED_AT=2019-02-28 \
	LANG=en_US.UTF-8 \
	HOME=/opt/build \
	TERM=xterm

WORKDIR /opt/build

RUN echo http proxy: ${http_proxy} ${HTTP_PROXY}
RUN echo https proxy: ${https_proxy} ${HTTPS_PROXY}

RUN \
	yum install -y epel-release && \
	yum install -y wget unzip "@Development tools" && \
	wget https://packages.erlang-solutions.com/erlang-solutions-1.0-1.noarch.rpm && \
	rpm -ivh erlang-solutions-1.0-1.noarch.rpm && \
	rm erlang-solutions-1.0-1.noarch.rpm && \
	yum update -y --nogpgcheck && \
	yum install -y esl-erlang && \
	mkdir /usr/lib/elixir && \
	chmod 755 /usr/lib/elixir && \
	cd /usr/lib/elixir && \
	wget https://github.com/elixir-lang/elixir/releases/download/v1.9.1/Precompiled.zip && \
	unzip Precompiled.zip && \
	ln -s /usr/lib/elixir/bin/elixir /usr/bin/elixir && \
	ln -s /usr/lib/elixir/bin/iex /usr/bin/iex && \
	ln -s /usr/lib/elixir/bin/mix /usr/bin/mix && \
	ln -s /usr/lib/elixir/bin/elixirc /usr/bin/elixirc && \
	mix local.hex --force && \
	mix local.rebar --force


CMD ["/bin/bash"]
