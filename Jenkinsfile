String jsonFile = "scripts/selectedBranches.json"
String currentCountryBranch = "release/0.5"
String submoduleName = "santander-one"


// env.MYTOOL_VERSION = '1.33'
// node {
//   sh '/usr/local/mytool-$MYTOOL_VERSION/bin/start'
// }

// script {
// 	env.BRANCH_OPTION = "PreselectedBranch"
// }

pipeline {

	// environment {
	// 	APP_NAME = 'poland'
	// }
	parameters {
		// Should show preselected branch to notify user that it will be updated if we can call a script to present it before showing these options
		booleanParam(name: "UPDATE_CORE_BRANCH", defaultValue: false, description: "Mark this check to update Core branch")
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
				expression { return params.UPDATE_CORE_BRANCH }
				expression { return !env.FOUND_BRANCH }
			}
			steps {
				script {
					// Call script to get options
					BRANCHES = sh (script: """#!/bin/bash -l
								ruby scripts/core_branch_options.rb
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

					// Save selected option to json file (and create file if it does not exist)
					if (env.BRANCHES != null) {
						def branches = readJSON text: env.BRANCHES
						branches[currentCountryBranch] = USER_INPUT
						writeJSON file: jsonFile, json: branches, pretty: 1
					} else {
						def dict = ["${currentCountryBranch}": USER_INPUT]
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
					sh "fastlane ios update_core_branch countryBranch:${currentCountryBranch} coreBranch:${env.FOUND_BRANCH} submoduleName:${submoduleName}"
				}
			}
		}
	}
}
