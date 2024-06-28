# Union System

A union system using vue3-ts and go-fiber.

Using PostgreSQL and Redis to store data.

## Features

- [x] Permission Control
- [x] User Management
- [x] Role Management
- [x] Auto Dark Mode
- [x] 管理员端活动管理类型管理页面
- [x] 管理员端活动查看活动详情
- [x] 管理员端 援助类型管理
- [x] 管理员端活动编辑活动信息页面
- [x] RBAC权限控制 角色添加/删除
- [x] 整理会员界面

## Environment

- go 1.22
- node 18.0.0
- PostgreSQL 16.2
- Redis 7

## Usage

### Frontend

Change api url in `frontend/.env` file.

```bash
cd frontend
pnpm install
pnpm dev
```

### Backend

Before run backend, you need change PostgreSQL and Redis connect config in `backend/config.yaml` file.

PostgreSQL database schema file is `backend/union.sql`.

```bash
cd backend/cmd
go run main.go
```
