# Build Stage
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /source

# 1. Copy the solution file
COPY ["Expense Tracker.sln", "./"]

# 2. Create the subdirectory and copy the .csproj file there
# Quotes are used because of the space in "Expense Tracker"
COPY ["Expense Tracker/Expense Tracker.csproj", "Expense Tracker/"]

# 3. Restore dependencies
RUN dotnet restore "Expense Tracker/Expense Tracker.csproj"

# 4. Copy everything else and build
COPY . .
WORKDIR "/source/Expense Tracker"
RUN dotnet publish -c release -o /app

# Final Stage
FROM mcr.microsoft.com/dotnet/aspnet:8.0
WORKDIR /app
COPY --from=build /app ./

# Railway/Render Port setup
ENV ASPNETCORE_URLS=http://+:${PORT:-8080}

# Use quotes for the DLL name because of the space
ENTRYPOINT ["dotnet", "Expense Tracker.dll"]
