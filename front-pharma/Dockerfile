FROM --platform=linux/amd64 node:20-slim
WORKDIR /usr/src/app
COPY package*.json ./
RUN npm install -g @angular/cli

RUN npm i
# If npm i fails, try running the following command instead:
# RUN npm i --legacy-peer-deps

COPY . ./
RUN npm run build
EXPOSE 8080
CMD [ "node", "server.js" ]