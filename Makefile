BUILD_DIR := ./build
PROD_REPO = git@github.com:333vinyl/333vinyl.github.io.git

DATE   ?= "$(shell date)"
POST ?= $(filter-out $@,$(MAKECMDGOALS))
FILE = $(shell date "+./contents/articles/%Y-%m-%d-$(POST).md" | sed -e y/\ /-/)

post:
		echo "---" >> $(FILE)
		echo "title: \"$(POST)\"" >> $(FILE)
		echo "date: $(shell date +\"%Y-%m-%d\")" >> $(FILE)
		echo "---" >> $(FILE)
		vim $(FILE)
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

deploy: clean build
		cd $(BUILD_DIR) && git add --all . && git commit -m "PROD" && git push -f origin +master:refs/heads/master

push-deploy: deploy
		git push origin master

preview:
		wintersmith preview
