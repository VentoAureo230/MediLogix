FROM node:20-bullseye

# git: general dev workflow
# openssl: JWT RSA keypair generation (post-create.sh)
# postgresql-client: pg_isready / psql for setup + troubleshooting
# lsof: post-start.sh port-in-use detection
# build-essential, python3: node-gyp fallback for native deps (e.g. argon2) if no prebuilt binary matches the container's arch
RUN apt-get update && apt-get install -y --no-install-recommends \
      git \
      openssl \
      postgresql-client \
      lsof \
      build-essential \
      python3 \
    && rm -rf /var/lib/apt/lists/*

RUN npm install -g @angular/cli@18

# Pre-create the node_modules mount points owned by 'node' so the named
# volumes compose overlays here inherit correct ownership on first mount
# (Docker seeds a new named volume from whatever already exists at that
# path in the image).
RUN mkdir -p /workspace/api/node_modules /workspace/front-pharma/node_modules \
    && chown -R node:node /workspace

USER node
WORKDIR /workspace
