module "s3_bucket" {
  source      = "./modules/s3"
  bucket_name = "payaza-devops-assessment-test-bucket"
}

module "ecr" {
  source        = "./modules/ecr"
  ecr_repo_name = "payaza-devops-assessment"
}

module "vpc" {
  source           = "./modules/vpc"
  max_subnets      = 10
  public_sn_count  = 3
  private_sn_count = 2
  cidr_block       = "10.16.0.0/16"
  public_cidrs     = [for i in range(1, 255, 2) : cidrsubnet("10.16.0.0/16", 8, i)]
  private_cidrs    = [for i in range(0, 255, 2) : cidrsubnet("10.16.0.0/16", 8, i)]
}

module "ecs" {
  source                      = "./modules/ecs"
  simple-api-target-group-arn = module.lb.payaza_test_api_tg_arn
  public_subnets              = module.vpc.public_subnets
  payaza_test_lb              = module.lb.payaza_test_lb
  payaza_test_execution_role  = module.iam.payaza_task_ecs_task_execution_role
  simple-api-sg               = module.vpc.simple_api_security_group

}

module "lb" {
  source                  = "./modules/lb"
  payaza_test_lb_sg       = [module.vpc.lb_sg]
  public_subnets          = module.vpc.public_subnets
  payaza_test_vpc_id      = module.vpc.payaza_vpc_id
  elb_healthy_threshold   = 2
  elb_interval            = 30
  elb_timeout             = 3
  elb_unhealthy_threshold = 2
}

module "iam" {
  source = "./modules/iam"
}

module "scaling" {
  source                  = "./modules/scaling"
  ecs_cluster_name        = module.ecs.payaz_test_cluster_name
  ecs_simple_api_svc_name = module.ecs.simple_api_name

}

