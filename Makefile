build-container-image:
	docker build \
		--tag dudeofawesome/lexicon \
		--file Containerfile \
		.
