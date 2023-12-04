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
- MySQL 8.0
- Redis 6

## Usage

### Frontend

Change api url from `frontend/.env` file.
```bash
cd frontend
pnpm install
pnpm dev
```
### Backend

Before run backend, you need change MySQL and Redis connect config from `backend/config/config.yaml` file.

MySQL database schema file is `backend/config/schema.sql`.


```bash
cd backend/cmd
go run main.go
```
