image-test:
	make -C assignment-test itest --no-print-directory
	make -C customized-test itest --no-print-directory

test:
	make -C assignment-test test --no-print-directory
	make -C customized-test test --no-print-directory

clean:
	make -C assignment-test clean --no-print-directory
	make -C customized-test clean --no-print-directory
