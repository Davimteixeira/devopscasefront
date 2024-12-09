# DEVOPSCASEFRONT

Este é o projeto `DEVOPSCASEFRONT`, uma aplicação React que utiliza Docker, CI/CD com GitHub Actions e deploy automatizado na Vercel.

## Como Funciona o CI/CD

O processo de **Integração Contínua (CI)** e **Entrega Contínua (CD)** é automatizado através do **GitHub Actions** e é projetado para garantir que as alterações feitas no código sejam testadas, construídas e enviadas automaticamente para produção sem intervenção manual. Esse processo melhora a eficiência e a confiabilidade do desenvolvimento, tornando o ciclo de vida do código mais rápido e seguro.

### O Processo de CI/CD

1. **Branch de Acionamento: `main`**
   O workflow de CI/CD é acionado automaticamente sempre que há um **push** na **branch principal** do repositório, ou seja, na branch `main`. Isso significa que todas as alterações feitas na `main` (seja por commit direto ou por merge de uma pull request) irão disparar o pipeline de integração e deploy.

2. **GitHub Actions Workflow**
   O arquivo `vercel-deploy.yml`, que está localizado na pasta `.github/workflows`, contém a configuração do workflow. A cada push para a `main`, o GitHub Actions executa o seguinte pipeline:

   ### Etapas do Workflow:

   - **Checkout do Código**: O código mais recente da branch `main` é baixado usando a ação `actions/checkout@v2`. Isso garante que a versão mais atual do código esteja sendo usada para o build.

     ```yaml
     - name: Checkout code
       uses: actions/checkout@v2
     ```

   - **Configuração do Ambiente Node.js**: A aplicação React é baseada em **Node.js**, então o workflow configura o ambiente Node.js com a versão necessária. A ação `actions/setup-node@v2` garante que o Node.js esteja instalado e configurado corretamente antes de instalar as dependências.

     ```yaml
     - name: Set up Node.js
       uses: actions/setup-node@v2
       with:
         node-version: '20'
     ```

   - **Instalação de Dependências**: O workflow então instala todas as dependências necessárias para rodar a aplicação com o comando `npm install`. Além disso, a aplicação é construída com `npm run build`, o que garante que o código está pronto para ser enviado para produção.

     ```yaml
     - name: Install dependencies
       run: |
         npm install
         npm run build
     ```

   - **Deploy na Vercel**: O último passo é o deploy da aplicação para a Vercel. O CLI do Vercel é instalado globalmente usando `npm install -g vercel`, e o deploy é feito com o comando `vercel --token ${{ secrets.VERCEL_TOKEN }} --prod`. O token do Vercel é armazenado de forma segura no GitHub Secrets e é utilizado para autenticar o processo de deploy na plataforma Vercel.

     ```yaml
     - name: Vercel deploy
       run: |
         npm install -g vercel  # Instalar o CLI do Vercel globalmente
         vercel --token ${{ secrets.VERCEL_TOKEN }} --prod  # Executar o deploy na Vercel em produção
     ```

3. **Execução do Deploy**
   Uma vez que o workflow seja executado com sucesso, a aplicação será automaticamente disponibilizada no **ambiente de produção** da Vercel, onde ela pode ser acessada por qualquer usuário. O deploy para a Vercel é configurado para ser feito na produção (`--prod`), garantindo que as mudanças sejam refletidas no ambiente final.

4. **GitHub Actions - CI/CD Automático**
   Este fluxo automatizado reduz a necessidade de intervenções manuais e permite que a equipe de desenvolvimento se concentre apenas em fazer o código funcionar e realizar novas funcionalidades. Além disso, ao ser acionado a cada alteração na branch `main`, o fluxo de CI/CD garante que as versões mais recentes do código sejam sempre enviadas para produção, sem riscos de esquecer algum passo importante.

### Vantagens do Processo de CI/CD:

- **Automatização Completa**: O processo de integração, build e deploy é totalmente automatizado, garantindo consistência e rapidez.
- **Menos Erros Manuais**: Elimina a possibilidade de erros que poderiam ocorrer durante o deploy manual.
- **Entrega Rápida e Confiável**: Mudanças feitas na branch `main` são enviadas para produção de forma rápida e confiável.
- **Feedback Imediato**: Em caso de falha em qualquer etapa do processo (como a construção do código ou o deploy), a equipe recebe feedback imediato, permitindo correções rápidas.
- **Escalabilidade**: O processo pode ser escalado facilmente, adicionando mais etapas (como testes automatizados ou linting) conforme o projeto cresce.

### Quando o Workflow de CI/CD é Acionado?

A cada vez que você faz um **push** para a **branch `main`**, o workflow de CI/CD será disparado automaticamente. Isso inclui tanto commits diretos quanto merges de pull requests para a branch `main`. O workflow garante que a versão mais atual da aplicação seja construída e implantada na Vercel sem a necessidade de intervenções manuais.

---

Este processo de CI/CD permite que a equipe de desenvolvimento tenha uma entrega contínua e ágil da aplicação, mantendo a produção sempre atualizada com as últimas mudanças no código. Ao integrar essas práticas no desenvolvimento, conseguimos melhorar a produtividade, a confiabilidade e a velocidade do ciclo de vida da aplicação.

## Como Rodar o Container Localmente

### Pré-requisitos:

1. **Docker**: Certifique-se de que o Docker esteja instalado e configurado no seu sistema. Você pode instalar o Docker [aqui](https://www.docker.com/get-started).
2. **Docker Compose**: O Docker Compose facilita o gerenciamento de containers multi-serviço. Ele também deve estar instalado. Você pode seguir as instruções [aqui](https://docs.docker.com/compose/install/).

### Passos para rodar o container localmente:

1. Clone este repositório:

   ```bash
   git clone https://github.com/seu-usuario/devopscasefront.git
   cd devopscasefront
   ```

2. Certifique-se de que o Docker está rodando e execute o seguinte comando para construir e iniciar os containers:

   ```bash
   docker-compose up --build
   ```

3. O projeto estará disponível em `http://localhost/7676`. Você pode acessar a aplicação diretamente pelo navegador.

## Estrutura do Docker Compose

O arquivo `docker-compose.yml` define a estrutura de containers para o projeto, com a configuração de Nginx servindo a aplicação React.

### Estrutura do `docker-compose.yml`:

```yaml
version: '3.8'

services:
  frontend:
    build: .
    ports:
      - '5173:5173' # Porta que o Vite usa no modo de desenvolvimento
    volumes:
      - .:/app # Sincroniza o diretório de código local com o container
    environment:
      - NODE_ENV=development # Ambiente de desenvolvimento
    command: npm run dev # Comando para rodar o servidor Vite

```
