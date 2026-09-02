FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

COPY src/DockerPipelineLab.csproj src/
RUN dotnet restore src/DockerPipelineLab.csproj

COPY src/ src/
RUN dotnet publish src/DockerPipelineLab.csproj -c Release -o /app/publish --no-restore

FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS runtime
WORKDIR /app

COPY --from=build /app/publish .

ENV ASPNETCORE_URLS=http://+:8080
EXPOSE 8080

ENTRYPOINT ["dotnet", "DockerPipelineLab.dll"]
