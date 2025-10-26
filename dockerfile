# Etapa 1: Build
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /app

# Copiar los archivos de la solución y restaurar dependencias
COPY ./MCHRLanding.sln ./
COPY ./IntellingCore.App/*.csproj ./IntellingCore.App/
RUN dotnet restore ./IntellingCore.App/IntellingCore.App.csproj

# Copiar el resto del código fuente y compilar
COPY ./IntellingCore.App ./IntellingCore.App/
WORKDIR /app/IntellingCore.App
RUN dotnet publish -c Release -o /out

# Etapa 2: Runtime
FROM nginx:alpine AS runtime
WORKDIR /usr/share/nginx/html

# Copiar los archivos publicados desde la etapa de build
COPY --from=build /out/wwwroot .

# Copiar el archivo de configuración personalizado de Nginx
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Exponer el puerto en el que corre la aplicación
EXPOSE 8010
