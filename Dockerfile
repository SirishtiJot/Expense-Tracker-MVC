# Build Stage
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /source

# Copy everything first to avoid path issues
COPY . .

# Restore dependencies directly using the solution file
# Hum pooray project ko restore karenge bina subdirectory ki tension liye
RUN dotnet restore "Expense Tracker.sln"

# Build and Publish
# --no-restore use karenge kyunki hum pehle hi kar chuke hain
RUN dotnet publish "Expense Tracker.sln" -c Release -o /app --no-restore

# Final Stage
FROM mcr.microsoft.com/dotnet/aspnet:8.0
WORKDIR /app
COPY --from=build /app ./

# Port setup for Railway
ENV ASPNETCORE_URLS=http://+:8080
EXPOSE 8080

# DLL name check: Agar aapke project ki output file ka naam "Expense Tracker.dll" hai
ENTRYPOINT ["dotnet", "Expense Tracker.dll"]
