name: Build and Deploy Termux Ghost Repo

on:
  push:
    branches: [main]

jobs:
  build-and-deploy:
    runs-on: ubuntu-latest

    steps:
      - uses: actions/checkout@v3

      - name: Install dpkg tools
        run: sudo apt-get update && sudo apt-get install -y dpkg-dev gzip

      - name: Build .deb package
        run: ./build-deb.sh

      - name: Generate Packages index
        run: |
          dpkg-scanpackages debs /dev/null > debs/Packages
          gzip -kf debs/Packages

      - name: Commit Packages index
        run: |
          git config --local user.name "github-actions[bot]"
          git config --local user.email "github-actions[bot]@users.noreply.github.com"
          git add debs/Packages debs/Packages.gz debs/*.deb
          git commit -m "Update Packages index" || echo "No changes to commit"
          git push

      - name: Deploy to GitHub Pages
        uses: peaceiris/actions-gh-pages@v3
        with:
          github_token: ${{ secrets.GITHUB_TOKEN }}
          publish_dir: ./debs
