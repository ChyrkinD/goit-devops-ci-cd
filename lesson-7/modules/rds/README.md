# RDS Terraform Module

Цей гнучкий модуль дозволяє розгортати базу даних в AWS, використовуючи або класичний **RDS Instance**, або **Aurora Cluster** (залежно від параметра `use_aurora`).

## Особливості
- Автоматично створює **DB Subnet Group**.
- Автоматично створює **Security Group** з дозволом на вхідний трафік.
- Автоматично створює **Parameter Group** з налаштуваннями `max_connections`, `log_statement` та `work_mem`.
- Керується однією булевою змінною `use_aurora` для вибору архітектури БД.

## Приклад використання

### 1. Звичайний RDS (PostgreSQL)
```hcl
module "rds" {
  source = "./modules/rds"

  use_aurora     = false
  db_name        = "mydatabase"
  db_username    = "dbadmin"
  db_password    = "SuperSecretPassword123!"
  
  vpc_id         = module.vpc.vpc_id
  subnet_ids     = module.vpc.private_subnets

  engine         = "postgres"
  engine_version = "15.4"
  instance_class = "db.t3.micro"
  
  allocated_storage = 20
  multi_az          = false
}
```

### 2. Aurora Cluster (PostgreSQL Compatible)
```hcl
module "rds_aurora" {
  source = "./modules/rds"

  use_aurora     = true
  db_name        = "myauroradb"
  db_username    = "dbadmin"
  db_password    = "SuperSecretPassword123!"
  
  vpc_id         = module.vpc.vpc_id
  subnet_ids     = module.vpc.private_subnets

  engine         = "aurora-postgresql"
  engine_version = "15.4"
  instance_class = "db.r6g.large"
}
```

## Змінні (Inputs)

| Ім'я | Тип | За замовчуванням | Опис |
|------|-----|------------------|------|
| `use_aurora` | `bool` | `false` | Встановіть `true` для створення Aurora Cluster. Якщо `false` - створюється звичайний RDS інстанс. |
| `db_name` | `string` | `"postgresdb"` | Ім'я бази даних, що буде створена. |
| `db_username` | `string` | `"dbadmin"` | Логін головного користувача. |
| `db_password` | `string` | n/a | Пароль головного користувача (sensitive). |
| `vpc_id` | `string` | n/a | ID VPC для створення Security Group. |
| `subnet_ids` | `list(string)` | n/a | Список ID підмереж для DB Subnet Group. |
| `engine` | `string` | `"postgres"` | Рушій бази даних (`postgres`, `mysql`, `aurora-postgresql`, `aurora-mysql`). |
| `engine_version` | `string` | `"15.4"` | Версія рушія бази даних. |
| `instance_class` | `string` | `"db.t3.micro"` | Клас інстанції (наприклад, `db.t3.micro`, `db.r6g.large`). |
| `multi_az` | `bool` | `false` | Увімкнення Multi-AZ для звичайного RDS. |
| `allocated_storage` | `number` | `20` | Розмір диска (ГБ). Застосовується тільки для RDS. |
| `allowed_cidr_blocks` | `list(string)`| `["10.0.0.0/16"]` | Мережі, яким дозволено доступ до порту БД. |
| `db_port` | `number` | `5432` | Порт бази даних (5432 для Postgres, 3306 для MySQL). |

## Як змінити параметри?
Щоб змінити тип бази даних з RDS на Aurora, просто змініть `use_aurora = true` та вкажіть відповідний `engine` (наприклад, `aurora-postgresql`). Клас інстансу змінюється через `instance_class`, а для звичайного RDS розмір диска вказується через `allocated_storage`. Модуль сам вирішить, який тип Parameter Group створювати та які ресурси піднімати.
