###################
# BUILD FOR LOCAL DEVELOPMENT
###################

FROM node:20-alpine AS development

# Create app directory
WORKDIR /usr/src/app

# Copy application dependency manifests to the container image.
COPY --chown=node:node package*.json ./

# Install app dependencies using npm ci
RUN npm ci

# Bundle app source
COPY --chown=node:node . .

# Use the node user from the image (instead of the root user)
USER node

###################
# BUILD FOR PRODUCTION
###################

FROM node:20-alpine AS build

WORKDIR /usr/src/app

COPY --chown=node:node package*.json ./

# Install all dependencies from the development stage
COPY --chown=node:node --from=development /usr/src/app/node_modules ./node_modules

COPY --chown=node:node . .

# Generate Prisma client and build the application
RUN npx prisma generate
RUN npm run build

# Set NODE_ENV environment variable
ENV NODE_ENV=production
ENV HOSTNAME=0.0.0.0

# Running `npm ci` removes the existing node_modules directory and passing in --only=production ensures that only the production dependencies are installed. This ensures that the node_modules directory is as optimized as possible
RUN npm ci --only=production && npm cache clean --force

USER node

###################
# PRODUCTION
###################

FROM node:20-alpine AS production

# Copy the bundled code and node_modules from the build stage
COPY --chown=node:node --from=build /usr/src/app/node_modules ./node_modules
COPY --chown=node:node --from=build /usr/src/app/dist ./dist
COPY --chown=node:node --from=build /usr/src/app/prisma ./prisma

# In case of a migration failure, run the rollback command before the deploy command
# Ex : CMD ["sh", "-c", "npx prisma migrate resolve --rolled-back [migration] && npx prisma migrate deploy && node dist/src/main.js"]
# The migration that failed can be found in the error message
# Once it is resolved, you can remove the rollback command from the CMD
# Apply migrations and start the server

CMD ["sh", "-c", "npx prisma migrate deploy && node dist/main.js"]