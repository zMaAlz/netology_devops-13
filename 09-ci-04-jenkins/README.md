# Домашнее задание к занятию "09.04 Jenkins"

## Declarative Pipeline 

```
pipeline {
    agent any
    stages {
        stage(‘Git’){
            steps{ git branch: 'docker', credentialsId: 'b67c2c35-0b9d-4839-be19-da574b247e65', url: 'git@github.com:zMaAlz/vector-role.git'
                }
            }
        stage(‘molecule’){
            steps{ sh 'molecule test'
                }
            }
        }
}
```

## Scripted Pipeline

```
node(){
    stage("Git checkout"){
        git credentialsId: 'b67c2c35-0b9d-4839-be19-da574b247e65', url: 'git@github.com:aragastmatb/example-playbook.git'
    }
    stage("Run playbook"){
        if (env.PROD_RUN == 'true'){
            sh 'ansible-playbook site.yml -i inventory/prod.yml'
        }
       if (env.PROD_RUN == 'false'){
            sh 'ansible-playbook site.yml -i inventory/prod.yml --check --diff'
        }
    }
}
```


[Пример](https://github.com/zMaAlz/vector-role/tree/docker)