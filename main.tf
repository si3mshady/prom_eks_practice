module "vpc" {
   source               = "./vpc"
   vpc_cidr = var.vpc_cidr
   public_k8s_subnets =  [for i in range(4, 255, 2) : cidrsubnet(var.vpc_cidr, 10, i)]
   private_k8s_subnets = [for i in range(3, 255, 2) : cidrsubnet(var.vpc_cidr, 10, i)]
}

module "rew_relic_monitoring" {
   source               = "./iam"
}

output "bastion" {

   value = module.vpc.web_bastion_public
  
}

# module "eks" {
#     source = "./eks"
#     private_eks_subnets = module.elliott_sandbox_vpc.vpc_private_subnets
#     public_eks_subnets = module.elliott_sandbox_vpc.vpc_public_subnets
#     vpc_id = module.elliott_sandbox_vpc.elliot_vpc_id
#     eks_security_group = module.elliott_sandbox_vpc.elliot_public_sg
# }

