# ========================
# ApplicationDbContext
# ========================
migration/add:
	@if [ -z "$(NAME)" ]; then \
		echo "Erro: você precisa informar o nome da migration, ex: make migration/add NAME=InitialCreate"; \
		exit 1; \
	fi
	docker compose run --rm ef-tools sh -c "dotnet tool install --global dotnet-ef && /root/.dotnet/tools/dotnet-ef migrations add $(NAME) --project Infrastructure/TMB.Challenge.Infrastructure.csproj --startup-project API/TMB.Challenge.API.csproj --context ApplicationDbContext"

migration/update:
	docker compose run --rm ef-tools sh -c "dotnet tool install --global dotnet-ef && /root/.dotnet/tools/dotnet-ef database update --project Infrastructure/TMB.Challenge.Infrastructure.csproj --startup-project API/TMB.Challenge.API.csproj --context ApplicationDbContext"

migration/list:
	docker compose run --rm ef-tools sh -c "dotnet tool install --global dotnet-ef && /root/.dotnet/tools/dotnet-ef dbcontext list --project Infrastructure/TMB.Challenge.Infrastructure.csproj --startup-project API/TMB.Challenge.API.csproj"
