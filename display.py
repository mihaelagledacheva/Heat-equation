import sys
import numpy as np
import matplotlib.pyplot as plt

def read_matrix_from_file(file_path):
    with open(file_path, 'r') as file:
        max_row = 0
        max_col = 0
        entries = []
        
        for line in file:
            row, col, value = map(float, line.strip().split())
            entries.append((int(row), int(col), value))
            max_row = max(max_row, int(row))
            max_col = max(max_col, int(col))
    
    matrix = np.zeros((max_row + 1, max_col + 1))
    for row, col, value in entries:
        matrix[row, col] = value

    return matrix

def save_heatmap(matrix, output_file):
    plt.imshow(matrix, cmap='hot', interpolation='nearest')
    plt.colorbar()
    plt.axis('off')
    plt.savefig(output_file)
    

if __name__ == "__main__":
    if len(sys.argv) != 3:
        print("Usage: python display.py <input_file> <output_file>")
        sys.exit(1)
        
    input_file = sys.argv[1]
    output_file = sys.argv[2]
    
    matrix = read_matrix_from_file(input_file)
    save_heatmap(matrix, output_file)
