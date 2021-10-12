#!groovy

node('aws&&docker')
{
	withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', accessKeyVariable: 'AWS_ACCESS_KEY',
					   credentialsId: 'aws_cred', secretKeyVariable: 'AWS_SECRET_KEY']])
    {
        deleteDir()

        def terminate = params.TERMINATE_INSTANCE

//         try
//         {
            stage('Git checkout')
            {
                git branch: 'master', credentialsId: 'git_cred',
                    url: 'https://github.com/2020mt93231/micro_services_ass.git'
            }
            dir("key")
            {
                withCredentials([file(credentialsId: 'scalable_service_key', variable: 'FILE')])
                {
                    sh "cp ${FILE} dslabs_automation.pem"
                }
            }

            stage('Infra')
            {
                sh "terraform init iac_src"
                sh "terraform validate -var=\'access_key=${AWS_ACCESS_KEY}\' -var=\'secret_key=${AWS_SECRET_KEY}\'  iac_src"
                sh "terraform plan -var=\'access_key=${AWS_ACCESS_KEY}\' -var=\'secret_key=${AWS_SECRET_KEY}\' -input=false -out=plan.out iac_src"
                sh "terraform apply -input=false -auto-approve plan.out"
            }
//         }
//         catch (e)
//         {
//             currentBuild.result = 'FAILURE'
//             println(e)
//         }
//         finally
//         {
//             if ("${terminate}" == 'true')
//             {
//                 stage('Terminate Infra')
//                 {
//                     echo "Terminating the instance"
//                     sh "terraform destroy -auto-approve iac_src"
//                 }
//             }
//             else
//             {
//                 stage('Keep Infra')
//                 {
//                     echo "Keeping the instance in AWS, please check the archive file"
//                     sh "terraform output -json > ${manifest_file}"
//                     archiveArtifacts allowEmptyArchive: true, artifacts: "${manifest_file}"
//                 }
//             }
//         }
    }
}