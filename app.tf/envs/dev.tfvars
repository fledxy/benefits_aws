
env_prefix                             = "benefits"
vpc_name                               = "benefits_vpc"
cidrvpc                                = "10.0.0.0/16"
enable_nat_gateway                     = true
single_nat_gateway                     = true
enable_dns_hostnames                   = true
create_database_subnet_group           = true
create_database_subnet_route_table     = true
create_database_internet_gateway_route = true
enable_flow_log                        = true
create_flow_log_cloudwatch_iam_role    = true
create_flow_log_cloudwatch_log_group   = true
eks_config = {
  cluster_name                                   = "fledxy"
  cluster_version                                = "1.30"
  min_size                                       = 3
  max_size                                       = 9
  eks_managed_node_group_defaults_instance_types = ["t2.medium", "t2.large"]
  instance_type                                  = "t2.medium"
  instance_types                                 = ["t2.medium", "t2.large"]
  manage_aws_auth_configmap                      = true
  endpoint_public_access                         = true
  # aws_auth_users = [
  #   {
  #     userarn  = "arn:aws:iam::539247450054:user/eks-ops"
  #     username = "eks-ops"
  #     groups   = ["system:masters"]
  #   },
  #   {
  #     userarn  = "arn:aws:iam::539247450054:user/devops"
  #     username = "devops"
  #     groups   = ["system:masters"]
  #   },
  # ]
  cluster_endpoint_public_access_cidrs = ["0.0.0.0/0"],
  # eks_cw_logging                       = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
}
