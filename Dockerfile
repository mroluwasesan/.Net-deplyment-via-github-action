# Use the official .NET SDK image for building the application
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build-env
WORKDIR /app

# Copy the project files
COPY *.csproj ./
RUN dotnet restore

# Copy the remaining files and build the application
COPY . ./
RUN dotnet publish -c Release -o out

# Use the official .NET runtime image for running the application
FROM mcr.microsoft.com/dotnet/aspnet:6.0
WORKDIR /app

# Copy the built files from the build stage
COPY --from=build-env /app/out .

# Expose the application port
EXPOSE 80

# Run the application
ENTRYPOINT ["dotnet", "webapp.dll"]
