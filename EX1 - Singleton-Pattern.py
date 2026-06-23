class Singleton:
    
    # Variable to store the single instance
    _instance = None

    def __new__(cls):

        # Create object only once
        if cls._instance is None:
            cls._instance = super().__new__(cls)

        return cls._instance

    def __init__(self):
        # Initialization code
        print("Singleton Initialized")

    def do_something(self):
        # Method to perform operations
        print("Performing an operation...")


# Using the Singleton
obj1 = Singleton()
obj1.do_something()

obj2 = Singleton()
obj2.do_something()

# Check whether both references point to the same object
print("Are both objects same?", obj1 is obj2)


"""
Output:
Singleton Initialized
Performing an operation...
Singleton Initialized
Performing an operation...
Are both objects same? True
"""
