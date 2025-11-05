# Go app infra challenge

## 1. Infrastructure

### Architecture

![](Architecture.jpg)

In order to implement the multi-region failover architecture, I have chosen to use an Active-Passive approach using a **DNS Failover Routing Policy** to balance traffic between a primary GKE in one region and a secondary GKE in another region.

Due to the lack of context of what is the amount of traffic and from where in the globe it will come, I have decided to follow this approach because for an MVP is a cheaper approach rather than using an Active-Active approach (e.g. by using Multi-cluster Gateways with Global External HTTPS Load Balancers).

With the selected approach (DNS Failover Routing Policy) it is expected a period of some minutes of downtime, where the DNS failover records need to be propagated to the clients and where the client's DNS cache needs to expire. This issue has been partially mitigated by setting a low TTL to the DNS records.

Using a Fleet of clusters with Multi-cluster Gateways could be interesting to implement in the future if we need to provide service to customers across the globe, what could justify the costs of having multiple clusters running multiple instances of our workloads and using Global Load Balancers (more expensive). It could also solve the downtime issue mentioned related to the DNS resolution cache and propagation.

### Networking

In order to have more control on ohw many IP are available to GKE nodes, Pods and services, I manually have configured the different subnet secondary ranges accordingly.

The subnet masks have been chosen to allocate up to 256 nodes (/24) and the maximum Pods capacity allowed by Pod (256 Pods per node, so /16). For GKE Services a /20 mask have been chosen because we'll need more services than nodes, but less than number of Pods.

### Monitoring

Right now the monitoring stack (Prometheus and Grafana) is deployed in the same cluster as the workloads since this is an MVP. In the future we should move the monitoring stack out of the subject under test (i.e. the cluster) to ensure that the monitoring stack keeps working even if the whole cluster is down.

Cluster and app logs should be available in Google Cloud Logging service. In future iterations, we could evaluate if Google Cloud Logging service meets our needs or we should implement a 3rd party logging solution.

### Security

Applying the Least Privilege principle, we have created a new service account to be used by the GKE nodes in order to push metrics and logs into GCP monitoring services and to pull Docker images from the GCP Artifacts registry.

A Firewall rule has been created to allow GCP services to run health checks against GKE nodes.

In order to securely access the GKE cluster I have prevented public access to GKE API endpoint by enabling private endpoints only. This will force that our CI/CD solution must have a Runner instance deployed in the same VPC in order to apply changes into the cluster.

Additionally, GKE nodes will only have private IP addresses, what ensures that cluster applications should only be reachable from the same VPC or publicly exposed via a Load Balancer.

In future iterations we could implement these improvements

- Disable non-default RBAC bindings in a cluster that reference the system:unauthenticated and system:authenticated groups or the system:anonymous user, to prevent usage of default insecure groups.
- set automountServiceAccountToken=false in the Pod specification if your Pods don't need to communicate with the API server.

### Additional notes

- In order to run the Terraform code it is required to have a bucket created with the name `terraform-states`.
- I have divided the Terraform code in 2 different stacks (`base` and `app`) In order to keep domains separated and prevent coupling different scopes:
  - `base` is the underground infrastructure required to host our Go application. This infrastructure would probably be managed by the Operations team or expert and contains resources that could be shared with other application stacks in the future.
  - `app` is the stack responsible to deploy only the resources related to the Go application. This stack could be managed by the development team without having to worry about the configuration of the underlying infrastructure.
- I kept Helm deployments in different resources blocks (instead of using `for_each` for sake of simplicity), because that way we have more flexibility to customize each deployment configuration separately.
- I have added the `Gateway` resource as part of the app chart in order to simplify and provide flexibility to the configuration of the `hostname`.

### Incomplete tasks

Due to the lack of time to further implement this solution, there have been some implementation details or improvements I couldn't implement:

- Expose the application through HTTPS using a self-signed certificate: in order to expose the application securely to the Internet we could deploy `cert-manager` in the GKE clusters in order to leverage the domain configuration from the `Gateway` resources to issue a certificate from Let's Encrypt.
- In order to allow administrator/operations tasks in the GKE cluster, a jumpbox/bastion machine accesible only from a VPN should be created in a separate subnet in the same VPC in order to run Kubernetes commands against the GKE private endpoints.
- **Custom metrics for HPA:** In the current MVP implementation, only CPU metric have been used to scale Pods. In a future iteration, we could configure Prometheus Exporters to properly retrieve custom metrics (e.g. the amount of busy go routines) and configure the Horizontal Pod Autoscaler to scale base on that metric.
- More Firewall rules could be configured in order to enforce that only the expected traffic is allowed to access the different components within the VPC.
- ArgoCD and ArgoRollouts could be configured and deployed on each cluster in order to manage it's own resources deployments using a GitOps approach and to allow canary deployments. This way we make sure the GKE private endpoints are reachable (we would need to make sure there are proper Firewall rules that allow ArgoCD to pull contents from the Git repositories).
  - Additional node pools could be configured into the GKE clusters in order to allow allocating more resources for Runners to run.

## 2. Application


## 3. Security
