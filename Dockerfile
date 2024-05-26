# Use the official .NET Core SDK image to build the application
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build

# Set the working directory inside the container
WORKDIR /app

# Copy the .csproj file and restore any dependencies
COPY *.csproj ./
RUN dotnet restore

# Copy the rest of the application files and build the application
COPY . ./
RUN dotnet publish -c Release -o out

# Use the official .NET runtime image to run the application
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS runtime

# Set the working directory inside the container
WORKDIR /app

# Copy the build output from the build stage to the runtime stage
COPY --from=build /app/out .

# Expose port 80
EXPOSE 80

# Set the ASP.NET Core URL environment variable to listen on port 80
ENV ASPNETCORE_URLS=http://+:80

# Specify the entry point for the application
ENTRYPOINT ["dotnet", "DMart.dll"]
