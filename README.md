# GitLab CI/CD Pipeline with Docker

A practical CI/CD lab demonstrating how to automate application builds, Docker image creation, private registry publishing, and deployment using GitLab CI/CD.

## Pipeline Architecture

```text
Developer
   |
   v
 GitLab
   |
   v
GitLab Runner (Docker Executor)
   |
   +----> Build Docker Image
   |
   +----> Push Image ---> Private Docker Registry
   |
   +----> Deploy Application
```

## Technologies

- GitLab CI/CD
- GitLab Runner
- Docker
- Docker Registry v2
- Nginx reverse proxy / SSL registry setup
- .NET 8
- Linux / Oracle Linux
- Bash

## What I Implemented

- Configured a GitLab Runner using the Docker executor.
- Built a containerized .NET application through a CI/CD pipeline.
- Automated Docker image creation from a Dockerfile.
- Published container images to a private Docker registry.
- Added a deployment stage for running the generated image.
- Used GitLab CI/CD variables for credentials and environment-specific configuration.
- Practiced troubleshooting runner, Docker, registry, authentication, and TLS issues.

## Repository Structure

```text
gitlab-ci-cd-pipeline/
├── README.md
├── .gitignore
├── .dockerignore
├── .gitlab-ci.yml
├── Dockerfile
├── src/
│   ├── DockerPipelineLab.csproj
│   └── Program.cs
├── scripts/
│   ├── build.sh
│   ├── push.sh
│   └── deploy.sh
└── docs/
    └── pipeline-flow.md
```

## CI/CD Stages

### 1. Build

The pipeline builds the Docker image and saves it as an artifact so that the next job can use the exact same image.

### 2. Push

The image is loaded from the artifact, authenticated against the private registry, tagged, and pushed.

### 3. Deploy

The deployment job can pull the image on a target Docker host and replace the running container. Deployment is configured through GitLab CI/CD variables rather than hardcoded credentials.

## GitLab CI/CD Variables

Configure the following variables in **GitLab → Settings → CI/CD → Variables**:

| Variable | Purpose |
|---|---|
| `REGISTRY_URL` | Private Docker registry hostname |
| `REGISTRY_USER` | Registry username |
| `REGISTRY_PASSWORD` | Registry password |
| `IMAGE_NAME` | Image repository/name |
| `DEPLOY_HOST` | Deployment server |
| `DEPLOY_USER` | SSH user for deployment |
| `SSH_PRIVATE_KEY` | Deployment SSH private key |

Credentials and private keys must never be committed to the repository.

## Runner

The lab used a GitLab Runner named `oracle-docker-runner` with the Docker executor.

The runner executes CI jobs in isolated Docker environments and requires access to Docker for image build/push operations.

## Private Registry and TLS

This project is designed to work with the private registry created in the companion lab:

**Private Docker Registry with Nginx & SSL/TLS**

If the registry uses an internal or self-signed CA, the GitLab Runner host must trust that CA before Docker can push images successfully.

Typical trust location on Linux:

```text
/etc/docker/certs.d/<registry-hostname>/ca.crt
```

## Running the Application Locally

Build the image:

```bash
docker build -t docker-pipeline-lab:local .
```

Run it:

```bash
docker run -d --name docker-pipeline-lab -p 8080:8080 docker-pipeline-lab:local
```

Test:

```bash
curl http://localhost:8080/
curl http://localhost:8080/health
```

## Local Script Usage

Build:

```bash
./scripts/build.sh
```

Push:

```bash
REGISTRY_URL=registry.lab.local \
REGISTRY_USER=<username> \
REGISTRY_PASSWORD=<password> \
IMAGE_NAME=docker-pipeline-lab \
./scripts/push.sh
```

Deploy:

```bash
DEPLOY_HOST=<server> \
DEPLOY_USER=<user> \
IMAGE=registry.lab.local/docker-pipeline-lab:latest \
./scripts/deploy.sh
```

## Security Considerations

- Store secrets in GitLab CI/CD variables.
- Mark sensitive variables as **masked** and **protected** when appropriate.
- Do not commit SSH private keys, registry passwords, or TLS private keys.
- Use trusted CA certificates instead of disabling TLS verification.
- Restrict access to the Docker daemon and deployment host.
- Pin CI images to explicit versions for reproducible builds.

## Troubleshooting Practiced

### GitLab Runner

Check runner status and confirm that the runner is online and assigned to the project.

### Docker Build

Verify that the runner can access Docker and that the Dockerfile builds successfully.

### Registry Authentication

Check registry credentials and confirm that the runner can authenticate before pushing.

### TLS / x509 Errors

If Docker reports an unknown certificate authority, install the registry CA certificate on the runner host and restart Docker if required.

### Deployment

Verify SSH connectivity, Docker availability on the target host, registry access, and image permissions.

## Learning Outcomes

This lab strengthened my understanding of:

- CI/CD pipeline design
- GitLab Runner and Docker executor
- Automated Docker image builds
- Private registry integration
- Deployment automation
- CI/CD secrets management
- TLS and certificate troubleshooting
- Linux-based DevOps workflows

## Future Improvements

- Add automated unit and integration tests.
- Add Docker image vulnerability scanning.
- Add rollback support.
- Add deployment health checks.
- Add separate staging and production environments.
- Add notifications for pipeline failures.
