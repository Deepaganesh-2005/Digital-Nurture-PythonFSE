# Binary Search Implementation

def binary_search(numbers, target):

    left = 0
    right = len(numbers) - 1

    while left <= right:
        middle = (left + right) // 2

        if numbers[middle] == target:
            return middle

        elif numbers[middle] < target:
            left = middle + 1

        else:
            right = middle - 1

    return -1


numbers = [10, 20, 30, 40, 50, 60, 70]
target = 50

result = binary_search(numbers, target)

if result != -1:
    print("Element found at index:", result)
else:
    print("Element not found")