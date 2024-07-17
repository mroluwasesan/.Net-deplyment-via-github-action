# Use the official .NET image as the build environment
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build-env

# Set the working directory
WORKDIR /app

# Copy the .csproj file and restore dependencies
COPY webapp/*.csproj ./webapp/
RUN dotnet restore ./webapp/webapp.csproj

# Copy the entire project
COPY . .

# Set the working directory to the webapp directory
WORKDIR /app/webapp

# Build the project
RUN dotnet build --configuration Release --no-restore

# Publish the project
RUN dotnet publish --configuration Release --no-restore --output /app/out

# Use the official ASP.NET image as the runtime environment
FROM mcr.microsoft.com/dotnet/aspnet:8.0

# Set the working directory
WORKDIR /app

# Copy the published output from the build environment
COPY --from=build-env /app/out .

# Expose the port
EXPOSE 80

# Run the application
ENTRYPOINT ["dotnet", "webapp.dll"]
