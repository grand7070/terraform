# Three-tier Architecture
테라폼으로 Three-tier Architecture 구성

## Tree Structure

- root : 루트 모듈, 환경별(stage/prod) 프로비저닝 구성
- modules : 자식 모듈, main.tf, variables.tf, outputs.tf로 구성
    - terraform-aws-ec2 : launch template, ASG
    - terraform-aws-lb : lb, lb listener, target group
    - terraform-aws-rds : rds, parameter group, subnet group
    - terraform-aws-security-group : security group
    - terraform-aws-vpc : vpc, subnet, IGW, NAT GW, EIP, route table
- scripts : 모듈에서 사용하는 스크립트

## To Run
**AWS Credentials**

윈도우 기준 `C:\Users\{유저 이름}\.aws` 의 credentials 파일에 다음을 추가
```
[terraform]
aws_access_key_id=Your Access Key ID
aws_secret_access_key=Your Secret Access Key
```

**CLI Command**

```
# root/stage
terraform init
terraform fmt # optional
terraform validate # optional
terraform plan --var-file=stage.tfvars
terraform apply --var-file=stage.tfvars --auto-approve
```
## Result
WEB 계층의 Web Server(NGINX)와 APP 계층의 Web Application Server(Tomcat)에 각각 트래픽 분산 및 DB 연결을 확인할 수 있다.

## TODO
- rds_instance 리소스에 하드코딩된 username과 password 처리 (Vault or AWS Secret Manager)
- backend 구성 (S3)
- AWS Credentials 방식 변경
- GitHub Actions로 자동화

## Reference
https://github.com/ziwooda/AUSG-BigChat-Archive
https://potato-yong.tistory.com/category/AWS/3%20Tier%20Architecture
https://registry.terraform.io/providers/hashicorp/aws/latest/docs