FROM nginx:alpine

# Instalar dependencias
RUN apk add --no-cache curl unzip

# Configurar Nginx
COPY nginx.conf /etc/nginx/conf.d

# Argumentos de construcción
ARG S3_URL
ARG FILE_NAME
ARG SHA256_CHECKSUM

# Descargar y preparar el build
RUN curl -L "${S3_URL}" -o "${FILE_NAME}".zip && \
    echo "${SHA256_CHECKSUM}  "${FILE_NAME}".zip" | sha256sum -c && \
    unzip "${FILE_NAME}".zip -d /usr/share/nginx/html && \
    rm "${FILE_NAME}".zip && \
    apk del curl unzip

# Permisos y limpieza
RUN chown -R nginx:nginx /usr/share/nginx/html && \
    find /usr/share/nginx/html -type d -exec chmod 755 {} \; && \
    find /usr/share/nginx/html -type f -exec chmod 644 {} \;

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]