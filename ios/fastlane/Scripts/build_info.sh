#!/bin/sh

rows=()
append() {
  rows+=("$1"$'\t'"$2")
}

append "Git Commit" "$(git rev-parse --short HEAD)"
append "macOS" "$(sw_vers --productVersion) ($(sw_vers --buildVersion))"
append "Xcode" "$(xcodebuild -version | sed -n '1s/Xcode //p') ($(xcodebuild -version | sed -n '2s/Build version //p'))"
append "GnuPG" "$(gpg --version | grep '^gpg' | sed -n 's/^gpg (GnuPG) \([0-9.]*\).*/\1/p')"
append "FVM" "$(fvm -v)"
append "Flutter" "$(fvm flutter --version | sed -n 's/^Flutter \([^ ]*\).*/\1/p')"
append "Dart" "$(fvm flutter --version | sed -n 's/^.*Dart \([^ ]*\).*/\1/p')"
append "Ruby" "$(grep '^ruby "\S\+"' ../Gemfile | sed -n 's/ruby "\([^ ]*\)".*/\1/p')"
append "Cocoapods" "$(bundle exec pod --version)"
append "Fastlane" "$(bundle exec fastlane -version 2>&1  | grep '^fastlane [0-9.]\+' | sed 's/fastlane //')"

. Scripts/print_table.sh
title="Build Info"
header=("Name" "Value")
{ print_table "$title" header[@] rows[@] ; } >> debug.log