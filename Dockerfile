# Build Stage (Using SDK 6.0)
FROM mcr.microsoft.com/dotnet/sdk:6.0 AS build
WORKDIR /source

# Copy everything
COPY . .

# Restore dependencies using the solution file
RUN dotnet restore "Expense Tracker.sln"

# Build and Publish
RUN dotnet publish "Expense Tracker.sln" -c Release -o /app --no-restore

# Final Stage (Using Runtime 6.0)
FROM mcr.microsoft.com/dotnet/aspnet:6.0
WORKDIR /app
COPY --from=build /app ./

# Port setup for Railway
ENV ASPNETCORE_URLS=http://+:8080
EXPOSE 8080

# DLL name check
ENTRYPOINT ["dotnet", "Expense Tracker.dll"]
