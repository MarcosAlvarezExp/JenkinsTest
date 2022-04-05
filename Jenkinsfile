// Boolean is_develop_branch = BRANCH_NAME.contains("develop")
// Boolean is_master_branch = BRANCH_NAME.contains("master")
// Boolean is_release_branch = BRANCH_NAME.contains("release")
// Boolean is_develop_or_master = is_develop_branch || is_master_branch
// Boolean is_release_or_master = is_release_branch || is_master_branch
// String cron_string = is_develop_or_master ? "H 23 * * *" : ""
String[] names = ["Pepito1", "Juanito1"]
String countryKey = "Poland"
String coreKey = "Core"
String jsonFile = "scripts/branches2.json"
String jsonFileWrite = "scripts/branchesWrote.json"
String currentCountryBranch = "release/0.6"


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
             	)

	echo "These are the names:"
	echo NAMES
	// env.NAMES = NAMES
	// echo "${env.NAMES}"
	echo "Another names:"
	String namesString = "${NAMES}"
	echo namesString
	echo "Another names 2:"
	def string = namesString.split("\n") as List // Depending on how i'm returning the result of the script I would use "\n" or ",""
	// String[] array = string.split(",")
	echo string[0]
	echo string[1]
}

// script {
// 	// Define Variable
// 	def USER_INPUT = input(
// 						message: 'User input required - Some Yes or No question?',
// 						parameters: [
// 						        [$class: 'ChoiceParameterDefinition',
// 						         choices: names.join('\n'),
// 						         name: 'input',
// 						         description: 'Menu - select box option']
// 						])

// 	echo "The answer is: ${USER_INPUT}"

// 	if( "${USER_INPUT}" == "yes"){
// 	//do something
// 	} else {
// 	//do something else
// 	}
// }

node {
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
	// 	NAMES = sh (script: """#!/bin/bash -l
	// 			ruby scripts/testResult.rb
 //                """,
 //             	returnStdout: true
 //             	)
 //  	}

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
		// choice(name: 'NAMES', choices: NAMES, description: 'Another description')
		booleanParam(name: "RUN_TESTS", defaultValue: false, description: "Mark this check to execute unit and snapshot tests")
		booleanParam(name: "INCREMENT_VERSION", defaultValue: true, description: "Mark this check to commit a version tag and bump version release nuber C (A.B.C)")
		choice(name: 'NODE_LABEL', choices: ['poland', 'ios', 'hub'], description: '')
    }
	// agent { label params.NODE_LABEL ?: 'poland' } 
	agent any 
	// triggers { cron(cron_string) }

	stages {

		stage('Read JSON with previous selected branches') {
			steps {
				script {
					echo "Getting branches from json file"
					def branches = readJSON file: jsonFile //, returnPojo: true
					// println branches
					env.BRANCHES = branches
					// for (Dictionary branch: branches) {
						branches.each { key, value ->
				    		echo "Walked through key $key and value $value"
				    	}
					// }

					def found = branches[currentCountryBranch]
					if (found != null) {
						env.FOUND_BRANCH = found
					}

					// echo "Writting json"
					// writeJSON file: jsonFileWrite, json: branches, pretty: 1
				}
			}
		}

		// stage('See if exists a Core branch selected previously') {
		// 	steps {
		// 		script {
		// 			def branches = readJSON text: env.BRANCHES
		// 			def found = branches[currentCountryBranch]
		// 			if (found != null) {
		// 				env.FOUND_BRANCH = found
		// 			}
		// 		}
		// 	}
		// }

		stage('Call script to give options') {
			when {
				expression { return !env.FOUND_BRANCH }
			}
			steps {
				script {

					NAMES = sh (script: """#!/bin/bash -l
								ruby scripts/testResult.rb
				                """,
				             	returnStdout: true
				             	)
					// echo NAMES
					String namesString = "${NAMES}"
					// echo namesString
					def options = namesString.split("\n") as List // Depending on how i'm returning the result of the script I would use "\n" or ",""
					// echo options[0]
					// echo options[1]

					def USER_INPUT = input(
						message: 'Select branch from Core submodule to update reference',
						parameters: [
						        [$class: 'ChoiceParameterDefinition',
						         choices: options.join('\n'),
						         name: 'input',
						         description: 'Menu - select box option']
						])

					echo "The answer is: ${USER_INPUT}"

					// Save selected option in json file
					def branches = readJSON text: env.BRANCHES
					branches[currentCountryBranch] = USER_INPUT
					println (branches)
					writeJSON file: jsonFile, json: branches, pretty: 1
				}
			}
		}

		// stage('Wait for user to select branch') {
		// 	when {
		// 		expression { return !env.FOUND_BRANCH }
		// 	}
		// 	steps {

		// 		script {
		// 			def branches = readJSON text: env.BRANCHES
		// 			// println branches

		// 			def coreBranches = []
		// 			// for (Dictionary branch: branches.branches) {
		// 				branches.each { key, value ->
		// 		    		coreBranches << "$value"
		// 		    	}
		// 			// }

		// 			def USER_INPUT = input(
		// 				message: 'Select branch from Core submodule to update reference',
		// 				parameters: [
		// 				        [$class: 'ChoiceParameterDefinition',
		// 				         choices: coreBranches.join('\n'),
		// 				         name: 'input',
		// 				         description: 'Menu - select box option']
		// 				])

		// 			echo "The answer is: ${USER_INPUT}"

		// 			// Save selected branch to Json
		// 			env.FOUND_BRANCH = USER_INPUT
		// 		}
		// 	}
		// }

		stage('Updates Core branch if proceed') {
			when {
				expression { return env.FOUND_BRANCH }
			}
			steps {
				script {
					echo "Update Core branch"
					// Call script to update Core branch
				}
			}
		}

		stage('Test script reslt') {
       		steps {
				sh "ruby scripts/testResult.rb"
       			echo "Executing script"
				
       		}
        }


	}
	// post {
	// 	success {
	// 		cleanWs()
	// 	}
	// 	failure {
	// 		mail to: "marcos.alvarez@experis.es", subject: "Build: ${env.JOB_NAME} - Failed", body: "The PL build ${env.JOB_NAME} has failed"
	// 	}
	// }
}
