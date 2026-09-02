# CI/CD Pipeline Flow

## Overview

```text
                    +----------------+
                    |    Developer   |
                    +-------+--------+
                            |
                            v
                    +----------------+
                    |     GitLab     |
                    +-------+--------+
                            |
                            v
                 +----------------------+
                 |   GitLab Runner      |
                 |    Docker Executor   |
                 +----------+-----------+
                            |
             +--------------+--------------+
             |              |              |
             v              v              v
        +---------+    +---------+    +---------+
        |  Build  | -> |  Push   | -> | Deploy  |
        +---------+    +----+----+    +----+----+
                            |               |
                            v               v
                    +---------------+   +-----------+
                    | Private Docker|   | Docker    |
                    |   Registry    |   | Host      |
                    +---------------+   +-----------+
```

## Job Responsibilities

### Build

- Starts a Docker-in-Docker service.
- Builds the application image.
- Saves the image as a pipeline artifact.

### Push

- Downloads the image artifact.
- Loads the image into Docker.
- Authenticates to the private registry.
- Pushes both the commit-tagged image and `latest`.

### Deploy

- Runs manually by default.
- Connects to the deployment host over SSH.
- Pulls the requested image.
- Removes the previous container.
- Starts the new container.

## Why Use a Commit Tag?

The pipeline uses `$CI_COMMIT_SHORT_SHA` as the image tag. This makes each image traceable to the Git commit that produced it and avoids relying only on the mutable `latest` tag.

## Required Runner Configuration

The pipeline uses Docker-in-Docker (`dind`), so the GitLab Runner must be configured to allow the Docker service to run with the required privileges. Docker-in-Docker should be used carefully because privileged CI jobs increase the runner's security exposure.

For production environments, consider hardened builders and least-privilege runner configurations.
