String jsonFile = "scripts/selectedBranches.json"
String currentCountryBranch = "release/0.6"


// env.MYTOOL_VERSION = '1.33'
// node {
//   sh '/usr/local/mytool-$MYTOOL_VERSION/bin/start'
// }

pipeline {

	// environment {
	// 	APP_NAME = 'poland'
	// }
	parameters {
		booleanParam(name: "RUN_TESTS", defaultValue: false, description: "Mark this check to execute unit and snapshot tests")
		booleanParam(name: "INCREMENT_VERSION", defaultValue: true, description: "Mark this check to commit a version tag and bump version release nuber C (A.B.C)")
		choice(name: 'NODE_LABEL', choices: ['poland', 'ios', 'hub'], description: '')
    }
	agent any 
	// triggers { cron(cron_string) }

	stages {

		stage('Read JSON with previous selected option if exists') {
			steps {
				script {
					echo "Getting branches from json file"
					def exists = fileExists jsonFile
					if (exists) {
						def branches = readJSON file: jsonFile //, returnPojo: true
						env.BRANCHES = branches
						// 	branches.each { key, value ->
					 //    		echo "Walked through key $key and value $value"
					 //    	}

						def found = branches[currentCountryBranch]
						if (found != null) {
							env.FOUND_BRANCH = found
						}
					}
				}
			}
		}

		stage('Give options and save selected one') {
			when {
				expression { return !env.FOUND_BRANCH }
			}
			steps {
				script {
					// Call script to get options
					BRANCHES = sh (script: """#!/bin/bash -l
								ruby scripts/coreBranchesOptions.rb
				                """,
				             	returnStdout: true
				             	)

					// Show options
					String branchesString = "${BRANCHES}"
					def options = branchesString.split("\n") as List

					def USER_INPUT = input(
						message: 'Select branch from Core submodule to update reference',
						parameters: [
						        [$class: 'ChoiceParameterDefinition',
						         choices: options.join('\n'),
						         name: 'input',
						         description: 'Menu - select box option']
						])

					echo "Selected option ${USER_INPUT} will be save to json file"

					// Save selected option to json file
					if (env.BRANCHES != null) {
						def branches = readJSON text: env.BRANCHES
						branches[currentCountryBranch] = USER_INPUT
						writeJSON file: jsonFile, json: branches, pretty: 1
					} else {
						def dict = [currentCountryBranch: USER_INPUT]
						writeJSON file: jsonFile, json: dict, pretty: 1
					}

					env.FOUND_BRANCH = USER_INPUT
				}
			}
		}

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
	}
}
