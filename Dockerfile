# Etapa 1: Construção da aplicação
FROM node:20 AS development

WORKDIR /app
COPY package.json package-lock.json ./
RUN npm install

COPY . .
RUN npm run build

# Etapa 2: Instalar Vercel CLI
FROM node:20 AS vercel

WORKDIR /app
RUN npm install -g vercel

# Etapa 3: Configuração do Nginx para produção
FROM nginx:stable-alpine AS production

WORKDIR /usr/share/nginx/html

# Copiar o arquivo de template do nginx
COPY /.nginx/templates/nginx.conf.template /etc/nginx/templates/nginx.conf.template

# Copiar os arquivos de build para o Nginx
COPY --from=development /app/build /usr/share/nginx/html

# Comando para rodar o Nginx
CMD ["/bin/sh", "-c", "envsubst '$NGINX_PORT' < /etc/nginx/templates/nginx.conf.template > /etc/nginx/conf.d/default.conf && exec nginx -g 'daemon off;'"]
