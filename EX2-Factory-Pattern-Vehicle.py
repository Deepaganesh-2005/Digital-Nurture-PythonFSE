# Factory Method Pattern Implementation
# Creates objects without exposing object creation logic to the client

class Car:
    def drive(self):
        print("Driving a Car")


class Bike:
    def drive(self):
        print("Riding a Bike")


class VehicleFactory:

    @staticmethod
    def create_vehicle(vehicle_type):

        if vehicle_type.lower() == "car":
            return Car()

        elif vehicle_type.lower() == "bike":
            return Bike()

        else:
            raise ValueError("Invalid Vehicle Type")


vehicle1 = VehicleFactory.create_vehicle("car")
vehicle1.drive()

vehicle2 = VehicleFactory.create_vehicle("bike")
vehicle2.drive()


"""
Output:
Driving a Car
Riding a Bike
"""