#!/bin/sh

# parse branch
if [ -f $GITHUB_EVENT_PATH ]; then
	# in case of push event
	BRANCH=$(cat $GITHUB_EVENT_PATH | jq -r .ref | awk -F '/' '{print $3}')

	if [ -z "$BRANCH" ]
    then
    	# in case of pullresuest event
    	BRANCH=$(cat $GITHUB_EVENT_PATH | jq -r head.ref)
    fi
else
	echo "Required file on path 'GITHUB_EVENT_PATH' not exists"
fi


codefresh auth create-context context --api-key $CF_API_KEY
codefresh auth use-contex context


if [ (-n "$TRIGGER_NAME") -a ( -n "$VAR_NAME")]
then
	codefresh run $PIPELINE_NAME --trigger=$TRIGGER_NAME --branch=$BRANCH --var $VAR_NAME=$VAR_VALUE
elif [ -n "$TRIGGER_NAME"]
	codefresh run $PIPELINE_NAME --trigger=$TRIGGER_NAME --branch=$BRANCH
elif [ -n "$VAR_NAME"]
	codefresh run $PIPELINE_NAME --branch=$BRANCH --var $VAR_NAME=$VAR_VALUE
else
	codefresh run $PIPELINE_NAME --branch=$BRANCH
fi
