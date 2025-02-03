for file in test_inputs/error_checking/*.in; do
	cat "$file" | ./a
done
