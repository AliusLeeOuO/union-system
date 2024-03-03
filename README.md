# Union System

A union system using vue3-ts and go-fiber.

Using MySQL and Redis to store data.

## Features

- [x] Permission Control
- [x] User Management
- [x] Role Management
- [x] Auto Dark Mode

## Environment
- go 1.17
- node 18.0.0
- PostgreSQL 16.2
- Redis 6

## Usage

### Frontend

Change api url in `frontend/.env` file.
```bash
cd frontend
pnpm install
pnpm dev
```
### Backend

Before run backend, you need change PostgreSQL and Redis connect config in `backend/config/config.yaml` file.

MySQL database schema file is `backend/config/schema.sql`.


```bash
cd backend/cmd
go run main.go
```
