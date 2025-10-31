# ==========================
# Etapa 1: Construir Backend
# ==========================
FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build-backend
WORKDIR /src

# Copia el archivo de solución y los proyectos necesarios
COPY MCHRLanding.sln ./
COPY IntellingCore.API/IntellingCore.API.csproj IntellingCore.API/
COPY IntellingCore.App/IntellingCore.App.csproj IntellingCore.App/

# Restaura dependencias
RUN dotnet restore MCHRLanding.sln

# Copia todo el código
COPY . .

# Publica el backend
RUN dotnet publish IntellingCore.API/IntellingCore.API.csproj -c Release -o /app/publish/api

# ==========================
# Etapa 2: Construir Frontend (Blazor)
# ==========================
FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build-frontend
WORKDIR /src
COPY --from=build-backend /src ./
RUN dotnet publish IntellingCore.App/IntellingCore.App.csproj -c Release -o /app/publish/app

# ==========================
# Etapa 3: Imagen Final
# ==========================
FROM mcr.microsoft.com/dotnet/aspnet:7.0 AS final
WORKDIR /app

# Copia el backend publicado
COPY --from=build-backend /app/publish/api ./
# Copia el frontend Blazor (que ya está precompilado)
COPY --from=build-frontend /app/publish/app/wwwroot ./wwwroot

# Render usa el puerto 10000 o el definido por PORT
EXPOSE 10000
ENV ASPNETCORE_URLS=http://+:10000

ENTRYPOINT ["dotnet", "IntellingCore.API.dll"]
