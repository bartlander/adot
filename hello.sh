if [[ "$1" == "j" ]]; then port=8;
elif [[ "$1" == "n" ]]; then port=9;
else echo "usage: $0 j|n"; exit 1; fi

echo "curl -X GET http://localhost:888${port}/hello"
curl -X GET http://localhost:888${port}/hello
