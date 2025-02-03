for file in test_inputs/code_generation/*.in; do
	cat "$file" | ./a
done
