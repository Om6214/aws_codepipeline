# Key Learnings from CI/CD Project

This document summarizes the major technical and conceptual learnings gained
while designing, implementing, debugging, and cleaning up the CI/CD pipeline
for the portfolio application.

---

## 1. Understanding End-to-End CI/CD Flow

This project provided hands-on experience with a complete CI/CD lifecycle:

- GitHub as the source control system
- AWS CodePipeline as the orchestration layer
- CodeBuild for Docker image build and push
- CodeDeploy for application deployment
- EC2 as the runtime environment

Seeing how each service interacts in sequence helped build a clear mental
model of cloud-based CI/CD systems.

---

## 2. Artifact Management in AWS CodePipeline

One of the most important learnings was understanding how artifacts work in
CodePipeline.

Key insights:
- Every pipeline stage consumes artifacts produced by a previous stage
- Artifacts are stored in an S3 bucket managed by CodePipeline
- A missing artifact may appear as an IAM or permission error
- Not all pipelines require build artifacts when using Docker-based deployment

This clarified the difference between:
- `SourceArtifact` (source code and deployment files)
- `BuildArtifact` (compiled or packaged output)

---

## 3. IAM Role Separation and Trust Relationships

The project reinforced the importance of IAM role design:

- Each AWS service must use its own dedicated IAM role
- Trust relationships determine which service can assume a role
- Reusing roles across services leads to failures and security risks
- Over-permissioning can hide real configuration issues during debugging

Clear role separation simplified troubleshooting and improved security
understanding.

---

## 4. Docker-Based Deployment Strategy

Using Docker Hub as an external image registry highlighted:

- Benefits of immutable infrastructure
- Decoupling build and runtime environments
- Faster deployments by pulling pre-built images
- Simplified rollback by switching image tags

This approach reduced dependency on build artifacts and made deployments
more predictable.

---

## 5. Debugging Misleading Cloud Errors

A major learning was that cloud error messages are not always direct.

Examples:
- Missing artifacts surfaced as permission errors
- Incorrect pipeline configuration appeared as IAM failures

Effective debugging required:
- Inspecting S3 artifacts directly
- Understanding internal service behavior
- Validating assumptions instead of repeatedly changing permissions

---

## 6. Importance of Pipeline Design Decisions

The project emphasized that CI/CD design choices matter:

- Deciding where to build artifacts
- Choosing between SourceArtifact and BuildArtifact
- Selecting in-place deployment over blue/green for simplicity

Design clarity prevented unnecessary complexity.

---

## 7. Infrastructure Clean-Up and Cost Awareness

An important non-technical learning was cost responsibility:

- CI/CD services can incur charges even when idle
- EC2 instances and EBS volumes must be terminated explicitly
- S3 artifact buckets should be cleaned up after use

Cleaning up resources is as important as creating them.

---

## 8. Documentation as Part of Engineering

Maintaining structured documentation improved:

- Debugging efficiency
- Knowledge retention
- Ability to explain decisions during interviews

Documenting architecture, IAM roles, and issues faced made the project more
professional and reusable.

