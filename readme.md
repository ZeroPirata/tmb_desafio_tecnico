# 🚀 Sistema de Gestão de Pedidos - Desafio Técnico TMB

Sistema completo de gestão de pedidos com processamento assíncrono, desenvolvido com .NET, React e mensageria em tempo real.

## 📋 Índice

- [Sobre o Projeto](#sobre-o-projeto)
- [Tecnologias Utilizadas](#tecnologias-utilizadas)
- [Arquitetura](#arquitetura)
- [Pré-requisitos](#pré-requisitos)
- [Instalação e Execução](#instalação-e-execução)
- [Configuração](#configuração)
- [Endpoints da API](#endpoints-da-api)
- [Funcionalidades](#funcionalidades)
- [Estrutura do Projeto](#estrutura-do-projeto)
- [Contribuição](#contribuição)

## 📖 Sobre o Projeto

Este sistema permite criar, listar e visualizar pedidos com processamento assíncrono. Quando um pedido é criado, uma mensagem é enviada para o Azure Service Bus, onde um worker processa e atualiza o status do pedido em tempo real.

### Fluxo do Sistema

1. **Criação**: Cliente cria pedido via interface web
2. **Persistência**: Dados salvos no PostgreSQL
3. **Mensageria**: Mensagem enviada para a fila
4. **Processamento**: Worker consome mensagem e processa pedido
5. **Atualizações**: Status atualizado em tempo real via SignalR

## 🛠️ Tecnologias Utilizadas

![GIT](https://img.shields.io/badge/Git-F05032?style=for-the-badge&logo=git&logoColor=white)
![Docker](https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white)
![.NET 9](https://img.shields.io/badge/.NET-9.0-512BD4?style=for-the-badge&logo=dotnet&logoColor=white)
![React](https://img.shields.io/badge/React-TSX-61DAFB?style=for-the-badge&logo=react&logoColor=black)
![Postgres 17](https://img.shields.io/badge/Postgres-17-336791?style=for-the-badge&logo=postgresql&logoColor=white)
![TailwindCSS](https://img.shields.io/badge/Tailwind_CSS-38B2AC?style=for-the-badge&logo=tailwind-css&logoColor=white)
![SignalR](https://img.shields.io/badge/SignalR-512BD4?style=for-the-badge&logo=dotnet&logoColor=white)

### Backend
- **C# .NET 9** - Framework principal
- **Entity Framework Core** - ORM
- **PostgreSQL 17** - Banco de dados
- **RabbitMQ** - Mensageria
- **SignalR** - Comunicação em tempo real
- **Health Checks** - Monitoramento

### Frontend
- **React 18** - Interface do usuário
- **TypeScript** - Tipagem estática
- **TailwindCSS** - Estilização
- **SignalR Client** - Tempo real no frontend

### Infraestrutura
- **Docker & Docker Compose** - Containerização
- **Nginx** - Proxy reverso
- **Health Checks UI** - Dashboard de saúde

## 🏗️ Arquitetura

```mermaid
graph TB
    Client[Cliente/Browser] --> Nginx[Nginx Proxy]
    Nginx --> Frontend[React App]
    Nginx --> API[.NET API]
    
    API --> DB[(PostgreSQL)]
    API --> Queue[RabbitMQ]
    API --> SignalR[SignalR Hub]
    
    Worker[Background Worker] --> Queue
    Worker --> DB
    Worker --> SignalR
    
    Frontend --> SignalR
    
    HealthCheck[Health Checks] --> API
    HealthCheck --> DB
    HealthCheck --> Queue
```

### Fluxo de Processamento de Pedidos

1. **Requisição HTTP** → Cliente faz requisição para criar pedido
2. **Persistência** → API salva pedido no PostgreSQL com status "Pendente"
3. **Mensagem** → Evento publicado na fila com CorrelationId=OrderId
4. **Consumo** → Worker consome mensagem de forma idempotente
5. **Processamento** → Status atualizado: Pendente → Processando → Finalizado
6. **Notificação** → SignalR notifica frontend em tempo real

## 📋 Pré-requisitos

- [Docker](https://www.docker.com/) e Docker Compose
- [Git](https://git-scm.com/)
- [Make](https://www.gnu.org/software/make/) (opcional, mas recomendado)

## 🚀 Instalação e Execução

### 1. Clonar o Repositório

```bash
git clone <url-do-repositorio>
cd desafio-tmb
```

### 2. Inicializar Submódulos

```bash
git submodule update --init --recursive
```

### 3. Configurar Ambiente

```bash
# Copiar arquivo de exemplo
cp .env.example .env

# Editar variáveis de ambiente (ver seção Configuração)
nano .env
```

### 4. Executar Migrações

```bash
# Adicionar migração inicial
make migration/add IniciarProjeto

# Aplicar migrações
make migration/update
```

### 5. Iniciar Aplicação

```bash
# Construir e iniciar todos os serviços
docker compose up --build

# Ou executar em background
docker compose up --build -d
```

### 6. Verificar Saúde dos Serviços

Acesse: http://localhost:8081 (Health Checks Dashboard)

## ⚙️ Configuração

### Variáveis de Ambiente (.env)

```bash
# Banco de Dados PostgreSQL
POSTGRES_HOST=postgres
POSTGRES_PORT=5432
POSTGRES_USER=tmb_user
POSTGRES_PASSWORD=tmb_password
POSTGRES_DB=tmb_orders

# API .NET
ASPNETCORE_ENVIRONMENT=Development
API_HOST=0.0.0.0
API_PORT=8080

# Mensageria (RabbitMQ como alternativa ao Azure Service Bus)
RABBITMQ_HOST=rabbitmq
RABBITMQ_USER=guest
RABBITMQ_PASS=guest

# Health Checks
HEALTHCHECKS_UI_PORT=8081

# Frontend React
REACT_APP_SIGNALR_HUB_URL=http://localhost:8080/orderhub
REACT_APP_HEALTH_URL=http://localhost:8081
REACT_APP_TBM_API_URL=http://localhost:8080/api
REACT_PORT=3000
```

## 🌐 Endpoints da API

### Pedidos (Orders)

| Método | Endpoint | Descrição |
|--------|----------|-----------|
| `POST` | `/api/orders` | Criar novo pedido |
| `GET` | `/api/orders` | Listar todos os pedidos |
| `GET` | `/api/orders/{id}` | Obter detalhes de um pedido |

### Health Checks

| Método | Endpoint | Descrição |
|--------|----------|-----------|
| `GET` | `/health` | Status geral da aplicação |
| `GET` | `/health/ready` | Verificar se está pronto |
| `GET` | `/health/live` | Verificar se está funcionando |

### Exemplo de Payload

```json
{
  "cliente": "João Silva",
  "produto": "Notebook Dell",
  "valor": 2500.00
}
```

## ✨ Funcionalidades

### Core Features
- ✅ Criação, listagem e visualização de pedidos
- ✅ Processamento assíncrono com mensageria
- ✅ Atualizações em tempo real via SignalR
- ✅ Health checks para todos os componentes
- ✅ Interface responsiva com TailwindCSS

### Status do Pedido
- **Pendente** → Estado inicial após criação
- **Processando** → Worker iniciou processamento
- **Finalizado** → Pedido processado com sucesso

### Recursos Técnicos
- **Idempotência** → Mensagens processadas apenas uma vez
- **Correlation ID** → Rastreamento de pedidos
- **Health Monitoring** → Monitoramento contínuo
- **Docker Compose** → Ambiente completo containerizado

## 📁 Estrutura do Projeto

```
├── src/
│   ├── TmbApi/              # API .NET Core
│   │   ├── Controllers/     # Controllers da API
│   │   ├── Models/          # Modelos de dados
│   │   ├── Services/        # Serviços de negócio
│   │   ├── Workers/         # Background workers
│   │   └── Hubs/           # SignalR hubs
│   └── frontend/           # Aplicação React
│       ├── src/
│       │   ├── components/ # Componentes React
│       │   ├── services/   # Serviços API
│       │   └── hooks/      # Custom hooks
│       └── public/
├── docker-compose.yml      # Configuração dos containers
├── .env.example           # Exemplo de variáveis
├── Makefile              # Comandos auxiliares
└── README.md            # Este arquivo
```

## 🌍 URLs de Acesso

| Serviço | URL | Descrição |
|---------|-----|-----------|
| **Frontend** | http://localhost:3000 | Interface do usuário |
| **API** | http://localhost:8080 | Backend .NET |
| **Health Checks** | http://localhost:8081 | Dashboard de saúde |
| **Swagger** | http://localhost:8080/swagger | Documentação da API |

## 🧪 Executar Testes

```bash
# Testes unitários
dotnet test src/TmbApi.Tests/

# Testes de integração
dotnet test src/TmbApi.IntegrationTests/
```

## 📊 Monitoramento

O sistema inclui health checks para:
- 🔍 **API** → Verificação de funcionamento
- 🗄️ **PostgreSQL** → Conectividade do banco
- 📨 **RabbitMQ** → Status da fila de mensagens
- 🔄 **Worker** → Processamento de background

Acesse o dashboard em: http://localhost:8081

## 🤝 Contribuição

1. Fork do projeto
2. Crie sua feature branch (`git checkout -b feature/nova-funcionalidade`)
3. Commit suas mudanças (`git commit -am 'Adiciona nova funcionalidade'`)
4. Push para a branch (`git push origin feature/nova-funcionalidade`)
5. Abra um Pull Request

## 📝 Notas de Desenvolvimento

- O worker processa mensagens com delay de 5 segundos para simular processamento real
- SignalR fornece feedback visual imediato das mudanças de status
- Todas as operações de mensageria são idempotentes
- Health checks são executados a cada 30 segundos

---

**Desenvolvido com ❤️ para o Desafio Técnico TMB**