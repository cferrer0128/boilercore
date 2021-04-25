FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build-env
WORKDIR /app

#copy csproj
COPY *.csproj ./
RUN dotnet restore

# Copy * .* 
COPY . ./
RUN dotnet publish -c Release -o out

# Build
FROM mcr.microsoft.com/dotnet/aspnet:5.0
WORKDIR /app
COPY --from=build-env /app/out .
EXPOSE 8080
ENTRYPOINT ["dotnet","WeatherAPI.dll"]