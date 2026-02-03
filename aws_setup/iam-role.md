# IAM Roles Used in CI/CD Project

This document lists all IAM roles created and used in the GitHub → AWS CI/CD pipeline
(CodePipeline, CodeBuild, CodeDeploy, EC2).

---

## 1. CodePipeline Service Role

**Role name**
AWSCodePipelineServiceRole-ap-south-1-portfolio-pipeline

**Used by**
AWS CodePipeline

**Purpose**
- Orchestrates the CI/CD workflow
- Fetches source code from GitHub
- Stores and retrieves artifacts from S3
- Triggers CodeBuild and CodeDeploy stages

**Key permissions**
- AmazonS3FullAccess
- AWSCodePipelineFullAccess
- AWSCodeDeployFullAccess
- AmazonSSMReadOnlyAccess  // this allows the codebuild to access the envs from the security manager

**Trust relationship**
```json
{
  "Effect": "Allow",
  "Principal": {
    "Service": "codepipeline.amazonaws.com"
  },
  "Action": "sts:AssumeRole"
}
```

## 2. CodeBuild Service Role

**Role name**
codebuild-portfolio-service-role

**Used by**
AWS CodeBuild

**Purpose**
- Runs build jobs
- Builds Docker image
- Pushes Docker image to Docker Hub

**Key permissions**
- AWSCodeBuildDeveloperAccess
- AmazonS3ReadOnlyAccess
- CloudWatchLogsFullAccess

**Trust relationship**
```json
{
  "Effect": "Allow",
  "Principal": {
    "Service": "codebuild.amazonaws.com"
  },
  "Action": "sts:AssumeRole"
}

```

## 3. CodeDeploy Service Role

**Role name**
CodeDeployServiceRole-Portfolio

**Used by**
AWS CodeDeploy

**Purpose**
- Downloads pipeline artifact from S3
- Executes lifecycle hooks (BeforeInstall, ApplicationStart)
- Coordinates deployment to EC2 instances

**Key permissions**
- AWSCodeDeployRole
- AmazonS3ReadOnlyAccess

**Trust relationship**
```json
{
  "Effect": "Allow",
  "Principal": {
    "Service": "codedeploy.amazonaws.com"
  },
  "Action": "sts:AssumeRole"
}

```

## 4. EC2 Instance Role

**Role name**
EC2PortfolioInstanceRole-Portfolio

**Used by**
EC2 Instance (Ubuntu)

**Purpose**
- Allows EC2 to communicate with AWS services
- Enables CodeDeploy agent to receive deployments
- Allows log access if required

**Key permissions**
- AmazonS3ReadOnlyAccess
- AWSCodeDeployFullAccess
- CloudWatchAgentServerPolicy

**Trust relationship**
```json
{
  "Effect": "Allow",
  "Principal": {
    "Service": "ec2.amazonaws.com"
  },
  "Action": "sts:AssumeRole"
}
```

| AWS Service  | IAM Role Used                    |
| ------------ | -------------------------------- |
| CodePipeline | AWSCodePipelineServiceRole-*     |
| CodeBuild    | codebuild-portfolio-service-role |
| CodeDeploy   | CodeDeployServiceRole-Portfolio  |
| EC2          | EC2PortfolioInstanceRole         |
