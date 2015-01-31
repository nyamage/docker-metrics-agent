# docker-metrics-agent
It's a container which collect docker metrics and send it to fluentd server.

# How to run (send log data to fluentd container in same host)

Step 1. Clone github repository

```
git clone https://github.com/nyamage/docker-metrics-agent.git
```

Step 2. Build docker image based on docker file
```
$cd docker-metrics-agent
$docker build -t <tag name whatever you want>
```

Step 3. Run it! 
```
$docker run -it --link=<fluentd server container name>:log_server --rm --name=docker_agent -v /sys/fs/cgroup:/mysys/fs/cgroup -v /var/run/docker.sock:/var/run/docker.sock <tag name in step 2>
```

# How it works
This container uses fluentd plugin named fluent-plugin-docker-metrics to collect docker metrics and send it to fluentd server.
It gets docker container list by using docker remote api and collects docker metrics from /sys/fs/cgroup.
To make it works in container, you need to use volume option for cgroup and docker.sock when you run this container.


# How to send log to fluentd server in different host
You need to modify server directive in fluentd/fluent.conf file.
In this case, you don't need link option when you run "docker run" command.
```
<match docker.**>
  type forward
  <server>
    host log_server
  </server>
</match>
```

