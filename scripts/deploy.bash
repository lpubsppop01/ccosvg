#! /usr/bin/env bash

# Select deployment target
while true; do
    read -p 'Deployment target is production or staging? (p/s)' PS
    case $PS in
        [Pp]*)
            DEPLOYMENT_TARGET=production
            break;;
        [Ss]*)
            DEPLOYMENT_TARGET=staging
            break;;
        *)
            echo "Please answer production or staging.";;
    esac
done

# Function to increment build number
incremenet_build_number() {
    PROJECT_DIR=$(dirname $(dirname $0))
    PUBSPEC_YAML_PATH="$PROJECT_DIR/pubspec.yaml"
    BUILD_NUMBER=`grep -oP '(?<=version: [0-9]\.[0-9]\.[0-9]\+)[0-9]+' $PUBSPEC_YAML_PATH`
    BUILD_NUMBER=$((BUILD_NUMBER + 1))
    TEMP_PATH=`mktemp`
    sed -E "s/(version: [0-9]\.[0-9]\.[0-9])\+[0-9]+/\1+$BUILD_NUMBER/g" \
        $PUBSPEC_YAML_PATH > $TEMP_PATH
    mv $TEMP_PATH $PUBSPEC_YAML_PATH
}

# Increment build number 
while true; do
    read -p 'Increment build number? (y/n)' YN
    case $YN in
        [Yy]*)
            incremenet_build_number
            break;;
        [Nn]*)
            break;;
        *)
            echo "Please answer yes or no.";;
    esac
done

# Delete existing remote branch
while true; do
    read -p "Delete existing \"$DEPLOYMENT_TARGET\" branch? (y/n)" YN
    case $YN in
        [Yy]*)
            git branch -D $DEPLOYMENT_TARGET
            git push origin :$DEPLOYMENT_TARGET
            break;;
        [Nn]*)
            break;;
        *)
            echo "Please answer yes or no.";;
    esac
done

# Build and push
flutter pub global activate peanut && \
flutter pub global run peanut -b $DEPLOYMENT_TARGET --web-renderer canvaskit && \
git push origin $DEPLOYMENT_TARGET
