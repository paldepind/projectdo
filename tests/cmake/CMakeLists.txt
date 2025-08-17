cmake_minimum_required(VERSION 3.10)
project(TestProject)

enable_testing()

add_test(NAME example_test COMMAND echo "test passed")
