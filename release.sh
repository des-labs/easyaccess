#!/bin/bash

VERSION=$1

if [[ "${VERSION}x" == "x" ]]; then
    echo "Specify version number"
    exit 1
fi

echo "+-----------------------------------------------------------+"
echo 'Did you update "CHANGES.md"?'; echo

if grep $VERSION CHANGES.md ; then
    echo; echo "It looks like you did."; echo;
else
    echo; echo "It looks like you did not."; echo;
    exit 1
fi

echo
echo "+-----------------------------------------------------------+"
echo 'Did you update "config/conda/meta.yaml"?'; echo

search1=$(grep "version: \"${VERSION}\"" config/conda/meta.yaml)
search2=$(grep "git_rev: ${VERSION}" config/conda/meta.yaml)
if [[ $search1 && $search2 ]]; then
    echo; echo "It looks like you did."; echo;
else
    echo; echo "It looks like you did not."; echo;
    exit 1
fi

echo "+-----------------------------------------------------------+"
echo 'Did you update "easyaccess/version.py"?'; echo

if grep "version_tag = ($(echo $VERSION | sed 's/\./, /g'))" easyaccess/version.py ; then
    echo; echo "It looks like you did."; echo;
else
    echo; echo "It looks like you did not."; echo;
    exit 1
fi

echo "+-----------------------------------------------------------+"
echo 'Did you build the PyPi package?'; echo
if find dist/ | grep $VERSION ; then
    echo; echo "It looks like you did."; echo;
else
    echo; echo "It looks like you did not."; echo;
    python3 setup.py sdist
    python3 setup.py bdist_wheel --universal
    echo
    echo "You need to manually execute the following to upload:"; echo
    echo "    twine upload \"dist/easyaccess-${VERSION}-py2.py3-none-any.whl\" \"dist/easyaccess-${VERSION}.tar.gz\""; echo
    exit 1
fi
