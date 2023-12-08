# Observability solution for a Kubernetes cluster

## Requirements
An observability solution for a Kubernetes cluster consisting of multiple Linux nodes running mixed workloads. The solution should provide:
- metric collection from Kubernetes infrastructure and hosted applications
- a way to visualize metrics on dashboards
- long-term down-sampled data retention
- alerts based on collected metrics

## Design
![System Design](system-design.svg)

The proposed solution consists of the following components:
- [Prometheus](#prometheus), for metric collection
- [Thanos](#thanos), for long-term storage of metric data
- [Grafana](#grafana), for metric visualization
- [AlertManager](#alertmanager), for metric-based alert handling

### Prometheus
Prometheus is 

- dynamic service discovery via the Kubernetes API to discover targets from which to pull metrics.
- it makes use of the following sub-components: 
    - `kube-state-metrics` uses the Kubernetes API to generate metrics related to the state of objects, such as services, deployments, pods etc.  
    - `node-exporter` is installed on every Kubernetes node to make available machine-level metrics such as CPU, memory, network usage etc.
    - additional metrics can be specified via `scrape_config`, allowing Prometheus to ingest application-level metrics such as HTTP request data 
- pulls metrics by periodically calling the `/metrics` endpoint on every discovered service
- stores metrics in a local time-series database or can be configured to write data to a remote storage system 

### Thanos
Rather than relying solely on local storage, which is indented to store data for a limited time and provides limited data compaction, Prometheus can be configured to remote write to Thanos, which:  
- can use object storage such az Azure Blob Storage as the primary storage for metrics and metadata
- provides rich data compaction options, allowing for longer data retention periods and faster querying over longer time spans
- can receive data from multiple Prometheus instances in multiple Kubernetes clusters, allowing for global querying
- uses the Prometheus Query API and therefore can be used by Grafana as a data source in much the same way as Prometheus

### Grafana
Grafana can use both Prometheus and Thanos as data sources for data visualization

### AlertManager
Prometheus provides alerting rules which can be evaluate the condition of a particular expression. When an alert state is detected the alert may be sent as a notification to another system. Due to the distributed nature of Prometheus, these alerts can be quite frequent and duplicated, the alert state being reported by multiple Prometheus instances.

Sending Prometheus alerts to AlertManager ensures that alerts are deduplicated, grouped and routed to the correct receiver integration.

AlertManager can be configured to forward alerts to external systems such as Slack and PagerDuty.

## GitOps
All of the specified components of the solution may be deployed via Helm charts using a GitOps CD tool such as ArgoCD.