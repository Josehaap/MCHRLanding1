# Etapa 1: Build
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Copiamos los csproj y restauramos
COPY IntellingCore.API/*.csproj IntellingCore.API/
COPY IntellingCore.App/*.csproj IntellingCore.App/
RUN dotnet restore IntellingCore.API/IntellingCore.API.csproj

# Copiamos todo el código
COPY . .

# Publicamos la API (que incluye el frontend Blazor)
RUN dotnet publish IntellingCore.API/IntellingCore.API.csproj -c Release -o /app/publish

# Etapa 2: Runtime
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS runtime
WORKDIR /app
COPY --from=build /app/publish .

# Exponer el puerto que Render asigna
ENV ASPNETCORE_URLS=http://+:$PORT
EXPOSE $PORT

# Iniciar la API
ENTRYPOINT ["dotnet", "IntellingCore.API.dll"]

