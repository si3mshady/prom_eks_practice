pipeline {
    agent any

     parameters {
    string(name: 'CLUSTER_NAME', defaultValue: 'elliott-eks-fargate-deux')
    string(name: 'ACCOUNT_NUMBER', defaultValue: '8675309')
    string(name: 'USER_NAME', defaultValue: 'kratos')
    string(name: 'REGION', defaultValue: 'us-east-1')
  }

    stages {

         stage('Test') {
            steps {
                echo 'Testing..'
                // sh ("terraform init")
                // sh ("terraform plan")
            }
        }

        stage('Build & Deploy') {
            steps {
                sh("eksctl create cluster --name $CLUSTER_NAME --region $REGION  || true")
                sh ("eksctl create nodegroup --cluster=$CLUSTER_NAME --name=$CLUSTER_NAME-nodes || true")
                sh("eksctl create iamidentitymapping --cluster  $CLUSTER_NAME --region=$REGION --arn arn:aws:iam::$ACCOUNT_NUMBER:user/$USER_NAME --group system:masters --username $USER_NAME || true")
                sh("aws eks update-kubeconfig --name $CLUSTER_NAME --region=$REGION")
                sh ("sudo sed -i 's/v1alpha1/v1beta1/g' /var/lib/jenkins/.kube/config")
               
            }


        }

          stage('Install Prometheus and Grafana') {
            steps {
                echo 'Setting up Monitoring...'
                sh("kubectl create namespace prometheus || true")

                sh("helm repo add prometheus-community https://prometheus-community.github.io/helm-charts || true")
                sh("helm repo update")

                sh('helm upgrade -i prometheus-grfana prometheus-community/kube-prometheus-stack \
                    --namespace prometheus \
                    --set alertmanager.persistentVolume.storageClass="gp2",server.persistentVolume.storageClass="gp2"')
                
            
            }


        }
       
      
    }
}

// kubectl expose service prometheus-grfana-grafana --type=NodePort --target-port=3000 -n prometheus --name=grafana-ext
// service/grafana-ext exposed

// kubectl  get  secret prometheus-grfana-grafana   -n prometheus -o yaml
//  echo 'cHJvbS1vcGVyYXRvcg==' | base64 --decode