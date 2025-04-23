module "vpc" {
  source                                 = "./_modules/network"
  vpc_cidr                               = var.cidrvpc
  vpc_name                               = var.vpc_name
  enable_nat_gateway                     = var.enable_nat_gateway
  single_nat_gateway                     = var.single_nat_gateway
  enable_dns_hostnames                   = var.enable_dns_hostnames
  create_database_subnet_group           = var.create_database_subnet_group
  create_database_subnet_route_table     = var.create_database_subnet_route_table
  create_database_internet_gateway_route = var.create_database_internet_gateway_route
  enable_flow_log                        = var.enable_flow_log
  create_flow_log_cloudwatch_iam_role    = var.create_flow_log_cloudwatch_iam_role
  create_flow_log_cloudwatch_log_group   = var.create_flow_log_cloudwatch_log_group
  cluster_name                           = var.eks_config.cluster_name
  default_tags = merge(
    var.default_tags
  )
}

#CREATE THE EKS CLUSTER
module "eks" {
  depends_on = [
    module.vpc
  ]
  source                                         = "./_modules/eks"
  vpc_id                                         = module.vpc.vpc_id
  private_subnet_ids                             = module.vpc.vpc_private_subnet_ids
  intranet_subnet_ids                            = module.vpc.intra_subnet_ids
  env_prefix                                     = var.env_prefix
  cluster_name                                   = var.eks_config.cluster_name
  cluster_version                                = var.eks_config.cluster_version
  min_size                                       = var.eks_config.min_size
  max_size                                       = var.eks_config.max_size
  eks_managed_node_group_defaults_instance_types = var.eks_config.eks_managed_node_group_defaults_instance_types
  manage_aws_auth_configmap                      = var.eks_config.manage_aws_auth_configmap
  instance_types                                 = var.eks_config.instance_types
  endpoint_public_access                         = var.eks_config.endpoint_public_access
  cluster_endpoint_public_access_cidrs           = var.eks_config.cluster_endpoint_public_access_cidrs
  eks_cw_logging                                 = var.eks_config.eks_cw_logging
  default_tags                                   = var.default_tags
}
