.PHONY: archive testflight

archive:
	@ chmod +x Scripts/decrypt_files.sh && \
	  Scripts/decrypt_files.sh "passphrase" "Encrypted" "Private" && \
		set -a && \
		source fastlane/.fastlane.env && \
		source fastlane/Private/.appstore.env && \
		set +a && \
		fastlane upload

beta:
	@set -a && \
		source fastlane/.fastlane.env && \
		source fastlane/Private/.appstore.env && \
		set +a && \
		fastlane beta
		