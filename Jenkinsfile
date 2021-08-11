#!/usr/bin/env groovy
pipeline {
  agent {
      label 'commonagent'
  }

  stages {
    stage('Build artefact') {
      steps {
        ansiColor('xterm') {
        	sh('make clean build')
        }
      }
    }
    stage('Upload to s3') {
      steps {
        ansiColor('xterm') {
            sh('make publish')
        }
      }
    }
    stage ('Run cip-attval-terraform job') {
      steps {
        build job: 'cip-attval-terraform/terraform-environments'
      }
    }
  }
}
