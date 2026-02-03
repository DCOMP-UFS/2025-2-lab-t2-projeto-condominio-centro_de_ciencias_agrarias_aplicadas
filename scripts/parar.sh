#!/bin/bash

# Script para parar e limpar todos os containers
# Autor: Centro de Ciências Agrárias Aplicadas
# Data: Fevereiro 2026

echo "==========================================="
echo "  Parar e Limpar Containers"
echo "==========================================="
echo ""

# Cores para output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

cd "$(dirname "$0")/.." || exit

echo -e "${YELLOW}🛑 Parando todos os containers...${NC}"
docker-compose down

echo ""
echo -e "${YELLOW}🧹 Limpando imagens não utilizadas...${NC}"
docker image prune -f

echo ""
echo -e "${GREEN}✅ Containers parados e limpos!${NC}"
