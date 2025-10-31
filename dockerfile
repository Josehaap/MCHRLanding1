# ==========================
# Etapa 1: Build Backend
# ==========================
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build-backend
WORKDIR /src

COPY MCHRLanding.sln ./
COPY IntellingCore.API/IntellingCore.API.csproj IntellingCore.API/
COPY IntellingCore.App/IntellingCore.App.csproj IntellingCore.App/

RUN dotnet restore MCHRLanding.sln
COPY . .

RUN dotnet publish IntellingCore.API/IntellingCore.API.csproj -c Release -o /app/publish/api

# ==========================
# Etapa 2: Build Frontend (Blazor)
# ==========================
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build-frontend
WORKDIR /src
COPY --from=build-backend /src ./
RUN dotnet publish IntellingCore.App/IntellingCore.App.csproj -c Release -o /app/publish/app

# ==========================
# Etapa 3: Imagen Final
# ==========================
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS final
WORKDIR /app

COPY --from=build-backend /app/publish/api ./
COPY --from=build-frontend /app/publish/app/wwwroot ./wwwroot

EXPOSE 10000
ENV ASPNETCORE_URLS=http://+:10000

ENTRYPOINT ["dotnet", "IntellingCore.API.dll"]
