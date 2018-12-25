DEPLOYMENT_BUCKET_NAME := desole-packaging
STACK_NAME := ffmpeg-thumbnail-builder


SOURCES=$(shell find src/)

clean: 
	rm -rf build

build/output.yml: cloudformation/template.yml $(SOURCES)
	mkdir -p build
	aws cloudformation package --template-file cloudformation/template.yml --output-template-file build/output.yml --s3-bucket $(DEPLOYMENT_BUCKET_NAME)

deploy: build/output.yml
	aws cloudformation deploy --template-file build/output.yml --stack-name $(STACK_NAME) --capabilities CAPABILITY_IAM
	aws cloudformation describe-stacks --stack-name $(STACK_NAME) --query Stacks[].Outputs[].OutputValue --output text

