#!/bin/bash

# Script para fazer deploy de todos os laboratórios
# Autor: Centro de Ciências Agrárias Aplicadas
# Data: Fevereiro 2026

echo "==========================================="
echo "  Deploy dos Sites dos Laboratórios"
echo "==========================================="
echo ""

# Cores para output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

# Verifica se o Docker está rodando
if ! docker info > /dev/null 2>&1; then
    echo -e "${RED}❌ Docker não está rodando. Por favor, inicie o Docker.${NC}"
    exit 1
fi

echo -e "${YELLOW}📦 Parando containers existentes...${NC}"
docker-compose down

echo ""
echo -e "${YELLOW}🏗️  Construindo e iniciando os containers...${NC}"
docker-compose up -d --build

echo ""
echo -e "${GREEN}✅ Deploy concluído!${NC}"
echo ""
echo "==========================================="
echo "  Sites disponíveis em:"
echo "==========================================="
echo -e "  Portal Principal:  ${GREEN}http://localhost${NC}"
echo -e "  Laboratório 1:     ${GREEN}http://localhost:8081${NC} ou ${GREEN}http://localhost/lab1${NC}"
echo -e "  Laboratório 2:     ${GREEN}http://localhost:8082${NC} ou ${GREEN}http://localhost/lab2${NC}"
echo -e "  Laboratório 3:     ${GREEN}http://localhost:8083${NC} ou ${GREEN}http://localhost/lab3${NC}"
echo "==========================================="
echo ""
echo "Para ver os logs: docker-compose logs -f"
echo "Para parar: docker-compose down"
echo ""
