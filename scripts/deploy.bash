#! /usr/bin/env bash

# Function to increment build number
incremenet_build_number() {
    PROJECT_DIR=$(dirname $(dirname $0))
    PUBSPEC_YAML_PATH="$PROJECT_DIR/pubspec.yaml"
    BUILD_NUMBER=`grep -oP '(?<=version: [0-9]\.[0-9]\.[0-9]\+)[0-9]' $PUBSPEC_YAML_PATH`
    BUILD_NUMBER=$((BUILD_NUMBER + 1))
    TEMP_PATH=`mktemp`
    sed -E "s/(version: [0-9]\.[0-9]\.[0-9])\+[0-9]/\1+$BUILD_NUMBER/g" \
        $PUBSPEC_YAML_PATH > $TEMP_PATH
    mv $TEMP_PATH $PUBSPEC_YAML_PATH
}

# Increment build number 
while true; do
    read -p 'Increment build number? (y/n)' INCREMENTS_BUILD_NUMBER
    case $INCREMENTS_BUILD_NUMBER in
        [Yy]*)
            incremenet_build_number
            break;;
        [Nn]*)
            break;;
        *)
            echo "Please answer yes or no.";;
    esac
done

# Delete existing remote production branch
while true; do
    read -p 'Delete existing remote "production" branch? (y/n)' DELETES_PRODUCTIOIN_BRANCH
    case $DELETES_PRODUCTIOIN_BRANCH in
        [Yy]*)
            git push origin :production
            break;;
        [Nn]*)
            break;;
        *)
            echo "Please answer yes or no.";;
    esac
done

# Build and push
flutter pub global activate peanut && \
flutter pub global run peanut -b production --web-renderer canvaskit && \
git push origin production
