FROM nginx:alpine

# Copia os arquivos do site para o container
COPY index.html /usr/share/nginx/html/index.html

# Se tiver mais arquivos, copie também:
# COPY ./src /usr/share/nginx/html/

# Expõe a porta 80
EXPOSE 80

# O nginx já inicia automaticamente
CMD ["nginx", "-g", "daemon off;"]
