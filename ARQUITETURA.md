# Arquitetura do Projeto - Centro de Ciências Agrárias

## 📋 Visão Geral

Este projeto utiliza **Docker Compose** com um **Nginx centralizado** para gerenciar múltiplos sites de laboratórios através de um único ponto de entrada.

## 🏗️ Estrutura

```
projeto-condominio/
├── docker-compose.yml          # Orquestração de containers
├── nginx.conf                  # Configuração centralizada de proxy
├── laboratorios/
│   ├── Dockerfile.lab1        # Build simplificado Lab 1
│   ├── Dockerfile.lab2        # Build simplificado Lab 2
│   ├── laboratorio1/          # Submódulo Git (repo Camilo)
│   └── laboratorio2/          # Submódulo Git (repo Felipe)
├── dados-centro/              # Dados compartilhados
└── scripts/
    ├── configurar-repos.sh    # Configurar submódulos
    ├── deploy.sh              # Deploy completo
    ├── atualizar.sh           # Atualizar submódulos
    └── parar.sh               # Parar containers
```

## 🌐 Roteamento de Domínios

### Nginx Centralizado (Proxy Reverso)

O `nginx.conf` na raiz do projeto gerencia TODO o roteamento:

#### **Laboratório 1 - Acessível por:**

- ✅ `http://matchupsite.com.br` → Site principal
- ✅ `http://localhost/lab1/` → Desenvolvimento local

#### **Laboratório 2 - Acessível por:**

- ✅ `http://sitelab2.com.br` → Domínio próprio
- ✅ `http://matchupsite.com.br/laboratorio2/` → Via path
- ✅ `http://localhost/lab2/` → Desenvolvimento local

### Configuração DNS Necessária

Para produção, configure seus domínios apontando para o IP do servidor:

```
matchupsite.com.br      → IP_DO_SERVIDOR
www.matchupsite.com.br  → IP_DO_SERVIDOR
sitelab2.com.br         → IP_DO_SERVIDOR
www.sitelab2.com.br     → IP_DO_SERVIDOR
```

## 🐳 Containers

### 1. nginx-proxy (Porta 80)

- **Função:** Proxy reverso centralizado
- **Expõe:** Porta 80 (HTTP)
- **Roteia:** Todos os domínios para os labs internos

### 2. laboratorio1 (Interno)

- **Função:** Site do Laboratório 1
- **Porta:** Interna (não exposta)
- **Build:** `laboratorios/Dockerfile.lab1`
- **Conteúdo:** Serve arquivos de `laboratorio1/src/`

### 3. laboratorio2 (Interno)

- **Função:** Site do Laboratório 2
- **Porta:** Interna (não exposta)
- **Build:** `laboratorios/Dockerfile.lab2`
- **Conteúdo:** Serve arquivos raiz do repositório

## 🚀 Fluxo de Deploy

1. **Configurar submódulos** (primeira vez):

   ```bash
   ./scripts/configurar-repos.sh
   ```

2. **Deploy completo**:

   ```bash
   ./scripts/deploy.sh
   ```

   - Atualiza submódulos Git
   - Reconstrói containers Docker
   - Inicia todos os serviços

3. **Atualizar sites**:
   ```bash
   ./scripts/atualizar.sh
   ```

## 🔧 Dockerfiles Simplificados

### Por que não usar os Dockerfiles dos submódulos?

Os repositórios individuais podem ter `Dockerfile` e `nginx.conf` próprios, mas:

- ❌ Criaria conflito com o proxy centralizado
- ❌ Cada lab tentaria configurar seu próprio nginx
- ❌ Perderíamos o roteamento unificado

### Solução: Dockerfiles no Projeto Principal

Criamos `Dockerfile.lab1` e `Dockerfile.lab2` que:

- ✅ Servem apenas arquivos estáticos
- ✅ Usam nginx padrão (sem configuração customizada)
- ✅ Deixam o roteamento para o nginx centralizado

## 📊 Diagrama de Rede

```
Internet
   │
   ├─ matchupsite.com.br ────┐
   ├─ sitelab2.com.br ───────┤
   └─ localhost ─────────────┤
                             │
                    ┌────────▼─────────┐
                    │  nginx-proxy     │
                    │  (Porta 80)      │
                    └────────┬─────────┘
                             │
                ┌────────────┴────────────┐
                │   centro-network        │
                │   (Docker Network)      │
                └───┬─────────────────┬───┘
                    │                 │
         ┌──────────▼──────┐  ┌──────▼──────────┐
         │ laboratorio1    │  │ laboratorio2    │
         │ (interno)       │  │ (interno)       │
         └─────────────────┘  └─────────────────┘
```

## 🎯 Vantagens desta Arquitetura

✅ **Centralização:** Um único ponto de entrada (porta 80)  
✅ **Flexibilidade:** Múltiplos domínios por laboratório  
✅ **SSL Simplificado:** Certificados gerenciados em um lugar  
✅ **Isolamento:** Labs não sabem da existência uns dos outros  
✅ **Independência:** Cada lab mantém seu próprio repositório  
✅ **Escalabilidade:** Fácil adicionar novos laboratórios

## 📝 Adicionar Novo Laboratório

1. Adicione o submódulo:

   ```bash
   git submodule add URL_REPO laboratorios/laboratorio3
   ```

2. Crie `laboratorios/Dockerfile.lab3`

3. Adicione ao `docker-compose.yml`:

   ```yaml
   laboratorio3:
     build:
       context: ./laboratorios
       dockerfile: Dockerfile.lab3
   ```

4. Configure roteamento em `nginx.conf`:
   ```nginx
   server {
       listen 80;
       server_name lab3.com.br;
       location / {
           proxy_pass http://laboratorio3:80;
       }
   }
   ```

## 🔒 Segurança

Para produção, adicione SSL/TLS:

- Use **Certbot** para certificados Let's Encrypt
- Configure HTTPS no `nginx.conf`
- Redirecione HTTP para HTTPS

## 📞 Suporte

Para problemas ou dúvidas:

- Verifique logs: `docker-compose logs -f`
- Reinicie: `./scripts/deploy.sh`
- Verifique DNS: `nslookup matchupsite.com.br`
