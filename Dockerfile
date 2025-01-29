FROM nginx:alpine

# Instalar dependencias temporales
RUN apk add --no-cache --virtual .build-deps curl unzip

# Argumentos de construcción
ARG S3_URL
ARG FILE_NAME

# Eliminar archivos por defecto de Nginx
RUN rm -rf /usr/share/nginx/html/*

# Descargar y preparar el build
RUN curl -L "${S3_URL}" -o "${FILE_NAME}.zip" && \
    unzip -o "${FILE_NAME}.zip" -d /usr/share/nginx/html && \
    rm "${FILE_NAME}.zip" && \
    apk del .build-deps

# Configurar Nginx
COPY nginx.conf /etc/nginx/conf.d

# Ajustar permisos
RUN chown -R nginx:nginx /usr/share/nginx/html && \
    find /usr/share/nginx/html -type d -exec chmod 755 {} \; && \
    find /usr/share/nginx/html -type f -exec chmod 644 {} \;

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]