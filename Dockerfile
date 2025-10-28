# 1️⃣ Osnovna slika za zagon aplikacije (.NET 8 runtime)
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app
EXPOSE 8080

# 2️⃣ Slika za gradnjo (.NET 8 SDK)
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# kopiramo .csproj in obnovimo odvisnosti
COPY ["razvojingradnja.csproj", "./"]
RUN dotnet restore "razvojingradnja.csproj"

# kopiramo vse ostalo
COPY . .
RUN dotnet build "razvojingradnja.csproj" -c Release -o /app/build

# 3️⃣ Faza objave
FROM build AS publish
RUN dotnet publish "razvojingradnja.csproj" -c Release -o /app/publish /p:UseAppHost=false

# 4️⃣ Končna slika za zagon
FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "razvojingradnja.dll"]
