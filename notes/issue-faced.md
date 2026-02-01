# Issues Faced During CI/CD Implementation

This document highlights the major issues encountered while building and
debugging the CI/CD pipeline and explains how each issue was resolved.

The most critical issue involved artifact handling between CodeBuild,
CodePipeline, and CodeDeploy.

---

## Issue 1: Build Artifact vs Source Artifact Mismatch

### Problem Description

The deployment stage in AWS CodePipeline was repeatedly failing with the
following error:

```
Unable to access the artifact with Amazon S3 object key'portfolio-pipeline/BuildArtif/<id>'.
The provided role does not have sufficient permissions.
```


At first glance, the error appeared to be related to IAM permissions or S3
access control.

---

### Initial Assumptions

Based on the error message, the following possibilities were investigated:

- Missing S3 permissions on CodePipeline or CodeDeploy IAM roles
- Incorrect trust relationships between AWS services
- KMS encryption issues on the S3 artifact bucket
- Incorrect service role assignment in CodeDeploy

Multiple IAM roles were reviewed and recreated, and S3 permissions were
verified during troubleshooting.

---

### Root Cause Analysis

After inspecting the S3 artifact bucket, it was observed that:

- Only a `SourceArti/` folder existed in the artifact bucket
- No `BuildArtifact/` folder was present

This revealed the real issue:

- The CodeBuild stage was **not producing any build artifacts**
- The Deploy stage in CodePipeline was configured to consume a
  **BuildArtifact** that did not exist
- CodePipeline attempted to fetch a non-existent object from S3, which
  surfaced as a misleading permission error

---

### Why This Happened

In this project:

- Docker images were built and pushed to Docker Hub in CodeBuild
- The EC2 instance pulled the image directly from Docker Hub during deployment
- CodeDeploy only required `appspec.yml` and deployment scripts

Therefore, a build artifact was **not actually required**, but the pipeline
was incorrectly configured to expect one.

---

### Resolution

The issue was resolved by:

- Reconfiguring the Deploy stage in CodePipeline to use `SourceArtifact`
  instead of `BuildArtifact`
- Ensuring that CodeDeploy consumed the source artifact containing:
  - `appspec.yml`
  - Deployment scripts (`start.sh`, `stop.sh`)

After aligning the artifact configuration, deployments completed
successfully.

---

### Key Learnings

- CodePipeline error messages can be misleading when artifacts are missing
- A missing artifact may surface as an IAM or S3 permission error
- Not all CI/CD pipelines require build artifacts, especially when using
  Docker-based deployments
- Always verify actual objects present in the S3 artifact bucket during
  debugging

---

## Issue 2: IAM Role Confusion During Debugging

### Problem Description

While debugging the artifact issue, multiple IAM roles were reviewed,
including:

- CodePipeline service role
- CodeDeploy service role
- EC2 instance role

This created temporary confusion about which role was responsible for
artifact access.

---

### Resolution

The issue was resolved by clearly identifying role responsibilities:

- CodePipeline service role handles artifact orchestration
- CodeDeploy service role handles deployment coordination
- EC2 instance role handles runtime execution

Clear role separation simplified further debugging.

---

## Summary

The most challenging issue in this project was not related to IAM or
permissions but to artifact configuration within CodePipeline.

Identifying and resolving the `BuildArtifact` vs `SourceArtifact` mismatch
required careful inspection of S3 artifacts and pipeline configuration,
resulting in a deeper understanding of AWS CI/CD internals.
