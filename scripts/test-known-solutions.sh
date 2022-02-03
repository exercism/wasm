#!/bin/bash

# Assumed to be run from project root directory

# Overwrites the starter *.wat files with the solution *.wat files located in each exercise's .meta directory
# Used to allow CI to execute all exercise unit tests against known solutions to check for regressions
for exercise_dir in ./exercises/*/*; do
    exercise_name=$(basename "$exercise_dir")

    # Save original files to restore after running unit tests
    cp "${exercise_dir}/${exercise_name}.wat" "${exercise_dir}/${exercise_name}.wat.old"
    cp "${exercise_dir}/${exercise_name}.spec.js" "${exercise_dir}/${exercise_name}.spec.js.old"

    # Overwrite the exercise *.wat source with a known solution
    cp "${exercise_dir}/.meta/proof.ci.wat" "${exercise_dir}/${exercise_name}.wat"

    # Enable all Jest unit tests
    sed -i s/xtest/test/ "${exercise_dir}/${exercise_name}.spec.js"
done

npm test

for exercise_dir in ./exercises/*/*; do
    exercise_name=$(basename "$exercise_dir")

    # Restore the original *.wat source
    mv "${exercise_dir}/${exercise_name}.wat.old" "${exercise_dir}/${exercise_name}.wat"

    # Enable the original Jest test spec
    mv "${exercise_dir}/${exercise_name}.spec.js.old" "${exercise_dir}/${exercise_name}.spec.js"
done
