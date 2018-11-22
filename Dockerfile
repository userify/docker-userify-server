FROM debian:stretch
WORKDIR /opt/userify-server
ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get upgrade -y \
  && apt-get install -y --no-install-recommends nano wget curl git python \
  build-essential python-dev libffi-dev zlib1g-dev libjpeg-dev libssl-dev \
  python-lxml libxml2-dev libldap2-dev libsasl2-dev libxslt1-dev redis-server \
  libxslt1-dev redis-server ntpdate curl python-setuptools python-dev \
  ca-certificates procps \
  && rm -rf /var/lib/apt/lists/* \
  && rm -rf /tmp/*
RUN curl -# https://bootstrap.pypa.io/get-pip.py > get-pip.py && \
  python get-pip.py && rm -f get-pip.py
RUN pip install --no-cache-dir --upgrade --compile cffi pyasn1 python-ldap \
  python-slugify jinja2 shortuuid bottle otpauth qrcode ipwhois netaddr \
  setproctitle py-bcrypt termcolor tomorrow addict pynacl rq boto pyindent \
  spooky redis==2.10.6 pillow emails cryptography paste apache-libcloud \
  service_identity ldaptor pyopenssl setuptools wheel ndg-httpsclient \
  html2text
EXPOSE 443
COPY startup.sh ./
COPY userify-start ./
CMD ["./startup.sh"]



# would like to include a final binary in the deploy dockerfile
#RUN curl -# https://releases.userify.com/dist/userify-pro-server.gz | \
#  gunzip > userify-server && chmod +x userify-server


# Would be preferable to build artefacts we can move to smaller deploy container
#COPY --from=builder /container/dist/ ./


# Other missed recommendations
# RECOMMENDED KERNEL SETTINGS
# for Userify:
#/sbin/sysctl -w fs.file-max=1048576
# recommended for local Redis:
#/sbin/sysctl vm.overcommit_memory=1
#echo never > /sys/kernel/mm/transparent_hugepage/enabled


# Set timezone in build - better to find way in orchestration
#ENV TZ=Pacific/Auckland
#RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone
