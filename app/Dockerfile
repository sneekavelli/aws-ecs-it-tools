# Build stage
FROM node:lts-alpine AS build-stage

ENV NPM_CONFIG_LOGLEVEL=warn
ENV CI=true

WORKDIR /app

COPY package.json pnpm-lock.yaml ./

RUN corepack enable \
    && corepack prepare pnpm@9.11.0 --activate \
    && pnpm install --frozen-lockfile

COPY . .

RUN pnpm build

# Production stage
FROM nginx:stable-alpine AS production-stage

COPY --from=build-stage /app/dist /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
