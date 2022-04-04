// Boolean is_develop_branch = BRANCH_NAME.contains("develop")
// Boolean is_master_branch = BRANCH_NAME.contains("master")
// Boolean is_release_branch = BRANCH_NAME.contains("release")
// Boolean is_develop_or_master = is_develop_branch || is_master_branch
// Boolean is_release_or_master = is_release_branch || is_master_branch
// String cron_string = is_develop_or_master ? "H 23 * * *" : ""
String[] names = ["Pepito1", "Juanito1"]


// env.MYTOOL_VERSION = '1.33'
// node {
//   sh '/usr/local/mytool-$MYTOOL_VERSION/bin/start'
// }

node {
	echo "This is another test"
	NAMES = sh (script: """#!/bin/bash -l
				ruby scripts/testResult.rb
                """,
             	returnStdout: true
             	).split(" ")

echo "These are the names:"
echo NAMES
}

script {

	echo NAMES

            // Define Variable
             def USER_INPUT = input(
                    message: 'User input required - Some Yes or No question?',
                    parameters: [
                            [$class: 'ChoiceParameterDefinition',
                             choices: names.join('\n'),
                             name: 'input',
                             description: 'Menu - select box option']
                    ])

            echo "The answer is: ${USER_INPUT}"

            if( "${USER_INPUT}" == "yes"){
                //do something
            } else {
                //do something else
            }
        }

node{
    // now you are on slave labeled with 'label'
    def workspace = WORKSPACE
    // ${workspace} will now contain an absolute path to job workspace on slave

    workspace = env.WORKSPACE
    // ${workspace} will still contain an absolute path to job workspace on slave

    // When using a GString at least later Jenkins versions could only handle the env.WORKSPACE variant:
    echo "Current workspace is ${env.WORKSPACE}"

    // the current Jenkins instances will support the short syntax, too:
    echo "Current workspace is $WORKSPACE"
}

// Esto no captura los nombres en la variable
// node {
// 	echo "This is a test"
// 	NAMES = sh 'ruby scripts/testResult.rb'
// 	echo "Print names"
// 	echo NAMES
// 	// sh '/Users/malmes/Documents/git/JenkinsTest/scripts/testResult.rb'
// }

