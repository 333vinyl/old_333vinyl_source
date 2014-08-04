BUILD_DIR := ./build
PROD_REPO = git@github.com:333vinyl/333vinyl.github.io.git

DATE ?= "$(shell date)"
ALBUMN = $(shell echo $(ALBUM) | sed -e 's/ /_/g' | tr '[:upper:]' '[:lower:]')
ARTISTN = $(shell echo $(ARTIST) | sed -e 's/ /_/g' | tr '[:upper:]' '[:lower:]')
DIR = ./contents/articles/$(ARTISTN)-$(ALBUMN)
FILE = $(DIR)/index.md
URL = $(shell wget -qO - "http://www.albumart.org/index.php?searchkey=$$(perl -MURI::Escape -e 'print uri_escape($$ARGV[0]);' "$(ARTISTN) - $(ALBUMN)")&itempage=1&newsearch=1&searchindex=Music" | xmllint --html --xpath  'string(//a[@title="View larger image" and starts-with(@href, "http://ecx.images-amazon")]/@href)' - 2>/dev/null)

post:
		mkdir -p $(DIR)
		echo "---" >> $(FILE)
		echo "title: \"$(ARTIST) - $(ALBUM)\"" >> $(FILE)
		echo "date: $(shell date +\"%Y-%m-%d\")" >> $(FILE)
		echo "author: ben-bailey" >> $(FILE)
		echo "artwork: \"$(ARTISTN)-$(ALBUMN).jpg\"" >> $(FILE)
		echo "artist: $(ARTIST)" >> $(FILE)
		echo "album: $(ALBUM)" >> $(FILE)
		echo "score: $(SCORE)" >> $(FILE)
		echo "p4k: $(P4K)" >> $(FILE)
		echo "label: " >> $(FILE)
		echo "release: " >> $(FILE)
		echo "template: review.jade" >> $(FILE)
		echo "---" >> $(FILE)
		wget -q $(URL) -O "$(DIR)/$(ARTISTN)-$(ALBUMN).jpg"
		atom $(FILE)
		exit

install:
		npm install

clean:
		rm -rf $(BUILD_DIR)

git-prod:
		cd $(BUILD_DIR) && git init && git remote add origin $(PROD_REPO)

build: clean
		wintersmith build
		echo "333vinyl.us" >> $(BUILD_DIR)/CNAME

deploy: clean build git-prod
		cd $(BUILD_DIR) && git add . && git commit -am "PROD" && git push -f origin +master:refs/heads/master

push-deploy: deploy
		git add .
		git commit -am "push-deploy"
		git push origin master

preview:
		wintersmith preview
