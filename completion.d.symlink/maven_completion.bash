#!/bin/bash
# Programmed bash completion for use with maven2
# Copyright 2007 Pawel Kierat (pawel.kierat@gmail.com)
#
# Usage:
# The script first completes phases and plugins. If the user entry ends with ':',
# goals for the specified plugin are searched.
#
# Development:
# Every entry in PLUGINS array matches the corresponding element of GOALS array.
# To add a new plugin with its set of goals, put its name in PLUGINS and
# a space-separated list of goals as a string in GOALS.
#

PHASES="validate generate-sources process-sources generate-resources process-resources compile process-classes generate-test-sources process-test-sources generate-test-resources process-test-resources test-compile test package integration-test verify install deploy"

PLUGINS=("clean" "compiler" "deploy" "install" "resources" "site" "surfire" "verifier" "ear" "ejb" "jar" "rar" "war" "changelog" "changes" "checkstyle" "clover" "doap" "docck" "javadoc" "jxr" "pmd" "project-info-reports" "surfire-report" "ant" "antrun" "archetype" "assembly" "dependency" "enforcer" "gpg" "help" "invoker" "one" "plugin" "release" "remote-resources" "repository" "scm" "source" "eclipse" "idea" "build-helper" "castor" "javacc" "jdepend" "native" "sql" "taglist")

GOALS=("clean" "compile testCompile" "deploy deploy-file" "install install-file" "resources testResources" "deploy attach-descriptor site run stage-deploy stage" "test" "verify" "ear generate-application-xml" "ejb" "jar test-jar sign sign-verify" "rar" "war exploded inplace" "changelog dev-activity file-activity" "announcement-mail announcement-generate changes-report jira-report" "checkstyle check" "aggregate check instrument log clover save-history" "generate" "check" "javadoc test-javadoc jar" "jxr test-jxr" "pmd cpd check cpd-check" "cim dependencies dependency-convergence issue-tracking license mailing-list index summary scm project-team" "report report-only" "ant clean" "run" "create create-from-project" "assembly attached directory-online directory directory-single single unpack" "copy copy-dependencies unpack unpack-dependencies resolve list sources resolve-plugins go-offline purge-local-repository build-classpath analyze analyze-only analyze-dep-mgt tree" "enforce enforce-once display-info" "sign sign-and-deploy-file" "active-profiles describe effective-pom effective-settings" "run" "convert deploy-maven-one-repository install-maven-one-repository maven-one-plugin" "descriptor report updateRegistry xdoc addPluginArtifactMetadata" "clean perform prepare rollback branch" "bundle process" "bundle-create bundle-pack" "add changelog checkin checkout diff edit status tag unedit update validate" "jar test-jar" "add-maven-repo clean eclipse make-artifacts install-plugins" "idea project module workspace clean" "add-source add-test-source attach-artifact" "generate" "jtb jjtree javacc" "generate" "initialize compile link javah ranlib resource-compile compile-messages" "execute" "taglist")

POM_OPTS="-DmodelVersion -DartifactId -DgroupId -Dpackaging -Dname -Ddescription -Dversion -Durl -Dmaven.test.skip"

MVN_OPTS="-q --quiet -C --strict-checksums -c --lax-checksums -P --activate-profiles -ff --fail-fast -fae --fail-at-end -B --batch-mode -fn --fail-never -up --update-plugins -N --non-recursive -npr --no-plugin-registry -U --update-snapshots -cpu --check-plugin-updates -npu --no-plugin-updates -D --define -X --debug -e --errors -f --file -h --help -o --offline -r --reactor -s --settings -v --version"

_mvn() {
    local cur opts prev plugin mojos
    COMPREPLY=()
    cur="${COMP_WORDS[COMP_CWORD]}"
    prev="${COMP_WORDS[COMP_CWORD-1]}"
    case "${cur}" in
    -*)
	opts="${POM_OPTS} ${MVN_OPTS}"
	;;
    *:*)
    	plugin=$(echo "${cur}" | sed 's/:.*//g')
    	cur=$(echo "${cur}" | sed 's/.*://g')
	for i in ${!PLUGINS[*]}; do
	    if [[ "${plugin}" == ${PLUGINS[${i}]} ]]; then
		mojos=${GOALS[${i}]}
    		break
	    fi
	done
	opts=${mojos}
	;;
    *)
	opts="${PHASES} ${PLUGINS[@]}"
	;;
    esac
    COMPREPLY=( $(compgen -W "${opts}" -- ${cur}) )
    return 0
}

complete -F _mvn mvn


