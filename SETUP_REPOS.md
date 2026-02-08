# Guia de Setup dos Repositórios dos Laboratórios

## Status Atual dos Repositórios

### ✅ Laboratório 1 - Camilo Feitosa

- **URL:** https://github.com/DCOMP-UFS/2025-2-lab-t2-projeto-lab-site-CamiloFeitosa.git
- **Status:** Configurado como Git Submodule
- **Funcionando:** Sim

### ⚠️ Laboratório 2 - Pedro

- **URL fornecida:** https://github.com/DCOMP-UFS/2025-2-lab-t2-projeto-lab-site-Pedro-rdn.git
- **Status:** Repositório não encontrado ou não acessível
- **Ação necessária:** Verifique a URL correta ou permissões de acesso

### ⚠️ Laboratório 3 - Davi

- **URL fornecida:** https://github.com/DCOMP-UFS/2025-2-lab-t2-projeto-lab-site-DaviZzZS2.git
- **Status:** Repositório não encontrado ou não acessível
- **Ação necessária:** Verifique a URL correta ou permissões de acesso

### 🔜 Laboratório 4 - William

- **URL:** A ser fornecida
- **Status:** Aguardando criação/configuração
- **Ação necessária:** Criar o repositório e informar a URL

## Como Corrigir os Repositórios com Erro

### Opção 1: URLs estão incorretas

As URLs podem precisar de `.git` no final ou podem ter o nome errado. Teste:

```bash
# Testar Lab 2 com .git
git ls-remote https://github.com/DCOMP-UFS/2025-2-lab-t2-projeto-lab-site-Pedro-rdn.git

# Testar Lab 3 com .git
git ls-remote https://github.com/DCOMP-UFS/2025-2-lab-t2-projeto-lab-site-DaviZzZS2.git
```

### Opção 2: Repositórios são privados

Se os repositórios forem privados, você precisa:

1. **Autenticação SSH (Recomendado):**

   ```bash
   # Adicionar chave SSH ao GitHub
   ssh-keygen -t ed25519 -C "seu-email@exemplo.com"
   # Copiar a chave pública para GitHub
   cat ~/.ssh/id_ed25519.pub

   # Usar URLs SSH em vez de HTTPS
   git submodule add git@github-pedro:DCOMP-UFS/2025-2-lab-t2-projeto-lab-site-Pedro-rdn.git laboratorios/laboratorio2
   ```

2. **Personal Access Token:**
   ```bash
   # Criar token em: https://github.com/settings/tokens
   # Usar na URL:
   git submodule add https://SEU_TOKEN@github.com/DCOMP-UFS/2025-2-lab-t2-projeto-lab-site-Pedro-rdn.git laboratorios/laboratorio2
   ```

### Opção 3: Adicionar manualmente os repositórios corretos

Se você souber as URLs corretas:

```bash
cd /caminho/para/seu/projeto

# Remover placeholders
rm -rf laboratorios/laboratorio2
rm -rf laboratorios/laboratorio3

# Adicionar repositórios corretos
git submodule add <URL_CORRETA_LAB2> laboratorios/laboratorio2
git submodule add <URL_CORRETA_LAB3> laboratorios/laboratorio3

# Inicializar e atualizar
git submodule init
git submodule update
```

## Workflow Completo

### 1. Primeira Configuração (em uma nova máquina)

```bash
# Clonar este repositório
git clone <URL-deste-repo>
cd 2025-2-lab-t2-projeto-condominio-centro_de_ciencias_agrarias_aplicadas

# Inicializar submódulos
git submodule init
git submodule update

# Fazer deploy
./scripts/deploy.sh
```

### 2. Atualizar os sites (puxar mudanças dos labs)

```bash
# Atualizar todos os repositórios e fazer redeploy
./scripts/atualizar.sh
```

Este script:

- Faz `git pull` nos 3 repositórios dos laboratórios
- Para os containers atuais
- Reconstrói as imagens Docker
- Inicia os novos containers

### 3. Adicionar o 4º laboratório (quando disponível)

Quando tiver o repositório do 4º lab:

1. **Adicionar ao Git:**

   ```bash
   git submodule add <URL_LAB4> laboratorios/laboratorio4
   ```

2. **Atualizar docker-compose.yml:**

   ```yaml
   # Adicionar seção do Lab 4
   laboratorio4:
     build:
       context: ./laboratorios/laboratorio4
       dockerfile: Dockerfile
     container_name: lab4-site
     ports:
       - "8084:80"
     networks:
       - centro-network
     restart: unless-stopped
     volumes:
       - ./dados-centro:/dados-centro:ro
     environment:
       - LAB_NAME=Laboratório 4
       - LAB_PORT=8084
   ```

3. **Atualizar nginx.conf:**

   ```nginx
   location /lab4 {
       proxy_pass http://laboratorio4:80/;
       proxy_set_header Host $host;
       proxy_set_header X-Real-IP $remote_addr;
       proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
   }
   ```

4. **Deploy:**
   ```bash
   ./scripts/deploy.sh
   ```

## Scripts Disponíveis

| Script                          | Descrição                                 |
| ------------------------------- | ----------------------------------------- |
| `./scripts/deploy.sh`           | Faz deploy inicial de todos os sites      |
| `./scripts/atualizar.sh`        | Atualiza repositórios e faz redeploy      |
| `./scripts/parar.sh`            | Para todos os containers                  |
| `./scripts/configurar-repos.sh` | Configura interativamente os repositórios |

## Comandos Úteis

```bash
# Ver status dos submódulos
git submodule status

# Ver logs de um laboratório específico
docker-compose logs -f laboratorio1

# Ver todos os containers rodando
docker-compose ps

# Acessar shell de um container
docker exec -it lab1-site sh

# Forçar rebuild de um lab específico
docker-compose up -d --build laboratorio1
```

## Troubleshooting

### Submódulo não atualiza

```bash
cd laboratorios/laboratorio1
git pull origin main
cd ../..
docker-compose up -d --build laboratorio1
```

### Erro de permissão no Git

```bash
# Verificar autenticação
ssh -T git@github.com

# ou para HTTPS
git config --global credential.helper store
```

### Container não sobe

```bash
# Ver logs detalhados
docker-compose logs laboratorio1

# Verificar se o Dockerfile existe
ls -la laboratorios/laboratorio1/Dockerfile
```

## Próximos Passos

1. ⚠️ **Corrigir URLs dos Labs 2, 3 e 4** - Verifique as URLs corretas com os responsáveis
2. ✅ **Testar o deploy** - Execute `./scripts/deploy.sh`
3. 🔄 **Configurar automação** - Configure cron job ou GitHub Actions para atualização automática
4. 🔒 **Configurar HTTPS** - Para produção, configure certificados SSL
