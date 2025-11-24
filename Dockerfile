
FROM nginx:alpine

# Supprime la config par défaut et copie ton CV
RUN rm -rf /usr/share/nginx/html/*
COPY . /usr/share/nginx/html

# Expose le port Nginx
EXPOSE 80

# Commande par défaut
CMD ["nginx", "-g", "daemon off;"]
