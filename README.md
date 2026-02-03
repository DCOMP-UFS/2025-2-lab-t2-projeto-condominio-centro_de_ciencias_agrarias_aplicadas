# Centro de Ciências Agrárias Aplicadas

## Sistema de Deploy Unificado dos Laboratórios

Este repositório centraliza o deploy e gerenciamento dos sites dos laboratórios do Centro de Ciências Agrárias Aplicadas usando Docker, Docker Compose e Git Submodules.

**🎯 Objetivo:** Este repositório faz automaticamente `git pull` dos repositórios individuais dos laboratórios e sobe os sites de cada um.

## 📋 Status dos Repositórios

| Lab | Responsável    | Status           | URL                                                                                       |
| --- | -------------- | ---------------- | ----------------------------------------------------------------------------------------- |
| 1   | Camilo Feitosa | ✅ Configurado   | [Ver repo](https://github.com/DCOMP-UFS/2025-2-lab-t2-projeto-lab-site-CamiloFeitosa.git) |
| 2   | Pedro          | ⚠️ URL incorreta | Pendente                                                                                  |
| 3   | Davi           | ⚠️ URL incorreta | Pendente                                                                                  |
| 4   | -              | 🔜 A adicionar   | -                                                                                         |

> **Nota:** Os Labs 2 e 3 estão com placeholders pois os repositórios não foram encontrados. Veja [SETUP_REPOS.md](SETUP_REPOS.md) para instruções de correção.

## 📁 Estrutura do Projeto

```
.
├── docker-compose.yml          # Orquestração dos 4 sites
├── nginx.conf                  # Proxy reverso para acesso unificado
├── laboratorios/               # Sites dos laboratórios
│   ├── laboratorio1/          # Repositório do Lab 1
│   │   ├── Dockerfile
│   │   └── index.html
│   ├── laboratorio2/          # Repositório do Lab 2
│   │   ├── Dockerfile
│   │   └── index.html
│   ├── laboratorio3/          # Repositório do Lab 3
│   │   ├── Dockerfile
│   │   └── index.html
│   └── laboratorio4/          # Repositório do Lab 4
│       ├── Dockerfile
│       └── index.html
├── dados-centro/              # Dados compartilhados entre labs
└── scripts/                   # Scripts de automação
    ├── deploy.sh              # Deploy completo
    ├── atualizar.sh           # Atualizar repositórios
    ├── parar.sh               # Parar containers
    └── configurar-repos.sh    # Configurar submódulos Git
```

## 🚀 Como Usar

### Deploy Inicial

1. **Clone este repositório:**

   ```bash
   git clone <url-deste-repo>
   cd 2025-2-lab-t2-projeto-condominio-centro_de_ciencias_agrarias_aplicadas
   ```

2. **Inicialize os submódulos Git:**

   ```bash
   git submodule init
   git submodule update
   ```

3. **Execute o deploy:**

   ```bash
   ./scripts/deploy.sh
   ```

   Ou manualmente:

   ```bash
   docker-compose up -d --build
   ```

   (Camilo):\*\* http://localhost:8081 ou http://localhost/lab1

- **Laboratório 2 (Pedro):** http://localhost:8082 ou http://localhost/lab2
- **Laboratório 3 (Davi):** http://localhost:8083 ou http://localhost/lab3
- **Dados do Centro:** http://localhost/dados

## 🔧 Como Funciona o Sistema

````� Como Funciona o Sistema

### Arquitetura

### Adicionar Lab 4 (quando disponível)

```bash
# Adicionar repositório
git submodule add <URL_LAB4> laboratorios/laboratorio4

# Depois edite docker-compose.yml e nginx.conf para incluir o Lab 4

# Fazer deploy
./scripts/deploy.sh
````

Veja instruções completas em [SETUP_REPOS.md](SETUP_REPOS.md)

## 🛠️ Comandos Disponíveis

### Scripts de Gerenciamento

| Comando                         | Descrição                                       |
| ------------------------------- | ----------------------------------------------- |
| `./scripts/deploy.sh`           | 🚀 Deploy inicial de todos os sites             |
| `./scripts/atualizar.sh`        | 🔄 **Atualiza repos (git pull) e faz redeploy** |
| `./scripts/parar.sh`            | 🛑 Para todos os containers                     |
| `./scripts/configurar-repos.sh` | ⚙️ Configura URLs dos repositórios              |

### Comandos Docker

```bash
# Ver logs de todos os labs
docker-compose logs -f

# Ver logs de um lab específico
docker-compose logs -f laboratorio1

# Ver status dos containers
docker-compose ps

# Reconstruir um lab específico
docker-compose up -d --build laboratorio1

# Parar tudo
docker-compose down

# Parar e limpar volumes
docker-compose down -v
# Remover pastas de exemplo
rm -rf laboratorios/laboratorio1
rm -rf laboratorios/laboratorio2
rm -rf laboratorios/laboratorio3
rm -rf laboratorios/laboratorio4

# Adicionar repositórios como submódulos
git submodule add <URL-do-repo-lab1> laboratorios/laboratorio1
git submodule add <URL-do-repo-lab2> laboratorios/laboratorio2
git submodule add <URL-do-repo-lab3> laboratorios/laboratorio3
git submodule add <URL-do-repo-lab4> laboratorios/laboratorio4

# Inicializar e atualizar
git submodule init
git submodule update
```

### Opção 2: Clonar Manualmente

```bash
rm -rf laboratorios/laboratorio1
git clone <URL-do-repo-lab1> laboratorios/laboratorio1

rm -rf laboratorios/laboratorio2
git clone <URL-do-repo-lab2> laboratorios/laboratorio2

# ... e assim por diante
```

### Atualizar Repositórios

```bash
./scripts/atualizar.sh
```

Ou manualmente:

```bash
git submodule update --remote --merge
docker-compose up -d --build
```

## 🛠️ Comandos Úteis

### Ver logs dos containers:

```bash
docker-compose logs -f
```

### Ver logs de um laboratório específico:

```bash
docker-compose logs -f laboratorio1
```

### Parar todos os containers:

```bash
./scripts/parar.sh
# ou
docker-compose down
```

### Reconstruir um laboratório específico:

```bash
docker-compose up -d --build laboratorio1
```

### Ver status dos containers:

```bash
docker-compose ps
```

## 📝 Requisitos dos Repositórios dos Laboratórios

Cada repositório de laboratório deve conter:

1. **Dockerfile** - Para construir a imagem do site
2. **Arquivos do site** - HTML, CSS, JS, etc.

### Exemplo de Dockerfile (para site estático):

```dockerfile
FROM nginx:alpine
COPY . /usr/share/nginx/html/
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
```

### Exemplo para site Node.js:

```dockerfile
FROM node:18-alpine
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
EXPOSE 3000
CMD ["npm", "start"]
```

## 📊 Dados Compartilhados

A pasta `dados-centro/` é compartilhada com todos os laboratórios através de volumes Docker. Coloque aqui:

- Publicações científicas
- Datasets de pesquisas
- Relatórios anuais
- Documentos administrativos

**Acesso:** http://localhost/dados

## 🔧 Configuração Avançada

### Alterar Portas

Edite o arquivo `docker-compose.yml` e modifique as portas:

```yaml
laboratorio1:
  ports:
    - "8081:80" # Altere 8081 para a porta desejada
```

### Adicionar Variáveis de Ambiente

No `docker-compose.yml`, adicione em `environment`:

```yaml
laboratorio1:
  environment:
    - DATABASE_URL=postgres://...
    - API_KEY=seu-api-key
```

### Configurar HTTPS

Para produção, configure certificados SSL no `nginx.conf`:

```nginx
server {
    listen 443 ssl;
    ssl_certificate /etc/nginx/ssl/cert.pem;
    ssl_certificate_key /etc/nginx/ssl/key.pem;
    # ... resto da configuração
}
```

## 🐛 Solução de Problemas

### Porta já em uso:

```bash
# Verificar o que está usando a porta
lsof -i :80
# Ou altere a porta no docker-compose.yml
```

### Container não inicia:

```bash
# Ver logs detalhados
docker-compose logs laboratorio1
# Reconstruir do zero
docker-compose down
docker-compose up -d --build
```

### Submódulos não atualizam:

```bash
git submodule update --init --recursive --remote
```

## 📚 Documentação Adicional

- [Docker Compose](https://docs.docker.com/compose/)
- [Git Submodules](https://git-scm.com/book/en/v2/Git-Tools-Submodules)
- [Nginx](https://nginx.org/en/docs/)

## 👥 Equipe

Centro de Ciências Agrárias Aplicadas - 2026

## 📄 Licença

Este projeto é de uso interno do Centro de Ciências Agrárias Aplicadas.
