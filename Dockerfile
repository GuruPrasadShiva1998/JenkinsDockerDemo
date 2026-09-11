# =========================
# Build Stage
# =========================
FROM mcr.microsoft.com/dotnet/sdk:10.0 AS build

WORKDIR /src

# Copy project file first
COPY *.csproj ./

# Restore NuGet packages
RUN dotnet restore

# Copy remaining source code
COPY . .

# Build and publish
RUN dotnet publish -c Release -o /app/publish /p:UseAppHost=false


# =========================
# Runtime Stage
# =========================
FROM mcr.microsoft.com/dotnet/aspnet:10.0 AS final

WORKDIR /app

# Copy published application
COPY --from=build /app/publish .

# Application port
EXPOSE 8080

# Configure ASP.NET Core to listen on port 8080
ENV ASPNETCORE_URLS=http://+:8080

# Start application
ENTRYPOINT ["dotnet", "YourProjectName.dll"]
