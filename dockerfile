# Etapa 1: Build
FROM mcr.microsoft.com/dotnet/sdk:7.0 AS build
WORKDIR /src

# Copia solo los archivos de solución y proyectos
COPY *.sln ./
COPY Concesionario/Concesionario.csproj Concesionario/
COPY LibsClass/LibsClass.csproj LibsClass/

# Restaura dependencias (usa la solución directamente)
RUN dotnet restore

# Copia todo el código
COPY . .

# Publica el proyecto principal (carpeta donde está Program.cs)
RUN dotnet publish Concesionario/Concesionario.csproj -c Release -o /app/publish

# Etapa 2: Runtime
FROM mcr.microsoft.com/dotnet/aspnet:7.0 AS final
WORKDIR /app
COPY --from=build /app/publish .

# Render expone dinámicamente el puerto en $PORT
ENV ASPNETCORE_URLS=http://+:${PORT}
EXPOSE 10000

ENTRYPOINT ["dotnet", "Concesionario.dll"]
