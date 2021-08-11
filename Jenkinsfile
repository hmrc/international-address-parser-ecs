#!/usr/bin/env groovy
pipeline {
  agent {
      label 'commonagent'
  }

  stages {
    stage('Build docker image') {
      steps {
        ansiColor('xterm') {
        	sh('make clean build')
        }
      }
    }
    stage('Upload image to ECS') {
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
