resource "shoreline_notebook" "high_apache_workers_load" {
  name       = "high_apache_workers_load"
  data       = file("${path.module}/data/high_apache_workers_load.json")
  depends_on = [shoreline_action.invoke_apache_check,shoreline_action.invoke_apache_config_workers]
}

resource "shoreline_file" "apache_check" {
  name             = "apache_check"
  input_file       = "${path.module}/data/apache_check.sh"
  md5              = filemd5("${path.module}/data/apache_check.sh")
  description      = "A misconfiguration in the Apache server settings that may cause an imbalance in the load distribution among different workers, leading to an overload on some workers."
  destination_path = "/agent/scripts/apache_check.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "apache_config_workers" {
  name             = "apache_config_workers"
  input_file       = "${path.module}/data/apache_config_workers.sh"
  md5              = filemd5("${path.module}/data/apache_config_workers.sh")
  description      = "Define variables"
  destination_path = "/agent/scripts/apache_config_workers.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_apache_check" {
  name        = "invoke_apache_check"
  description = "A misconfiguration in the Apache server settings that may cause an imbalance in the load distribution among different workers, leading to an overload on some workers."
  command     = "`chmod +x /agent/scripts/apache_check.sh && /agent/scripts/apache_check.sh`"
  params      = ["PATH_TO_APACHE_CONFIG_FILE"]
  file_deps   = ["apache_check"]
  enabled     = true
  depends_on  = [shoreline_file.apache_check]
}

resource "shoreline_action" "invoke_apache_config_workers" {
  name        = "invoke_apache_config_workers"
  description = "Define variables"
  command     = "`chmod +x /agent/scripts/apache_config_workers.sh && /agent/scripts/apache_config_workers.sh`"
  params      = ["PATH_TO_APACHE_CONFIG_FILE","DESIRED_NUMBER_OF_WORKERS"]
  file_deps   = ["apache_config_workers"]
  enabled     = true
  depends_on  = [shoreline_file.apache_config_workers]
}

