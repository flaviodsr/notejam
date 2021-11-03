# Notejam

- Implementation: Python (Flask)
- Changes:
  - Added support for MySQL
  - Load database configuration from environment variables
  - Added Dockerfile
  - Added helm chart for Notejam

**NOTE:** Besides the application and Dockerfile, the helm chart and terraform scripts are non-functional, however they are filled with the most important parts of its implementation.

## Deploying

### Infrastructure

Using terraform create the following infrastructure:

- Kubernetes cluster (AKS, EKS, GKE) with at least 3 nodes in different regions
- MySQL databases (1x production, 1x test)
  The production database must be configured with backup for at leas 3 years.

### Application

1. On the Kubernetes cluster deploy [ArgoCD](https://argo-cd.readthedocs.io/en/stable/)
2. Create a Git repository with three branches (dev, test, prod) and configure it so the prod branch can only receive pull requests from the test branch, while the test branch can only receive pull request from the dev branch.
3. Push the code in this repository to the dev branch.
4. On ArgoCD, create 3 Argo applications to make the deployment of Notejam accordingly to previously created branches. The application will make use of the notejam-helm chart to deploy Notejam using the `values.yaml` named accordingly under the `deploy` directory.
5. Configure ArgoCD to automatically redeploy the application on repository changes.
6. Create a PR from the dev branch to the test branch and merge it.
7. Create a PR from the test branch to the prod branch and merge it.

For each branch a CI must be configured to build the Notejam container image using the provided Dockerfile.

The end result should be 3 instances of the Notejam application running on the Kubernetes cluster, each on different namespaces and with different configurations:

- dev:
  - namespace: notejam-dev
  - database: sqlite
  - image-tag: dev
- test:
  - namespace: notejam-test
  - database: mysql (test)
  - image-tag: v0.1-test
- prod:
  - namespace: notejam-prod
  - database: mysql (prod)
  - image-tag: v0.1

The dev environment should always be wiped on each new deployment. The test environment should have enough data loaded to reproduce the production environment, besides that, new deployments should be done as an "upgrade" of the previous one (performing database schema migrations for example) to ensure upgradability.

## How this will meet the Business Requirements

- **The Application must serve variable amount of traffic. Most users are active during business hours. During big events and conferences the traffic could be 4 times more than typical.**

  By creating a Horizontal Pod Autoscaler (HPA) the application can be scaled up and down automatically based on the container performance or custom metrics (e.g. from Prometheus). Note that this is only possible because the application is running with a remote database.

- **The Customer takes guarantee to preserve your notes up to 3 years and recover it if needed.**

  By configuring the database to backup its data for at least 3 years, the application can be configured to automatically recover the data if needed.

- **The Customer ensures continuity in service in case of datacenter failures.**

  By using a Kubernetes cluster with at least 3 nodes in different regions, the application can self recover on nodes on different regions and be available in case of datacenter failures.

- **The Service must be capable of being migrated to any regions supported by the cloud provider in case of emergency.**

  By using a Kubernetes cluster with at least 3 nodes in different regions, the application can be deployed in any region supported by the cloud provider.

- **The Customer is planning to have more than 100 developers to work in this project who want to roll out multiple deployments a day without interruption / downtime.**

  By creating a Kubernetes deployment using `strategy: RollingUpdate` it ensures that new deployments will not incur in downtime. For a more sophisticated solution, it is also possible to use Knative Serving + Istio and deploy the application as a Knative service which supports applying blue-green/canary deployment patterns.

- **The Customer wants to provision separated environments to support their development process for development, testing, production in the near future.**

  By using GitOps, three different environments are deployed in different namespaces.

- **The Customer wants to see relevant metrics and logs from the infrastructure for quality assurance and security purposes.**

  This can be done by using the cloud provider API and monitoring tools. Or, to amend the vendor lock-in, it is possible to use [Prometheus](https://github.com/prometheus-operator/prometheus-operator) and [Grafana](https://github.com/grafana-operator/grafana-operator) to monitor the application.
