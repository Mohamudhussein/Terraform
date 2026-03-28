# Default provider (primary region)
provider "aws" {
  region = "us-east-1"
}

# Aliased provider (secondary region)
provider "aws" {
  alias  = "us_west"
  region = "us-west-2"
}