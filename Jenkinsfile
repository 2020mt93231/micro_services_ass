#!groovy

node
{
	withCredentials([[$class: 'AmazonWebServicesCredentialsBinding', accessKeyVariable: 'AWS_ACCESS_KEY',
					   credentialsId: 'aws_cred', secretKeyVariable: 'AWS_SECRET_KEY'],
					   usernamePassword(credentialsId: 'db_cred', usernameVariable: 'DB_USR',
					   passwordVariable: 'DB_PWD')]
    {
        deleteDir()
        def terminate = params.TERMINATE_INSTANCE
        def key_name = "ec2_key"

        stage('Git checkout')
        {
            git branch: 'db', credentialsId: 'git_cred',  url: 'git@github.com:2020mt93231/micro_services_ass.git'
        }

        try
        {
            def cwd_path = "${env.WORKSPACE}\\src"
            cwd = cwd_path.replace("\\", "\\\\\\\\")

            withCredentials([file(credentialsId: 'ec2_key', variable: 'FILE')])
            {
                powershell "cp ${FILE} ${key_name}.pem"
                priv_key_path = "${env.WORKSPACE}\\${key_name}.pem"
                priv_key = priv_key_path.replace("\\", "\\\\\\\\")
            }

            stage('Infra creation')
            {
                dir("iac_src")
                {
                    powershell "terraform init"
                    powershell "terraform validate"
                    powershell "terraform plan -var 'access_key=${AWS_ACCESS_KEY}' -var 'secret_key=${AWS_SECRET_KEY}' -var 'priv_key=${priv_key}' -var 'cwd=${cwd}' -var 'db_user=${DB_USR}' -var 'db_pwd=${DB_PWD}'"
                    powershell "terraform apply -var 'access_key=${AWS_ACCESS_KEY}' -var 'secret_key=${AWS_SECRET_KEY}' -var 'priv_key=${priv_key}' -var 'cwd=${cwd}' -var 'db_user=${DB_USR}' -var 'db_pwd=${DB_PWD}' -auto-approve"
                }
            }
        }
        catch (e)
        {
            currentBuild.result = 'FAILURE'
            println(e)
        }
        finally
        {
            if ("${terminate}" == 'true')
            {
                stage('Terminate Infra')
                {
                    echo "Terminating the instance"
                    dir("iac_src")
                    {
                        powershell "terraform destroy -var 'access_key=${AWS_ACCESS_KEY}' -var 'secret_key=${AWS_SECRET_KEY}' -var 'priv_key=${priv_key}' -var 'cwd=${cwd}' -var 'db_user=${DB_USR}' -var 'db_pwd=${DB_PWD}' -auto-approve"
                    }
                }
            }
            else
            {
                stage('Keep Infra')
                {
                    echo "Keeping the instance in AWS, please check the archive file"
                    dir("iac_src")
                    {
                        powershell "terraform output -json > manifest.json"
                        archiveArtifacts allowEmptyArchive: true, artifacts: "${manifest.json}"
                    }
                }
            }
        }
    }
}