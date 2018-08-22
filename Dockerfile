FROM microsoft/aspnetcore:2.0 AS base
WORKDIR /app
EXPOSE 80

FROM microsoft/aspnetcore-build:2.0 AS build
WORKDIR /src
COPY example.csproj ./
RUN dotnet restore /example.csproj
COPY . .
WORKDIR /src/
RUN dotnet build example.csproj -c Release -o /app

FROM build AS publish
RUN dotnet publish example.csproj -c Release -o /app

FROM base AS final
WORKDIR /app
COPY --from=publish /app .
ENTRYPOINT ["dotnet", "example.dll"]
