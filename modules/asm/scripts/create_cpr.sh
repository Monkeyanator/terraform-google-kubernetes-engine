#!/usr/bin/env bash

# Copyright 2022 Google LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

set -e

if [ "$#" -lt 3 ]; then
    >&2 echo "Not all expected arguments set."
    exit 1
fi

# Wait for the CRD to get created before creating the CPR.
readonly CPR_RESOURCE=controlplanerevisions.mesh.cloud.google.com
for _i in {1..6}; do
  echo "Ensuring ControlPlaneRevision exists in cluster... attempt ${_i}"
  if kubectl get crd "${CPR_RESOURCE}"
  then
    break
  else
    sleep 10
  fi
done

kubectl wait --for condition=established --timeout=60s crd/"${CPR_RESOURCE}"

if ! kubectl create namespace istio-system; then
  echo "Failed to create system namespace; continuing since this can indicate existence"
fi

REVISION_NAME=$1; shift
CHANNEL=$1; shift
ENABLE_CNI=$1; shift

cat <<EOF | kubectl apply -f -
apiVersion: mesh.cloud.google.com/v1beta1
kind: ControlPlaneRevision
metadata:
  name: "${REVISION_NAME}"
  namespace: istio-system
  labels:
    mesh.cloud.google.com/managed-cni-enabled: "${ENABLE_CNI}"
spec:
  type: managed_service
  channel: "${CHANNEL}"
EOF

kubectl wait -n istio-system --for=condition=Reconciled controlplanerevision/"${REVISION_NAME}" --timeout 5m