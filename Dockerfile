##
# @copyright Copyright (C) 2025, Ereyna Labs Ltd. - All Rights Reserved
# @file Dockerfile
# @parblock
# This file is subject to the terms and conditions defined in file 'LICENSE.md',
# which is part of this source code package.  Proprietary and confidential.
# @endparblock
# @author Dave Linten <david@ereynalabs.com>
#

#
# Runtime container
#
# Runtime container
FROM debian:bookworm-slim

# Pull vars from global
ENV DEBIAN_FRONTEND=noninteractive
ARG BUILD_TYPE
ARG PROJECT_NAME
ARG APP_BIN_TARGET
ARG APP_LIB_TARGET
ARG APP_WWW_TARGET
ARG APP_TEST_TARGET
ARG APP_DATABASE_NAME
ARG SOURCE_LOCATION
ARG BUILD_LOCATION

# Install necessary packages
RUN apt update && apt install -y \
    wget \
    gnupg \
    lsb-release

# Add PostgreSQL official repository
RUN echo "deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main" | tee /etc/apt/sources.list.d/pgdg.list \
    && wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | tee /etc/apt/trusted.gpg.d/postgresql.asc \
    && apt update

# Install PostgreSQL 17
RUN apt install -y postgresql-17 postgresql-contrib openssl git git-lfs util-linux \
  rsync openssl jq libjsoncpp-dev \
  nodejs npm chromium python3 python3-pip

# Fix GCC
RUN <<EOF
echo "deb http://deb.debian.org/debian sid main" | tee /etc/apt/sources.list.d/sid.list
apt update -y
apt install -y -t sid libstdc++6
rm /etc/apt/sources.list.d/sid.list
apt update
EOF

WORKDIR /

RUN mkdir -p /var/lib/postgresql/17/main && \
    chown -R postgres:postgres /var/lib/postgresql && \
    chown -R postgres:postgres /var/log/postgresql && \
    chmod -R 700 /var/lib/postgresql

