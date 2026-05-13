terraform {
  required_version = ">= 1.6.0"
}

resource "local_file" "lab_summary" {
  filename = "${path.module}/cloud_lab_summary.txt"
  content  = "Cloud Lab includes Python, Docker, Jenkins CI/CD, Prometheus, Grafana, Kubernetes, Helm, and Terraform."
}
