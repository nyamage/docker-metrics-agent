# Use phusion/baseimage as base image. To make your builds reproducible, make
# sure you lock down to a specific version, not to `latest`!
# See https://github.com/phusion/baseimage-docker/blob/master/Changelog.md for
# a list of version numbers.
FROM phusion/passenger-ruby19:0.9.14

# Set correct environment variables.
ENV HOME /root

# Regenerate SSH host keys. baseimage-docker does not contain any, so you
# have to do that yourself. You may also comment out this instruction; the
# init system will auto-generate one during boot.
RUN /etc/my_init.d/00_regen_ssh_host_keys.sh

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

# Setup fluentd
RUN mkdir -p /etc/fluent \\
	&& gem install fluentd --no-ri --no-rdoc \\
	&& cd /etc/fluent && fluentd --setup . \\
	&& mkdir -p /var/log/td-agent/tmp/ \\
	&& fluent-gem install fluent-plugin-record-reformer fluent-plugin-docker-metrics \\
 	&& mkdir -p /etc/service/fluentd

# To run fluentd by default
ADD fluent/    /etc/fluent/
ADD fluentd.sh /etc/service/fluentd/run
