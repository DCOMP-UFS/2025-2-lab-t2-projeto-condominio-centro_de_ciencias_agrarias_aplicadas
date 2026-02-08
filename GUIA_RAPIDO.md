# 🚀 GUIA RÁPIDO - Deploy dos Laboratórios

## ✅ O que foi configurado

### Repositórios Git Submodules

- ✅ **Lab 1 (Camilo):** Configurado e funcionando
- ✅ **Lab 2 (Pedro):** Configurado e funcionando
- ✅ **Lab 3 (Davi):** Configurado e funcionando
- ✅ **Lab 4 (William):** Configurado e funcionando

## 🎯 Comandos Essenciais

### 1️⃣ Atualizar Sites (Git Pull + Redeploy)

```bash
./scripts/atualizar.sh
```

**Isso faz:**

- Git pull em todos os repositórios dos labs
- Para containers atuais
- Reconstrói imagens Docker
- Inicia novos containers

### 2️⃣ Deploy Inicial

```bash
./scripts/deploy.sh
```

### 3️⃣ Parar Tudo

```bash
./scripts/parar.sh
```

### 4️⃣ Ver Logs

```bash
# Todos os labs
docker-compose logs -f

# Um lab específico
docker-compose logs -f laboratorio1
```

## 🔧 Corrigir Labs 2 e 3

### Opção 1: Verificar URLs corretas

```bash
# Teste se as URLs funcionam
git ls-remote https://github.com/DCOMP-UFS/2025-2-lab-t2-projeto-lab-site-Pedro-rdn.git
git ls-remote https://github.com/DCOMP-UFS/2025-2-lab-t2-projeto-lab-site-DaviZzZS2.git
```

### Opção 2: Adicionar manualmente com URL correta

```bash
# Lab 2
rm -rf laboratorios/laboratorio2
git submodule add <URL_CORRETA_LAB2> laboratorios/laboratorio2

# Lab 3
rm -rf laboratorios/laboratorio3
git submodule add <URL_CORRETA_LAB3> laboratorios/laboratorio3

# Atualizar
git submodule init
git submodule update
```

### Opção 3: Usar SSH se forem repos privados

```bash
# Adicionar chave SSH no GitHub primeiro
git submodule add git@github.com:DCOMP-UFS/repo-correto.git laboratorios/laboratorio2
```

## 🌐 Acessar os Sites

Após deploy:

- Portal: http://localhost
- Lab 1: http://localhost:8081 ou http://localhost/lab1
- Lab 2: http://localhost:8082 ou http://localhost/lab2
- Lab 3: http://localhost:8083 ou http://localhost/lab3
- Lab 4: http://localhost:8084 ou http://localhost/lab4

## 📁 Arquivos Importantes

- `docker-compose.yml` - Orquestração dos containers
- `nginx.conf` - Proxy reverso (unifica acesso)
- `.gitmodules` - Configuração dos submódulos
- `scripts/atualizar.sh` - Script principal de atualização
- `SETUP_REPOS.md` - Documentação detalhada

## ⚡ Workflow Típico

### Na máquina do servidor:

```bash
# 1. Clonar este repo (primeira vez)
git clone <URL_DESTE_REPO>
cd 2025-2-lab-t2-projeto-condominio-centro_de_ciencias_agrarias_aplicadas

# 2. Inicializar submódulos (primeira vez)
git submodule init
git submodule update

# 3. Deploy inicial (primeira vez)
./scripts/deploy.sh

# 4. Para atualizar sites (sempre que os labs mudarem)
./scripts/atualizar.sh
```

### Quando os desenvolvedores atualizarem os labs:

```bash
# No servidor, apenas execute:
./scripts/atualizar.sh
```

## 🔄 Adicionar Lab 4

Quando tiver o repositório:

```bash
# 1. Adicionar submódulo
git submodule add <URL_LAB4> laboratorios/laboratorio4

# 2. Editar docker-compose.yml (adicionar seção lab4)
# 3. Editar nginx.conf (adicionar /lab4)
# 4. Editar scripts/deploy.sh (adicionar Lab 4 na lista)

# 5. Deploy
./scripts/deploy.sh
```

## ❓ Problemas Comuns

### Container não sobe

```bash
docker-compose logs laboratorio1
```

### Submódulo não atualiza

```bash
cd laboratorios/laboratorio1
git pull origin main
cd ../..
docker-compose up -d --build laboratorio1
```

### Porta já em uso

```bash
# Ver o que está usando a porta
lsof -i :80

# Ou mudar a porta no docker-compose.yml
```

## 📞 Próximos Passos

1. ✅ Todos os labs estão funcionando
2. ✅ Testar o sistema com `./scripts/deploy.sh`
3. 🔄 Quando labs forem atualizados, usar `./scripts/atualizar.sh`
4. 🔒 Configurar HTTPS para produção
