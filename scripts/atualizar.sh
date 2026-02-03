#!/bin/bash

# Script para atualizar os repositórios dos laboratórios e fazer redeploy
# Autor: Centro de Ciências Agrárias Aplicadas
# Data: Fevereiro 2026

echo "==========================================="
echo "  Atualização dos Laboratórios"
echo "==========================================="
echo ""

# Cores para output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

cd "$(dirname "$0")/.." || exit

echo -e "${BLUE}📥 Atualizando repositórios dos laboratórios...${NC}"
echo ""

# Atualizar submódulos Git
if [ -f .gitmodules ]; then
    echo -e "${YELLOW}🔄 Fazendo git pull nos submódulos...${NC}"
    git submodule update --remote --merge
    
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ Submódulos atualizados com sucesso!${NC}"
    else
        echo -e "${RED}❌ Erro ao atualizar submódulos.${NC}"
        echo -e "${YELLOW}Tentando atualizar manualmente...${NC}"
        
        # Atualizar cada laboratório individualmente
        for lab in laboratorios/laboratorio*; do
            if [ -d "$lab/.git" ]; then
                echo -e "${BLUE}  → Atualizando $lab...${NC}"
                (cd "$lab" && git pull origin main || git pull origin master)
            fi
        done
    fi
else
    echo -e "${YELLOW}ℹ️  Nenhum submódulo Git configurado.${NC}"
    echo ""
    echo "Para adicionar repositórios dos laboratórios como submódulos:"
    echo "  ./scripts/configurar-repos.sh"
fi

echo ""
echo -e "${YELLOW}🔄 Reconstruindo e reiniciando containers...${NC}"
echo ""

# Parar containers
docker-compose down

# Reconstruir e iniciar
docker-compose up -d --build

if [ $? -eq 0 ]; then
    echo ""
    echo -e "${GREEN}✅ Atualização e deploy concluídos com sucesso!${NC}"
    echo ""
    echo "==========================================="
    echo "  Sites atualizados e disponíveis em:"
    echo "==========================================="
    echo -e "  Portal Principal:  ${GREEN}http://localhost${NC}"
    echo -e "  Laboratório 1:     ${GREEN}http://localhost:8081${NC}"
    echo -e "  Laboratório 2:     ${GREEN}http://localhost:8082${NC}"
    echo -e "  Laboratório 3:     ${GREEN}http://localhost:8083${NC}"
    echo "==========================================="
else
    echo ""
    echo -e "${RED}❌ Erro ao fazer deploy.${NC}"
    echo "Execute 'docker-compose logs' para ver detalhes."
    exit 1
fi
