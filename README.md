# Terraform GCP Cloud SQL

Terraform module for deploying Cloud SQL instances on Google Cloud Platform with support for PostgreSQL and MySQL, high availability, read replicas, private IP networking, and automated backups.

## Architecture

```mermaid
graph TB
    subgraph GCP["Google Cloud Platform"]
        style GCP fill:#e8f0fe,stroke:#4285f4,stroke-width:2px,color:#1a73e8

        subgraph VPC["VPC Network"]
            style VPC fill:#e6f4ea,stroke:#34a853,stroke-width:2px,color:#137333
            PSN["Private Service Networking"]
            GCA["Global Compute Address"]
            style PSN fill:#ceead6,stroke:#34a853,color:#137333
            style GCA fill:#ceead6,stroke:#34a853,color:#137333
        end

        subgraph CloudSQL["Cloud SQL"]
            style CloudSQL fill:#fce8e6,stroke:#ea4335,stroke-width:2px,color:#c5221f
            PRIMARY["Primary Instance<br/>HA: Regional"]
            DB["Databases"]
            USR["Users"]
            style PRIMARY fill:#fad2cf,stroke:#ea4335,color:#c5221f
            style DB fill:#fad2cf,stroke:#ea4335,color:#c5221f
            style USR fill:#fad2cf,stroke:#ea4335,color:#c5221f
        end

        subgraph Replicas["Read Replicas"]
            style Replicas fill:#fef7e0,stroke:#fbbc04,stroke-width:2px,color:#e37400
            R1["Replica 1"]
            R2["Replica 2"]
            style R1 fill:#feefc3,stroke:#fbbc04,color:#e37400
            style R2 fill:#feefc3,stroke:#fbbc04,color:#e37400
        end

        subgraph Backup["Backup & Recovery"]
            style Backup fill:#f3e8fd,stroke:#a142f4,stroke-width:2px,color:#7627bb
            BAK["Automated Backups"]
            PITR["Point-in-Time Recovery"]
            style BAK fill:#e9d5fc,stroke:#a142f4,color:#7627bb
            style PITR fill:#e9d5fc,stroke:#a142f4,color:#7627bb
        end
    end

    APP["Application"] -->|private IP| PSN
    PSN --> PRIMARY
    GCA --> PSN
    PRIMARY --> DB
    PRIMARY --> USR
    PRIMARY -->|replication| R1
    PRIMARY -->|replication| R2
    PRIMARY --> BAK
    PRIMARY --> PITR

    style APP fill:#c8e6c9,stroke:#2e7d32,color:#1b5e20
```

## Features

- Cloud SQL instances for PostgreSQL 15 and MySQL 8.0
- High availability with REGIONAL availability type
- Read replicas with independent sizing
- Private IP via Private Service Networking
- Automated backups with point-in-time recovery
- Configurable maintenance windows
- Query Insights for performance monitoring
- Database flags for fine-grained tuning
- Multiple databases and users per instance

## Usage

### Basic

```hcl
module "cloud_sql" {
  source = "github.com/kogunlowo123/terraform-gcp-cloud-sql"

  project_id       = "my-gcp-project"
  instance_name    = "my-postgres"
  database_version = "POSTGRES_15"

  databases = {
    "myapp" = {}
  }

  users = {
    "appuser" = { password = "change-me" }
  }
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.5.0 |
| google | >= 5.10.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| project\_id | The GCP project ID | `string` | n/a | yes |
| instance\_name | Cloud SQL instance name | `string` | n/a | yes |
| database\_version | Database version | `string` | `"POSTGRES_15"` | no |
| tier | Machine tier | `string` | `"db-f1-micro"` | no |
| availability\_type | HA type (REGIONAL/ZONAL) | `string` | `"ZONAL"` | no |
| enable\_private\_ip | Enable private IP | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| instance\_name | Cloud SQL instance name |
| instance\_connection\_name | Connection name |
| private\_ip\_address | Private IP address |
| public\_ip\_address | Public IP address |
| read\_replica\_names | Read replica instance names |

## License

MIT Licensed. See [LICENSE](LICENSE) for full details.
