.PHONY: dirs
dirs:
	mkdir -p local envs

.PHONY: rc
rc:
	# Set up Okura in rc files
	./rc
