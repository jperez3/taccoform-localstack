resource "aws_secretsmanager_secret" "db_creds" {
  name                    = "db_creds"
  recovery_window_in_days = 0
}

resource "aws_secretsmanager_secret_version" "db_creds" {
  secret_id     = aws_secretsmanager_secret.db_creds.id
  secret_string = "plzdontdothis"
}

resource "aws_rds_cluster" "default" {
  cluster_identifier        = "aurora-cluster-demo"
  engine                    = "aurora-postgresql"
  availability_zones        = ["us-east-1a", "us-east-1b", "us-east-1c"]
  database_name             = var.db_name
  master_username           = var.db_user
  master_password           = aws_secretsmanager_secret_version.db_creds.secret_string
  skip_final_snapshot       = true
}

resource "aws_rds_cluster_instance" "cluster_instances" {
  count              = 2
  identifier         = "aurora-cluster-demo-${count.index}"
  cluster_identifier = aws_rds_cluster.default.id
  instance_class     = "db.t4g.large"
  engine             = aws_rds_cluster.default.engine
  engine_version     = aws_rds_cluster.default.engine_version
}


output "db_query" {
  value = <<EOT
uv run awslocal rds-data execute-statement \
    --database ${var.db_name} \
    --resource-arn ${aws_rds_cluster.default.arn} \
    --secret-arn ${aws_secretsmanager_secret_version.db_creds.arn} \
    --include-result-metadata --sql 'SELECT 123'
EOT
}

output "psql" {
  value = "psql -d ${var.db_name} -U ${var.db_user} -p ${aws_rds_cluster.default.port} -h localhost -W"

}
