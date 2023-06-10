pipeline {
  agent any
    environment {
        STR = "https://ausdevops.atlassian.net/rest/api/2/status/10009"
        Jira_ID = "DL-99"
        Key = "c2hhc2h3YXQucHJhc2FkLnRlbHN0cmFAZ21haWwuY29tOkFUQVRUM3hGZkdGMDl3WUl3Unl1X3JxNW01eWJNTUhPRG1RcWNjaW5ncDhzU1dtbGFvMFA2bVF2VG0tRWFiOHZVVnNGM0F4cVRCVnFaX1h1c0FOYlBxZjhlX2VweWJldTktQzg3MFJuSkhxQ2xfYmtORmN2N3ZPa2RkTjRmbTF6Z0NkUVFkY3lMZmJsU0lDNlNhektyWmkyNjBtb1NDdjRyQU9EbFBQRW1yeEVzSFNOWlJpQUVMUT05Qzg3NEJBMA=="
    }
  stages {
       stage('Gitlab File Download') 
    {
      steps {
         script{ 
         sh 'ls -lart'
         echo "SCM Pooling Complete Files Downloaded"
         sh 'ls -lart & pwd'
         echo "Moving Jira Task to Next ID 3, Code ready for Approval"
         
         }}}

    stage('Jira Transition ID 3 , Code build complete') {
      steps{
           sh '''curl --request POST --url 'https://ausdevops.atlassian.net/rest/api/latest/issue/DL-99/transitions' -H "Authorization: Basic c2hhc2h3YXQucHJhc2FkLnRlbHN0cmFAZ21haWwuY29tOkFUQVRUM3hGZkdGMDl3WUl3Unl1X3JxNW01eWJNTUhPRG1RcWNjaW5ncDhzU1dtbGFvMFA2bVF2VG0tRWFiOHZVVnNGM0F4cVRCVnFaX1h1c0FOYlBxZjhlX2VweWJldTktQzg3MFJuSkhxQ2xfYmtORmN2N3ZPa2RkTjRmbTF6Z0NkUVFkY3lMZmJsU0lDNlNhektyWmkyNjBtb1NDdjRyQU9EbFBQRW1yeEVzSFNOWlJpQUVMUT05Qzg3NEJBMA==" --data '{"transition": {"id": "3"}}' -H "Content-Type: application/json"'''
         }} 


       stage('Jira Approval Check') {
      steps {
         script{ 
          PWD = sh(script:"""pwd""", returnStdout: true).trim()
          def logFile = new File("$PWD/test.txt")
          sh '> $PWD/test.txt && cat $PWD/test.txt'
for (int i = 0; i < 10; i++) {
         Job_Status=null
         //Jira_staus = sh(script: 'curl -s -D- -u shashwat.prasad.telstra@gmail.com:ATATT3xFfGF0B2NwWSue2gxRQpS7x1AaOA1gfGSNrSnysnBc8ji6g0A1XH4zOEjzteTec-Rh6st60rf9vZHUGNiOghF1UrPdMIzrGAT1Ay76Em-PzPsameT5cshaHj4TTJAouwn0d7w4rwy3qfN7LniYllUDfN4e6gAE3l69M_AzJ8qrJ_6Updo=7F03D91E -X GET -H "Content-Type: application/json" https://ausdevops.atlassian.net/rest/api/latest/issue/$Jira_ID?fields=status', returnStdout: true).trim()
         Jira_staus = sh(script: 'curl -D- -X GET -H "Authorization: Basic $Key" -H "Content-Type: application/json" "https://ausdevops.atlassian.net/rest/api/latest/issue/DL-99?fields=status"', returnStdout: true).trim()
         println Jira_staus
         logFile.append(Jira_staus)
         sh 'cat test.txt && pwd && ls -lart'
         Job_Status = sh(script:"""if grep -Fq "$STR" $PWD/test.txt; then echo "Approved" ; else  echo "Waiting Approval" ; fi""", returnStdout: true).trim()
         echo " the Staus of Jira ticket is --------------${Job_Status}------------"  
         JiraStatus = Job_Status
             if (JiraStatus == "Approved") 
             {
                 echo "Jira Task is approved now we are moving to next stage of Deployment"
                 break
             }
             else { echo "Waiting Approval"
                      }
          sleep(10) 
          println i
          if (i == 9) {System.exit(1); }
         }
             
         }}
  }
          stage('User VM Creation') {
            steps {
                
                sh '''
id
which terraform
pwd
terraform -version
terraform init
terraform plan
terraform apply --auto-approve
##User Addition##
#sudo useradd -m -p $(openssl passwd -1 Proximus#18) SPT_Test -g sudo
##UserCheck###
#sudo cat /etc/passwd | grep -i SPT_Test
##Login whicth User###
#sshpass -p 'Proximus#18' ssh SPT_Test@192.168.1.105
exit
'''
            }}

    stage('Jira Transition ID 5 , done') {
      steps{
           sh '''curl --request POST --url 'https://ausdevops.atlassian.net/rest/api/latest/issue/DL-99/transitions' -H "Authorization: Basic c2hhc2h3YXQucHJhc2FkLnRlbHN0cmFAZ21haWwuY29tOkFUQVRUM3hGZkdGMDl3WUl3Unl1X3JxNW01eWJNTUhPRG1RcWNjaW5ncDhzU1dtbGFvMFA2bVF2VG0tRWFiOHZVVnNGM0F4cVRCVnFaX1h1c0FOYlBxZjhlX2VweWJldTktQzg3MFJuSkhxQ2xfYmtORmN2N3ZPa2RkTjRmbTF6Z0NkUVFkY3lMZmJsU0lDNlNhektyWmkyNjBtb1NDdjRyQU9EbFBQRW1yeEVzSFNOWlJpQUVMUT05Qzg3NEJBMA==" --data '{"transition": {"id": "5"}}' -H "Content-Type: application/json"'''
         }}
         
         }}