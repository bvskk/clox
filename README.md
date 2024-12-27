## Benchmarks

Time taken to execute the [benchmark suite](./benchmarks) (lower is better):

| Benchmark         | clox   | jlox    |
| ----------------- | ------ | ------- |
| binary_tree       | 25.09s | 41.66s  |
| equality          | 18.50s | 24.37s  |
| fib               | 15.98s | 81.21s  |
| instantiation*    | 43.38s | 28.99s  |
| invocation        | 10.43s | 35.98s  |
| method_call       | 14.38s | 79.67s  |
| properties        | 11.40s | 76.35s  |
| string_equality   | 25.74s | 63.27s  |
| trees             | 22.55s | 87.52s  |
| zoo               | 13.71s | 79.41s  |
| zoo_batch         | 10.0s  | 10.03s  |

*This is most likely because the garbage collector implemented in clox is worse than Java's GC

Benchmarks were run with the following configuration:

- Device: Lenovo Thinkpad E14 Gen3 AMD
- Processor: AMD Ryzen 5 5500U
- RAM: 8 GiB
- OS: Windows 10 Build 19045
- MSVC: 17.12.3
- OpenJDK: 23.0.1


## References
- [Crafting Interpreters](https://craftinginterpreters.com/) by Bob Nystrom.
- [loxcraft](https://github.com/ajeetdsouza/loxcraft) is where the benchmarks are from.
