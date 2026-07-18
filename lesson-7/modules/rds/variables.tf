variable "use_aurora" {
  description = "Якщо true, створює Aurora кластер; інакше створює звичайну RDS інстанцію"
  type        = bool
  default     = false
}

variable "db_name" {
  description = "Ім'я бази даних"
  type        = string
  default     = "postgresdb"
}

variable "db_username" {
  description = "Ім'я користувача бази даних"
  type        = string
  default     = "dbadmin"
}

variable "db_password" {
  description = "Пароль доступу до бази даних"
  type        = string
  sensitive   = true
}

variable "vpc_id" {
  description = "ID VPC, де буде розгорнута БД"
  type        = string
}

variable "subnet_ids" {
  description = "Список підмереж для DB Subnet Group"
  type        = list(string)
}

variable "engine" {
  description = "Тип рушія бази даних (напр. postgres, aurora-postgresql)"
  type        = string
  default     = "postgres"
}

variable "engine_version" {
  description = "Версія рушія бази даних"
  type        = string
  default     = "15.4"
}

variable "instance_class" {
  description = "Клас інстанції бази даних"
  type        = string
  default     = "db.t3.micro"
}

variable "multi_az" {
  description = "Чи увімкнути Multi-AZ (тільки для RDS; Aurora обробляє це на рівні кластера)"
  type        = bool
  default     = false
}

variable "allocated_storage" {
  description = "Розмір виділеного сховища в ГБ (тільки для RDS)"
  type        = number
  default     = 20
}

variable "allowed_cidr_blocks" {
  description = "Список CIDR блоків, яким дозволено доступ до БД"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "db_port" {
  description = "Порт для підключення до бази даних"
  type        = number
  default     = 5432
}
