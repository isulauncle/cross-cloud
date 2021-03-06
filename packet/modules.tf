# module "dns" {
#   source = "./modules/dns"
#   name = "${ var.name }"
#   master_ips = "${ module.etcd.master_ips }"
#   public_master_ips = "${ module.etcd.public_master_ips }"
#   # public_worker_ips = "${ module.worker.public_worker_ips }"
#   master_node_count = "${ var.master_node_count }"
#   worker_node_count = "${ var.worker_node_count }"
#   domain = "${ var.domain }"
# }

module "etcd" {
  source                    = "./modules/etcd"
  name                      = "${ var.name }"
  master_node_count         = "${ var.master_node_count }"
  packet_project_id         = "${ var.packet_project_id }"
  packet_facility           = "${ var.packet_facility }"
  packet_billing_cycle      = "${ var.packet_billing_cycle }"
  packet_operating_system   = "${ var.packet_operating_system }"
  packet_master_device_plan = "${ var.packet_master_device_plan }"
  kubelet_image_url         = "${ var.kubelet_image_url }"
  kubelet_image_tag         = "${ var.kubelet_image_tag }"
  dns_service_ip            = "${ var.dns_service_ip }"
  cluster_domain            = "${ var.cluster_domain }"
  internal_tld              = "${ var.name }.${ var.domain }"
  pod_cidr                  = "${ var.pod_cidr }"
  service_cidr              = "${ var.service_cidr }"
  ca                        = "${ module.tls.ca }"
  etcd                      = "${ module.tls.etcd }"
  etcd_key                  = "${ module.tls.etcd_key }"
  apiserver                 = "${ module.tls.apiserver }"
  apiserver_key             = "${ module.tls.apiserver_key }"
  data_dir                  = "${ var.data_dir }"
}

# module "worker" {
#   source                    = "./modules/worker"
#   name                      = "${ var.name }"
#   worker_node_count         = "${ var.worker_node_count }"
#   packet_project_id         = "${ var.packet_project_id }"
#   packet_facility           = "${ var.packet_facility }"
#   packet_billing_cycle      = "${ var.packet_billing_cycle }"
#   packet_operating_system   = "${ var.packet_operating_system }"
#   packet_worker_device_plan = "${ var.packet_worker_device_plan }"
#   kubelet_image_url         = "${ var.kubelet_image_url }"
#   kubelet_image_tag         = "${ var.kubelet_image_tag }"
#   dns_service_ip            = "${ var.dns_service_ip }"
#   cluster_domain            = "${ var.cluster_domain }"
#   internal_tld              = "${ var.name }.${ var.domain }"
#   pod_cidr                  = "${ var.pod_cidr }"
#   service_cidr              = "${ var.service_cidr }"
#   ca = "${ module.tls.ca }"
#   worker = "${ module.tls.worker }"
#   worker_key = "${ module.tls.worker_key }"
#   etcd_discovery            = "${ module.etcd.etcd_discovery }"
#   data_dir                  = "${ var.data_dir }"
# }

module "kubeconfig" {
  source = "../kubeconfig"
  data_dir = "${ var.data_dir }"
  endpoint = "endpoint.${ var.name }.${ var.domain }"
  name = "${ var.name }"
  ca = "${ module.tls.ca}"
  client = "${ module.tls.client }"
  client_key = "${ module.tls.client_key }"

}

module "tls" {
  source = "../tls"

  data_dir = "${ var.data_dir }"

  tls_ca_cert_subject_common_name = "CA"
  tls_ca_cert_subject_organization = "Kubernetes"
  tls_ca_cert_subject_locality = "San Francisco"
  tls_ca_cert_subject_province = "California"
  tls_ca_cert_subject_country = "US"
  tls_ca_cert_validity_period_hours = 1000
  tls_ca_cert_early_renewal_hours = 100

  tls_etcd_cert_subject_common_name = "k8s-etcd"
  tls_etcd_cert_validity_period_hours = 1000
  tls_etcd_cert_early_renewal_hours = 100
  tls_etcd_cert_dns_names = "kubernetes.local"
  tls_etcd_cert_ip_addresses = "127.0.0.1"

  tls_client_cert_subject_common_name = "k8s-admin"
  tls_client_cert_validity_period_hours = 1000
  tls_client_cert_early_renewal_hours = 100
  tls_client_cert_dns_names = "kubernetes,kubernetes.default,kubernetes.default.svc,kubernetes.default.svc.cluster.local"
  tls_client_cert_ip_addresses = "127.0.0.1"

  tls_apiserver_cert_subject_common_name = "k8s-apiserver"
  tls_apiserver_cert_validity_period_hours = 1000
  tls_apiserver_cert_early_renewal_hours = 100
  tls_apiserver_cert_dns_names = "kubernetes,kubernetes.default,kubernetes.default.svc,kubernetes.default.svc.cluster.local,endpoint.${ var.name }.${ var.domain }"
  tls_apiserver_cert_ip_addresses = "127.0.0.1,10.0.0.1"

  tls_worker_cert_subject_common_name = "k8s-worker"
  tls_worker_cert_validity_period_hours = 1000
  tls_worker_cert_early_renewal_hours = 100
  tls_worker_cert_dns_names = "kubernetes,kubernetes.default,kubernetes.default.svc,kubernetes.default.svc.cluster.local"
  tls_worker_cert_ip_addresses = "127.0.0.1"
}
