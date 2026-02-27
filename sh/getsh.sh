#安装unzip
if ! command -v unzip 2>&1 >/dev/null; then
    echo "Installing unzip..."
    sudo apt-get update && sudo apt-get install -y unzip
fi

curl -L https://github.com/einblatt/infrastructure-dev-ops/archive/refs/heads/main.zip -o service.zip && sudo unzip -o service.zip && rm service.zip
