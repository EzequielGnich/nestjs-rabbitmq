FROM node:slim As development

WORKDIR /usr/src/app

COPY package*.json ./

RUN npm install

COPY --chown=node:node . ./

RUN npm run build

FROM node:slim as production

ARG NODE_ENV=production
ENV NODE_ENV=${NODE_ENV}

WORKDIR /usr/src/app

COPY package*.json ./

RUN npm install --only=production

COPY --chown=node:node . ./

COPY --from=development /usr/src/app/dist .dist

CMD ["node", "dist/apps/auth/main"]