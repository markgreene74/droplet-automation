FROM alpine:3.21

# install ansible and other tools, dependencies, etc.
RUN apk add curl ansible && \
    mkdir /.ansible && chmod -R +rwx /.ansible

# install terraform
RUN if [ "$(arch)" = "x86_64" ]; then \
      export T_ARCH="amd64"; \
    elif [ "$(arch)" = "aarch64" ]; then \
      export T_ARCH="arm64"; \
    else \
      echo "ERROR: Unknown architecture"; fi && \
    curl "https://releases.hashicorp.com/terraform/1.11.4/terraform_1.11.4_linux_${T_ARCH}.zip" -o /tmp/terraform.zip && \
    unzip /tmp/terraform.zip terraform -d /usr/local/bin/

CMD ["sh", "-c", "tail -f /dev/null"]
