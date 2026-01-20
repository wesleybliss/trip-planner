#!/bin/bash

BUILD_TARGET="build/app/outputs/flutter-apk/app-release.apk"

read -p "Did you update the version before running this? (y/N) " -n 1 -r
echo

if [[ $REPLY =~ ^[Yy]$ ]]; then
    
    echo "Creating production release"
    
    if [ "$1" != "--skip-build" ] || [ ! -f "$BUILD_TARGET" ]; then
        flutter build apk --release
    fi
    
    firebase appdistribution:distribute \
        "$BUILD_TARGET" \
        --app '1:976595109556:android:e30cdbd96926f08bc5b9e1' \
        --groups 'alpha-testers'
    
fi
