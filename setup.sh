gcloud beta container --project "sekhrivijaytest4" clusters create "us-central" --region "us-central1" --no-enable-basic-auth --cluster-version "1.17.17-gke.1101" --release-channel "stable" --machine-type "e2-medium" --image-type "COS" --disk-type "pd-standard" --disk-size "100" --metadata disable-legacy-endpoints=true --scopes "https://www.googleapis.com/auth/cloud-platform" --num-nodes "1" --enable-stackdriver-kubernetes --enable-ip-alias --network "projects/sekhrivijaytest4/global/networks/default" --subnetwork "projects/sekhrivijaytest4/regions/us-central1/subnetworks/default" --default-max-pods-per-node "110" --no-enable-master-authorized-networks --addons HorizontalPodAutoscaling,HttpLoadBalancing --enable-autoupgrade --enable-autorepair --max-surge-upgrade 1 --max-unavailable-upgrade 0 --workload-pool "sekhrivijaytest4.svc.id.goog"


gcloud beta container --project "sekhrivijaytest4" clusters create "us-west" --region "us-west1" --no-enable-basic-auth --cluster-version "1.17.17-gke.1101" --release-channel "stable" --machine-type "e2-medium" --image-type "COS" --disk-type "pd-standard" --disk-size "100" --metadata disable-legacy-endpoints=true --scopes "https://www.googleapis.com/auth/cloud-platform" --num-nodes "1" --enable-stackdriver-kubernetes --enable-ip-alias --network "projects/sekhrivijaytest4/global/networks/default" --subnetwork "projects/sekhrivijaytest4/regions/us-west1/subnetworks/default" --default-max-pods-per-node "110" --no-enable-master-authorized-networks --addons HorizontalPodAutoscaling,HttpLoadBalancing --enable-autoupgrade --enable-autorepair --max-surge-upgrade 1 --max-unavailable-upgrade 0 --workload-pool "sekhrivijaytest4.svc.id.goog"




gcloud services enable gkehub.googleapis.com --project sekhrivijaytest4
gcloud services enable dns.googleapis.com --project sekhrivijaytest4
gcloud services enable trafficdirector.googleapis.com --project sekhrivijaytest4
gcloud services enable cloudresourcemanager.googleapis.com --project sekhrivijaytest4
gcloud services enable multiclusterservicediscovery.googleapis.com --project sekhrivijaytest4
gcloud services enable anthos.googleapis.com --project sekhrivijaytest4
gcloud services enable multiclusteringress.googleapis.com --project sekhrivijaytest4
gcloud services enable container.googleapis.com --project=sekhrivijaytest4
gcloud services enable gkeconnect.googleapis.com --project=sekhrivijaytest4
gcloud services enable iamcredentials.googleapis.com --project=sekhrivijaytest4

gcloud projects add-iam-policy-binding sekhrivijaytest4 \
 --member user:devops@vijaytest1.joonix.net \
 --role=roles/gkehub.admin \
 --role=roles/iam.serviceAccountAdmin \
 --role=roles/iam.serviceAccountKeyAdmin \
 --role=roles/resourcemanager.projectIamAdmin



#https://container.googleapis.com/v1/projects/sekhrivijaytest4/locations/us-central1/clusters/us-central
#https://container.googleapis.com/v1/projects/sekhrivijaytest4/locations/us-west1/clusters/us-west


#Setup multi cluster services 
gcloud alpha container hub multi-cluster-services enable --project sekhrivijaytest4

#Register Clusters
gcloud container hub memberships register us-central \
   --gke-cluster us-central1/us-central \
   --enable-workload-identity \
   --project sekhrivijaytest4

gcloud container hub memberships register us-west \
   --gke-cluster us-west1/us-west \
   --enable-workload-identity \
   --project sekhrivijaytest4

#Make central as config cluster 
gcloud alpha container hub ingress enable \
  --config-membership=projects/sekhrivijaytest4/locations/global/memberships/us-central

gcloud alpha container hub ingress describe


#Grant the required Identity and Access Management (IAM) permissions for MCS Importer
gcloud projects add-iam-policy-binding sekhrivijaytest4 \
    --member "serviceAccount:sekhrivijaytest4.svc.id.goog[gke-mcs/gke-mcs-importer]" \
    --role "roles/compute.networkViewer"




#Check MCS
gcloud alpha container hub multi-cluster-services describe



#To change context 
gcloud container clusters get-credentials us-central --region us-central1 --project sekhrivijaytest4
gcloud container clusters get-credentials us-west --region us-west1 --project sekhrivijaytest4



#Do this on both clusters 
kubectl create ns zp
kubectl -n zp apply -f zone.yaml
kubectl -n zp apply -f frontend.yaml

#To export services on both clusters 
kubectl -n zp apply -f export-zp.yaml

#Check MCI
gcloud alpha container hub ingress describe

#Only on Central To setup MCS and MCI 
kubectl -n zp apply -f mcs.yaml
kubectl -n zp apply -f mci.yaml

