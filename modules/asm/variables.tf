/**
 * Copyright 2022 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

variable "project_id" {
  description = "The project in which the resource belongs."
  type        = string
}

variable "cluster_name" {
  description = "The unique name to identify the cluster in ASM."
  type        = string
}

variable "cluster_location" {
  description = "The cluster location for this ASM installation."
  type        = string
}

variable "fleet_id" {
  description = "The fleet to use for this ASM installation."
  type        = string
  default     = ""
}

variable "channel" {
  description = "The channel to use for this ASM installation."
  type        = string
  validation {
    condition = anytrue([
      var.channel == "rapid",
      var.channel == "regular",
      var.channel == "stable",
      var.channel == "", // if unset, use GKE data source and use release cluster channel
    ])
    error_message = "Must be one of rapid, regular, or stable."
  }
  default = ""
}

variable "enable_cni" {
  description = "Determines whether to enable CNI for this ASM installation. Required to use Managed Data Plane (MDP)."
  type        = bool
  default     = false
}

variable "enable_vpc_sc" {
  description = "Determines whether to enable VPC-SC for this ASM installation. For more information read https://cloud.google.com/service-mesh/docs/managed/vpc-sc"
  type        = bool
  default     = false
}

variable "enable_cross_cluster_service_discovery" {
  description = "Determines whether to enable cross-cluster service discovery between this cluster and other clusters in the fleet."
  type        = bool
  default     = false
}
