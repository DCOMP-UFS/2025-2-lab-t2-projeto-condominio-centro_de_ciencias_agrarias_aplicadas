#!/bin/bash

# Script para adicionar repositórios externos dos laboratórios como Git Submodules
# Autor: Centro de Ciências Agrárias Aplicadas
# Data: Fevereiro 2026

echo "==========================================="
echo "  Configurar Repositórios dos Laboratórios"
echo "==========================================="
echo ""

# Cores para output
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

cd "$(dirname "$0")/.." || exit

echo -e "${YELLOW}Este script irá configurar os repositórios dos laboratórios como submódulos Git.${NC}"
echo ""
echo "URLs dos repositórios conhecidos:"
echo "  Lab 1: git@github-camilo:DCOMP-UFS/2025-2-lab-t2-projeto-lab-site-CamiloFeitosa.git"
echo "  Lab 2: git@github-davi:DCOMP-UFS/2025-2-lab-t2-projeto-lab-site-DaviZzZS2.git"
echo "  Lab 3: git@github-pedro:DCOMP-UFS/2025-2-lab-t2-projeto-lab-site-Pedro-rdn.git"
echo "  Lab 4: git@github-wendell:DCOMP-UFS/2025-2-lab-t2-projeto-lab-site-WendellYan-dev.git"
echo "Por favor, forneça as URLs dos repositórios (deixe em branco para usar as URLs padrão):"
echo ""

# Laboratório 1
echo -e "${BLUE}Laboratório 1 (Camilo Feitosa):${NC}"
read -p "URL do repositório [pressione Enter para usar padrão]: " LAB1_URL
LAB1_URL=${LAB1_URL:-"git@github-camilo:DCOMP-UFS/2025-2-lab-t2-projeto-lab-site-CamiloFeitosa.git"}
    
if [ ! -z "$LAB1_URL" ]; then
    echo -e "${YELLOW}Removendo pasta existente...${NC}"
    git submodule deinit -f laboratorios/laboratorio1 2>/dev/null
    git rm --cached -rf laboratorios/laboratorio1 2>/dev/null
    rm -rf laboratorios/laboratorio1
    rm -rf .git/modules/laboratorios/laboratorio1
    echo -e "${YELLOW}Adicionando submódulo...${NC}"
    git submodule add "$LAB1_URL" laboratorios/laboratorio1
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ Lab 1 configurado!${NC}"
    else
        echo -e "${RED}❌ Erro ao adicionar Lab 1. Verifique a URL e permissões.${NC}"
    fi
fi

echo ""

# Laboratório 2
echo -e "${BLUE}Laboratório 2 (Davi ZzZS2):${NC}"
read -p "URL do repositório [pressione Enter para usar padrão]: " LAB2_URL
LAB2_URL=${LAB2_URL:-"git@github-davi:DCOMP-UFS/2025-2-lab-t2-projeto-lab-site-DaviZzZS2.git"}

if [ ! -z "$LAB2_URL" ]; then
    echo -e "${YELLOW}Removendo pasta existente...${NC}"
    git submodule deinit -f laboratorios/laboratorio2 2>/dev/null
    git rm --cached -rf laboratorios/laboratorio2 2>/dev/null
    rm -rf laboratorios/laboratorio2
    rm -rf .git/modules/laboratorios/laboratorio2
    echo -e "${YELLOW}Adicionando submódulo...${NC}"
    git submodule add "$LAB2_URL" laboratorios/laboratorio2
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ Lab 2 configurado!${NC}"
    else
        echo -e "${RED}❌ Erro ao adicionar Lab 2. Verifique a URL e permissões.${NC}"
        echo -e "${YELLOW}Criando placeholder...${NC}"
        mkdir -p laboratorios/laboratorio2
    fi
fi

echo ""

# Laboratório 3
echo -e "${BLUE}Laboratório 3 (Pedro rdn):${NC}"
read -p "URL do repositório [pressione Enter para usar padrão]: " LAB3_URL
LAB3_URL=${LAB3_URL:-"git@github-pedro:DCOMP-UFS/2025-2-lab-t2-projeto-lab-site-Pedro-rdn.git"}

if [ ! -z "$LAB3_URL" ]; then
    echo -e "${YELLOW}Removendo pasta existente...${NC}"
    git submodule deinit -f laboratorios/laboratorio3 2>/dev/null
    git rm --cached -rf laboratorios/laboratorio3 2>/dev/null
    rm -rf laboratorios/laboratorio3
    rm -rf .git/modules/laboratorios/laboratorio3
    echo -e "${YELLOW}Adicionando submódulo...${NC}"
    git submodule add "$LAB3_URL" laboratorios/laboratorio3
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ Lab 3 configurado!${NC}"
    else
        echo -e "${RED}❌ Erro ao adicionar Lab 3. Verifique a URL e permissões.${NC}"
        echo -e "${YELLOW}Criando placeholder...${NC}"
        mkdir -p laboratorios/laboratorio3
    fi
fi

echo ""

# Laboratório 4
echo -e "${BLUE}Laboratório 4 (Wendell Yan):${NC}"
read -p "URL do repositório [pressione Enter para usar padrão]: " LAB4_URL
LAB4_URL=${LAB4_URL:-"git@github-wendell:DCOMP-UFS/2025-2-lab-t2-projeto-lab-site-WendellYan-dev.git"}

if [ ! -z "$LAB4_URL" ]; then
    echo -e "${YELLOW}Removendo pasta existente...${NC}"
    git submodule deinit -f laboratorios/laboratorio4 2>/dev/null
    git rm --cached -rf laboratorios/laboratorio4 2>/dev/null
    rm -rf laboratorios/laboratorio4
    rm -rf .git/modules/laboratorios/laboratorio4
    echo -e "${YELLOW}Adicionando submódulo...${NC}"
    git submodule add "$LAB4_URL" laboratorios/laboratorio4
    if [ $? -eq 0 ]; then
        echo -e "${GREEN}✅ Lab 4 configurado!${NC}"
    else
        echo -e "${RED}❌ Erro ao adicionar Lab 4. Verifique a URL e permissões.${NC}"
        echo -e "${YELLOW}Criando placeholder...${NC}"
        mkdir -p laboratorios/laboratorio4
    fi
fi

echo ""
echo -e "${GREEN}✅ Configuração concluída!${NC}"
echo ""
echo "Próximo passo:"
echo "  Execute: ./scripts/deploy.sh"
echo ""
echo "O script de deploy irá automaticamente:"
echo "  - Inicializar os submódulos (git submodule init)"
echo "  - Atualizar os submódulos (git submodule update)"
echo "  - Construir e iniciar os containers Docker"
echo ""
echo "Para atualizar os submódulos manualmente no futuro:"
echo "  ./scripts/atualizar.sh"
