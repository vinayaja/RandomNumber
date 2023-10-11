# https://hub.docker.com/_/microsoft-dotnet
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /source

# copy csproj and restore as distinct layers
COPY *.sln .
COPY *.csproj . 
COPY *.csproj ./RandomNumber/
RUN dotnet restore

# copy everything else and build app
COPY * ./RandomNumber/
WORKDIR /source/RandomNumber
RUN dotnet publish RandomNumber.csproj -c release -o /app

# final stage/image
FROM mcr.microsoft.com/dotnet/aspnet:6.0
WORKDIR /app
COPY --from=build /app ./
ENTRYPOINT ["dotnet", "RandomNumber.dll"]