pipeline {
	// environment {
	// 	APP_NAME = 'poland'
	// 	LANG = 'en_US.UTF-8'
	// 	LANGUAGE = 'en_US.UTF-8'
	// 	LC_ALL = 'en_US.UTF-8'
 //        MATCH_PASSWORD=credentials('jenkins-match-password')
	// 	COMMIT_MESSAGE = sh(script: 'git log --oneline --format=%B -n 1 $GIT_COMMIT', returnStdout: true).trim()
	// 	NEXUS_USERNAME=credentials('jenkins-nexus-username')
	// 	NEXUS_PASSWORD=credentials('jenkins-nexus-password')
	// 	APPLE_ID=credentials('jenkins-apple-id')
 //      	FASTLANE_ITC_TEAM_ID=credentials('jenkins-team-id-enterprise')
 //      	FASTLANE_USER=credentials('jenkins-apple-id')
	// }
	parameters {
		// booleanParam(name: "DEPLOY_TO_INTERN", defaultValue: "${is_develop_branch}", description: "Mark this check to build and deploy in app center Intern schema version")
		// booleanParam(name: "DEPLOY_TO_PRE", defaultValue: "${is_release_or_master}", description: "Mark this check to build and deploy in app center PRE schema version")
		// booleanParam(name: "RUN_APPIUM", defaultValue: "${is_develop_or_master}", description: "Mark this check to build a version for Appium tests ")
		booleanParam(name: "RUN_TESTS", defaultValue: false, description: "Mark this check to execute unit and snapshot tests")
		booleanParam(name: "INCREMENT_VERSION", defaultValue: true, description: "Mark this check to commit a version tag and bump version release nuber C (A.B.C)")
		choice(name: 'NODE_LABEL', choices: ['poland', 'ios', 'hub'], description: '')
    }
	// agent { label params.NODE_LABEL ?: 'poland' } 
	agent any 
	// triggers { cron(cron_string) }

	stages {

		stage('Wait for user to input text?') {
    		steps {
        		script {
             		def userInput = input(id: 'userInput', message: 'Merge to?',
             		parameters: [[$class: 'ChoiceParameterDefinition', defaultValue: 'strDef', 
                				description:'describing choices', name:'nameChoice', choices: "QA\nUAT\nProduction\nDevelop\nMaster"]
             					])

            		println(userInput); //Use this value to branch to different logic if needed
        		}
    		}
		}

		stage('Test script reslt') {
       		steps {
				sh "ruby scripts/testResult.rb"
       			echo "Executing script"
				
       		}
        }

		// stage('install dependencies') {
  //      		steps {
		// 		sh "git checkout $BRANCH_NAME"
  //      			echo "Installing dependencies"
		// 		sh "bundle install"
  //      			sh "cd Project && bundle exec fastlane ios update_pods"
  //      		}
  //       }
		// stage('Distribute Intern') {
		// 	when {
		// 		branch 'develop'
  //       		expression { return  !env.COMMIT_MESSAGE.startsWith("Updating Version")}
		// 		expression { return params.DEPLOY_TO_INTERN }
  //           }
		// 	steps {
		// 		echo "Distributing android app"
		// 		sh "cd Project && bundle exec fastlane ios release deploy_env:intern notify_testers:true branch:develop"
		// 	}
  //       }
		
		// stage('Run Unit tests') {
		// 	when {
		// 		branch 'develop'
		// 		expression { return  !env.COMMIT_MESSAGE.startsWith("Updating Version")}
		// 		expression { return params.RUN_TESTS }
		// 	}
		// 	steps {
		// 		echo "Testing Poland Local Example Apps"
		// 		sh "cd Project && bundle exec fastlane ios test"
		// 	}
		// }

		// stage('Compile Intern to Appium') {
		// 	when {
		// 		anyOf { branch 'master'; branch 'develop' }	
		// 		expression { return  !env.COMMIT_MESSAGE.startsWith("Updating Version")}
		// 		expression { return params.RUN_APPIUM }
  //   		}
		// 	steps {
		// 		catchError(buildResult: 'SUCCESS', stageResult: 'FAILURE') {
		// 			echo "Distributing iOS app"
		// 			sh "cd Project && bundle exec fastlane ios build_appium"
		// 			sh "mv Build/Products/Intern-Debug-iphonesimulator/PL-INTERN*.app INTERN.app"
		// 			sh 'zip -vr INTERN.zip INTERN.app/ -x "*.DS_Store"'
		// 			archiveArtifacts artifacts: 'INTERN.zip'
		// 		}
		// 	}
  //       }

		// stage('Distribute Pre iOS') {
		// 	when {
		// 		anyOf { branch 'master'; branch 'release/*' }	
		// 		expression { return params.DEPLOY_TO_PRE }
		// 	}
		// 	steps {
		// 		echo "Distributing Pre app"
		// 		sh "cd Project && bundle exec fastlane ios release deploy_env:pre notify_testers:true branch:master"
		// 	}
		// }
		
		// stage('Increment Version and Update Repo Version ') {
		// 	when {
		// 		anyOf { branch 'develop'; branch 'master'; branch 'release/*' }
		// 		expression { return params.INCREMENT_VERSION }
  //               expression { return  !env.COMMIT_MESSAGE.startsWith("Updating Version")}
		// 	}
		// 	steps {
		// 		sh "cd Project && bundle exec fastlane ios increment_version"
		// 	}
  //       }
	}
	post {
		success {
			cleanWs()
		}
		failure {
			mail to: "marcos.alvarez@experis.es", subject: "Build: ${env.JOB_NAME} - Failed", body: "The PL build ${env.JOB_NAME} has failed"
		}
	}
}
