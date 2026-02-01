# EC2 Setup for CI/CD Deployment

This document describes how the EC2 instance was configured to receive
deployments from AWS CodeDeploy and run the application inside Docker.

---

## 1. EC2 Instance Details

- **Instance type**: t2.micro
- **Operating system**: Ubuntu (64-bit)
- **Purpose**:
  - Host the Dockerized Next.js application
  - Receive deployments from AWS CodeDeploy
  - Run containers pulled from Docker Hub

---

## 2. IAM Role Attachment

The EC2 instance is attached to a dedicated IAM role:

**Role name**
EC2PortfolioInstanceRole

**Purpose**
- Allows CodeDeploy agent to communicate with AWS CodeDeploy
- Allows EC2 to download artifacts from S3 if required

---

## 3. Security Group Configuration

Inbound rules:

| Type | Protocol | Port | Source |
|----|---------|-----|--------|
| SSH | TCP | 22 | My IP |
| HTTP | TCP | 3000 | 0.0.0.0/0 |

Outbound:
- Allow all traffic

---

## 4. Install Docker

Docker is required to run the application container.

```bash
sudo apt update
sudo apt install -y docker.io
```

### Enable Docker and allow non-root usage:
```
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker ubuntu
```
---
## 5. Install AWS CodeDeploy Agent
The CodeDeploy agent allows AWS CodeDeploy to manage deployments on EC2.
```
sudo apt update
sudo apt install -y ruby wget
```
Download and install the agent (region-specific):

```
wget https://aws-codedeploy-ap-south-1.s3.ap-south-1.amazonaws.com/latest/install
chmod +x install
sudo ./install auto
```

Start and verify the agent:

```
sudo systemctl start codedeploy-agent
sudo systemctl status codedeploy-agent
```

---

## 6. Verify CodeDeploy Agent
Check agent logs if needed:

`sudo tail -f /var/log/aws/codedeploy-agent/codedeploy-agent.log`

---

## 7. Docker Runtime Verification
Confirm Docker is working:
```
docker --version
docker ps
```

---

## 8. Application Runtime
During deployment:

- CodeDeploy runs lifecycle scripts from appspec.yml

- start.sh pulls the latest Docker image from Docker Hub

- The container is started and exposed on port 3000

Example command executed during deployment:

```
docker pull om6214/portfolio-image:latest
docker run -d \
  --name portfolio \
  -p 3000:3000 \
  --env-file /home/ubuntu/.env.local \
  om6214/portfolio-image:latest

```

---

## 9. Application Access
After successful deployment, the application is accessible at:

`http://<EC2-PUBLIC-IP>:3000`