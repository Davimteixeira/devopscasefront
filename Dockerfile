# Use a imagem oficial do Node.js 20
FROM node:20 

# Diretório de trabalho no container
WORKDIR /app

COPY package.json package-lock.json ./

# Instalar as dependências do projeto
RUN npm install

# Copiar o restante do código-fonte
COPY . .

# Expor a porta em que o Vite roda (geralmente 5173)
EXPOSE 5173

# Comando para rodar o servidor em modo de desenvolvimento
CMD ["npm", "run", "dev"]