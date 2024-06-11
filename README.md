### Heat equation in CUDA
We propose 3 parallel methods for solving 2D heat equations. We also provide 30 tests against which they can be tested.

To execute the code, run `./main <solver number> <test number>`. This will approximate a solution for the desired test case, 
first sequentially and then using the indicated parallel method. 
The resulting heat function grids are stored in "heatmap_sequential.txt" and "heatmap_gpu.txt".
If the code was executed successfully, both files should contain identical information.

To visualize the solution, run `python display.py <input_txt_file> <output_png_file>`.

Full information about this project can be found in "report.pdf".
