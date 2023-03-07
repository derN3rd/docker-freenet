FROM openjdk:11-jdk-slim as builder

# Build argument (e.g. "build01478")
ARG freenet_build=build01497

WORKDIR /build

RUN apt update && apt install -y openssl git wget

# Download Freenet
RUN git clone https://github.com/hyphanet/fred.git

# copy and apply patches for better speed
COPY ./kittypatches /build/kittypatches
RUN cd /build/kittypatches && ./autopatch.sh /build/fred -p oo

# Build Freenet
RUN cd /build/fred && ./gradlew jar

RUN mkdir -p /fred
RUN addgroup --gid 1000 fred
RUN adduser --uid 1000 --ingroup fred --home /fred fred
RUN chown 1000:1000 /fred
WORKDIR /fred
USER 1000

# Get the latest freenet build or use supplied version
RUN build=$(test -n "${freenet_build}" && echo ${freenet_build} \
  || wget -qO - https://api.github.com/repos/hyphanet/fred/releases/latest | grep 'tag_name'| cut -d'"' -f 4) \
  && short_build=$(echo ${build}|cut -c7-) && echo -e "build: $build\nurl: https://github.com/hyphanet/fred/releases/download/$build/new_installer_offline_$short_build.jar" >buildinfo.json
RUN echo "Building:"
RUN cat buildinfo.json



# Download and install freenet in the given version
RUN wget -O /tmp/new_installer.jar $(grep url /fred/buildinfo.json |cut -d" " -f2)
RUN echo $(grep url /fred/buildinfo.json |cut -d" " -f2)
RUN echo "INSTALL_PATH=/fred" >/tmp/install_options.conf
RUN java -jar /tmp/new_installer.jar -options /tmp/install_options.conf
RUN sed -i 's#wrapper.app.parameter.1=freenet.ini#wrapper.app.parameter.1=/conf/freenet.ini#' /fred/wrapper.conf
RUN rm /tmp/new_installer.jar /tmp/install_options.conf
RUN echo "Build successful"
RUN echo "----------------"
RUN cat /fred/buildinfo.json








FROM openjdk:11-jre-slim
LABEL maintainer="derN3rd <oss@dern3rd.de>"

# Runtime argument
ENV allowedhosts=127.0.0.1,0:0:0:0:0:0:0:1 darknetport=12345 opennetport=12346


# Do not run freenet as root user:
RUN mkdir -p /conf /data 
RUN addgroup --gid 1000 fred
RUN adduser --uid 1000 --group fred -h /fred fred 
RUN chown -R 1000:1000 /conf
RUN chown -R 1000:1000 /data
USER 1000
WORKDIR /fred
# VOLUME ["/conf", "/data"]

COPY --chown=1000:1000 --from=builder /fred /fred
COPY --chown=1000:1000 --from=builder /build/fred/build/libs/freenet.jar /fred/
COPY --chown=1000:1000 ./freenet.ini /conf/
COPY --chown=1000:1000 ./freenet.ini /defaults/
COPY --chown=1000:1000 docker-run /fred/

USER root

RUN chown -R 1000:1000 /conf
RUN chown -R 1000:1000 /data

USER 1000

# Interfaces:
EXPOSE 8888 9481 ${darknetport}/udp ${opennetport}/udp
# Check every 5 Minutes, if Freenet is still running
HEALTHCHECK --interval=5m --timeout=3s CMD /fred/run.sh status || exit 1

# Command to run on start of the container
CMD [ "/fred/docker-run" ]
